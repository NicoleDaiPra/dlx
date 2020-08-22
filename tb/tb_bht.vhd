library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_bht is

end entity tb_bht;

architecture test of tb_bht is
	component bht is
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
	end component bht;

	component bht_fully_associative_cache is
		generic (
			T: integer := 8; -- width of the TAG bits
			L: integer := 8; -- line size
			NL: integer := 32 -- number of lines in the cache
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
	end component bht_fully_associative_cache;

	constant A: integer := 16;
	constant NL: integer := 32; 
	constant period: time := 1 ns;

	constant NO_UPDATE: std_logic_vector(1 downto 0) := "00";
	constant HISTORY_UPDATE: std_logic_vector(1 downto 0) := "01";
	constant NEW_BRANCH_UPDATE: std_logic_vector(1 downto 0) := "10";
	constant RESERVED: std_logic_vector(1 downto 0) := "11";

	signal clk, rst, predicted_taken, addr_known, taken: std_logic;
	signal pc, next_pc, instr_to_update, target_addr: std_logic_vector(A-1 downto 0);
	signal update: std_logic_vector(1 downto 0);

	signal cache_update_line, cache_update_data: std_logic;
	signal cache_data_in, cache_data_out_read, cache_data_out_rw: std_logic_vector(A+2-1 downto 0); -- prediction_bits&target_address
	signal cache_hit_read, cache_hit_rw: std_logic;

begin
	cache: bht_fully_associative_cache
		generic map (
			T => A,
			L => A+2, -- store the target address + 2 prediction bits
			NL => NL
		)
		port map (
			clk => clk,
			rst => rst,
			update_line => cache_update_line,
			update_data => cache_update_data,
			read_address => pc,
			rw_address => instr_to_update,
			data_in => cache_data_in,
			hit_miss_read => cache_hit_read,
			data_out_read => cache_data_out_read,
			hit_miss_rw => cache_hit_rw,
			data_out_rw => cache_data_out_rw
		);

	dut: bht
		generic map (
			A => A
		)
		port map (
			next_pc => next_pc,
			predicted_taken => predicted_taken,
			addr_known => addr_known,
			update => update,
			target_addr => target_addr,
			taken => taken,
			cache_update_line => cache_update_line,
			cache_update_data => cache_update_data,
			cache_data_in => cache_data_in,
			cache_data_out_read => cache_data_out_read,
			cache_data_out_rw => cache_data_out_rw,
			cache_hit_read => cache_hit_read,
			cache_hit_rw => cache_hit_rw
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
		update <= NO_UPDATE;
		wait for period/2;

		rst <= '1';

		-- this address should be unkwnown to the bht
		pc <= X"00A0";
		wait for period;

		assert (predicted_taken = '0') report "predicted_taken should have been 0" severity FAILURE;
		assert (addr_known = '0') report "address 0x00A0 should have been unknown" severity FAILURE;

		-- address 0x00A0 has been discovered to be a taken branch to address 0xFFB0, add it to the bht
		pc <= X"00FA";

		update <= NEW_BRANCH_UPDATE;
		instr_to_update <= X"00A0";
		target_addr <= X"FFB0";
		taken <= '1';
		wait for period;

		assert (predicted_taken = '0') report "predicted_taken should have been 0" severity FAILURE;

		-- address 0x00A0 is being read again. This time the bht knows about it
		-- also address 0x00FA has been discovered to be a non taken branch with target address 0x0004
		pc <= X"00A0";

		update <= NEW_BRANCH_UPDATE;
		instr_to_update <= X"00FA";
		target_addr <= X"0004";
		taken <= '0';
		wait for period;

		assert (predicted_taken = '1') report "predicted_taken should have been 1" severity FAILURE;
		assert (addr_known = '1') report "address 0x00A0 should have been known" severity FAILURE;
		assert (next_pc = X"FFB0") report "next_pc is not equal to 0xFFB0" severity FAILURE;

		-- address 0x00FA is being read again now, address 0x00A0 has been taken again
		pc <= X"00FA";

		update <= HISTORY_UPDATE;
		instr_to_update <= X"00A0";
		target_addr <= X"ABCD"; -- check that even if this is not the correct address the FSM behaves correctly
		taken <= '1';
		wait for period;

		assert (predicted_taken = '0') report "predicted_taken should have been 0" severity FAILURE;
		assert (next_pc = X"0004") report "next_pc is not equal to 0x0004" severity FAILURE;

		-- check that address 0x00A0 still returns the correct values
		-- address 0x00FA has been not taken again
		pc <= X"00A0";

		update <= HISTORY_UPDATE;
		instr_to_update <= X"00FA";
		target_addr <= X"DCBA"; -- check that even if this is not the correct address the FSM behaves correctly
		taken <= '0';
		wait for period;

		assert (predicted_taken = '1') report "predicted_taken should have been 1" severity FAILURE;
		assert (next_pc = X"FFB0") report "next_pc is not equal to 0xFFB0" severity FAILURE;

		-- check that address 0x00FA still returns the correct values
		pc <= X"00FA";

		update <= NO_UPDATE;
		wait for period;

		assert (predicted_taken = '0') report "predicted_taken should have been 0" severity FAILURE;
		assert (next_pc = X"0004") report "next_pc is not equal to 0x0004" severity FAILURE;

		-- now make address 0x00A0 go from strongly taken to strongly not taken

		pc <= X"00A0";

		update <= HISTORY_UPDATE;
		instr_to_update <= X"00A0";
		target_addr <= X"FFB0";
		taken <= '0';
		wait for period;

		-- fsm state 10
		assert (predicted_taken = '1') report "predicted_taken should have been 1" severity FAILURE;
		assert (next_pc = X"FFB0") report "next_pc is not equal to 0xFFB0" severity FAILURE;

		wait for period;

		-- fsm state 01
		assert (predicted_taken = '0') report "predicted_taken should have been 0" severity FAILURE;
		assert (next_pc = X"FFB0") report "next_pc is not equal to 0xFFB0" severity FAILURE;

		wait for period;

		-- fsm state 00
		assert (predicted_taken = '0') report "predicted_taken should have been 0" severity FAILURE;
		assert (next_pc = X"FFB0") report "next_pc is not equal to 0xFFB0" severity FAILURE;

		wait for period;

		-- check that after another not taken the result is still the same as the cycle before
		assert (predicted_taken = '0') report "predicted_taken should have been 0" severity FAILURE;
		assert (next_pc = X"FFB0") report "next_pc is not equal to 0xFFB0" severity FAILURE;

		-- now do the opposite for address 0x00FA
		pc <= X"00FA";

		update <= HISTORY_UPDATE;
		instr_to_update <= X"00FA";
		target_addr <= X"0004";
		taken <= '1';
		wait for period;

		-- fsm state 01
		assert (predicted_taken = '0') report "predicted_taken should have been 0" severity FAILURE;
		assert (next_pc = X"0004") report "next_pc is not equal to 0x0004" severity FAILURE;

		wait for period;

		-- fsm state 10
		assert (predicted_taken = '1') report "predicted_taken should have been 1" severity FAILURE;
		assert (next_pc = X"0004") report "next_pc is not equal to 0x0004" severity FAILURE;

		wait for period;

		-- fsm state 11
		assert (predicted_taken = '1') report "predicted_taken should have been 1" severity FAILURE;
		assert (next_pc = X"0004") report "next_pc is not equal to 0x0004" severity FAILURE;

		wait for period;

		-- check that after another not taken the result is still the same as the cycle before
		assert (predicted_taken = '1') report "predicted_taken should have been 1" severity FAILURE;
		assert (next_pc = X"0004") report "next_pc is not equal to 0x0004" severity FAILURE;
		
		-- now fill the cache and replace one element
		update <= NEW_BRANCH_UPDATE;
		taken <= '1';
		for i in 0 to 31 loop
			instr_to_update <= std_logic_vector(to_unsigned(0 + i*4, 16));
			target_addr <= std_logic_vector(to_unsigned(0 - i*4, 16));
			wait for period;
		end loop;

		-- this address should be unknown to the bht now
		update <= NO_UPDATE;
		pc <= X"00A0";

		wait for period;

		assert (addr_known = '0') report "0x00A0 should be unknown" severity FAILURE;
		wait;
	end process test_proc;
end architecture test;