library ieee;
use ieee.std_logic_1164.all;

-- Represent a single line in the cache.
-- It stores the tag, the data corresponding to it and a valid bit
entity btb_cache_line is
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
end entity btb_cache_line;

architecture behavioral of btb_cache_line is

	signal curr_valid, next_valid: std_logic;
	signal curr_tag, next_tag: std_logic_vector(T-1 downto 0);
	signal curr_data, next_data: std_logic_vector(L-1 downto 0);

begin
	state_reg: process(clk)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				curr_valid <= '0';
				curr_tag <= (others => '0');
				curr_data <= (others => '0');
			else
				curr_valid <= next_valid;
				curr_tag <= next_tag;
				curr_data <= next_data;
			end if;	
		end if;
	end process state_reg;

	valid <= curr_valid;
	tag_out <= curr_tag;
	data_out <= curr_data;

	comblogic: process(curr_valid, curr_tag, curr_data, update_line, update_data, tag_in, data_in)
	begin
		next_valid <= curr_valid;
		next_tag <= curr_tag;
		next_data <= curr_data;

		-- the tag must be updated
		if (update_line = '1') then
			next_tag <= tag_in;
		end if;

		-- update the data and set the validity bit to 1
		if (update_line = '1' or update_data = '1') then
			next_data <= data_in;
			next_valid <= '1';
		end if;
	end process comblogic;
end architecture behavioral;