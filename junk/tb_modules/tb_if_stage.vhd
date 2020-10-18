library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

-- this tb executes the test.asm example two times, 1 time without knowing the existence of the beqz and 1 time knowing about it
entity tb_if_stage is

end tb_if_stage;

architecture test of tb_if_stage is
	component if_stage is
		port (
			clk: in std_logic;
			rst: in std_logic;

			pc_out: out std_logic_vector(29 downto 0); -- current PC value (used by the BTB cache)

			-- control interface
			pc_en: in std_logic; -- enable the PC register
			pc_sel: in std_logic; -- 1 if the next pc must be pc+4, 0 if it has to be the one coming out from the BTB
			-- "00" if nothing has to be done
			-- "01" if an already known instruction has to be updated (taken/not taken)
			-- "10" if a new instruction must be added
			-- "11" reserved
			btb_update: in std_logic_vector(1 downto 0);
			btb_taken: in std_logic; -- when an address is being added to the BTB tells if it was taken or not
			btb_target_addr: in std_logic_vector(29 downto 0); -- address to be added to the BTB
			btb_addr_known: out std_logic; -- tells if the BTB has recognized or not the current PC address
			btb_predicted_taken: out std_logic; -- the BTB has predicted the branch to be taken

			-- cache interface
			cache_update_line: out std_logic; -- set to 1 if the cache has to update a whole line
			cache_update_data: out std_logic; -- set to 1 if the cache has to update only a line's data
			cache_data_in: out std_logic_vector(31 downto 0); -- data to be written in the cache
			cache_data_out_read: in std_logic_vector(31 downto 0); -- data out of the read-only address port of the cache
			cache_data_out_rw: in std_logic_vector(31 downto 0); -- data out of the read-write address port of the cache
			cache_hit_read: in std_logic; -- set to 1 if the read-only address generated a hit 
			cache_hit_rw: in std_logic -- set to 1 if the read-write address generated a hit
		);
	end component if_stage;

	component btb_fully_associative_cache is
		generic (
			T: integer := 8; -- width of the TAG bits
			L: integer := 8 -- line size
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			update_line: in std_logic; -- if update_line = '1' the cache adds a new entry to the cache
			update_data: in std_logic; -- if update_data = '1' the cache only replace the data corresponding to a tag
			read_address: in std_logic_vector(T-1 downto 0); -- address to be read from the cache
			rw_address: in std_logic_vector(T-1 downto 0); -- address to be written from the cache
			data_in: in std_logic_vector(L-1 downto 0); -- data to be added to the cache
			hit_miss_read: out std_logic; -- if read_address generates a hit then hit_miss_read = '1', otherwise hit_miss_read ='0'
			data_out_read: out std_logic_vector(L-1 downto 0); -- if hit_miss_read = '1' it contains the searched data, otherwise its value must not be considered
			hit_miss_rw: out std_logic; -- if rw_address generates a hit then hit_miss_rw = '1', otherwise hit_miss_rw ='0'
			data_out_rw: out std_logic_vector(L-1 downto 0) -- if hit_miss_rw = '1' it contains the searched data, otherwise its value must not be considered
	   );
	end component btb_fully_associative_cache;

	component rom is
		generic ( 
	    	N: integer := 32;
	        M: integer := 8;
	        F: string := "test.asm";
	        T: time := 0 ns
	    );
	    port ( 
	    	rst: in std_logic;
	        addr: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
	        data_out: out std_logic_vector(N-1 downto 0) 
	    );
	end component rom;

	constant period: time := 1 ns; 

	signal clk, rst, pc_en, pc_sel, btb_taken, btb_addr_known, btb_predicted_taken, cache_update_line, cache_update_data, cache_hit_read, cache_hit_rw: std_logic;
	signal btb_update: std_logic_vector(1 downto 0);
	signal pc_out, btb_target_addr, rw_address: std_logic_vector(29 downto 0);
	signal cache_data_in, cache_data_out_read, cache_data_out_rw, data_out: std_logic_vector(31 downto 0);

