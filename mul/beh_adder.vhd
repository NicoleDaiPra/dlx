library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity beh_adder is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		cin: in std_logic;
		sum: out std_logic_vector(N-1 downto 0);
		cout: out std_logic
	);
end beh_adder;

architecture behavioral of beh_adder is

begin
	process(a, b, cin)
		variable tmp: std_logic_vector(N downto 0);
		variable a_i, b_i, c_i: std_logic_vector(N downto 0);
	begin
	    a_i := '0'&a;
	    b_i := '0'&b;
	    c_i := (0 => cin, others => '0');
		tmp := std_logic_vector(unsigned(a_i) + unsigned(b_i) + unsigned(c_i));
		sum <= tmp(N-1 downto 0);
		cout <= tmp(N);
	end process;

end behavioral;
