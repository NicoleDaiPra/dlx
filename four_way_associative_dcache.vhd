library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fun_pack.all;

-- Four way set-associative data cache implementation.
-- It's possible to define the width of the tag bits, the size of a word contained in a line
-- and how much lines the cache contains (it must be a power-of-2 value).
-- The replacement policy is LRU
entity four_way_associative_dcache is
	generic (
		T: integer := 10; -- width of the TAG bits
		W: integer := 16; -- word size
		NL: integer := 64 -- total number of lines in the cache (internally they're split in sets)
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
end entity four_way_associative_dcache;

architecture structural of four_way_associative_dcache is
component dcache_block is
	generic (
		T: integer := 22; --tag bit size
		W: integer := 32; -- word size
		N: integer := 4; -- number of lines contained in the block (each line correspond to a cache set)
		NL: integer := 16;
		NT: integer := 32 -- timestamp size
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		update: in std_logic; -- if update = '1' the block adds the data in data_in to a line
		inc_timestamp: in std_logic;
		read_line: in std_logic;
		address: in std_logic_vector(T+n_width(NL/4)+2-1 downto 0); -- address to be matched
		data_in: in std_logic_vector(4*W-1 downto 0); -- data to be added to a line
		timestamp_in: in std_logic_vector(NT-1 downto 0); -- current time, expressed in clock cycles
		valid: out std_logic; -- 1 if the data contained in the line is valid, 0 otherwise
		tag: out std_logic_vector(T-1 downto 0); -- tag stored in the selected line
		data_out: out std_logic_vector(W-1 downto 0); -- output of the selected line
		timestamp_out: out std_logic_vector(NT-1 downto 0) -- timestamp of the selected line
	);
end component dcache_block;

component up_counter is
	generic (
		N: integer := 32 -- number of bits
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		o: out std_logic_vector(N-1 downto 0)
	);
end component up_counter;

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

component mux_2x1 is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sel: in std_logic;
		o: out std_logic_vector(N-1 downto 0)
	);
end component mux_2x1;

component lte_comparator is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		lte: out std_logic
	);
end component lte_comparator;

component en_decoder_2x4 is
	port (
		i: in std_logic_vector(1 downto 0);
		en: in std_logic;
		o: out std_logic_vector(3 downto 0)
	);
end component en_decoder_2x4;

type logic_array is array (0 to 3) of std_logic;
type tag_array is array (0 to 3) of std_logic_vector(T-1 downto 0);
type data_array is array (0 to 3) of std_logic_vector(W-1 downto 0);
type timestamp_array is array (0 to 3) of std_logic_vector(31 downto 0);

signal timestamp: std_logic_vector(31 downto 0);
signal update_array: std_logic_vector(3 downto 0);
signal valid_array: logic_array;
signal tag_out_array: tag_array;
signal data_out_array: data_array;
signal timestamps: timestamp_array;
signal hits_misses: logic_array;
signal tags_equals: logic_array;
signal hits: logic_array;
signal mux_enc: std_logic_vector(1 downto 0);
signal lte_lv1: std_logic_vector(1 downto 0);
signal index_mux_lv1: std_logic_vector(3 downto 0);
signal timestamp_mux_lv1: std_logic_vector(63 downto 0);
signal lte_final_mux: std_logic;
signal update_enc_input: std_logic_vector(1 downto 0);
signal int_inc_timestamp: logic_array;

