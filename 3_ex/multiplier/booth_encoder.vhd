library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity booth_encoder is
    generic (
        NBIT: integer := 32;
        NMUX: integer := 16
    );
    port (
        b: in std_logic_vector(NBIT-1 downto 0);
        y: out std_logic_vector(3*NMUX-1 downto 0)
    );
end booth_encoder;

architecture behavioral of booth_encoder is
    component booth_encoder_block is
        port (
            b: in std_logic_vector(2 downto 0);
            y: out std_logic_vector(2 downto 0)
        );
    end component booth_encoder_block;
    
    signal booth_b: std_logic_vector(NBIT downto 0);
    signal odd_b: std_logic_vector(NBIT+1 downto 0);
    signal spl_b: std_logic_vector(3*NMUX-1 downto 0); -- contains b's values ordered as b(i+1)&b(i)&b(i), with i += 2

begin
    booth_b <= b&'0'; -- concatenate b(-1) to b, as required by the booth encoder
    
splitP: process(booth_b, odd_b, b) is
    begin
        if (NBIT mod 2 = 1) then
            -- the number of bits is odd, therefore sign extension must be performed
            -- to have the right number of bits for the encoder
            if (b(NBIT-1) = '1') then
                -- b is negative
                odd_b <= '1'&booth_b;
            else
                -- b is positive
                odd_b <= '0'&booth_b;
            end if;
            
            for i in 0 to NMUX-1 loop
                spl_b(3*i) <= odd_b(2*i);
                spl_b(3*i + 1) <= odd_b(2*i + 1);
                spl_b(3*i + 2) <= odd_b(2*i + 2);
            end loop;
        else
            -- the number of bits is even, therefore the number of bits needed is already there
            for i in 0 to NMUX-1 loop
                spl_b(3*i) <= booth_b(2*i);
                spl_b(3*i + 1) <= booth_b(2*i + 1);
                spl_b(3*i + 2) <= booth_b(2*i + 2);
            end loop;
        end if;    
    end process splitP;
    

    g0: for i in 0 to NMUX-1 generate
        -- for each mux create a booth encoder which takes as input b(i+1)&b(i)&b(i-1) and outputs the selection for the ith mux
        enc_block: booth_encoder_block
            port map (
                b => spl_b(3*i+2 downto 3*i),
                y => y(3*i+2 downto 3*i)
            );          
    end generate g0;
end behavioral;
