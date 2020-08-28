library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu is
end tb_alu;

architecture tb of tb_alu is
	
	component alu is
	port ( 
		clk: in std_logic;
		rst: in std_logic;

    	op_type: in std_logic_vector(1 downto 0);
    	op_sign: in std_logic; 							-- 1 if the operands are signed, 0 otherwise

    	-- operands
    	a_adder: in std_logic_vector(31 downto 0);
    	b_adder: in std_logic_vector(31 downto 0);
    	a_mult: in std_logic_vector(31 downto 0);
    	b_mult: in std_logic_vector(31 downto 0);
    	a_shift: in std_logic_vector(31 downto 0);
    	b_shift: in std_logic_vector(31 downto 0);
    	a_log: in std_logic_vector(31 downto 0);
    	b_log: in std_logic_vector(31 downto 0);

    	sub_add: in std_logic;							-- 1 if it is a subtraction, 0 otherwise
    	shift_type: in std_logic_vector(3 downto 0);
    	log_type: in std_logic_vector(3 downto 0);
    	
    	alu_out_high: out std_logic_vector(31 downto 0);
    	alu_out_low: out std_logic_vector(31 downto 0);
    	alu_flags: out std_logic_vector(2 downto 0) 	-- Z: zero flag, V: overflow flag, S: sign flag
		);
    end component alu;

	signal clk, rst, op_sign, sub_add: std_logic;

	signal a_adder, b_adder: std_logic_vector(31 downto 0);
	signal a_mult, b_mult: std_logic_vector(31 downto 0);
	signal a_shift, b_shift: std_logic_vector(31 downto 0);
	signal a_log, b_log: std_logic_vector(31 downto 0);

	signal shift_type, log_type: std_logic_vector(3 downto 0);
	signal op_type: std_logic_vector(1 downto 0);

	signal alu_out_high, alu_out_low: std_logic_vector(31 downto 0);
	signal alu_flags: std_logic_vector(2 downto 0);

	constant period: time := 10 ns;
	
