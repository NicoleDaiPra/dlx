library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_in_generator is
    generic (
        NBIT: integer := 32;
        SHIFT_LEVEL: integer := 3 
    );
    port (
        a: in std_logic_vector(NBIT-1 downto 0);
        zeros: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
        pos_a: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
        neg_a: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
        pos_2a: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
        neg_2a: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0)
    );
end mux_in_generator;

architecture behavioral of mux_in_generator is
    signal pos_tmp: std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
    signal neg_tmp: std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
    constant nbit_shift: integer := SHIFT_LEVEL*2; -- tells of how many bits the input a must be shifted
    
begin
    process(a)
        variable sign_ext_n: std_logic_vector((SHIFT_LEVEL*2) downto 0);
        variable sign_ext: std_logic;
    begin
        -- sign extension of 'a' has to be performed
        if (SHIFT_LEVEL = 0) then
            -- if SHIFT_LEVEL is 0 sign_ext must be used, as vectors(0 downto 0) are not supported
            sign_ext := a(NBIT-1);
            pos_tmp <= sign_ext&a;
            neg_tmp <= std_logic_vector(0-signed(sign_ext&a));
        else
            sign_ext_n := (others => a(NBIT-1));
            pos_tmp <= sign_ext_n&a;
            neg_tmp <= std_logic_vector(0-signed(sign_ext_n&a));
        end if;
    end process;
    
    zeros <= (others => '0');
    pos_a <= std_logic_vector(signed(pos_tmp) sll nbit_shift);
    neg_a <= std_logic_vector(signed(neg_tmp) sll nbit_shift);
    pos_2a <= std_logic_vector(signed(pos_tmp) sll nbit_shift+1);
    neg_2a <= std_logic_vector(signed(neg_tmp) sll nbit_shift+1);
end behavioral;