begin
	dut: if_stage
		port map (
			clk => clk,
			rst => rst,
			pc_out => pc_out,
			pc_en => pc_en,
			pc_sel => pc_sel,
			btb_update => btb_update,
			btb_taken => btb_taken,
			btb_target_addr => btb_target_addr,
			btb_addr_known => btb_addr_known,
			btb_predicted_taken => btb_predicted_taken,
			cache_update_line => cache_update_line,
			cache_update_data => cache_update_data,
			cache_data_in => cache_data_in,
			cache_data_out_read => cache_data_out_read,
			cache_data_out_rw => cache_data_out_rw,
			cache_hit_read => cache_hit_read,
			cache_hit_rw => cache_hit_rw
		);

	btb_cache: btb_fully_associative_cache
		generic map (
			T => 30,
			L => 32
		)
		port map (
			clk => clk,
			rst => rst,
			update_line => cache_update_line,
			update_data => cache_update_data,
			read_address => pc_out,
			rw_address => rw_address,
			data_in => cache_data_in,
			data_out_read => cache_data_out_read,
			data_out_rw => cache_data_out_rw,
			hit_miss_read => cache_hit_read,
			hit_miss_rw => cache_hit_rw
		);

	imem: rom
		generic map (
			N => 32,
			M => 128,
			F => "C:\Users\leona\Desktop\ms\if_stage\if_stage.srcs\sim_1\new\test.asm",
			T => 0 ns
		)
		port map (
			rst => rst,
			addr => pc_out(6 downto 0),
			data_out => data_out
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_proc;

	test_proc: process
	begin
		rst <= '0';
		wait for period/2;
		rst  <= '1';

		-- cycle 0: j 16
		pc_en <= '1';
		pc_sel <= '1';
		btb_update <= "00";
		btb_taken <= '0';
		btb_target_addr <= (others  => '0');
		rw_address <= (others => '0');
		wait for period;

		-- cycle 1: add r1, r2, r3
		pc_en <= '1';
		pc_sel <= '1';
		btb_update <= "00";
		btb_taken <= '0';
		btb_target_addr <= (others  => '0');
		wait for period;

		-- cycle 2: addi r1, r2, #5, stall just to check that the pc_emn works
		pc_en <= '0';
		pc_sel <= '1';
		btb_update <= "00";
		btb_taken <= '0';
		btb_target_addr <= (others  => '0');
		wait for period;

		-- cycle 2: addi r1, r2, #5
		pc_en <= '1';
		pc_sel <= '1';
		btb_update <= "00";
		btb_taken <= '0';
		btb_target_addr <= (others  => '0');
		wait for period;

		-- cycle 3: beqz 32, not known
		pc_en <= '1';
		pc_sel <= '1';
		btb_update <= "00";
		btb_taken <= '0';
		btb_target_addr <= (others  => '0');
		wait for period;

		-- reset everything
		rst <= '0';
		wait for period;

		rst <= '1';

		-- add beqz to the btb
		pc_en <= '0';
		btb_update <= "10";
		btb_taken <= '1';
		btb_target_addr <= std_logic_vector(to_unsigned(32, 30));
		wait for period;

		-- execute the program again
		-- cycle 0: j 16
		pc_en <= '1';
		pc_sel <= '1';
		btb_update <= "00";
		btb_taken <= '0';
		btb_target_addr <= (others  => '0');
		rw_address <= (0 => '1', others => '0');
		wait for period;

		-- cycle 1: add r1, r2, r3
		pc_en <= '1';
		pc_sel <= '1';
		btb_update <= "00";
		btb_taken <= '0';
		btb_target_addr <= (others  => '0');
		wait for period;

		-- cycle 2: addi r1, r2, #5
		pc_en <= '1';
		pc_sel <= '1';
		btb_update <= "00";
		btb_taken <= '0';
		btb_target_addr <= (others  => '0');
		wait for period;

		-- cycle 3: beqz 32, known
		pc_en <= '1';
		pc_sel <= '0';
		btb_update <= "00";
		btb_taken <= '0';
		btb_target_addr <= (others  => '0');
		wait for period;

		-- just loop a few times to check whether the beqz has been recognized as taken
		for i in 0 to 7 loop
			pc_en <= '1';
			pc_sel <= '1';
			btb_update <= "00";
			btb_taken <= '0';
			btb_target_addr <= (others  => '0');
			wait for period; 
		end loop;

		wait;
	end process test_proc;

end test;
