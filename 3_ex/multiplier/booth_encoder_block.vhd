library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity booth_encoder_block is
    port (
        b: in std_logic_vector(2 downto 0);
        y: out std_logic_vector(2 downto 0)
    );
end booth_encoder_block;

architecture behavioral of booth_encoder_block is
    
begin
    process(b)
    begin
        -- encode the selection signal for the multiplexers
        case (b) is
            when "000" => y  <= "000"; -- 0
            when "111" => y <= "000"; -- 0
            when "001" => y <= "001"; -- A 
            when "010" => y <= "001"; -- A 
            when "101" => y <= "010"; -- -A
            when "110" => y <= "010"; -- -A
            when "011" => y <= "011"; -- 2A
            when "100" => y <= "100"; -- -2A
            when others => y <= (others => 'Z');          
        end case;
end process;

end behavioral;
