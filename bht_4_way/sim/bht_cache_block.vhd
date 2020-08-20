library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fun_pack.n_width;

-- A cache block contains N cache lines. Each of these lines correspond to a different set.
entity bht_cache_block is
	generic (
		T: integer := 22; --tag bit size
		W: integer := 32; -- word size
		N: integer := 4; -- number of lines contained in the block (each line correspond to a different cache set)
		NL: integer := 16 -- total number of lines present in the cache
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
end entity bht_cache_block;

architecture behavioral of bht_cache_block is
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

	type data_array is array (0 to N-1) of std_logic_vector(W-1 downto 0);
	type tag_array is array (0 to N-1) of std_logic_vector(T-1 downto 0);

	signal valid_vector: std_logic_vector(N-1 downto 0);
	signal data_out_array: data_array;
	signal update_line_vector, update_data_vector: std_logic_vector(N-1 downto 0);
	signal tag_out_array: tag_array;

begin
	line_gen: for i in 0 to N-1 generate
		line: bht_cache_line
			generic map (
				T => T,
				L => W
			)
			port map (
				clk => clk,
				rst => rst,
				update_line => update_line_vector(i),
				update_data => update_data_vector(i),
				tag_in => address_rw(T+n_width(NL/4)-1 downto n_width(NL/4)),
				data_in => data_in,
				valid => valid_vector(i),
				tag_out => tag_out_array(i),
				data_out => data_out_array(i)
			);
	end generate line_gen;

	tag_read <= tag_out_array(to_integer(unsigned(address_read(n_width(NL/4)-1 downto 0))));
	tag_rw <= tag_out_array(to_integer(unsigned(address_rw(n_width(NL/4)-1 downto 0))));
	data_out_read <= data_out_array(to_integer(unsigned(address_read(n_width(NL/4)-1 downto 0))));
	data_out_rw <= data_out_array(to_integer(unsigned(address_rw(n_width(NL/4)-1 downto 0))));
	valid_read <= valid_vector(to_integer(unsigned(address_read(n_width(NL/4)-1 downto 0))));
	valid_rw <= valid_vector(to_integer(unsigned(address_rw(n_width(NL/4)-1 downto 0))));

	comblogic: process(valid_vector, tag_out_array, data_out_array, update_line, update_data)
	begin
		update_line_vector <= (others => '0');
		update_data_vector <= (others => '0');

		if (update_line = '1') then
			update_line_vector(to_integer(unsigned(address_rw(n_width(NL/4)-1 downto 0)))) <= '1';
		end if;

		if (update_data = '1') then
			update_data_vector(to_integer(unsigned(address_rw(n_width(NL/4)-1 downto 0)))) <= '1';
		end if;
	end process comblogic;
end architecture behavioral;