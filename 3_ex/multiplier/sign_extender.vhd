library ieee;
use ieee.std_logic_1164.all;

entity sign_extender is
    generic (
        NBIT: integer := 4
    );
    port (
        msb: in std_logic;
        ext: out std_logic_vector(NBIT-1 downto 0)
    );
end sign_extender;

architecture behavioral of sign_extender is
    
begin
    ext <= (others => msb);
end behavioral;
