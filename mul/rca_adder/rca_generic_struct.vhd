library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity rca_generic_struct is 
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
end rca_generic_struct; 

-- Structural implementation

architecture structural of rca_generic_struct is
    signal stmp: std_logic_vector(N-1 downto 0); -- Store the s output of the fa
    signal ctmp: std_logic_vector(N downto 0); -- Store the carry of the fa

    component fa 
        port (
            a: in std_logic;
            b: in std_logic;
            cin: in std_logic;
            s: out std_logic;
            cout: out std_logic
        );
  end component; 

begin

    ctmp(0) <= cin; -- Initialize the carry
    s <= stmp; -- Output the sum result
    cout <= ctmp(N); -- Output the co of the entire sum
  
    -- Generation of the full adders

    adder1: for i in 1 to N generate
        fai: fa 
            port map (a(i-1), b(i-1), ctmp(i-1), stmp(i-1), ctmp(i));
    end generate;
end architecture structural;