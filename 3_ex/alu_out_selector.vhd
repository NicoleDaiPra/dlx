library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

-- Unit that selects the output of the ALU based on the operation's type. It also sets the flags related
-- to the output. 

-- The alu_flag has three fields: 
-- alu_flags(2): Zero flag, set to 1 if the result is 0, to 0 otherwise
-- alu_flags(1): Overflow flag, set to 1 is an overflow occured, to 0 otherwise
-- alu_flags(0): Sign flag, set to 1 if the result is negative, 0 otherwise

-- The result is produced on 32 bits except for the multiply that computes a 64 bits result.
-- In that case, it is split and returned by using alu_out_sel_high and alu_out_sel_high.

entity alu_out_selector is
	generic(
		N: integer := 32
	);
    port (	
    	a: in std_logic;	-- MSB of a
    	b: in std_logic;	-- MSB of b
    	op_type: in std_logic_vector(1 downto 0); -- identifies which unit is computing the result
    	op_sign: in std_logic; 	-- 1 if the operands are signed, 0 otherwise
    	sub_add: std_logic;		-- 1 if it is a subtraction, 0 otherwise
    	adder_out: in std_logic_vector(N-1 downto 0);
    	adder_cout: in std_logic;
    	mul_out: in std_logic_vector(2*N-1 downto 0);
    	shifter_out: in std_logic_vector(N-1 downto 0);
    	logicals_out: in std_logic_vector(N-1 downto 0);
    	alu_sel_out_high: out std_logic_vector(N-1 downto 0); -- upper part (63 downto 32) of the result used only for the multiply
    	alu_sel_out_low: out std_logic_vector(N-1 downto 0); -- lower part (31 downto 0) of the result
    	alu_flags: out std_logic_vector(2 downto 0) 	
    );
end alu_out_selector;

architecture behavioral of alu_out_selector is

begin

	sel_p: process (op_type, op_sign, sub_add, adder_out, adder_cout, mul_out, shifter_out, logicals_out)
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
				    
				    -- check if an overflow occured 
				    overflow := (not(a) and not(b) and adder_out(N-1)) or (a and b and not(adder_out(N-1)));
					overflow := overflow or (sub_add and (adder_cout xor adder_out(N-1)));
					alu_sel_out_low <= adder_out;

					-- add/sub instructions do not produce overflow with unsigned numbers
					alu_flags <= not(or_reduce(adder_out)) & (op_sign and overflow) & (op_sign and adder_out(N-1));

				when "01" => 
					alu_sel_out_low <= mul_out(N-1 downto 0);
					alu_sel_out_high  <= mul_out(2*N-1 downto N);

					-- MUL is performed with signed numbers only
					alu_flags <= not(or_reduce(mul_out)) & '0' & mul_out(N-1);

				when "10" => 
					alu_sel_out_low <= shifter_out;

					-- shift operations are not supposed to produce overflow
					alu_flags <= not(or_reduce(shifter_out)) & '0' & (op_sign and shifter_out(N-1));

				when "11" => 
					alu_sel_out_low <= logicals_out;

					-- logicals are not supposed to produce overfow
					-- logicals work with pure binary numbers so the sign flag is set to 0 by default
					alu_flags <= not(or_reduce(logicals_out)) & '0' & '0';
				
				when others => 
					alu_sel_out_low <= (others => '0');
					alu_flags <= (others => '0');
					
			end case;
		end process sel_p;
end behavioral;
