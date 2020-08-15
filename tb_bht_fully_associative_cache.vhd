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

	constant T: integer := 8;
	constant L: integer := 8;
	constant NL: integer := 8;
	constant period: time := 1 ns; 

	signal clk, rst, update_line, update_data, hit_miss_read, hit_miss_rw: std_logic;
	signal data_in, data_out_read, data_out_rw: std_logic_vector(L-1 downto 0);
	signal read_address, rw_address: std_logic_vector(T-1 downto 0);

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
			update_line => update_line,
			update_data => update_data,
			read_address => read_address,
			rw_address => rw_address,
			data_in => data_in,
			hit_miss_read => hit_miss_read,
			data_out_read => data_out_read,
			hit_miss_rw => hit_miss_rw,
			data_out_rw => data_out_rw
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
		rw_address <= read_address;
		wait for period/2;

		rst <= '1';

		-- try to read an invalid tag
		update_line <= '0';
		update_data <= '0';
		read_address <= X"AF";
		wait for period;

		assert (hit_miss_read = '0') report "data_out_read should have been invalid" severity FAILURE;
		assert (hit_miss_rw = '0') report "data_out_rw should have been invalid" severity FAILURE;

		-- now put some data in the cache
		update_line <= '1';

		for i in 0 to NL-1 loop
			addr := addr + 1;
			data := data - 1;
			rw_address <= std_logic_vector(addr);
			data_in <= std_logic_vector(data);
			wait for period;
		end loop;

		update_line <= '0';
		wait for period;

		-- now try to read some valid value
		read_address <= X"00";
		wait for period;

		data := (others => '1');
		assert (unsigned(data_out_read) = unsigned(data)) report "data_out_read has a wrong value" severity FAILURE;

		-- check that the replacement works
		addr := (others => '0');
		addr := addr + NL; -- set addr 1 position over the last stored one
		data := data - NL;

		rw_address <= std_logic_vector(addr);
		read_address <= std_logic_vector(addr);
		data_in <= std_logic_vector(data);
		update_line <= '1';
		wait for period;

		update_line <= '0';
		wait for period;

		assert (unsigned(data_out_read) = unsigned(data)) report "data_out has a wrong value" severity FAILURE;
		assert (hit_miss_read = '1') report "stored tag is wrong" severity FAILURE;

		rw_address <= std_logic_vector(addr);
		read_address <= std_logic_vector(addr);
		data_in <= X"AB";
		update_data <= '1';
		wait for period;

		update_data <= '0';
		wait for period;

		assert (data_out_read = X"AB") report "data_out has a wrong value" severity FAILURE;
		assert (hit_miss_read = '1') report "stored tag is wrong" severity FAILURE;

		-- the first address should be the one removed, check that this has happened
		read_address <= X"00";
		wait for period;

		assert (hit_miss_read ='0') report "a miss was expected" severity FAILURE;

		-- check that all the other values were not touched (check must be done by hand)
		addr := (others => '0');
		data := (others => '1');

		for i in 0 to NL-2 loop
			addr := addr + 1;
			data := data - 1;
			read_address <= std_logic_vector(addr);
			data_in <= std_logic_vector(data);
			wait for period;
		end loop;

		-- try to replace everything
		update_line <= '1';
		addr := (others => '1');
		data := (others => '0');

		for i in 0 to NL-1 loop
			addr := addr + 1;
			data := data - 1;
			rw_address <= std_logic_vector(addr);
			data_in <= std_logic_vector(data);
			wait for period;
		end loop;

		update_line <= '0';
		read_address <= std_logic_vector(addr);
		wait for period;

		assert (hit_miss_read = '1') report "hit was expected" severity FAILURE;
		assert (unsigned(data) = unsigned(data_out_read)) report "wrong data_out" severity FAILURE;
		
		-- read everything again

		addr := (others => '1');

		for i in 0 to NL-1 loop
			addr := addr + 1;
			read_address <= std_logic_vector(addr);
			wait for period;
		end loop;

		wait for period;

		-- try to replace only the data
		update_data <= '1';
		addr := (others => '1');
		data := X"CC";

		for i in 0 to NL-1 loop
			addr := addr + 1;
			data := data - 1;
			read_address <= std_logic_vector(addr);
			rw_address <= std_logic_vector(addr);
			data_in <= std_logic_vector(data);
			wait for period;
		end loop;

		update_data <= '0';
		wait for period;

		-- read back all the data
		addr := (others => '1');

		for i in 0 to NL-1 loop
			addr := addr + 1;
			read_address <= std_logic_vector(addr);
			wait for period;
		end loop;

		-- try to replace data without a tag hit -> it should not happens
		addr := X"AA";
		data := X"CC";

		read_address <= std_logic_vector(addr);
		wait for period; -- allow the assert to work properly

		update_data <= '1';
		for i in 0 to NL-2 loop
			addr := addr + 1;
			data := data - 1;
			read_address <= std_logic_vector(addr);
			rw_address <= std_logic_vector(addr);
			data_in <= std_logic_vector(data);
			assert (hit_miss_read = '0') report "a miss was expected" severity FAILURE;
			assert (unsigned(data_out_read) /= data) report "data_out should have been different from data" severity FAILURE;
			wait for period;
		end loop;

		update_data <= '0';

		-- read back all the data
		addr := (others => '1');

		for i in 0 to NL-1 loop
			addr := addr + 1;
			read_address <= std_logic_vector(addr);
			wait for period;
		end loop;
		wait;
	end process test_proc;
end architecture test;