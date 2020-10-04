library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use work.fun_pack.all;

entity tb_ram_dcache_mc is
end tb_ram_dcache_mc;

architecture test of tb_ram_dcache_mc is
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

	component ram is
		generic ( 
            N: integer := 32;
            M: integer := 8;
            T: time := 0 ns
	    );
	    port ( 
	        rst: in std_logic;
	        clk: in std_logic;
	        rw: in std_logic; -- rw = '1' read, rw = '0' write
	        addr: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
	        data_in: in std_logic_vector(N-1 downto 0);
	        data_out: out std_logic_vector(N-1 downto 0) 
	    );
	end component ram;

	component memory_controller is
		generic (
			N: integer := 32; -- data size
			C: integer := 32; -- cache address size
			A: integer := 8 -- RAM address size
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic; -- operation being performed by the CPU: 0 for read, 1 for write
			cpu_is_reading: in std_logic;
			cpu_cache_address: in std_logic_vector(C-1 downto 0); -- address used by the CPU coming from the cache
			evicted_cache_address: in std_logic_vector(C-1 downto 0); -- address of the evicted data coming from the cache
			cache_data_in: in std_logic_vector(N-1 downto 0); -- data coming from the cache
			cache_hit: in std_logic;
			cache_eviction: in std_logic;
			cache_update: out std_logic;
			cache_update_type: out std_logic_vector(1 downto 0); -- always set to "00" when writing data from the RAM
			cache_data_out: out std_logic_vector(N-1 downto 0); -- data going to the cache
			ram_data_in: in std_logic_vector(N-1 downto 0); -- data coming from the RAM
			ram_rw: out std_logic; -- rw = '1' read, rw = '0' write
			ram_address: out std_logic_vector(A-1 downto 0); -- address going to the RAM
			ram_data_out: out std_logic_vector(N-1 downto 0); -- data going to the RAM
			cu_resume: out std_logic -- used to communicate to the Cu that it can resume the execution after a cache miss 
		);
	end component memory_controller;

	constant period : time := 10 ns; 

	signal clk, rst, cu_update, mc_update, update, hit, ram_update, ram_rw, cpu_wr, cu_resume, cpu_is_reading: std_logic;
	signal update_type, cu_update_type, mc_update_type: std_logic_vector(1 downto 0);
	signal cache_data_in, cpu_data_in, cache_data_out, cpu_data_out, ram_data_in, ram_data_out: std_logic_vector(15 downto 0);
	signal address, cpu_cache_address, evicted_cache_address: std_logic_vector(15 downto 0);
	signal ram_address: std_logic_vector(7 downto 0);

begin
	cache: four_way_dcache
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
			ram_data_in => cache_data_in,
			cpu_data_in => cpu_data_in,
			hit => hit,
			ram_data_out => cache_data_out,
			ram_update => ram_update,
			cpu_address => cpu_cache_address,
			evicted_address => evicted_cache_address,
			cpu_data_out => cpu_data_out
		);

	mc: memory_controller
		generic map (
			N => 16,
			C => 16,
			A => 8
		)
		port map (
			clk => clk,
			rst => rst,
			wr => cpu_wr,
			cpu_is_reading => cpu_is_reading,
			cpu_cache_address => cpu_cache_address,
			evicted_cache_address => evicted_cache_address,
			cache_data_in => cache_data_out,
			cache_hit => hit,
			cache_eviction => ram_update,
			cache_update => update,
			cache_update_type => update_type,
			cache_data_out => cache_data_in,
			ram_data_in => ram_data_out,
			ram_rw => ram_rw,
			ram_address => ram_address,
			ram_data_out => ram_data_in,
			cu_resume => cu_resume
		);

	r: ram
		generic map (
			N => 16,
			M => 256,
			T => 0 ns
		)
		port map (
			clk => clk,
			rst => rst,
			rw => ram_rw,
			addr => ram_address,
			data_in => ram_data_in,
			data_out => ram_data_out
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
		cpu_wr <= '0';
		update <= '0';
		update_type <= "00";
		cpu_is_reading <= '0';
		wait for period/2;

		rst <= '1';

		-- try to read an invalid cache location
		cpu_wr <= '0';
		address <= X"F3C2";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"5678";
		wait for period;

		-- perform a store
		cpu_wr <= '1';
		address <= X"F3C2";
		update <= '1';
		update_type <= "01";
		cpu_data_in <= X"5678";
		wait for period;

		-- perform a N/2 store
		cpu_wr <= '1';
		address <= X"D282";
		update <= '1';
		update_type <= "10";
		cpu_data_in <= X"9ABC";
		wait for period;

		-- perform a N/4 store
		cpu_wr <= '1';
		address <= X"AAA2";
		update <= '1';
		update_type <= "11";
		cpu_data_in <= X"1212";
		wait for period;

		-- perform a store
		cpu_wr <= '1';
		address <= X"8812";
		update <= '1';
		update_type <= "01";
		cpu_data_in <= X"4321";
		wait for period;

		cpu_is_reading <= '1';
		-- a whole set should be full right now, try to read its content
		cpu_wr <= '0';
		address <= X"F3C2";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_wr <= '0';
		address <= X"D282";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_wr <= '0';
		address <= X"AAA2";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_wr <= '0';
		address <= X"8812";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		-- now trigger a store eviction
		cpu_wr <= '1';
		address <= X"4444";
		update <= '1';
		update_type <= "01";
		cpu_data_in <= X"8712";
		wait for period;

		-- a whole set should be full right now, try to read its content
		cpu_wr <= '0';
		address <= X"4444";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_wr <= '0';
		address <= X"D282";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_wr <= '0';
		address <= X"AAA2";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_wr <= '0';
		address <= X"8812";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		-- trigger a cache miss
		cpu_wr <= '0';
		address <= X"F3C2";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period/2;
		update <= 'Z';
		update_type <= "ZZ";
		wait for period/2;
		-- a cache miss has been detected, load the data from the RAM
		cpu_wr <= '0';
		address <= X"F3C2";
		update <= 'Z';
		update_type <= "ZZ";
		cpu_data_in <= X"0000";
		wait until cu_resume = '1';

		wait for period/2;

		-- a whole set should be full right now, try to read its content
		cpu_wr <= '0';
		address <= X"F3C2";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_wr <= '0';
		address <= X"4444";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_wr <= '0';
		address <= X"AAA2";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_wr <= '0';
		address <= X"8812";
		update <= '0';
		update_type <= "00";
		cpu_data_in <= X"0000";
		wait for period;

		cpu_is_reading <= '0';
		-- try to write in the other set
		cpu_wr <= '1';
		address <= X"F3C1";
		update <= '1';
		update_type <= "01";
		cpu_data_in <= X"0000";
		wait for period;

		-- perform a N store
		cpu_wr <= '1';
		address <= X"AAA2";
		update <= '1';
		update_type <= "01";
		cpu_data_in <= X"1212";
		wait for period;

		cpu_wr <= '0';
		update <= '0';
		wait;

	end process test_proc;

end test;
