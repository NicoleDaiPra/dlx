library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- less than or equal comparator
-- return 1 if a <= b, otherwise 0
entity lte_comparator is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		lte: out std_logic
	);
end entity lte_comparator;

architecture behavioral of lte_comparator is

begin
    process(a, b)
    begin
        if (unsigned(a) <= unsigned(b)) then
            lte <= '1';
        else
            lte <= '0';	
        end if;
	end process;
end architecture behavioral;