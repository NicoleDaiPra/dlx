library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use WORK.stype.all;

-- Behavioral shifter ablle to perform logical and arithmetical shifts and also 
-- rotate operations.

entity shifter is
    port ( 
        data_in: in std_logic_vector(31 downto 0);
        shift: in std_logic_vector(4 downto 0);
        shift_type: in std_logic_vector(3 downto 0); -- arith, logical, rotate right/left
        data_out: out std_logic_vector(31 downto 0)
    );
end shifter;

architecture beh of shifter is

begin
    shift_p: process(data_in, shift, shift_type)
        begin
            case shift_type is
                when LOGLEFT => data_out <= std_logic_vector(unsigned(data_in) sll to_integer(unsigned(shift)));
                when LOGRIGHT => data_out <= std_logic_vector(unsigned(data_in) srl to_integer(unsigned(shift)));
                --when ARITHLEFT => data_out <= std_logic_vector(unsigned(data_in) sla to_integer(unsigned(shift)));
                --when ARITHRIGHT => data_out <= std_logic_vector(unsigned(data_in) sra to_integer(unsigned(shift)));
                when ROTLEFT => data_out <= std_logic_vector(unsigned(data_in) rol to_integer(unsigned(shift)));
                when ROTRIGHT => data_out <= std_logic_vector(unsigned(data_in) ror to_integer(unsigned(shift))); 
                when others => data_out <= (others => '0');
            end case;
                
        end process shift_p;


end beh;
