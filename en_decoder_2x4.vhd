library ieee;
use ieee.std_logic_1164.all;

entity en_decoder_2x4 is
	port (
		i: in std_logic_vector(1 downto 0);
		en: in std_logic;
		o: out std_logic_vector(3 downto 0)
	);
end entity en_decoder_2x4;

architecture behavioral of en_decoder_2x4 is
	signal cmd: std_logic_vector(2 downto 0);
begin
	cmd <= en&i;

	o <= "0001" when cmd = "100" else
	  	 "0010" when cmd = "101" else
	  	 "0100" when cmd = "110" else
	  	 "1000" when cmd = "111" else
	  	 "0000";
end architecture behavioral;