begin

	dut: alu
		port map(
			clk => clk,
			rst => rst,
			op_type => op_type,
			op_sign => op_sign,
			a_adder => a_adder,
			b_adder => b_adder,
			a_mult => a_mult,
			b_mult => b_mult,
			a_shift => a_shift,
			b_shift => b_shift,
			a_log => a_log,
			b_log => b_log,
			sub_add => sub_add,
			shift_type => shift_type,
			log_type => log_type,
			alu_out_high => alu_out_high,
			alu_out_low => alu_out_low,
			alu_flags => alu_flags
		);

	clk_p: process
		begin
			clk <= '1';
			wait for period/2;
			clk <= '0';
			wait for period/2;
		end process clk_p;

	test_p: process
	    variable res: std_logic_vector(63 downto 0);
	    variable a: std_logic_vector(31 downto 0);
	    variable b: std_logic_vector(31 downto 0);
		begin

			rst  <= '0';
			wait for period;
			rst <= '1';
			wait for period/2;

			-- Test the alu add on random operands
			op_type <= "00";
			op_sign <= '0';
			sub_add  <= '0'; -- addition
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"11112222";
			b_adder <= X"33334444";
			a_mult <= X"11112222";
			b_mult <= X"33334444";
			a_shift <= X"11112222";
			b_shift <= X"33334444";
			a_log <= X"11112222";
			b_log <= X"33334444";
            wait for period;
            
			assert (alu_out_low = X"44446666") report "addition failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the addition" severity FAILURE;
            
            
			-- Test the alu add on random signed operands
			op_type <= "00";
			op_sign <= '1';
			sub_add  <= '0'; -- addition
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"11112222";
			b_adder <= X"88886666";
			a_mult <= X"11112222";
			b_mult <= X"88886666";
			a_shift <= X"11112222";
			b_shift <= X"88886666";
			a_log <= X"11112222";
			b_log <= X"88886666";
			wait for period;

			assert (alu_out_low = X"99998888") report "signed addition failed" severity FAILURE;
			assert (alu_flags = "001") report "wrong flags for the signed addition" severity FAILURE;

			-- Test the alu add on operands that should produce an overflow + result is zero
			-- The overflow is not signalled with unsigned operands
			op_type <= "00";
			op_sign <= '0';
			sub_add  <= '0'; -- addition
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"ffffffff";
			b_adder <= X"00000001";
			a_mult <= X"ffffffff";
			b_mult <= X"00000001";
			a_shift <= X"ffffffff";
			b_shift <= X"00000001";
			a_log <= X"ffffffff";
			b_log <= X"00000001";
			wait for period;

			assert (alu_out_low = X"00000000") report "addition overflow failed" severity FAILURE;
			assert (alu_flags = "100") report "wrong flags for the addition overflow" severity FAILURE;

			-- Test the alu add on signed (positive) operands that produce an overflow
			op_type <= "00";
			op_sign <= '1';
			sub_add  <= '0'; -- addition
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"77777777";
			b_adder <= X"77777777";
			a_mult <= X"77777777";
			b_mult <= X"77777777";
			a_shift <= X"77777777";
			b_shift <= X"77777777";
			a_log <= X"77777777";
			b_log <= X"77777777";
			wait for period;

			assert (alu_out_low = X"eeeeeeee") report "signed (positive) addition overflow failed" severity FAILURE;
			assert (alu_flags = "011") report "wrong flags for the signed (positive) addition overflow" severity FAILURE;

			-- Test the alu add on signed (negative) operands that produce an overflow
			op_type <= "00";
			op_sign <= '1';
			sub_add  <= '0'; -- addition
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"88888888";
			b_adder <= X"88888888";
			a_mult <= X"88888888";
			b_mult <= X"88888888";
			a_shift <= X"88888888";
			b_shift <= X"88888888";
			a_log <= X"88888888";
			b_log <= X"88888888";
			wait for period;

			assert (alu_out_low = X"11111110") report "signed (negative) addition overflow failed" severity FAILURE;
			assert (alu_flags = "011") report "wrong flags for the signed (negative) addition overflow" severity FAILURE;


			-- Test the alu sub on random unsigned operands
			op_type <= "00";
			op_sign <= '0';
			sub_add  <= '1'; -- subtraction
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"88886666";
			b_adder <= X"11112222";
			a_mult <= X"88886666";
			b_mult <= X"11112222";
			a_shift <= X"88886666";
			b_shift <= X"11112222";
			a_log <= X"88886666";
			b_log <= X"11112222";
			wait for period;

			assert (alu_out_low = X"77774444") report "subtraction failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the subtraction" severity FAILURE;

			-- Test the alu sub on random signed operands
			op_type <= "00";
			op_sign <= '1';
			sub_add  <= '1'; -- subtraction
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"99998888";
			b_adder <= X"11112222";
			a_mult <= X"99998888";
			b_mult <= X"11112222";
			a_shift <= X"99998888";
			b_shift <= X"11112222";
			a_log <= X"99998888";
			b_log <= X"11112222";
			wait for period;

			assert (alu_out_low = X"88886666") report "signed subtraction failed" severity FAILURE;
			assert (alu_flags = "001") report "wrong flags for the signed subtraction" severity FAILURE;

			-- Test the alu sub on unsigned operands that results in 0s
			op_type <= "00";
			op_sign <= '0';
			sub_add  <= '1'; -- subtraction
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"11112222";
			b_adder <= X"11112222";
			a_mult <= X"11112222";
			b_mult <= X"11112222";
			a_shift <= X"11112222";
			b_shift <= X"11112222";
			a_log <= X"11112222";
			b_log <= X"11112222";
			wait for period;

			assert (alu_out_low = X"00000000") report "0s subtraction failed" severity FAILURE;
			assert (alu_flags = "100") report "wrong flags for the 0s subtraction" severity FAILURE;

			-- Test the alu sub on unsigned operands that cause overflow
			-- The overflow is not signalled with unsigned operands
			op_type <= "00";
			op_sign <= '0';
			sub_add  <= '1'; -- subtraction
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"00000000";
			b_adder <= X"00000001";
			a_mult <= X"00000000";
			b_mult <= X"00000001";
			a_shift <= X"00000000";
			b_shift <= X"00000001";
			a_log <= X"00000000";
			b_log <= X"00000001";
            wait for period;
            
			assert (alu_out_low = X"ffffffff") report "subtraction overflow failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the subtraction overflow" severity FAILURE;

			-- Test the alu sub on signed operands that cause underflow 
			-- + check result = 0
			
			op_type <= "00";
			op_sign <= '1';
			sub_add  <= '1'; -- subtraction
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"88888888";
			b_adder <= X"88888888";
			a_mult <= X"88888888";
			b_mult <= X"88888888";
			a_shift <= X"88888888";
			b_shift <= X"88888888";
			a_log <= X"88888888";
			b_log <= X"88888888";
			wait for period;

			assert (alu_out_low = X"00000000") report "subtraction underflow failed" severity FAILURE;
			assert (alu_flags = "111") report "wrong flags for the subtraction underflow" severity FAILURE;

			-- Test the alu sub on signed operands that cause overflow 
			
			op_type <= "00";
			op_sign <= '1';
			sub_add  <= '1'; -- subtraction
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"7fffffff";
			b_adder <= X"80000000";
			a_mult <= X"7fffffff";
			b_mult <= X"80000000";
			a_shift <= X"7fffffff";
			b_shift <= X"80000000";
			a_log <= X"7fffffff";
			b_log <= X"80000000";
			wait for period;

			assert (alu_out_low = X"ffffffff") report "subtraction overflow failed" severity FAILURE;
			assert (alu_flags = "011") report "wrong flags for the subtraction overflow" severity FAILURE;

			-- Test the alu mult on unsigned operands

			op_type <= "01";
			op_sign <= '0';
			sub_add  <= '0'; -- subtraction
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"11112222";
			b_adder <= X"33334444";
			a_mult <= X"11112222";
			b_mult <= X"33334444";
			a_shift <= X"11112222";
			b_shift <= X"33334444";
			a_log <= X"11112222";
			b_log <= X"33334444";
			wait for period;

			assert (alu_out_low = X"a8641908") report "mult low failed" severity FAILURE;
			assert (alu_out_high = X"0369d4c3") report "mult high failed" severity FAILURE;			
			assert (alu_flags = "000") report "wrong flags for the mult" severity FAILURE;

			-- Test the alu mult on signed operands

			op_type <= "01";
			op_sign <= '1';
			sub_add  <= '0'; -- subtraction
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"11112222";
			a_adder <= X"88881111";
			a_mult <= X"11112222";
			b_mult <= X"88881111";
			a_shift <= X"11112222";
			b_shift <= X"88881111";
			a_log <= X"11112222";
			b_log <= X"88881111";
			wait for period;
			a:= X"11112222";
			b:= X"88881111";
            res:= std_logic_vector(signed(a) * signed(b));
            
			assert (alu_out_low = res(31 downto 0)) report "signed mult low failed" severity FAILURE;
			assert (alu_out_high = res(63 downto 32)) report "signed mult high failed" severity FAILURE;			
			assert (alu_flags = "001") report "wrong flags for the signed mult" severity FAILURE;

			-- Test the alu mult on signed operands - result is 0

			op_type <= "01";
			op_sign <= '1';
			sub_add  <= '0'; -- subtraction
			shift_type <= "0000"; -- shifter not required
			log_type <= "0000"; -- logicals not required

			a_adder <= X"11112222";
			b_adder <= X"00000000";
			a_mult <= X"11112222";
			b_mult <= X"00000000";
			a_shift <= X"11112222";
			b_shift <= X"00000000";
			a_log <= X"11112222";
			b_log <= X"00000000";
			wait for period;

			assert (alu_out_low = X"00000000") report "0 mult low failed" severity FAILURE;
			assert (alu_out_high = X"00000000") report "0 mult high failed" severity FAILURE;			
			assert (alu_flags = "101") report "wrong flags for the 0 mult" severity FAILURE;

			-- Test the alu shifter LOGRIGHT 0010

			op_type <= "10";
			op_sign <= '0';
			sub_add  <= '0'; -- subtraction
			shift_type <= "0010"; 
			log_type <= "0000"; -- logicals not required

			a_adder <= X"11112222";
			b_adder <= X"0000001B";
			a_mult <= X"11112222";
			b_mult <= X"0000001B";
			a_shift <= X"11112222";
			b_shift <= X"0000001B";
			a_log <= X"11112222";
			b_log <= X"0000001B";
			wait for period;

			assert (alu_out_low = X"00000002") report "logright low failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the logright" severity FAILURE;

			-- Test the alu shifter LOGLEFT 0011

			op_type <= "10";
			op_sign <= '1';
			sub_add  <= '0'; -- subtraction
			shift_type <= "0011"; 
			log_type <= "0000"; -- logicals not required

			a_adder <= X"11112222";
			b_adder <= X"0000001B";
			a_mult <= X"11112222";
			b_mult <= X"0000001B";
			a_shift <= X"11112222";
			b_shift <= X"0000001B";
			a_log <= X"11112222";
			b_log <= X"0000001B";
			wait for period;

			assert (alu_out_low = X"10000000") report "logleft low failed" severity FAILURE;
			assert (alu_flags = "001") report "wrong flags for the logleft" severity FAILURE;

			-- Test the alu shifter ARITHRIGHT 0100

			op_type <= "10";
			op_sign <= '1';
			sub_add  <= '0'; -- subtraction
			shift_type <= "0100"; 
			log_type <= "0000"; -- logicals not required

			a_adder <= X"88881111";
			b_adder <= X"0000001B";
			a_mult <= X"88881111";
			b_mult <= X"0000001B";
			a_shift <= X"88881111";
			b_shift <= X"0000001B";
			a_log <= X"88881111";
			b_log <= X"0000001B";
			wait for period;

			assert (alu_out_low = X"fffffff1") report "arithright low failed" severity FAILURE;
			assert (alu_flags = "001") report "wrong flags for the arithright" severity FAILURE;

			-- Test the alu shifter ARITHLEFT 0101

			op_type <= "10";
			op_sign <= '1';
			sub_add  <= '0'; -- subtraction
			shift_type <= "0101"; 
			log_type <= "0000"; -- logicals not required

			a_adder <= X"11112222";
			b_adder <= X"0000001B";
			a_mult <= X"11112222";
			b_mult <= X"0000001B";
			a_shift <= X"11112222";
			b_shift <= X"0000001B";
			a_log <= X"11112222";
			b_log <= X"0000001B";
			wait for period;

			assert (alu_out_low = X"10000000") report "arithleft low failed" severity FAILURE;
			assert (alu_flags = "001") report "wrong flags for the arithleft" severity FAILURE;

			-- Test the alu shifter AND: sel <= "1000"

			op_type <= "11";
			op_sign <= '0';
			sub_add  <= '0';
			shift_type <= "0000"; 
			log_type <= "1000"; 

			a_adder <= X"99999999";
			b_adder <= X"11111111";
			a_mult <= X"99999999";
			b_mult <= X"11111111";
			a_shift <= X"99999999";
			b_shift <= X"11111111";
			a_log <= X"99999999";
			b_log <= X"11111111";
			wait for period;

			assert (alu_out_low = X"11111111") report "arithleft low failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the arithleft" severity FAILURE;
			
			-- Test the alu shifter OR: sel <= "1110"

			op_type <= "11";
			op_sign <= '0';
			sub_add  <= '0'; 
			shift_type <= "0000"; 
			log_type <= "1110"; 

			a_adder <= X"99999999";
			b_adder <= X"11111111";
			a_mult <= X"99999999";
			b_mult <= X"11111111";
			a_shift <= X"99999999";
			b_shift <= X"11111111";
			a_log <= X"99999999";
			b_log <= X"11111111";
			wait for period;

			assert (alu_out_low = X"99999999") report "arithleft low failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the arithleft" severity FAILURE;

			-- Test the alu shifter XOR: sel <= "0110"

			op_type <= "11";
			op_sign <= '0';
			sub_add  <= '0'; 
			shift_type <= "0000"; 
			log_type <= "0110"; 

			a_adder <= X"99999999";
			b_adder <= X"11111111";
			a_mult <= X"99999999";
			b_mult <= X"11111111";
			a_shift <= X"99999999";
			b_shift <= X"11111111";
			a_log <= X"99999999";
			b_log <= X"11111111";
			wait for period;

			assert (alu_out_low = X"88888888") report "arithleft low failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the arithleft" severity FAILURE;

			-- Test the alu shifter NAND: sel <= "0111"

			op_type <= "11";
			op_sign <= '0';
			sub_add  <= '0'; 
			shift_type <= "0000"; 
			log_type <= "0111"; 

			a_adder <= X"99999999";
			b_adder <= X"11111111";
			a_mult <= X"99999999";
			b_mult <= X"11111111";
			a_shift <= X"99999999";
			b_shift <= X"11111111";
			a_log <= X"99999999";
			b_log <= X"11111111";
            wait for period;
            
			assert (alu_out_low = X"eeeeeeee") report "arithleft low failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the arithleft" severity FAILURE;

			-- Test the alu shifter NOR: sel <= "0001"

			op_type <= "11";
			op_sign <= '0';
			sub_add  <= '0';
			shift_type <= "0000"; 
			log_type <= "0001"; 

			a_adder <= X"99999999";
			b_adder <= X"11111111";
			a_mult <= X"99999999";
			b_mult <= X"11111111";
			a_shift <= X"99999999";
			b_shift <= X"11111111";
			a_log <= X"99999999";
			b_log <= X"11111111";
			wait for period;

			assert (alu_out_low = X"66666666") report "arithleft low failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the arithleft" severity FAILURE;
			
			-- Test the alu shifter NXOR: sel <= "1001"

			op_type <= "11";
			op_sign <= '0';
			sub_add  <= '0';
			shift_type <= "0000"; 
			log_type <= "1001"; 

			a_adder <= X"99999999";
			b_adder <= X"11111111";
			a_mult <= X"99999999";
			b_mult <= X"11111111";
			a_shift <= X"99999999";
			b_shift <= X"11111111";
			a_log <= X"99999999";
			b_log <= X"11111111";
			wait for period;

			assert (alu_out_low = X"77777777") report "arithleft low failed" severity FAILURE;
			assert (alu_flags = "000") report "wrong flags for the arithleft" severity FAILURE;
			
			wait;
		end process test_p;


end tb;
