library ieee;
use ieee.std_logic_1164.all;

entity mux_5x1 is
	generic (
		NBIT: integer := 4
	);
	port ( -- the mux takes N and not N-1 as input because it has to handle the size of the shifted values
        a: in	std_logic_vector(NBIT downto 0);
        b: in	std_logic_vector(NBIT downto 0);
        c: in	std_logic_vector(NBIT downto 0);
        d: in	std_logic_vector(NBIT downto 0);
        e: in	std_logic_vector(NBIT downto 0);
        sel: in std_logic_vector(2 downto 0);
        y: out std_logic_vector(NBIT downto 0)
	);
end entity mux_5x1;

-- behavioral implementation

architecture behavioral of mux_5x1 is

begin
	process(a, b, c, d, e, sel)
	begin
	   case sel is
	       when "000" => y <= a;
	       when "001" => y <= b;
	       when "010" => y <= c;
	       when "011" => y <= d;
	       when "100" => y <= e;
	       when others => y <= (others => 'Z');
	   end case;    
    end process;
end architecture behavioral;