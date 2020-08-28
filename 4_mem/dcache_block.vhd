library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fun_pack.n_width;

-- a cache block contains A cache lines. Each of these lines correspond to a different set.
entity dcache_block is
	generic (
		T: integer := 22; --tag bit size
		W: integer := 32; -- word size
		N: integer := 4; -- number of lines contained in the block (each line correspond to a different cache set)
		NL: integer := 16; -- total number of lines present in the cache
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
end entity dcache_block;

architecture behavioral of dcache_block is
	component dcache_line is
		generic (
			T: integer := 22; -- tag bit size
			W: integer := 32 -- word size (in bits)
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			update: in std_logic; -- if update = '1' the line stores the incoming data
			tag_in: in std_logic_vector(T-1 downto 0); -- tag to be saved when update = 1
			offset: in std_logic_vector(1 downto 0); -- offset bits to select a word
			data_in: in std_logic_vector(4*W-1 downto 0); -- data to be added to the line
			valid: out std_logic; -- 1 if the data contained in the line is valid, 0 otherwise
			tag_out: out std_logic_vector(T-1 downto 0); -- tag stored in the line
			data_out: out std_logic_vector(W-1 downto 0) -- output containing the word chosen with offset
		);
	end component dcache_line;

	type logic_array is array (0 to N-1) of std_logic;
	type data_array is array (0 to N-1) of std_logic_vector(W-1 downto 0);
	type timestamp_array is array (0 to N-1) of std_logic_vector(NT-1 downto 0);
	type tag_array is array (0 to N-1) of std_logic_vector(T-1 downto 0);

	signal valid_array: logic_array;
	signal data_out_array: data_array;
	signal update_array: logic_array;
	signal tag_out_array: tag_array;
	signal curr_timestamps, next_timestamps: timestamp_array;
begin
	
	line_gen : for i in 0 to N-1 generate
		line: dcache_line
			generic map (
				T => T,
				W => W
			)
			port map (
				clk => clk,
				rst => rst,
				update => update_array(i),
				tag_in => address(T+n_width(NL/4)+2-1 downto n_width(NL/4)+2),
				offset => address(1 downto 0),
				data_in => data_in,
				valid => valid_array(i),
				tag_out => tag_out_array(i),
				data_out => data_out_array(i)
			);
	end generate line_gen;

	state_reg: process(clk)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				curr_timestamps <= (others => (others => '0'));
			else
				curr_timestamps <= next_timestamps;
			end if;
		end if;
	end process state_reg;

	comblogic: process(curr_timestamps, valid_array, tag_out_array, data_out_array, update, inc_timestamp, read_line, address, data_in, timestamp_in)
	begin

		init_update: for i in 0 to N-1 loop
			update_array(i) <= '0';
		end loop; -- init_update

		next_timestamps <= curr_timestamps;
		if (update = '1') then
			--update the line corresponding to the set contained in address
			update_array(to_integer(unsigned(address(n_width(NL/4)+2-1 downto 2)))) <= '1';
			next_timestamps(to_integer(unsigned(address(n_width(NL/4)+2-1 downto 2)))) <= timestamp_in;

		end if;

		if (inc_timestamp = '1') then
			next_timestamps(to_integer(unsigned(address(n_width(NL/4)+2-1 downto 2)))) <= timestamp_in;	
		end if;

		if (read_line = '1') then
			valid <= valid_array(to_integer(unsigned(address(n_width(NL/4)+2-1 downto 2))));
		else
			valid <= '0';	
		end if;
		
		tag <= tag_out_array(to_integer(unsigned(address(n_width(NL/4)+2-1 downto 2))));
		data_out <= data_out_array(to_integer(unsigned(address(n_width(NL/4)+2-1 downto 2))));
		timestamp_out <= curr_timestamps(to_integer(unsigned(address(n_width(NL/4)+2-1 downto 2))));
	end process comblogic;
end architecture behavioral;