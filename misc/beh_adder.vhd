library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity beh_hadder is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sum: out std_logic_vector(N-1 downto 0);
		cout: out std_logic
	);
end beh_hadder;

architecture behavioral of beh_hadder is

begin
	process(a, b)
		variable tmp: std_logic_vector(N downto 0);
		variable a_i, b_i: std_logic_vector(N downto 0);
	begin
	    a_i := '0'&a;
	    b_i := '0'&b;
		tmp := std_logic_vector(unsigned(a_i) + unsigned(b_i));
		sum <= tmp(N-1 downto 0);
		cout <= tmp(N);
	end process;

end behavioral;
