library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fun_pack.n_width;

entity tb_four_way_associative_cache is
end entity tb_four_way_associative_cache;

architecture test of tb_four_way_associative_cache is
	component four_way_associative_dcache is
		generic (
		T: integer := 26; -- width of the TAG bits
		W: integer := 32; -- word size
		NL: integer := 16 -- total number of lines in the cache (internally they're split in sets)
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		update: in std_logic; -- if update = '1' the cache adds the data in data_in to the cache
		read_line: in std_logic;
		address: in std_logic_vector(T+n_width(NL/4)+2-1 downto 0); -- data to match
		data_in: in std_logic_vector(4*W-1 downto 0); -- data to be added to the cache
		hit_miss: out std_logic; -- if hit then hit_miss = '1', otherwise hit_miss ='0'
		data_out: out std_logic_vector(W-1 downto 0); -- if hit = '1' it contains the searched data, otherwise its value must not be considered 
		b0: out std_logic_vector(W-1 downto 0);
		b1: out std_logic_vector(W-1 downto 0);
		b2: out std_logic_vector(W-1 downto 0);
		b3: out std_logic_vector(W-1 downto 0);
		ts0, ts1, ts2, ts3: out std_logic_vector(31 downto 0);
		comp0, comp1: out std_logic;
		ind0, ind1: out std_logic_vector(1 downto 0);
		comp2: out std_logic;
		ind2: out std_logic_vector(1 downto 0)
	);
	end component four_way_associative_dcache;

	constant T: integer := 10;
	constant W: integer := 16; 
	constant NL: integer := 64;
	constant period: time := 2 ns; 

	signal clk, rst, update, read_line, hit_miss: std_logic;
	signal address: std_logic_vector(T+n_width(NL/4)+2-1 downto 0);
	signal data_in: std_logic_vector(4*W-1 downto 0);
	signal data_out, b0, b1, b2, b3: std_logic_vector(W-1 downto 0);
	signal ts0, ts1, ts2, ts3: std_logic_vector(31 downto 0);
	signal comp0, comp1: std_logic;
	signal ind0, ind1: std_logic_vector(1 downto 0);
	signal comp2: std_logic;
	signal ind2: std_logic_vector(1 downto 0);

begin
	dut: four_way_associative_dcache
		generic map (
			T => T,
			W => W,
			NL => NL
		)
		port map (
			clk => clk,
			rst => rst,
			update => update,
			read_line => read_line,
			address => address,
			data_in => data_in,
			hit_miss =>  hit_miss,
			data_out => data_out,
			b0 => b0,
			b1 => b1,
			b2 => b2,
			b3 => b3,
			ts0 => ts0,
			ts1 => ts1,
			ts2 => ts2,
			ts3 => ts3,
			comp0 => comp0,
			comp1 => comp1,
			ind0 => ind0,
			ind1 => ind1,
			comp2 => comp2,
			ind2 => ind2
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

		-- try to read something invalid
		update <= '0';
		read_line <= '1';
		address <= X"0004"; -- TAG = 0000 0000 00 SET = 0001 OFFSET = 00
		wait for period;

		assert (hit_miss = '0') report "data_out should have been invalid" severity FAILURE;
		-- put in address 0x0004 some values
		data_in <= X"123456789ABCDEF0";
		update <= '1';
		read_line <= '0';
		wait for period;

		-- read the same address as before, this time a hit is expected
		update <= '0';
		read_line <= '1';
		--assert (hit_miss = '1') report "data_out should have been valid" severity FAILURE;
		wait for period;

		-- now try to read all the offsets
		 for i in 0 to 3 loop
			address <= std_logic_vector(unsigned(address) + 1);
			wait for period;
		end loop;
        
        --assert (hit_miss = '0') report "data_out should have been invalid since a new set has been entered" severity FAILURE;

        -- fill the whole set changing the tags
        update <= '1';
        read_line <= '0';
        address <= X"0104"; -- TAG = 0000000100 SET 0001 OFFSET = 00
        data_in <= X"1111222233334444";
        wait for period;

        address <= X"0204"; -- TAG = 0000001000 SET 0001 OFFSET = 00
        data_in <= X"5555666677778888";
        wait for period;

        address <= X"0304"; -- TAG = 0000001100 SET 0001 OFFSET = 00
        data_in <= X"9999AAAABBBBCCCC";
        wait for period;

        -- now read a different line every 10*period to modify the timestamps
        update <= '0';
        wait for 10*period;

        read_line <= '1';
        address <= X"0004";
        wait for period;

        assert (hit_miss = '1') report "data_out should have been valid" severity FAILURE;
        assert (data_out = X"1234") report "data_out is not equal to '1234'" severity FAILURE;
        read_line <= '0';
        wait for 10*period;

        read_line <= '1';
        address <= X"0105";
        wait for period;

        assert (hit_miss = '1') report "data_out should have been valid" severity FAILURE;
        assert (data_out = X"2222") report "data_out is not equal to '2222'" severity FAILURE;
        read_line <= '0';
        wait for 10*period;

        read_line <= '1';
        address <= X"0206";
        wait for period;

        assert (hit_miss = '1') report "data_out should have been valid" severity FAILURE;
        assert (data_out = X"7777") report "data_out is not equal to '7777'" severity FAILURE;
        read_line <= '0';
        wait for 10*period;

        read_line <= '1';
        address <= X"0307";
        wait for period;

        assert (hit_miss = '1') report "data_out should have been valid" severity FAILURE;
        assert (data_out = X"CCCC") report "data_out is not equal to 'CCCC'" severity FAILURE;
        read_line <= '0';
        wait for 10*period;

        -- now check if the right replacement takes place
        update <= '1';
        data_in <= X"42135768A9CBDFDF";
        address <= X"0404"; -- TAG = 0000010000 SET 0001 OFFSET = 00
        wait for period;

        update <= '0';
        read_line <= '1';
        
        wait for period;
        assert (data_out = X"4213") report "data_out is not equal to 4213" severity FAILURE;
        wait for period;

        -- now try to read all the offsets
		for i in 0 to 3 loop
			address <= std_logic_vector(unsigned(address) + 1);
			wait for period;
		end loop;

		read_line <= '0';
		wait for 5*period;

		-- check that the other cache lines have not been overwritten
		read_line <= '1';
        address <= X"0105";
        wait for period;

        assert (hit_miss = '1') report "data_out should have been valid" severity FAILURE;
        assert (data_out = X"2222") report "data_out is not equal to '2222'" severity FAILURE;
        read_line <= '0';
        wait for period;

        read_line <= '1';
        address <= X"0206";
        wait for period;

        assert (hit_miss = '1') report "data_out should have been valid" severity FAILURE;
        assert (data_out = X"7777") report "data_out is not equal to '7777'" severity FAILURE;
        read_line <= '0';
        wait for period;

        read_line <= '1';
        address <= X"0307";
        wait for period;

        assert (hit_miss = '1') report "data_out should have been valid" severity FAILURE;
        assert (data_out = X"CCCC") report "data_out is not equal to 'CCCC'" severity FAILURE;
        read_line <= '0';
        wait for 10* period;

        -- try to write data on another set
        update <= '1';
        data_in <= X"9876678998766789";
        address <= X"0770";
        wait for period;

        update <= '0';
        read_line <= '1';
        wait for period;
        assert (hit_miss = '1') report "data_out should have been valid" severity FAILURE;

        wait for period;
		wait;
	end process;
end architecture test;