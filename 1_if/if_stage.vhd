library ieee;
use ieee.std_logic_1164.all;

-- top entity for the IF stage. It encapsulates a BTB used to perform branch prediction,
-- the PC register and its update logic. The instruction memory is considered to be an
-- external component in respect to the processor
entity if_stage is
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
end if_stage;

architecture behavioral of if_stage is
	component btb is
		generic (
			A: integer := 32 -- address length
		);
		port (
			next_pc: out std_logic_vector(A-1 downto 0); -- memory address to be fetched in the next cycle
			predicted_taken: out std_logic; -- tells if a branch has been recognized and it's predicted to be taken
			addr_known: out std_logic; -- tells if the instruction passed to the cache is known to the BHT, regardless of the predictred_taken value

			-- "00" if nothing has to be done
			-- "01" if an already known instruction has to be updated (taken/not taken)
			-- "10" if a new instruction must be added
			-- "11" reserved
			update: in std_logic_vector(1 downto 0);
			target_addr: in std_logic_vector(A-1 downto 0); -- next address to be fetched in case of a predicted taken
			taken: in std_logic; -- if 1 the branch has been taken, 0 if not.;

			-- cache interface
			cache_update_line: out std_logic; -- set to 1 if the cache has to update a whole line
			cache_update_data: out std_logic; -- set to 1 if the cache has to update only a line's data
			cache_data_in: out std_logic_vector(A+2-1 downto 0); -- data to be written in the cache
			cache_data_out_read: in std_logic_vector(A+2-1 downto 0); -- data out of the read-only address port of the cache
			cache_data_out_rw: in std_logic_vector(A+2-1 downto 0); -- data out of the read-write address port of the cache
			cache_hit_read: in std_logic; -- set to 1 if the read-only address generated a hit 
			cache_hit_rw: in std_logic -- set to 1 if the read-write address generated a hit
		);
	end component btb;

	component reg_en is
		generic (
			N: integer := 32
		);
		port (
			d: in std_logic_vector(N-1 downto 0);
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			q: out std_logic_vector(N-1 downto 0)	
		);
	end component reg_en;

	component beh_hadder is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sum: out std_logic_vector(N-1 downto 0);
			cout: out std_logic
		);
	end component beh_hadder;

	component mux_2x1 is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic;
			o: out std_logic_vector(N-1 downto 0)
		);
	end component mux_2x1;

	constant one: std_logic_vector(29 downto 0) := (0 => '1', others => '0'); 

	signal curr_pc, next_pc: std_logic_vector(29 downto 0);
	signal pc_plus4, pc_btb: std_logic_vector(29 downto 0);

begin
	pc_out <= curr_pc;

	pc: reg_en
		generic map (
			N => 30
		)
		port map (
			d => next_pc,
			en => pc_en,
			clk => clk,
			rst => rst,
			q => curr_pc
		);

	-- PC update logic

	branch_target_buffer: btb
		generic map (
			A => 30
		)
		port map (
			next_pc => pc_btb,
			predicted_taken => btb_predicted_taken,
			addr_known => btb_addr_known,
			update => btb_update,
			target_addr => btb_target_addr,
			taken => btb_taken,
			cache_update_line => cache_update_line,
			cache_update_data => cache_update_data,
			cache_data_in => cache_data_in,
			cache_data_out_read => cache_data_out_read,
			cache_data_out_rw => cache_data_out_rw,
			cache_hit_read => cache_hit_read,
			cache_hit_rw => cache_hit_rw
		);

	-- since PC is on 30 bits and not 32 it's enough to calculate
	-- next_pc = pc + 1
	-- instead of
	-- next_pc = pc + 4
	pc_adder: beh_hadder
		generic map (
			N => 30
		)
		port map (
			a => curr_pc,
			b => one,
			sum => pc_plus4,
			cout => open
		);

	-- based on the CU "pc_sel" input select either pc+4 or pc_btb as the next pc
	pc_selector: mux_2x1
		generic map (
			N => 30
		)
		port map (
			a => pc_plus4,
			b => pc_btb,
			sel => pc_sel,
			o => next_pc
		);
end behavioral;
