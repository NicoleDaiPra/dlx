library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.fun_pack.n_width;

-- Fully associative cache implementation.
-- It's possible to define the width of the tag bits, the size of a line
-- and how much lines the cache contains (it must be a power-of-2 value).
-- The replacement policy is FIFO.
-- This cache doesn't support multiple words stored into a single line
-- as it is meant to be used inside a BHT.
entity bht_fully_associative_cache is
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
end entity bht_fully_associative_cache;

architecture behavioral of bht_fully_associative_cache is
component bht_cache_line is
	generic (
		T: integer := 22; -- tag bit size
		L: integer := 32 -- line size
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		update: in std_logic; -- if update = '1' the line stores the incoming data
		tag_in: in std_logic_vector(T-1 downto 0); -- tag to be saved when update = 1
		data_in: in std_logic_vector(L-1 downto 0); -- data to be added to the line
		valid: out std_logic; -- 1 if the data contained in the line is valid, 0 otherwise
		tag_out: out std_logic_vector(T-1 downto 0); -- tag stored in the line
		data_out: out std_logic_vector(L-1 downto 0) -- output containing the word chosen with offset
	);
end component bht_cache_line;

component bht_cache_replacement_logic is
	generic (
		NL: integer := 128
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		cache_update: in std_logic; -- if 1 the cache wants to update a line
		line_update: out std_logic_vector(NL-1 downto 0) -- if the i-th bit is set to 1 the i-th line updates its content
	);
end component bht_cache_replacement_logic;

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

component pri_encoder_generic is
	generic (
		N: integer := 128
	);
	port (
		i: in std_logic_vector(N-1 downto 0);
		enc: out std_logic_vector(n_width(N)-1 downto 0)
	);
end component pri_encoder_generic;

component mux_nx1 is
	generic (
		N: integer := 32; -- data bit size
		M: integer := 128 -- number of elements to be muxed
	);
	port (
		i: in std_logic_vector(N*M-1 downto 0);
		sel: in std_logic_vector(n_width(M)-1 downto 0);
		o: out std_logic_vector(N-1 downto 0)
	);
end component mux_nx1;

type tag_array is array (0 to NL-1) of std_logic_vector(T-1 downto 0);
type data_array is array (0 to NL-1) of std_logic_vector(L-1 downto 0);

signal update_int: std_logic_vector(NL-1 downto 0);
signal valid_int: std_logic_vector(NL-1 downto 0);
signal tags: tag_array;
signal data_out_vector: std_logic_vector(L*NL-1 downto 0);
signal equals: std_logic_vector(NL-1 downto 0);
signal hits: std_logic_vector(NL-1 downto 0);
signal mux_enc: std_logic_vector(n_width(NL)-1 downto 0);

begin
	replacement: bht_cache_replacement_logic
		generic map (
			NL => NL
		)
		port map (
			clk => clk,
			rst => rst,
			cache_update => update,
			line_update => update_int
		);
	
	line_gen: for i in 0 to NL-1 generate
		line: bht_cache_line
			generic map (
				T => T,
				L => L
			)
			port map (
				clk => clk,
				rst => rst,
				update => update_int(i),
				tag_in => address,
				data_in => data_in,
				valid => valid_int(i),
				tag_out => tags(i),
				data_out => data_out_vector((i+1)*L-1 downto i*L)
			);

		eq_comp: equality_comparator
			generic map (
				N => T
			)
			port map (
				a => address,
				b => tags(i),
				o => equals(i)
			);

		hit_i: and2
			port map (
				a => equals(i),
				b => valid_int(i),
				o => hits(i)
			);
	end generate line_gen;

	encoder: pri_encoder_generic
		generic map (
			N => NL
		)
		port map (
			i => hits,
			enc => mux_enc
		);

	data_mux: mux_nx1
		generic map (
			N => L,
			M => NL
		)
		port map (
			i => data_out_vector,
			sel => mux_enc,
			o => data_out
		);

	hit_miss <= or_reduce(hits);
end architecture behavioral;