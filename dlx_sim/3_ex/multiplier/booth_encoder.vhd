library ieee;
use ieee.std_logic_1164.all;

entity booth_encoder is
	port (
		b: in std_logic_vector(2 downto 0);
		y: out std_logic_vector(2 downto 0)
	);
end booth_encoder;

architecture behavioral of booth_encoder is

begin
	with b select y <= 
		"000" when "000", -- 0
		"000" when "111", -- 0
		"001" when "001", -- A
		"001" when "010", -- A
		"010" when "101", -- -A
		"010" when "110", -- -A
		"011" when "011", -- 2A
		"100" when "100", -- -2A
		"000" when others;
end behavioral;