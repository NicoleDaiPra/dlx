library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_counter is
	generic (
		N: integer := 32 -- number of bits
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		o: out std_logic_vector(N-1 downto 0)
	);
end entity up_counter;

architecture behavioral of up_counter is
	signal curr_o, next_o: std_logic_vector(N-1 downto 0);
begin
	
	o <= curr_o;

	state_reg: process(clk)
	begin
		if (rst = '0') then
			curr_o <= (others => '0');
		elsif (clk = '1' and clk'event) then
			curr_o <= next_o;
		end if;
	end process state_reg;

	comblogic : process(curr_o)
	begin
		next_o <= std_logic_vector(unsigned(curr_o) + 1);
	end process comblogic;
end architecture behavioral;