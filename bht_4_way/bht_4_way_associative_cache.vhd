library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.fun_pack.all;

entity bht_4_way_associative_way is
	generic (
		T: integer := 29; -- width of the TAG bits
		W: integer := 16; -- word size
		NL: integer := 32 -- total number of lines in the cache (internally they're split in sets)
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		update_line: in std_logic; -- if update_line = '1' the cache adds a new entry to the cache
		update_data: in std_logic; -- if update_data = '1' the cache only replace the data corresponding to a tag
		read_address: in std_logic_vector(T+n_width(NL/4)-1 downto 0); -- address to be read from the cache
		rw_address: in std_logic_vector(T+n_width(NL/4)-1 downto 0); -- address to be written from the cache
		data_in: in std_logic_vector(W-1 downto 0); -- data to be added to the cache
		hit_miss_read: out std_logic; -- if read_address generates a hit then hit_miss_read = '1', otherwise hit_miss_read ='0'
		data_out_read: out std_logic_vector(W-1 downto 0); -- if hit_miss_read = '1' it contains the searched data, otherwise its value must not be considered
		hit_miss_rw: out std_logic; -- if rw_address generates a hit then hit_miss_rw = '1', otherwise hit_miss_rw ='0'
		data_out_rw: out std_logic_vector(W-1 downto 0) -- if hit_miss_rw = '1' it contains the searched data, otherwise its value must not be considered
	);
end entity bht_4_way_associative_way;

architecture structural of bht_4_way_associative_way is
	component bht_cache_block is
		generic (
			T: integer := 29; --tag bit size
			W: integer := 32; -- word size
			N: integer := 3; -- number of lines contained in the block (each line correspond to a different cache set)
			NL: integer := 32 -- total number of lines present in the cache
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			update_line: in std_logic; -- if update_line = '1' the block update a whole line
			update_data: in std_logic; -- if update_data = '1' the block update only the data stored in a line 
			address_read: in std_logic_vector(T+n_width(NL/4)-1 downto 0); -- read-only address to be matched
			address_rw: in std_logic_vector(T+n_width(NL/4)-1 downto 0); -- read-write address to be matched
			data_in: in std_logic_vector(W-1 downto 0); -- data to be added to a line
			valid_read: out std_logic; -- 1 if the data contained in the line is valid, 0 otherwise
			valid_rw: out std_logic; -- 1 if the data contained in the line is valid, 0 otherwise
			tag_read: out std_logic_vector(T-1 downto 0); -- tag stored in the read-only selected line
			tag_rw: out std_logic_vector(T-1 downto 0); -- tag stored in the rw selected line
			data_out_read: out std_logic_vector(W-1 downto 0); -- output of the read-only selected line
			data_out_rw: out std_logic_vector(W-1 downto 0) -- output of the read-only selected line
		);
	end component bht_cache_block;

	component bht_cache_replacement_logic is
		generic (
			NL: integer := 64 -- total number of lines in the cache
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			cache_update: in std_logic; -- if 1 the cache wants to update a line
			set_rw: in std_logic_vector(n_width(NL/4)-1 downto 0); -- the set that is being updated
			line_update: out std_logic_vector(3 downto 0) -- if the i-th bit is set to 1 the i-th line updates its content
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

	component priority_encoder_4to2 is
		port (
			a: in std_logic;
			b: in std_logic;
			c: in std_logic;
			d: in std_logic;
			enc: out std_logic_vector(1 downto 0)
		);
	end component priority_encoder_4to2;

	type tag_array is array (0 to 3) of std_logic_vector(T-1 downto 0);
	type data_array is array (0 to 3) of std_logic_vector(W-1 downto 0);

	signal update_line_int, update_data_int: std_logic_vector(3 downto 0);
	signal valid_read_int, valid_rw_int: std_logic_vector(3 downto 0);
	signal tag_out_read, tag_out_rw: tag_array;
	signal data_out_read_array, data_out_rw_array: data_array;
	signal equals_read, equals_rw: std_logic_vector(3 downto 0);
	signal hits_read, hits_rw: std_logic_vector(3 downto 0);
	signal read_mux_enc, rw_mux_enc: std_logic_vector(1 downto 0);

begin
	-- tells to the lines when they have to update their data
	replacement: bht_cache_replacement_logic
		generic map (
			NL => NL
		)
		port map (
			clk => clk,
			rst => rst,
			cache_update => update_line,
			set_rw => rw_address(n_width(NL/4)-1 downto 0),
			line_update => update_line_int
		);

	-- instantiate the 4 cache blocks along with the logic for detecting if a hit has occurred
	block_gen: for i in 0 to 3 generate
		block_i: bht_cache_block
			generic map (
				T => T,
				W => W,
				N => NL/4,
				NL => NL
			)
			port map (
				clk => clk,
				rst => rst,
				update_line => update_line_int(i),
				update_data => update_data_int(i),
				address_read => read_address,
				address_rw => rw_address,
				data_in => data_in,
				valid_read => valid_read_int(i),
				valid_rw => valid_rw_int(i),
				tag_read => tag_out_read(i),
				tag_rw => tag_out_rw(i),
				data_out_read => data_out_read_array(i),
				data_out_rw => data_out_rw_array(i)
			);

		eq_comp_read_hit: equality_comparator
			generic map (
				N => T
			)
			port map (
				a => read_address(T+n_width(NL/4)-1 downto n_width(NL/4)),
				b => tag_out_read(i),
				o => equals_read(i)
			);

		hit_read_i: and2
			port map (
				a => equals_read(i),
				b => valid_read_int(i),
				o => hits_read(i)
			);

		-- another equality comparator is needed to compare
		-- the 'rw_address' to the tags to find out
		-- the line where the data must be updated. This
		-- has to work in parallel with the read, therefore
		-- the need of the structure's duplication 
		eq_comp_rw_hit: equality_comparator
			generic map (
				N => T
			)
			port map (
				a => rw_address(T+n_width(NL/4)-1 downto n_width(NL/4)),
				b => tag_out_rw(i),
				o => equals_rw(i)
			);

		hit_rw_i: and2
			port map (
				a => equals_rw(i),
				b => valid_rw_int(i),
				o => hits_rw(i)
			);

		-- if the rw_address matches the one stored in the tag
		-- and the line is valid, if the cache wants to update only
		-- the data contained is allowed to do it
		update_data_i: and2
			port map (
				a => hits_rw(i),
				b => update_data,
				o => update_data_int(i)
			);
	end generate block_gen;

	-- decides which output signal has to go toward the read_data_mux
	read_encoder: priority_encoder_4to2
		port map (
			a => hits_read(0),
			b => hits_read(1),
			c => hits_read(2),
			d => hits_read(3),
			enc => read_mux_enc
		);

	-- decides which output signal has to go toward the rw_data_mux
	rw_encoder: priority_encoder_4to2
		port map (
			a => hits_rw(0),
			b => hits_rw(1),
			c => hits_rw(2),
			d => hits_rw(3),
			enc => rw_mux_enc
		);

	-- data mux read_address port
	read_data_mux: mux_4x1
		generic map (
			N => W
		)
		port map (
			a => data_out_read_array(0),
			b => data_out_read_array(1),
			c => data_out_read_array(2),
			d => data_out_read_array(3),
			sel => read_mux_enc,
			o => data_out_read
		);

	-- data mux rw_address port
	rw_data_mux: mux_4x1
		generic map (
			N => W
		)
		port map (
			a => data_out_rw_array(0),
			b => data_out_rw_array(1),
			c => data_out_rw_array(2),
			d => data_out_rw_array(3),
			sel => rw_mux_enc,
			o => data_out_rw
		);

	hit_miss_read <= or_reduce(hits_read);
	hit_miss_rw <= or_reduce(hits_rw);
end architecture structural;