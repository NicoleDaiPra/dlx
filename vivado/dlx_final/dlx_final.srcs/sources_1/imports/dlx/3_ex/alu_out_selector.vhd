library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

-- Unit that selects the output of the ALU based on the operation's type. 

-- The result is produced on 32 bits except for the multiplication that computes a 64 bits result.
-- In that case, it is split and returned by using alu_out_sel_high and alu_out_sel_high.

entity alu_out_selector is
	generic(
		N: integer := 32
	);
    port (	
    	op_type: in std_logic_vector(1 downto 0); -- identifies which unit is computing the result
    	adder_out: in std_logic_vector(N-1 downto 0); -- adder output
    	mul_out: in std_logic_vector(2*N-1 downto 0); -- multiplier output
    	shifter_out: in std_logic_vector(N-1 downto 0); -- shifter output
    	logicals_out: in std_logic_vector(N-1 downto 0); -- logicals output
    	alu_sel_out_high: out std_logic_vector(N-1 downto 0); -- upper part (63 downto 32) of the result used only for the multiply
    	alu_sel_out_low: out std_logic_vector(N-1 downto 0) -- lower part (31 downto 0) of the result	
    );
end alu_out_selector;

architecture behavioral of alu_out_selector is

begin

	sel_p: process (op_type, adder_out, mul_out, shifter_out, logicals_out)
		  variable overflow: std_logic;
		  
		begin
		
			-- op_type is encoded in the following way:
			-- 00: adder/subtractor
			-- 01: multiplier
			-- 10: shift/rotate
			-- 11: logicals

			alu_sel_out_high <= (others => '0');
			
			case op_type is
				when "00" => 
					alu_sel_out_low <= adder_out;

				when "01" => 
					alu_sel_out_low <= mul_out(N-1 downto 0);
					alu_sel_out_high  <= mul_out(2*N-1 downto N);

				when "10" => 
					alu_sel_out_low <= shifter_out;

				when "11" => 
					alu_sel_out_low <= logicals_out;
				
				when others => 
					alu_sel_out_low <= (others => '0');
					
			end case;
		end process sel_p;
end behavioral;
