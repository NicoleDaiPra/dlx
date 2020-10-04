library ieee;
use ieee.std_logic_1164.all;
use work.fun_pack.all;

entity tb_four_way_dcache is
--  Port ( );
end tb_four_way_dcache;

architecture test of tb_four_way_dcache is
	component four_way_dcache is
		generic (
			T: integer := 22; -- tag size
			N: integer := 32; -- word size
			NLINES: integer := 16 -- number of lines of the cache
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			address: in std_logic_vector(T+n_width(NLINES/4)-1 downto 0); -- address to be matched
			update: in std_logic; -- 1 if an update must be performed, 0 otherwise
			-- controls how the data is added to the line
			-- 00: stores N bits coming from the RAM
			-- 01: stores N bits coming from the CPU
			-- 10: stores N/2 bits coming from the CPU
			-- 11: stores N/4 bits coming from the CPU
			update_type: in std_logic_vector(1 downto 0);
			ram_data_in: in std_logic_vector(N-1 downto 0); -- data coming from the RAM (in big endian)
			cpu_data_in: in std_logic_vector(N-1 downto 0); -- data coming from the CPU (in little endian)
			hit: out std_logic; -- if 1 the read operation was a hit, 0 otherwise
			ram_data_out: out std_logic_vector(N-1 downto 0); -- data going to the RAM (in big endian)
			ram_update: out std_logic; -- tells to the RAM if it has to update its content
			cpu_address: out std_logic_vector(T+n_width(NLINES/4)-1 downto 0); -- propagate to the memory controller the current used address
			evicted_address: out std_logic_vector(T+n_width(NLINES/4)-1 downto 0); -- propagate to the memory controller the address of the line being evicted
			cpu_data_out: out std_logic_vector(N-1 downto 0) -- data going to the CPU (in little endian)
		);
	end component four_way_dcache;

	constant period : time := 10 ns; 

	constant STORE_RAM : std_logic_vector(1 downto 0) := "00";
	constant STORE_WORD : std_logic_vector(1 downto 0) := "01";
	constant STORE_HALFWORD : std_logic_vector(1 downto 0) := "10";
	constant STORE_BYTE : std_logic_vector(1 downto 0) := "11"; 

	signal clk, rst, update, hit, ram_update: std_logic;
	signal update_type: std_logic_vector(1 downto 0);
	signal address, ram_data_in, cpu_data_in, ram_data_out, cpu_address, evicted_address, cpu_data_out: std_logic_vector(15 downto 0);

begin
	dut: four_way_dcache
		generic map (
			T => 15,
			N => 16,
			NLINES => 8
		)
		port map (
			clk => clk,
			rst => rst,
			address => address,
			update => update,
			update_type => update_type,
			ram_data_in => ram_data_in,
			cpu_data_in => cpu_data_in,
			hit => hit,
			ram_data_out => ram_data_out,
			cpu_address => cpu_address,
			evicted_address => evicted_address,
			ram_update => ram_update,
			cpu_data_out => cpu_data_out
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

		rst <= '1';

		-- try to read a non valid location
		address <= X"F3C2";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"4321"; -- 0x1234 in little endian
		cpu_data_in <= X"5678";
		wait for period;

		-- perform a store
		address <= X"F3C2";
		update <= '1';
		update_type <= "01";
		ram_data_in <= X"4321"; -- 0x1234 in little endian
		cpu_data_in <= X"5678";
		wait for period;

		-- perform a N/2 store
		address <= X"D282";
		update <= '1';
		update_type <= "10";
		ram_data_in <= X"4321"; -- 0x1234 in little endian
		cpu_data_in <= X"9ABC";
		wait for period;

		-- perform a N/4 store
		address <= X"AAA2";
		update <= '1';
		update_type <= "11";
		ram_data_in <= X"4321"; -- 0x1234 in little endian
		cpu_data_in <= X"1212";
		wait for period;

		-- perform a load from memory
		address <= X"8812";
		update <= '1';
		update_type <= "00";
		ram_data_in <= X"4321"; -- 0x1234 in little endian
		cpu_data_in <= X"9ABC";
		wait for period;

		-- a whole set should be full right now, try to read its content
		address <= X"F3C2";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		address <= X"D282";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		address <= X"AAA2";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		address <= X"8812";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		-- now trigger a store eviction
		address <= X"4444";
		update <= '1';
		update_type <= "01";
		ram_data_in <= X"0000";
		cpu_data_in <= X"8712";
		wait for period;

		-- do nothing for a cycle
		update <= '0';
		wait for period;

		-- a whole set should be full right now, try to read its content
		address <= X"4444";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		address <= X"D282";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		address <= X"AAA2";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		address <= X"8812";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		-- trigger a cache miss
		address <= X"F3C2";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"4321"; -- 0x1234 in little endian
		cpu_data_in <= X"0000";
		wait for period;

		-- a cache miss has been detected, load the data from the RAM
		address <= X"F3C2";
		update <= '1';
		update_type <= "00";
		ram_data_in <= X"8765"; -- 0x5678 in little endian
		cpu_data_in <= X"0000";
		wait for period;

		update <= '0';
		wait for period;

		-- a whole set should be full right now, try to read its content
		address <= X"4444";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		address <= X"F3C2";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		address <= X"AAA2";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		address <= X"8812";
		update <= '0';
		update_type <= "00";
		ram_data_in <= X"0000";
		cpu_data_in <= X"0000";
		wait for period;

		-- try to write in the other set
		address <= X"F3C1";
		update <= '1';
		update_type <= "00";
		ram_data_in <= X"FFDD"; -- 0xDDFF in little endian
		cpu_data_in <= X"0000";
		wait for period;

		update <= '0';
		wait;
	end process test_proc;
end test;