begin
	-- counter generating the in-cache timestamp for the replacement algorithm
	timestamp_counter: up_counter
		generic map (
			N => 32
		)
		port map (
			clk => clk,
			rst => rst,
			o => timestamp
		);

	-- instantiate the 4 cache blocks along with the logic for detecting if a hit has occurred
	blocks: for i in 0 to 3 generate
		cb: dcache_block
			generic map (
				T => T,
				W => W,
				N => NL / 4,
				NL => NL,
				NT => 32
			)
			port map (
				clk => clk,
				rst => rst,
				update => update_array(i),
				inc_timestamp => int_inc_timestamp(i),
				read_line => read_line,
				address => address,
				data_in => data_in,
				timestamp_in => timestamp,
				valid => valid_array(i),
				tag => tag_out_array(i),
				data_out => data_out_array(i),
				timestamp_out => timestamps(i)
			);

		-- compare the tag coming out from the block with the one passed as input to the cache
		ec: equality_comparator
			generic map (
				N => T
			)
			port map (
				a => address(T+n_width(NL/4)+2-1 downto n_width(NL/4)+2),
				b => tag_out_array(i),
				o => tags_equals(i)
			);

		-- a hit is valid iff the tag matches and the valid bit is set to 1
		a_i: and2
			port map (
				a => valid_array(i),
				b => tags_equals(i),
				o => hits(i)
			);
			
		int_inc_timestamp(i) <= hits(i) and (not update);	
	end generate blocks;

	b0 <= data_out_array(0);
	b1 <= data_out_array(1);
	b2 <= data_out_array(2);
	b3 <= data_out_array(3);

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
			N => W	
		)
		port map (
			a => data_out_array(0),
			b => data_out_array(1),
			c => data_out_array(2),
			d => data_out_array(3),
			sel => mux_enc,
			o => data_out
		);

	hit_miss <= hits(0) or hits(1) or hits(2) or hits(3);

	-- Here starts the replacement logic instantiation. It works in this way:
	--
	-- The blocks are grouped in two and a comparison is done to find which of the two
	-- blocks in a group has the oldest timestamp. This happens in parallel
	-- between the two groups. Based on the comparison's output there are two
	-- muxes per group which output the index of the block with the smallest
	-- timestamp and its index position.
	--
	-- The timestamp coming from the two groups is the input of another less-than-or-equal
	-- comparator, which does the same work as before.
	--
	-- The final output of the mux handling the indexes determines the block where the
	-- replacement must take place, as it's the input to a 2x4 decoder which drive the
	-- update pins of the blocks. This decoder has an enable pin to avoid unwanted updates
	-- (that is, if to the cache no update has been requested, the decoder will keep to low
	-- all the update signals)
	update_comp_lv1 : for i in 0 to 1 generate
		lte: lte_comparator
			generic map (
				N => 32
			)
			port map (
				a => timestamps(2*i),
				b => timestamps(2*i+1),
				lte => lte_lv1(i)
			);

		index_mux: mux_2x1
			generic map (
				N => 2
			)
			port map (
				a => std_logic_vector(to_unsigned(2*i, 2)),
				b => std_logic_vector(to_unsigned(2*i+1, 2)),
				sel => lte_lv1(i),
				o => index_mux_lv1((i+1)*2-1 downto i*2)
			);

		timestamp_mux: mux_2x1
			generic map (
				N => 32
			)
			port map (
				a => timestamps(2*i),
				b => timestamps(2*i+1),
				sel => lte_lv1(i),
				o => timestamp_mux_lv1((i+1)*32-1 downto i*32)
			);
	end generate update_comp_lv1;

	comp0 <= lte_lv1(0);
	comp1 <= lte_lv1(1);
	ind0 <= index_mux_lv1(1 downto 0);
	ind1 <= index_mux_lv1(3 downto 2); 

	final_lte: lte_comparator
		generic map (
			N => 32
		)
		port map (
			a => timestamp_mux_lv1(31 downto 0),
			b => timestamp_mux_lv1(63 downto 32),
			lte => lte_final_mux
		);

	final_mux: mux_2x1
		generic map (
			N => 2
		)
		port map (
			a => index_mux_lv1(1 downto 0),
			b => index_mux_lv1(3 downto 2),
			sel => lte_final_mux,
			o => update_enc_input
		);

	en_enc: en_decoder_2x4
		port map (
			i => update_enc_input,
			en => update,
			o => update_array
		);

	comp2 <= lte_final_mux;
	ind2 <= update_enc_input;
	ts0 <= timestamps(0);
	ts1 <= timestamps(1);
	ts2 <= timestamps(2);
	ts3 <= timestamps(3);	
end architecture structural;