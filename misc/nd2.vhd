library ieee;
use ieee.std_logic_1164.all; 

entity nd2 is
	port (	
		a: in std_logic;
		b: in std_logic;
		y: out std_logic
	);
end nd2;


architecture arch1 of nd2 is

begin
	y <= not( a and b);
end arch1;

architecture arch2 of nd2 is

begin
	p1: process(a,b) 
	begin
		if (a = '1') and (b = '1') then
			y <= '0';
		elsif (a = '0') or (b = '0') then 
			y <= '1';
		end if;
	end process;
end arch2;

