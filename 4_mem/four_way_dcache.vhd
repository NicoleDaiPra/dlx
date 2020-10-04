library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use work.fun_pack.all;

-- 4-way set-associative cache implementation
entity four_way_dcache is
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
end four_way_dcache;

architecture behavioral of four_way_dcache is
	component dcache_block is
		generic (
			T: integer := 22; -- tag size
			N: integer := 32; -- word size
			NLINES: integer := 16 -- number of lines within a block
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			address: in std_logic_vector(T+n_width(NLINES)-1 downto 0); -- address to be matched
			update: in std_logic; -- 1 if an update must be performed, 0 otherwise
			-- controls how the data is added to the line
			-- 00: stores N bits coming from the RAM
			-- 01: stores N bits coming from the CPU
			-- 10: stores N/2 bits coming from the CPU
			-- 11: stores N/4 bits coming from the CPU
			update_type: in std_logic_vector(1 downto 0);
			ram_data_in: in std_logic_vector(N-1 downto 0); -- data coming from the RAM (in big endian)
			cpu_data_in: in std_logic_vector(N-1 downto 0); -- data coming from the CPU (in little endian)
			valid: out std_logic; -- if 1 the data read is valid, 0 otherwise
			dirty: out std_logic; -- 1 if the content of the line has been modified and its change not propagated to the RAM, 0 otherwise
			ram_data_out: out std_logic_vector(N-1 downto 0); -- data going to the RAM (in big endian)
			cpu_data_out: out std_logic_vector(N-1 downto 0); -- data going to the CPU (in little endian)
			tag_out: out std_logic_vector(T-1 downto 0) -- tag stored in the line 
		);
	end component dcache_block;

	component equality_comparator is
		generic (
			N: integer := 32 -- number of bits
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			o: out std_logic
		);
	end component equality_comparator;

	component mux_4x1 is
	    generic (
			N: integer := 22
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			c: in std_logic_vector(N-1 downto 0);
			d: in std_logic_vector(N-1 downto 0);
			sel: in std_logic_vector(1 downto 0);
			o: out std_logic_vector(N-1 downto 0)
		);
	end component mux_4x1;

	component and2 is
		port (
			a: in std_logic;
			b: in std_logic;
			o: out std_logic
		);
	end component and2;

	component priority_encoder_4to2 is
		port (
			a: in std_logic;
			b: in std_logic;
			c: in std_logic;
			d: in std_logic;
			enc: out std_logic_vector(1 downto 0)
		);
	end component priority_encoder_4to2;

	component dcache_replacement_logic is
		port (
			clk: in std_logic;
			rst: in std_logic;
			update: in std_logic; -- 1 if an update must be performed, 0 otherwise
			hits: in std_logic_vector(3 downto 0); -- used to determine if a particular block must be updated
			block_enc: in std_logic_vector(1 downto 0); -- in case of a hit the block specified by this signal must be updated
			block_to_upd: out std_logic_vector(3 downto 0); -- tells which block must be updated
			replacement: out std_logic -- tells to the cache if a replacement is taking place
		);
	end component dcache_replacement_logic;

	component encoder_4to2 is
		port (
			i: in std_logic_vector(3 downto 0);
			o: out std_logic_vector(1 downto 0)
		);
	end component encoder_4to2;

	type data_array is array (0 to 3) of std_logic_vector(N-1 downto 0);
	type tag_array is array (0 to 3) of std_logic_vector(T-1 downto 0);

	signal update_int: std_logic_vector(3 downto 0);
	signal valid_int: std_logic_vector(3 downto 0);
	signal dirty_int: std_logic_vector(3 downto 0);
	signal ram_data_out_int, cpu_data_out_int: data_array;
	signal tag_out_int: tag_array;
	signal tags_equals: std_logic_vector(3 downto 0);
	signal hits: std_logic_vector(3 downto 0);
	signal mux_enc, ram_out_enc: std_logic_vector(1 downto 0);
	signal repl: std_logic;

begin
	-- read operation

	-- generate the 4 blocks along with the logic for the hit detection
	block_gen : for i in 0 to 3 generate
		block_i: dcache_block
			generic map (
				T => T,
				N => N,
				NLINES => NLINES/4
			)
			port map (
				clk => clk,
				rst => rst,
				address => address,
				update => update_int(i),
				update_type => update_type,
				ram_data_in => ram_data_in,
				cpu_data_in => cpu_data_in,
				valid => valid_int(i),
				dirty => dirty_int(i),
				ram_data_out => ram_data_out_int(i),
				cpu_data_out => cpu_data_out_int(i),
				tag_out => tag_out_int(i)
			);

		-- compare the tag coming out from the block with the one passed as input to the cache
		ec: equality_comparator
			generic map (
				N => T
			)
			port map (
				a => address(T+n_width(NLINES/4)-1 downto n_width(NLINES/4)),
				b => tag_out_int(i),
				o => tags_equals(i)
			);

		-- a hit is valid iff the tag matches and the valid bit is set to 1
		a_i: and2
			port map (
				a => valid_int(i),
				b => tags_equals(i),
				o => hits(i)
			);
	end generate block_gen;

	hit <= or_reduce(hits);

	-- generate the selection bits for the output mux.
	--
	-- use a priority encoder to be sure to generate the correct
	-- selection bits in case of multiple matches
	pri_encoder: priority_encoder_4to2
		port map (
			a => hits(0),
			b => hits(1),
			c => hits(2),
			d => hits(3),
			enc => mux_enc
		);

	-- select the output of one block
	data_mux: mux_4x1
		generic map (
			N => N
		)
		port map (
			a => cpu_data_out_int(0),
			b => cpu_data_out_int(1),
			c => cpu_data_out_int(2),
			d => cpu_data_out_int(3),
			sel => mux_enc,
			o => cpu_data_out
		);

	-- write operation

	-- replacement logic to determine which block must be updated
	replacement: dcache_replacement_logic
		port map (
			clk => clk,
			rst => rst,
			update => update,
			hits => hits,
			block_enc => mux_enc,
			block_to_upd => update_int,
			replacement => repl
		);

	ram_out_encoder: encoder_4to2
		port map (
			i => update_int,
			o => ram_out_enc
		);

	cpu_address <= address;
	ram_data_out <= ram_data_out_int(to_integer(unsigned(ram_out_enc)));
	-- evicted address is calculated as follows: the tag of the data being evicted is concatenated to the set currently being used.
	evicted_address <= tag_out_int(to_integer(unsigned(ram_out_enc)))&address(n_width(NLINES/4)-1 downto 0);
	-- the RAM has to update its content iff a replacement is taking place and the dirty bit is set to 1
	ram_update <= repl and dirty_int(to_integer(unsigned(ram_out_enc)));
end behavioral;
