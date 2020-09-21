library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.fun_pack.n_width;

-- 32-entries fully associative cache implementation.
-- It's possible to define the width of the tag bits and the size of a line.
-- The replacement policy is FIFO.
-- This cache doesn't support multiple words stored into a single line
-- as it is meant to be used inside a BHT.
-- The cache has 2 output ports, one that correspond to 'read_address', which
-- is an address used for read-only operations, and another one corresponding to
-- 'rw_address' which can be used for both read and write instructions.
-- The output ports have corresponding 'hit_miss' signals
entity btb_fully_associative_cache is
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
end entity btb_fully_associative_cache;

architecture structural of btb_fully_associative_cache is
	component btb_cache_line is
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
	end component btb_cache_line;

	component btb_cache_replacement_logic is
		generic (
			NL: integer := 128
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			cache_update: in std_logic; -- if 1 the cache wants to update a line
			line_update: out std_logic_vector(NL-1 downto 0) -- if the i-th bit is set to 1 the i-th line updates its content
		);
	end component btb_cache_replacement_logic;

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

	component encoder_32x5 is
		port (
			i: in std_logic_vector(31 downto 0);
			enc: out std_logic_vector(4 downto 0)
		);
	end component encoder_32x5;

	component mux_32x1 is
		generic (
			NBIT: integer := 32
		);
		port (
			a: in std_logic_vector(NBIT-1 downto 0);
			b: in std_logic_vector(NBIT-1 downto 0);
			c: in std_logic_vector(NBIT-1 downto 0);
			d: in std_logic_vector(NBIT-1 downto 0);
			e: in std_logic_vector(NBIT-1 downto 0);
			f: in std_logic_vector(NBIT-1 downto 0);
			g: in std_logic_vector(NBIT-1 downto 0);
			h: in std_logic_vector(NBIT-1 downto 0);
			i: in std_logic_vector(NBIT-1 downto 0);
			j: in std_logic_vector(NBIT-1 downto 0);
			k: in std_logic_vector(NBIT-1 downto 0);
			l: in std_logic_vector(NBIT-1 downto 0);
			m: in std_logic_vector(NBIT-1 downto 0);
			n: in std_logic_vector(NBIT-1 downto 0);
			o: in std_logic_vector(NBIT-1 downto 0);
			p: in std_logic_vector(NBIT-1 downto 0);
			q: in std_logic_vector(NBIT-1 downto 0);
			r: in std_logic_vector(NBIT-1 downto 0);
			s: in std_logic_vector(NBIT-1 downto 0);
			t: in std_logic_vector(NBIT-1 downto 0);
			u: in std_logic_vector(NBIT-1 downto 0);
			v: in std_logic_vector(NBIT-1 downto 0);
			w: in std_logic_vector(NBIT-1 downto 0);
			x: in std_logic_vector(NBIT-1 downto 0);
			y: in std_logic_vector(NBIT-1 downto 0);
			z: in std_logic_vector(NBIT-1 downto 0);
			aa: in std_logic_vector(NBIT-1 downto 0);
			ab: in std_logic_vector(NBIT-1 downto 0);
			ac: in std_logic_vector(NBIT-1 downto 0);
			ad: in std_logic_vector(NBIT-1 downto 0);
			ae: in std_logic_vector(NBIT-1 downto 0);
			af: in std_logic_vector(NBIT-1 downto 0);
			sel: in std_logic_vector(4 downto 0);
			outp: out std_logic_vector(NBIT-1 downto 0)
		);
	end component mux_32x1;

	type tag_array is array (0 to 31) of std_logic_vector(T-1 downto 0);
	type data_array is array (0 to 31) of std_logic_vector(L-1 downto 0);

	signal update_line_int: std_logic_vector(31 downto 0);
	signal valid_int: std_logic_vector(31 downto 0);
	signal tags: tag_array;
	signal data_out_vector: data_array;
	signal equals_read, equals_rw: std_logic_vector(31 downto 0);
	signal hits_read, hits_rw: std_logic_vector(31 downto 0);
	signal update_data_int: std_logic_vector(31 downto 0);
	signal read_mux_enc, rw_mux_enc: std_logic_vector(4 downto 0);

