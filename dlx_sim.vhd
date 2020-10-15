library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use work.fun_pack.all;

entity dlx_sim is
	generic (
		F: string := "C:\Users\leona\dlx\test\test.asm.exe"
	);
	port (
		clk: in std_logic;
		rst: in std_logic;

		data_out: out std_logic_vector(31 downto 0)
	);
end dlx_sim;

architecture structural of dlx_sim is
	component dlx_syn is
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- btb cache interface
			btb_cache_update_line: out std_logic;
			btb_cache_update_data: out std_logic;
			btb_cache_hit_read: in std_logic;
			btb_cache_hit_rw: in std_logic;
			btb_cache_read_address: out std_logic_vector(29 downto 0);
			btb_cache_rw_address: out std_logic_vector(29 downto 0);
			btb_cache_data_in: out std_logic_vector(31 downto 0);
			btb_cache_data_out_read: in std_logic_vector(31 downto 0);
			btb_cache_data_out_rw: in std_logic_vector(31 downto 0);
			
			-- IROM interface
			pc_out: out std_logic_vector(29 downto 0);
			instr_if: in std_logic_vector(31 downto 0);

			-- dcache interface
			dcache_hit: in std_logic;
			dcache_update: out std_logic;
			dcache_update_type: out std_logic_vector(1 downto 0);
			dcache_data_in: in std_logic_vector(31 downto 0); -- data coming from the dcache
			dcache_address: out std_logic_vector(31 downto 0); -- address used by the dcache
			dcache_data_out: out std_logic_vector(31 downto 0); -- data going to the cache
			ram_update: in std_logic; -- raised by the cache, signals the need of an eviction
			ram_to_cache_data: out std_logic_vector(31 downto 0);
			cache_to_ram_data: in std_logic_vector(31 downto 0);
			cpu_cache_address: in std_logic_vector(31 downto 0); -- address currently used to access the dcache propagated to the memory controller
			evicted_cache_address: in std_logic_vector(31 downto 0); -- memory address where to write the evicted data
			
			-- RAM interface
			ram_rw: out std_logic;
			ram_address: out std_logic_vector(7 downto 0);
			ram_data_in: out std_logic_vector(31 downto 0);
			ram_data_out: in std_logic_vector(31 downto 0)
		);
	end component dlx_syn;

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

	component btb_fully_associative_cache is
		generic (
			T: integer := 8; -- width of the TAG bits
			L: integer := 8 -- line size
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
	end component btb_fully_associative_cache;

	component rom is
		generic ( 
	    	N: integer := 32;
	        M: integer := 8;
	        F: string := "/home/ms20.9/dlx";
	        T: time := 0 ns
	    );
	    port ( 
	    	rst: in std_logic;
	        addr: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
	        data_out: out std_logic_vector(N-1 downto 0) 
	    );
	end component rom;

	signal pc_out: std_logic_vector(29 downto 0);
	signal instr_if: std_logic_vector(31 downto 0);

	signal btb_cache_update_line, btb_cache_update_data, btb_cache_hit_read, btb_cache_hit_rw: std_logic;
	signal btb_cache_read_address, btb_cache_rw_address: std_logic_vector(29 downto 0);
	signal btb_cache_data_in, btb_cache_data_out_read, btb_cache_data_out_rw: std_logic_vector(31 downto 0);

	signal cu_resume_mem, hit_mem, cpu_is_reading, wr_mem, dcache_update, ld_sign_mem, alu_data_tbs_selector: std_logic;
	signal update_type_mem, ld_type_mem: std_logic_vector(1 downto 0);
	signal dcache_data_in, dcache_data_out, dcache_address: std_logic_vector(31 downto 0);

	-- dcache signals
	signal ram_update: std_logic;
	signal ram_to_cache_data: std_logic_vector(31 downto 0);
	signal cache_to_ram_data: std_logic_vector(31 downto 0);
	signal cpu_cache_address, evicted_cache_address: std_logic_vector(31 downto 0);

	signal ram_rw: std_logic;
	signal ram_address: std_logic_vector(7 downto 0);
	signal ram_data_in, ram_data_out: std_logic_vector(31 downto 0);

begin
	dlx: dlx_syn
		port map (
			clk => clk,
			rst => rst,

			-- btb cache interface
			btb_cache_update_line => btb_cache_update_line,
			btb_cache_update_data => btb_cache_update_data,
			btb_cache_hit_read => btb_cache_hit_read,
			btb_cache_hit_rw => btb_cache_hit_rw,
			btb_cache_read_address => btb_cache_read_address,
			btb_cache_rw_address => btb_cache_rw_address,
			btb_cache_data_in => btb_cache_data_in,
			btb_cache_data_out_read => btb_cache_data_out_read,
			btb_cache_data_out_rw => btb_cache_data_out_rw,
			
			-- IROM interface
			pc_out => pc_out,
			instr_if => instr_if,

			-- dcache interface
			dcache_hit => hit_mem,
			dcache_update => dcache_update,
			dcache_update_type => update_type_mem,
			dcache_data_in => dcache_data_in,
			dcache_address => dcache_address,
			dcache_data_out => dcache_data_out,
			ram_update => ram_update,
			ram_to_cache_data => ram_to_cache_data,
			cache_to_ram_data => cache_to_ram_data,
			cpu_cache_address => cpu_cache_address,
			evicted_cache_address => evicted_cache_address,
			
			-- RAM interface
			ram_rw => ram_rw,
			ram_address => ram_address,
			ram_data_in => ram_data_in,
			ram_data_out => ram_data_out
		);

	data_out <= dcache_data_out;

	irom: rom
		generic map (
			N => 32,
	        M => 256,
	        F =>  F,
	        T => 0 ns
		)
		port map (
			rst => rst,
	        addr => pc_out(7 downto 0),
	        data_out => instr_if
		);

	btb_cache: btb_fully_associative_cache
		generic map (
			T => 30,
			L => 32
		)
		port map (
			clk => clk,
			rst => rst,
			update_line => btb_cache_update_line,
			update_data => btb_cache_update_data,
			read_address => btb_cache_read_address,
			rw_address => btb_cache_rw_address,
			data_in => btb_cache_data_in,
			hit_miss_read => btb_cache_hit_read,
			data_out_read => btb_cache_data_out_read,
			hit_miss_rw => btb_cache_hit_rw,
			data_out_rw => btb_cache_data_out_rw
		);

	dcache: four_way_dcache
		generic map (
			T => 28,
			N => 32,
			NLINES => 64
		)
		port map (
			clk => clk,
			rst => rst,
			address => dcache_address,
			update => dcache_update,
			update_type => update_type_mem,
			ram_data_in => ram_to_cache_data,
			cpu_data_in => dcache_data_out,
			hit => hit_mem,
			ram_data_out => cache_to_ram_data,
			ram_update => ram_update,
			cpu_address => cpu_cache_address,
			evicted_address => evicted_cache_address,
			cpu_data_out => dcache_data_in
		);

	ram_mem: ram
		generic map (
			N => 32,
            M => 256,
            T => 0 ns
		)
		port map (
			rst => rst,
	        clk => clk,
	        rw => ram_rw,
	        addr => ram_address,
	        data_in => ram_data_in,
	        data_out => ram_data_out
		);

end structural;
