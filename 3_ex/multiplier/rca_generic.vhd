library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity rca_generic is 
    generic (
        N: integer := 8
    );
    port (
        a: in std_logic_vector(N-1 downto 0);
        b: in std_logic_vector(N-1 downto 0);
        cin: in std_logic;
        s: out std_logic_vector(N-1 downto 0);
        cout: out std_logic
    );
end rca_generic;

architecture behavioral of rca_generic is
  signal s_temp: std_logic_vector(N downto 0); -- signal to store the sum and carry result
  signal cin_temp: std_logic_vector(N downto 0);
begin
    cin_temp <= (0 => cin, others => '0');
    s_temp <= std_logic_vector(signed(a(N-1)&a) + signed(b(N-1)&b) + signed(cin_temp)); -- perform sign extension and the addition
    s <= s_temp(N-1 downto 0); -- output the sum result
    cout <= s_temp(N); -- the msb of the result is the carry out
end architecture behavioral;
