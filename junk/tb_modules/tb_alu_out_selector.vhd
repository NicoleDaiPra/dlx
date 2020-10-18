library ieee;
use ieee.std_logic_1164.all;

entity tb_alu_out_selector is
end tb_alu_out_selector;

architecture tb of tb_alu_out_selector is

	component alu_out_selector is
        generic(
            N: integer := 32
        );
	    port (	
	    	clk: in std_logic;
	    	rst: in std_logic;
	    	op_type: in std_logic_vector(1 downto 0);
	    	op_sign: in std_logic; 							-- 1 if the operands are signed, 0 otherwise
	    	adder_out: in std_logic_vector(N-1 downto 0);
	    	adder_cout: in std_logic;
	    	mul_out: in std_logic_vector(2*N-1 downto 0);
	    	shifter_out: in std_logic_vector(N-1 downto 0);
	    	logicals_out: in std_logic_vector(N-1 downto 0);
	    	alu_sel_out_low: out std_logic_vector(N-1 downto 0);
	    	alu_sel_out_high: out std_logic_vector(N-1 downto 0);
	    	alu_flags: out std_logic_vector(2 downto 0) 	-- Z,V,S
	    );
	end component alu_out_selector;

    constant period: time := 10 ns;
    constant N: integer := 32;
    
	signal clk, rst: std_logic;
	signal op_type:  std_logic_vector(1 downto 0);
	signal op_sign: std_logic; 							
	signal adder_out: std_logic_vector(N-1 downto 0);
	signal adder_cout: std_logic;
	signal mul_out: std_logic_vector(2*N-1 downto 0);
	signal shifter_out: std_logic_vector(N-1 downto 0);
	signal logicals_out: std_logic_vector(N-1 downto 0);
	signal alu_sel_out_low: std_logic_vector(N-1 downto 0);
	signal alu_sel_out_high: std_logic_vector(N-1 downto 0);
	signal alu_flags: std_logic_vector(2 downto 0);

begin

	dut: alu_out_selector 
	    generic map (
	       N => N
	    )
		port map (
			clk  => clk,
			rst => rst,
			op_type => op_type,
			op_sign => op_sign,
			adder_out => adder_out,
			adder_cout => adder_cout,
			mul_out => mul_out,
			shifter_out => shifter_out,
			logicals_out => logicals_out,
			alu_sel_out_low => alu_sel_out_low,
			alu_sel_out_high => alu_sel_out_high,
			alu_flags => alu_flags
		);

	clock_p: process
		begin
			clk  <= '1';
			wait for period/2;
			clk  <= '0';
			wait for period/2;
		end process clock_p;

	test_p: process
		begin

			wait for period/2;
			rst <= '0';
			wait for period;
			rst <= '1';

			adder_out <= X"11112222";
			adder_cout <= '1';

			mul_out <= X"33334444AAAABBBB";

			shifter_out <= X"55556666";
			logicals_out <= X"77778888";

			op_type <= "00"; -- select the output of the adder
			op_sign <= '0';
			wait for period;

			adder_cout <= '0';
			op_sign <= '1';
			wait for period;
			
			adder_out <= X"00000000";
			wait for period;

			op_type <= "01"; -- select the output of the multiplier
			op_sign <= '0';
			wait for period;

			op_sign <= '1';
			wait for period;

			op_type <= "10"; -- select the output of the shifter
			op_sign <= '0';
			wait for period;

			op_sign <= '1';
			wait for period;

			op_type <= "11"; -- select the logicals
			op_sign <= '0';
			wait for period;

			op_sign <= '1';

			wait;
		end process test_p;


end tb;
