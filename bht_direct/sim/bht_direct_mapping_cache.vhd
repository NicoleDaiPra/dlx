library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use work.fun_pack.all;

-- Direct mapping cache implementation for the BHT. It doesn't support multiple words per line.
-- It has a read-only interface and a read-write one. The latter allows to read and write the data
-- contained in a single line in a clock cycle, which is useful for the BHT
entity bht_direct_mapping_cache is
	generic (
		T: integer := 27; -- width of the TAG bits
		W: integer := 16; -- word size
		NL: integer := 32 -- total number of lines in the cache
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		update_line: in std_logic; -- if update_line = '1' the cache adds a new entry to the cache
		update_data: in std_logic; -- if update_data = '1' the cache only replace the data corresponding to a tag
		read_address: in std_logic_vector(T+n_width(NL)-1 downto 0); -- address to be read from the cache
		rw_address: in std_logic_vector(T+n_width(NL)-1 downto 0); -- address to be written from the cache
		data_in: in std_logic_vector(W-1 downto 0); -- data to be added to the cache
		hit_miss_read: out std_logic; -- if read_address generates a hit then hit_miss_read = '1', otherwise hit_miss_read ='0'
		data_out_read: out std_logic_vector(W-1 downto 0); -- if hit_miss_read = '1' it contains the searched data, otherwise its value must not be considered
		hit_miss_rw: out std_logic; -- if rw_address generates a hit then hit_miss_rw = '1', otherwise hit_miss_rw ='0'
		data_out_rw: out std_logic_vector(W-1 downto 0) -- if hit_miss_rw = '1' it contains the searched data, otherwise its value must not be considered
	);
end entity bht_direct_mapping_cache;

architecture behavioral of bht_direct_mapping_cache is
	component bht_cache_line is
		generic (
			T: integer := 22; -- tag bit size
			L: integer := 32 -- line size
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			update_line: in std_logic; -- if update_line = '1' the line stores the incoming data and tag
			update_data: in std_logic; -- if update_line = '1' the line stores the incoming data, maintaining the tag
			tag_in: in std_logic_vector(T-1 downto 0); -- tag to be saved when update = 1
			data_in: in std_logic_vector(L-1 downto 0); -- data to be added to the line
			valid: out std_logic; -- 1 if the data contained in the line is valid, 0 otherwise
			tag_out: out std_logic_vector(T-1 downto 0); -- tag stored in the line
			data_out: out std_logic_vector(L-1 downto 0) -- output containing the word chosen with offset
		);
	end component bht_cache_line;

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

	component and2 is
		port (
			a: in std_logic;
			b: in std_logic;
			o: out std_logic
		);
	end component and2;

	component bht_cache_replacement_logic is
		generic (
			NL: integer := 32
		);
		port (
			rw_line_index: in std_logic_vector(n_width(NL)-1 downto 0);
			cache_update_line: in std_logic;
			cache_update_data: in std_logic;
			hit: in std_logic; -- update_data can have a bit set to 1 iff the selected line contains valid data
			update_line: out std_logic_vector(NL-1 downto 0);
			update_data: out std_logic_vector(NL-1 downto 0)
		);
	end component bht_cache_replacement_logic;

	type tag_array is array (0 to NL-1) of std_logic_vector(T-1 downto 0);
	type data_array is array (0 to NL-1) of std_logic_vector(W-1 downto 0);

	signal update_line_int, update_data_int: std_logic_vector(NL-1 downto 0);
	signal valid_int: std_logic_vector(NL-1 downto 0);
	signal read_valid, rw_valid: std_logic;
	signal read_tag, rw_tag: std_logic_vector(T-1 downto 0);
	signal read_match, rw_match: std_logic;
	signal rw_hit: std_logic;
	signal tag_out_array: tag_array;
	signal data_out_array: data_array;

begin
	replacement: bht_cache_replacement_logic
		generic map (
			NL => NL
		)
		port map (
			rw_line_index => rw_address(n_width(NL)-1 downto 0),
			cache_update_data => update_data,
			cache_update_line => update_line,
			hit => rw_hit,
			update_line => update_line_int,
			update_data => update_data_int
		);

	-- instantiate the cache lines
	line_gen: for i in 0 to NL-1 generate
		cache_line: bht_cache_line
			generic map (
				T => T,
				L => W
			)
			port map (
				clk => clk,
				rst => rst,
				update_line => update_line_int(i),
				update_data => update_data_int(i),
				tag_in => rw_address(T+n_width(NL)-1 downto n_width(NL)),
				data_in => data_in,
				valid => valid_int(i),
				tag_out => tag_out_array(i),
				data_out => data_out_array(i)
			);
	end generate line_gen;

	-- select the requested data from the lines' outputs
	-- "n_width(NL)-1 downto 0" corresponds to the line index
	read_tag <= tag_out_array(to_integer(unsigned(read_address(n_width(NL)-1 downto 0))));
	rw_tag <= tag_out_array(to_integer(unsigned(rw_address(n_width(NL)-1 downto 0))));
	read_valid <= valid_int(to_integer(unsigned(read_address(n_width(NL)-1 downto 0))));
	rw_valid <= valid_int(to_integer(unsigned(rw_address(n_width(NL)-1 downto 0))));

	data_out_read <= data_out_array(to_integer(unsigned(read_address(n_width(NL)-1 downto 0))));
	data_out_rw <= data_out_array(to_integer(unsigned(rw_address(n_width(NL)-1 downto 0))));

	-- check that the tag of the line and the one passed as input match
	read_eq_comp: equality_comparator
		generic map (
			N => T
		)
		port map (
			a => read_address(T+n_width(NL)-1 downto n_width(NL)),
			b => read_tag,
			o => read_match
		);

	rw_eq_comp: equality_comparator
		generic map (
			N => T
		)
		port map (
			a => rw_address(T+n_width(NL)-1 downto n_width(NL)),
			b => rw_tag,
			o => rw_match
		);

	-- a hit is obtained iff the tags match and the data contained in the cache is valid
	read_hit_and: and2
		port map (
			a => read_valid,
			b => read_match,
			o => hit_miss_read
		);

	rw_hit_and: and2
		port map (
			a => rw_valid,
			b => rw_match,
			o => rw_hit
		);

	hit_miss_rw <= rw_hit;
end architecture behavioral;