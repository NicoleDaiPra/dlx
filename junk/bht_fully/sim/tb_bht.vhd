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
			clk: in std_logic;
			rst: in std_logic;

			pc: in std_logic_vector(A-1 downto 0); -- current fetched instruction (program counter value)
			next_pc: out std_logic_vector(A-1 downto 0); -- memory address to be fetched in the next cycle
			predicted_taken: out std_logic; -- tells if a branch has been recognized and it's predicted to be taken
			addr_known: out std_logic; -- tells if the instruction in 'pc' is known to the BHT, regardless of the predictred_taken value

			-- "00" if nothing has to be done
			-- "01" if an already known instruction has to be updated (taken/not taken)
			-- "10" if a new instruction must be added
			-- "11" reserved
			update: in std_logic_vector(1 downto 0);
			instr_to_update: in std_logic_vector(A-1 downto 0); -- address instruction to be updated/added
			target_addr: in std_logic_vector(A-1 downto 0); -- next address to be fetched in case of a predicted taken
			taken: in std_logic -- if 1 the branch has been taken, 0 if not.
		);
	end component bht;

	constant A: integer := 16;
	constant period: time := 1 ns;

	constant NO_UPDATE: std_logic_vector(1 downto 0) := "00";
	constant HISTORY_UPDATE: std_logic_vector(1 downto 0) := "01";
	constant NEW_BRANCH_UPDATE: std_logic_vector(1 downto 0) := "10";
	constant RESERVED: std_logic_vector(1 downto 0) := "11";

	signal clk, rst, predicted_taken, addr_known, taken: std_logic;
	signal pc, next_pc, instr_to_update, target_addr: std_logic_vector(A-1 downto 0);
	signal update: std_logic_vector(1 downto 0);

begin
	dut: bht
		generic map (
			A => A
		)
		port map (
			clk => clk,
			rst => rst,
			pc => pc,
			next_pc => next_pc,
			predicted_taken => predicted_taken,
			addr_known => addr_known,
			update => update,
			instr_to_update => instr_to_update,
			target_addr => target_addr,
			taken => taken
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