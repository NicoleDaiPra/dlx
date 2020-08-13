library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_bht_fully_associative_cache is
	
end entity tb_bht_fully_associative_cache;

architecture test of tb_bht_fully_associative_cache is
	component bht_fully_associative_cache is
		generic (
		T: integer := 8; -- width of the TAG bits
		L: integer := 8; -- line size
		NL: integer := 32 -- number of lines in the cache
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		update: in std_logic; -- if update ) '1' the cache updates its data
		address: in std_logic_vector(T-1 downto 0); -- if update = '1' the cache adds the data in data_in to the cache
		data_in: in std_logic_vector(L-1 downto 0); -- data to be added to the cache
		hit_miss: out std_logic; -- if hit then hit_miss = '1', otherwise hit_miss ='0'
		data_out: out std_logic_vector(L-1 downto 0) -- if hit = '1' it contains the searched data, otherwise its value must not be considered 
	);
	end component bht_fully_associative_cache;

	constant T: integer := 8;
	constant L: integer := 8;
	constant NL: integer := 8;
	constant period: time := 1 ns; 

	signal clk, rst, update, hit_miss: std_logic;
	signal data_in, data_out: std_logic_vector(L-1 downto 0);
	signal address: std_logic_vector(T-1 downto 0);

begin
	dut: bht_fully_associative_cache
		generic map (
			T => T,
			L => L,
			NL => NL
		)
		port map (
			clk => clk,
			rst => rst,
			update => update,
			address =>  address,
			data_in => data_in,
			hit_miss => hit_miss,
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
		variable addr: unsigned(T-1 downto 0) := (others => '1');
		variable data: unsigned(L-1 downto 0) := (others => '0');
	begin
		rst <= '0';
		wait for period/2;

		rst <= '1';

		-- try to read an invalid tag
		update <= '0';
		address <= X"AF";
		wait for period;

		assert (hit_miss = '0') report "data_out should have been invalid" severity FAILURE;

		-- now put some data in the cache
		update <= '1';

		for i in 0 to NL-1 loop
			addr := addr + 1;
			data := data - 1;
			address <= std_logic_vector(addr);
			data_in <= std_logic_vector(data);
			wait for period;
		end loop;

		update <= '0';
		wait for period;

		-- now try to read some valid value
		address <= X"00";
		wait for period;

		data := (others => '1');
		assert (unsigned(data_out) = unsigned(data)) report "data_out has a wrong value" severity FAILURE;

		-- check that the replacement works
		addr := (others => '0');
		addr := addr + NL; -- set addr 1 position over the last stored one
		data := data - NL;

		address <= std_logic_vector(addr);
		data_in <= std_logic_vector(data);
		update <= '1';
		wait for period;

		update <= '0';
		wait for period;

		assert (unsigned(data_out) = unsigned(data)) report "data_out has a wrong value" severity FAILURE;
		assert (hit_miss = '1') report "stored tag is wrong" severity FAILURE;

		-- the first address should be the one removed, check that this has happened
		address <= X"00";
		wait for period;

		assert (hit_miss ='0') report "a miss was expected" severity FAILURE;

		-- check that all the other values were not touched (check must be done by hand)
		addr := (others => '0');
		data := (others => '1');

		for i in 0 to NL-2 loop
			addr := addr + 1;
			data := data - 1;
			address <= std_logic_vector(addr);
			data_in <= std_logic_vector(data);
			wait for period;
		end loop;

		-- try to replace everything
		update <= '1';
		addr := (others => '0');
		data := (others => '1');

		for i in 0 to NL-2 loop
			addr := addr + 1;
			data := data - 1;
			address <= std_logic_vector(addr);
			data_in <= std_logic_vector(data);
			wait for period;
		end loop;

		update <= '0';
		wait for period;

		assert (hit_miss = '1') report "hit was expected" severity FAILURE;
		assert (unsigned(data) = unsigned(data_out)) report "wrong data_out" severity FAILURE;
		wait;
	end process test_proc;
end architecture test;