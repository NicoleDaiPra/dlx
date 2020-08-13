library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;


entity alu_out_selector is
	generic(
		N: integer
	);
    port (	
    	clk: in std_logic;
    	rst: in std_logic;
    	op_type: in std_logic_vector(1 downto 0);
    	op_sign: in std_logic; 							-- 1 if the operands are signed, 0 otherwise
    	adder_out: in std_logic_vector(N-1 downto 0);
    	adder_cout: in std_logic;
    	mul_out: in std_logic_vector(2*N-1 downto 0);
    	mul_cout: in std_logic;
    	shifter_out: in std_logic_vector(N-1 downto 0);
    	logicals_out: in std_logic_vector(N-1 downto 0);
    	alu_sel_out_high: out std_logic_vector(N-1 downto 0);
    	alu_sel_out_low: out std_logic_vector(N-1 downto 0);
    	alu_flags: out std_logic_vector(2 downto 0) 	-- Z: zero flag, V: overflow flag, S: sign flag
    );
end alu_out_selector;

architecture Behavioral of alu_out_selector is

	signal curr_flags, next_flags: std_logic_vector(2 downto 0);

begin

	reg_p: process (clk, rst)
		begin
			if (clk = '1' and clk'event) then
				if (rst = '0') then
					curr_flags <= (others => '0');
				else
					curr_flags <= next_flags;
				end if;
			end if;
		end process reg_p;

	sel_p: process (curr_flags, op_type, op_sign, adder_out, adder_cout, mul_out, mul_cout, shifter_out, logicals_out)
		begin
			-- 00: adder/subtractor
			-- 01: multiplier
			-- 10: shift/rotate
			-- 11: logicals
			
			next_flags <= curr_flags;
			alu_sel_out_high <= (others => '0');
			
			case op_type is
				when "00" => 
					alu_sel_out_low <= adder_out;
					next_flags <= not(or_reduce(adder_out)) & adder_cout & op_sign;

				when "01" => 
					alu_sel_out_low <= mul_out(N-1 downto 0);
					alu_sel_out_high  <= mul_out(2*N-1 downto N);
					next_flags <= not(or_reduce(mul_out)) & mul_cout & op_sign;

				when "10" => 
					alu_sel_out_low <= shifter_out;
					next_flags <= not(or_reduce(shifter_out)) & '0' & op_sign;

				when "11" => 
					alu_sel_out_low <= logicals_out;
					next_flags <= not(or_reduce(shifter_out)) & '0' & '0';
				
				when others => 
					alu_sel_out_low <= (others => '0');
					
			end case;
		end process sel_p;

		alu_flags <= curr_flags;

end Behavioral;
