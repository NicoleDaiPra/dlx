library ieee;
use ieee.std_logic_1164.all;

entity encoder_4to2 is
	port (
		i: in std_logic_vector(3 downto 0);
		o: out std_logic_vector(1 downto 0)
	);
end encoder_4to2;

architecture behavioral of encoder_4to2 is
begin
	with i select o <= 
		"00" when "0001",
		"01" when "0010",
		"10" when "0100",
		"11" when "1000",
		"00" when others;
end behavioral;
