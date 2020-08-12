library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.stype.all;

-- This shifter exploits the algorithm used by the T2 shifter in order to compute
-- logical and arithmetical shift. The same concept is also used to perform
-- the rotate operation.

entity shifter_t2 is
    port (
        data_in: in std_logic_vector(31 downto 0);
        shift: in std_logic_vector(4 downto 0);
        shift_type: in std_logic_vector(3 downto 0);
        data_out: out std_logic_vector(31 downto 0);
        to_value: out integer;
        from_value: out integer
    );
end shifter_t2;

architecture beh of shifter_t2 is
	
	signal mask00, mask08, mask16, mask24: std_logic_vector(38 downto 0) := (others => '0');

	begin

    -- Process that creates the masks required based on the type of the operation
    -- Each type of operation has four different masks shifted/rotated by 0, 8, 16
    -- and 24 positions. 
    
	mask_p: process (data_in, shift_type)
		variable zeros: std_logic_vector(31 downto 0) := (others => '0');
		variable msb: std_logic_vector(30 downto 0);
		begin
		    msb := (others => data_in(31));
		    
			case shift_type is
				when LOGRIGHT => 
					mask00 <= zeros(6 downto 0) & data_in;
			   		mask08 <= zeros(14 downto 0) & data_in(31 downto 8);
		   			mask16 <= zeros(22 downto 0) & data_in(31 downto 16);
			   		mask24 <= zeros(30 downto 0) & data_in(31 downto 24); 
				when LOGLEFT => 
					mask00 <= data_in & zeros(6 downto 0);
			   		mask08 <= data_in(23 downto 0) & zeros(14 downto 0);
		   			mask16 <= data_in(15 downto 0) & zeros(22 downto 0);
			   		mask24 <= data_in(7 downto 0) & zeros(30 downto 0);
				when ARITHRIGHT => 
					mask00 <= msb(6 downto 0) & data_in;
			   		mask08 <= msb(14 downto 0) & data_in(31 downto 8);
		   			mask16 <= msb(22 downto 0) & data_in(31 downto 16);
			   		mask24 <= msb(30 downto 0) & data_in(31 downto 24);
				when ARITHLEFT =>
					mask00 <= data_in & zeros(6 downto 0);
			   		mask08 <= data_in(23 downto 0) & zeros(14 downto 0);
		   			mask16 <= data_in(15 downto 0) & zeros(22 downto 0);
			   		mask24 <= data_in(7 downto 0) & zeros(30 downto 0);
				when ROTRIGHT =>
					mask00 <= data_in(6 downto 0) & data_in;
					mask08 <= data_in(14 downto 0) & data_in(31 downto 8);
				   	mask16 <= data_in(22 downto 0) & data_in(31 downto 16);
				   	mask24 <= data_in(30 downto 0) & data_in(31 downto 24);
				when ROTLEFT =>
					mask00 <= data_in & data_in (31 downto 25);
					mask08 <= data_in(23 downto 0) & data_in(31 downto 17);
				   	mask16 <= data_in(15 downto 0) & data_in(31 downto 9);
				   	mask24 <= data_in(7 downto 0) & data_in(31 downto 1);
				when others => 
					mask00 <= (others => '0');
					mask08 <= (others => '0');
				   	mask16 <= (others => '0');
				   	mask24 <= (others => '0');
			end case;
			 
		end process mask_p;

    -- Process that performs the exact shift starting from the closest mask
    -- to the actual number of positions that has to be shifted.
    
	shift_p: process(mask00, mask08, mask16, mask24, shift, shift_type)
	    variable to_value_l: integer := 7;
	    variable to_value_r: integer := 0;
	    variable from_value_r: integer;
	    variable from_value_l: integer;
		begin
            
            --to_value_l := to_integer(unsigned(not(shift(2 downto 0))));
            --to_value_r := to_integer(unsigned(shift(2 downto 0)));
            --from_value_r := 31 + to_value_r;
            --from_value_l:= 31 + to_value_l;
            
            -- Select the closest mask taking into account the 2 MSB of 
            -- the shift signal. Detect if it is a left or right shift
            -- and extract the bits of the mask that represent the final result.
             
			case shift(4 downto 3) is
				when "00" =>
				    if (shift_type(0) = '1') then -- logical shift left
                       to_value_l := to_integer(unsigned(not(shift(2 downto 0))));
                       from_value_l:= 31 + to_value_l;
                       from_value <= from_value_l;
                       to_value <= to_value_l;
                       data_out <= mask00(from_value_l downto to_value_l);     
				    else -- logical shift right
                        to_value_r := to_integer(unsigned(shift(2 downto 0)));
                        from_value_r := 31 + to_value_r;
                        from_value <= from_value_r;
                        to_value <= to_value_r;
                        data_out <= mask00(from_value_r downto to_value_r);
				    end if;

				when "01" => 
					if (shift_type(0) = '1') then -- logical shift left 
                        to_value_l := to_integer(unsigned(not(shift(2 downto 0))));
                        from_value_l:= 31 + to_value_l;
                        data_out <= mask08(from_value_l downto to_value_l);   
				    else -- logical shift right
                        to_value_r := to_integer(unsigned(shift(2 downto 0)));
                        from_value_r := 31 + to_value_r;
                        data_out <= mask08(from_value_r downto to_value_r);
				    end if;
				    
				when "10" => 
				    if (shift_type(0) = '1') then -- logical shift left
                        to_value_l := to_integer(unsigned(not(shift(2 downto 0))));
                        from_value_l:= 31 + to_value_l;
                        data_out <= mask16(from_value_l downto to_value_l);   
				    else -- logical shift right
				            to_value_r := to_integer(unsigned(shift(2 downto 0)));
				            from_value_r := 31 + to_value_r;
				            data_out <= mask16(from_value_r downto to_value_r);
				    end if;
					
				when "11" => 
				    if (shift_type(0) = '1') then -- logical shift left
                        to_value_l := to_integer(unsigned(not(shift(2 downto 0))));
                        from_value_l:= 31 + to_value_l;
                        data_out <= mask24(from_value_l downto to_value_l); 
				    else -- logical shift right
                        to_value_r := to_integer(unsigned(shift(2 downto 0)));
                        from_value_r := 31 + to_value_r;
                        data_out <= mask24(from_value_r downto to_value_r);
				    end if;
				when others => data_out <= (others => '0');
			end case;
			
		end process shift_p;

end beh;
