library ieee;
use ieee.std_logic_1164.all;

entity encoder_32x5 is
    port (
        i: in std_logic_vector(31 downto 0);
        enc: out std_logic_vector(4 downto 0)
    );
end entity encoder_32x5;

architecture behavioral of encoder_32x5 is

begin
    with i select enc <=
        "00000" when X"00000001",
        "00001" when X"00000002",
        "00010" when X"00000004",
        "00011" when X"00000008",
        "00100" when X"00000010",
        "00101" when X"00000020",
        "00110" when X"00000040",
        "00111" when X"00000080",
        "01000" when X"00000100",
        "01001" when X"00000200",
        "01010" when X"00000400",
        "01011" when X"00000800",
        "01100" when X"00001000",
        "01101" when X"00002000",
        "01110" when X"00004000",
        "01111" when X"00008000",
        "10000" when X"00010000",
        "10001" when X"00020000",
        "10010" when X"00040000",
        "10011" when X"00080000",
        "10100" when X"00100000",
        "10101" when X"00200000",
        "10110" when X"00400000",
        "10111" when X"00800000",
        "11000" when X"01000000",
        "11001" when X"02000000",
        "11010" when X"04000000",
        "11011" when X"08000000",
        "11100" when X"10000000",
        "11101" when X"20000000",
        "11110" when X"40000000",
        "11111" when others;
end architecture behavioral;