library ieee;
use ieee.std_logic_1164.all;

entity mux_6x1_single_bit is
	port (
        a: in std_logic;
        b: in std_logic;
        c: in std_logic;
        d: in std_logic;
        e: in std_logic;
        f: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        y: out std_logic
	);
end entity mux_6x1_single_bit;

-- behavioral implementation

architecture behavioral of mux_6x1_single_bit is

begin
	process(a, b, c, d, e, f, sel)
	begin
	   case sel is
	       when "000" => y <= a;
	       when "001" => y <= b;
	       when "010" => y <= c;
	       when "011" => y <= d;
	       when "100" => y <= e;
	       when "101" => y <= f;
	       when others => y <= '0';
	   end case;    
    end process;
end architecture behavioral;