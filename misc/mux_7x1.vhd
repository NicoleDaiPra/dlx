library ieee;
use ieee.std_logic_1164.all;

entity mux_7x1 is
	generic (
		N: integer := 4
	);
	port (
        a: in std_logic_vector(N-1 downto 0);
        b: in std_logic_vector(N-1 downto 0);
        c: in std_logic_vector(N-1 downto 0);
        d: in std_logic_vector(N-1 downto 0);
        e: in std_logic_vector(N-1 downto 0);
        f: in std_logic_vector(N-1 downto 0);
        g: in std_logic_vector(N-1 downto 0);
        sel: in std_logic_vector(2 downto 0);
        y: out std_logic_vector(N-1 downto 0)
	);
end mux_7x1;

architecture behavioral of mux_7x1 is

begin
	process(a, b, c, d, e, f, g, sel)
	begin
	   case sel is
	       when "000" => y <= a;
	       when "001" => y <= b;
	       when "010" => y <= c;
	       when "011" => y <= d;
	       when "100" => y <= e;
	       when "101" => y <= f;
	       when "110" => y <= g;
	       when others => y <= (others => '0');
	   end case;    
    end process;

end behavioral;
