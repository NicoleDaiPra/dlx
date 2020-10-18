library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fun_pack.all;

-- Direct mapping replacement policy implementation. It drives
-- the lines' update_line and update_data signal accordingly to the
-- cache needs.
-- The user of the cache must be sure to raise either update_line or update_data
-- but not both in a single clock cycle.
entity bht_cache_replacement_logic is
	generic (
		NL: integer := 32
	);
	port (
		rw_line_index: in std_logic_vector(n_width(NL)-1 downto 0);
		cache_update_line: in std_logic;
		cache_update_data: in std_logic;
		hit: in std_logic; -- update_data can have a bit set to 1 iff the selected line contains valid data
		update_line: out std_logic_vector(NL-1 downto 0);
		update_data: out std_logic_vector(NL-1 downto 0)
	);
end entity bht_cache_replacement_logic;

architecture behavioral of bht_cache_replacement_logic is

begin
	comblogic: process(rw_line_index, cache_update_line, cache_update_data, hit)
	begin
		update_data <= (others => '0');
		update_line <= (others =>'0');

		if (cache_update_line = '1') then
			update_line(to_integer(unsigned(rw_line_index))) <= '1';
		end if;

		if (cache_update_data = '1') then
			update_data(to_integer(unsigned(rw_line_index))) <= hit; -- equals to "1 and hit"
		end if;
	end process comblogic;
end architecture behavioral;