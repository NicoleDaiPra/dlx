library ieee;
use ieee.std_logic_1164.all;

-- Simple memory controller implementation to allow the simulation of the DLX with a cache and a RAM

-- Sequence of operations:

-- cache miss, wr = 0
-- cycle 1: CU releases the cache control and stalls, MC takes control
-- cycle 2: asks to the RAM the data using cpu_cache_address, samples the evicted data coming from the cache. Does the cache have to perform eviction to store the data?
--		1) Yes, go to cycle 3
--		2) No, CU regains the cache's control
-- cycle 3: write the data sampled from the cache into the RAM, the CU regains the cache's control

-- cache eviction, wr = 1, cache_eviction = '1'
-- cycle 1: CU doesn't stall, MC writes the data in RAM using evicted_cache_address

entity memory_controller is
	generic (
		N: integer := 32; -- data size
		C: integer := 32; -- cache address size
		A: integer := 8 -- RAM address size
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		wr: in std_logic; -- operation being performed by the CPU: 0 for read, 1 for write
		cpu_is_reading: in std_logic; -- used to discriminate false cache misses when the CPU is not using at all the cache. Set to 1 for reading, to 0 otherwise. During a write operation it's not important its value
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
end memory_controller;

architecture behavioral of memory_controller is
	type statetype is (IDLE, CACHEMISS, EVICTION_READ);

	constant c_a_zeros : std_logic_vector(C-A-1 downto 0) := (others  => '0'); --used to extend the ra

	signal currstate, nextstate: statetype;
	signal curr_evicted_address, next_evicted_address: std_logic_vector(C-1 downto 0);
	signal curr_cache_data, next_cache_data: std_logic_vector(N-1 downto 0);
	signal enable: std_logic;

begin
	reg_state: process(clk, rst)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				currstate <= IDLE;
				curr_evicted_address <= (others => '0');
				curr_cache_data <= (others => '0');
			else
				currstate <= nextstate;
				if (enable = '1') then
					curr_evicted_address <= next_evicted_address;
					curr_cache_data <= next_cache_data;
				end if;
			end if;	
		end if;
	end process reg_state;

	comblogic: process(currstate, curr_evicted_address, curr_cache_data, wr, cpu_is_reading, cpu_cache_address, evicted_cache_address, cache_data_in, cache_hit, cache_eviction, ram_data_in)
	begin
		cache_update_type <= "ZZ";
		cache_update <= 'Z';
		cache_data_out <= ram_data_in;
		ram_rw <= '1';
		ram_address <= cpu_cache_address(A-1 downto 0);
		ram_data_out <= cache_data_in;
		cu_resume <= '1';
		nextstate <= currstate;
		next_evicted_address <= evicted_cache_address;
		next_cache_data <= cache_data_in;
		enable <= '0';

		case (currstate) is
			when IDLE =>
				if (wr = '0' and cache_hit <= '0' and cpu_is_reading = '1') then -- a cache miss has occurred
					nextstate <= CACHEMISS;
					cu_resume <= '0';
				elsif (wr = '1' and cache_eviction = '1') then -- eviction during a write
					ram_rw <= '0';
					ram_address <= evicted_cache_address(A-1 downto 0);
				end if;

			when CACHEMISS => 
				cache_update <= '1';
				cache_update_type <= "00";
				cu_resume <= '0';
				if (cache_eviction = '1') then -- eviction during a read
					nextstate <= EVICTION_READ;
					enable <= '1';
				else
					nextstate  <= IDLE;	
				end if;

			when EVICTION_READ => 
				ram_address <= curr_evicted_address(A-1 downto 0);
				ram_data_out <= curr_cache_data;
				ram_rw <= '0';
				nextstate <= IDLE;

			when others =>
				nextstate <= IDLE;
		end case;
	end process comblogic;

end behavioral;
