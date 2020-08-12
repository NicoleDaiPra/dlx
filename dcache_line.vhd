library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- cache line implementation. It stores a tag, the data corresponding to the tag and a valid bit.
-- A line is 4*W bits wide
entity dcache_line is
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
end entity dcache_line;

architecture behavioral of dcache_line is
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

	signal curr_valid, next_valid: std_logic;
	signal curr_tag, next_tag: std_logic_vector(T-1 downto 0);
	signal curr_data, next_data: std_logic_vector(4*W-1 downto 0);

begin
	state_reg: process(clk)
	begin
		if (rst = '0') then
			curr_valid <= '0';
			curr_tag <= (others => '0');
			curr_data <= (others => '0');
		elsif (clk = '1' and clk'event) then
			curr_valid <= next_valid;
			curr_tag <= next_tag;
			curr_data <= next_data;
		end if;
	end process state_reg;

		mux: mux_4x1
		generic map (
			N => W
		)
		port map (
			a => curr_data(W-1 downto 0),
			b => curr_data(2*W-1 downto W),
			c => curr_data(3*w-1 downto 2*W),
			d => curr_data(4*W-1 downto 3*W),
			sel => offset,
			o => data_out
		);

	valid <= curr_valid;
	tag_out <= curr_tag;

	comblogic: process(curr_valid, curr_tag, curr_data, update, tag_in, data_in)
		variable data_in_be: std_logic_vector(4*W-1 downto 0) := (others => '0');
	begin
		next_valid <= curr_valid;
		next_tag <= curr_tag;
		next_data <= curr_data;
		
		if (update = '1') then
			-- if an update is requested store the line and save the new tag
			-- store the input data in big endian
			data_in_be := data_in(W-1 downto 0)&data_in(2*W-1 downto W)&data_in(3*W-1 downto 2*W)&data_in(4*W-1 downto 3*W);
			next_data <= data_in_be;
			next_valid <= '1';
			next_tag <= tag_in;
		end if;
	end process comblogic;
end architecture behavioral;