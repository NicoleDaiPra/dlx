library ieee;
use ieee.std_logic_1164.all;

-- A single line cache. It stores a word, the tag, the validity bit and the dirty bit.
entity dcache_line is
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
end dcache_line;

architecture behavioral of dcache_line is
	signal curr_data, next_data: std_logic_vector(N-1 downto 0); -- data stored inside the cache (in big endian)
	signal curr_tag, next_tag: std_logic_vector(T-1 downto 0);
	signal curr_valid, next_valid: std_logic;
	signal curr_dirty, next_dirty: std_logic;
begin
	state_reg: process(clk, rst)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				curr_data <= (others  => '0');
				curr_tag <= (others  => '0');
				curr_valid <= '0';
				curr_dirty <= '0';
			else
				curr_data <= next_data;
				curr_tag <= next_tag;
				curr_valid <= next_valid;
				curr_dirty <= next_dirty;
			end if;
		end if;
	end process state_reg;

	ram_data_out <= curr_data;
	cpu_data_out <= curr_data(N/4-1 downto 0)&curr_data(N/2-1 downto N/4)&curr_data(3*N/4-1 downto N/2)&curr_data(N-1 downto 3*N/4);
	tag_out <= curr_tag;
	valid <= curr_valid;
	dirty <= curr_dirty;
	
	comblogic: process(curr_data, curr_tag, curr_valid, curr_dirty, tag_in, update, update_type, ram_data_in, cpu_data_in)
	begin
		next_data <=  curr_data;
		next_tag <= curr_tag;
		next_valid <= curr_valid;
		next_dirty <= curr_dirty;

		if (update = '1') then
			next_tag <= tag_in;
			next_valid <= '1';
			case (update_type) is
				when "00" => -- stores N bits from the RAM
					next_data <= ram_data_in;
					next_dirty <= '0';
				when "01" => -- stores N bits from the CPU
					next_data <= cpu_data_in(N/4-1 downto 0)&cpu_data_in(N/2-1 downto N/4)&cpu_data_in(3*N/4-1 downto N/2)&cpu_data_in(N-1 downto 3*N/4);
					next_dirty <= '1';
				when "10" => -- stores N/2 bits from the CPU
					next_data <= cpu_data_in(N/4-1 downto 0)&cpu_data_in(N/2-1 downto N/4)&curr_data(N/2-1 downto 0);
					next_dirty <= '1';
				when "11" => -- stores N/4 bits from the CPU
					next_data <= cpu_data_in(N/4-1 downto 0)&curr_data(3*N/4-1 downto 0);	
				when others => -- this really shouldn't happens
					next_data <= curr_data;
					next_dirty <= '1';
			end case;
		end if;
	end process comblogic;

end behavioral;