begin
	-- tells to the lines when they have to update their data
	replacement: btb_cache_replacement_logic
		generic map (
			NL => 32
		)
		port map (
			clk => clk,
			rst => rst,
			cache_update => update_line,
			line_update => update_line_int
		);
	
	-- Instantiate NL lines along with their comparators and hit detectors
	line_gen: for i in 0 to 31 generate
		line: btb_cache_line
			generic map (
				T => T,
				L => L
			)
			port map (
				clk => clk,
				rst => rst,
				update_line => update_line_int(i),
				update_data => update_data_int(i),
				tag_in => rw_address,
				data_in => data_in,
				valid => valid_int(i),
				tag_out => tags(i),
				data_out => data_out_vector(i)
			);

		eq_comp_read_hit: equality_comparator
			generic map (
				N => T
			)
			port map (
				a => read_address,
				b => tags(i),
				o => equals_read(i)
			);

		hit_read_i: and2
			port map (
				a => equals_read(i),
				b => valid_int(i),
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
				a => rw_address,
				b => tags(i),
				o => equals_rw(i)
			);

		hit_rw_i: and2
			port map (
				a => equals_rw(i),
				b => valid_int(i),
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
	end generate line_gen;

	-- decides which output signal has to go toward the read_data_mux
	read_encoder: encoder_32x5
		port map (
			i => hits_read,
			enc => read_mux_enc
		);

	-- decides which output signal has to go toward the rw_data_mux
	rw_encoder: encoder_32x5
		port map (
			i => hits_rw,
			enc => rw_mux_enc
		);

	-- data mux read_address port
	read_data_mux: mux_32x1
		generic map (
			NBIT => L
		)
		port map (
			a => data_out_vector(0),
			b => data_out_vector(1),
			c => data_out_vector(2),
			d => data_out_vector(3),
			e => data_out_vector(4),
			f => data_out_vector(5),
			g => data_out_vector(6),
			h => data_out_vector(7),
			i => data_out_vector(8),
			j => data_out_vector(9),
			k => data_out_vector(10),
			l => data_out_vector(11),
			m => data_out_vector(12),
			n => data_out_vector(13),
			o => data_out_vector(14),
			p => data_out_vector(15),
			q => data_out_vector(16),
			r => data_out_vector(17),
			s => data_out_vector(18),
			t => data_out_vector(19),
			u => data_out_vector(20),
			v => data_out_vector(21),
			w => data_out_vector(22),
			x => data_out_vector(23),
			y => data_out_vector(24),
			z => data_out_vector(25),
			aa => data_out_vector(26),
			ab => data_out_vector(27),
			ac => data_out_vector(28),
			ad => data_out_vector(29),
			ae => data_out_vector(30),
			af => data_out_vector(31),
			sel => read_mux_enc,
			outp => data_out_read
		);

	rw_data_mux: mux_32x1
		generic map (
			NBIT => L
		)
		port map (
			a => data_out_vector(0),
			b => data_out_vector(1),
			c => data_out_vector(2),
			d => data_out_vector(3),
			e => data_out_vector(4),
			f => data_out_vector(5),
			g => data_out_vector(6),
			h => data_out_vector(7),
			i => data_out_vector(8),
			j => data_out_vector(9),
			k => data_out_vector(10),
			l => data_out_vector(11),
			m => data_out_vector(12),
			n => data_out_vector(13),
			o => data_out_vector(14),
			p => data_out_vector(15),
			q => data_out_vector(16),
			r => data_out_vector(17),
			s => data_out_vector(18),
			t => data_out_vector(19),
			u => data_out_vector(20),
			v => data_out_vector(21),
			w => data_out_vector(22),
			x => data_out_vector(23),
			y => data_out_vector(24),
			z => data_out_vector(25),
			aa => data_out_vector(26),
			ab => data_out_vector(27),
			ac => data_out_vector(28),
			ad => data_out_vector(29),
			ae => data_out_vector(30),
			af => data_out_vector(31),
			sel => rw_mux_enc,
			outp => data_out_rw
		);

	hit_miss_read <= or_reduce(hits_read);
	hit_miss_rw <= or_reduce(hits_rw);
end architecture structural;