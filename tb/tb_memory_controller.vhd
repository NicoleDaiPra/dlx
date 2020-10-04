library ieee;
use ieee.std_logic_1164.all;

entity tb_memory_controller is
end tb_memory_controller;

architecture test of tb_memory_controller is
	component memory_controller is
		generic (
			N: integer := 32; -- data size
			C: integer := 32; -- cache address size
			A: integer := 8 -- RAM address size
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			rw: in std_logic; -- operation being performed by the CPU: 1 for read, 0 for write
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

	constant period : time := 10ns; 

	signal clk, rst, rw, cache_hit, cache_eviction, cache_update, ram_rw, cu_resume: std_logic;
	signal cache_update_type: std_logic_vector(1 downto 0);
	signal cpu_cache_address, evicted_cache_address: std_logic_vector(31 downto 0);
	signal cache_data_in, cache_data_out, ram_data_in, ram_data_out: std_logic_vector(31 downto 0);
	signal ram_address: std_logic_vector(9 downto 0);

begin
	dut: memory_controller
		generic map (
			N => 32,
			C => 32,
			A => 10
		)
		port map (
			clk => clk,
			rst => rst,
			rw => rw,
			cpu_cache_address => cpu_cache_address,
			evicted_cache_address => evicted_cache_address,
			cache_data_in => cache_data_in,
			cache_hit => cache_hit,
			cache_eviction => cache_eviction,
			cache_update => cache_update,
			cache_update_type => cache_update_type,
			cache_data_out => cache_data_out,
			ram_data_in => ram_data_in,
			ram_rw => ram_rw,
			ram_address => ram_address,
			ram_data_out => ram_data_out,
			cu_resume => cu_resume
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

		-- test read operation with a hit
		rw <= '1';
		cpu_cache_address <= X"12345678";
		evicted_cache_address  <= X"11111111";
		cache_data_in <= X"87654321";
		cache_hit <= '1';
		cache_eviction <= '0';
		ram_data_in <= X"ABCDEF4C";
		wait for period;

		-- test write with no eviction
		rw <= '0';
		cpu_cache_address <= X"12345678";
		evicted_cache_address  <= X"11111111";
		cache_data_in <= X"87654321";
		cache_hit <= '1';
		cache_eviction <= '0';
		ram_data_in <= X"ABCDEF4C";
		wait for period;

		-- test write with eviction (no stall is expected)
		rw <= '0';
		cpu_cache_address <= X"12345678";
		evicted_cache_address  <= X"11111111";
		cache_data_in <= X"87654321";
		cache_hit <= '0';
		cache_eviction <= '1';
		ram_data_in <= X"ABCDEF4C";
		wait for period;

		-- test read with no eviction (cache miss)
		rw <= '1';
		cpu_cache_address <= X"12345678";
		evicted_cache_address  <= X"11111111";
		cache_data_in <= X"87654321";
		cache_hit <= '0';
		cache_eviction <= '0';
		ram_data_in <= X"ABCDEF4C";
		wait for period/2 + period/4;

		-- the CU has stalled, the MC does its job
		cache_hit <= '1';
		wait until cu_resume = '1';
		wait for period/2;

		wait for 10*period;

		-- the CU is working again, now test a read with eviction (cache miss)
		rw <= '1';
		cpu_cache_address <= X"12345678";
		evicted_cache_address  <= X"11111111";
		cache_data_in <= X"87654321";
		cache_hit <= '0';
		cache_eviction <= '1';
		ram_data_in <= X"ABCDEF4C";
		wait for period;

		-- the CU has stalled, the MC is in the CACHEMISS state
		evicted_cache_address <= X"AAAAAAAA";
		cache_data_in <= X"BBBBBBBB";
		wait for period;

		-- the MC is in READ_EVICTION state, the CU can resume
		rw <= '1';
		cpu_cache_address <= X"44444444";
		evicted_cache_address  <= X"55555555";
		cache_data_in <= X"66666666";
		cache_hit <= '1';
		cache_eviction <= '0';
		ram_data_in <= X"77777777";
		wait;
	end process test_proc;

end test;
