library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fun_pack.all;

-- A block contains a line per each set in the cache.
-- It redirects the cache inputs to the lines and output the value of the line selected by the set's bits
entity dcache_block is
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
end dcache_block;

architecture behavioral of dcache_block is
	component dcache_line is
		generic (
			T: integer := 22; -- tag size
			N: integer := 32 -- word size
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			tag_in: std_logic_vector(T-1 downto 0); -- tag to be added to the cache in case of an update
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
	end component dcache_line;

	type data_array is array (0 to NLINES-1) of std_logic_vector(N-1 downto 0);
	type tag_array is array (0 to NLINES-1) of std_logic_vector(T-1 downto 0);
	type bit_array is array (0 to NLINES-1) of std_logic;

	signal ram_data_out_arr, cpu_data_out_arr: data_array;
	signal tag_out_arr: tag_array;
	signal valid_arr: bit_array;
	signal dirty_arr: bit_array;
	signal update_arr: std_logic_vector(NLINES-1 downto 0);

begin
	lines_gen: for i in 0 to NLINES-1 generate
		line_i: dcache_line
			generic map (
				T => T,
				N => N
			)
			port map (
				clk => clk,
				rst => rst,
				tag_in => address(T+n_width(NLINES)-1 downto n_width(NLINES)),
				update => update_arr(i),
				update_type => update_type,
				ram_data_in => ram_data_in,
				cpu_data_in => cpu_data_in,
				valid => valid_arr(i),
				dirty => dirty_arr(i),
				ram_data_out => ram_data_out_arr(i),
				cpu_data_out => cpu_data_out_arr(i),
				tag_out => tag_out_arr(i)
			);
	end generate lines_gen;

	comblogic: process(address, update, valid_arr, ram_data_out_arr, cpu_data_out_arr, tag_out_arr)
	begin
		update_arr <= (others  => '0');

		valid <= valid_arr(to_integer(unsigned(address(n_width(NLINES)-1 downto 0))));
		dirty <= dirty_arr(to_integer(unsigned(address(n_width(NLINES)-1 downto 0))));
		ram_data_out <= ram_data_out_arr(to_integer(unsigned(address(n_width(NLINES)-1 downto 0))));
		cpu_data_out <= cpu_data_out_arr(to_integer(unsigned(address(n_width(NLINES)-1 downto 0))));
		tag_out <= tag_out_arr(to_integer(unsigned(address(n_width(NLINES)-1 downto 0))));

		if (update = '1') then
			update_arr(to_integer(unsigned(address(n_width(NLINES)-1 downto 0))))  <= '1';
		end if;
	end process comblogic;
end behavioral;
