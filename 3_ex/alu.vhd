library ieee;
use ieee.std_logic_1164.all;

-- ALU that encapsulate the computing units and the selector of the result

entity alu is
	port ( 
		clk: in std_logic;
		rst: in std_logic;

    	op_type: in std_logic_vector(1 downto 0);
    	op_sign: in std_logic; 							-- 1 if the operands are signed, 0 otherwise

    	op_a: in std_logic_vector(31 downto 0);
    	op_b: in std_logic_vector(31 downto 0);

    	sub_add: in std_logic;							-- 1 if it is a subtraction, 0 otherwise
    	shift_type: in std_logic_vector(3 downto 0);
    	log_type: in std_logic_vector(3 downto 0);
    	
    	alu_out_high: out std_logic_vector(31 downto 0);
    	alu_out_low: out std_logic_vector(31 downto 0);
    	alu_flags: out std_logic_vector(2 downto 0) 	-- Z: zero flag, V: overflow flag, S: sign flag
		);
end alu;

architecture beh of alu is

	component p4_adder is
		generic (
			N: integer := 32 
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			cin: in std_logic;
			s: out std_logic_vector(N-1 downto 0);
			cout: out std_logic;
			carries: out std_logic_vector(N/4 downto 0)
		);
	end component p4_adder;

	component boothmul is
		generic (
		    N: integer := 32
		);
		port (
		    a: in std_logic_vector(N-1 downto 0);
		    b: in std_logic_vector(N-1 downto 0);
		    y: out std_logic_vector(2*N-1 downto 0)
		);
	end component boothmul;

	component shifter_t2 is
	    port (
	        data_in: in std_logic_vector(31 downto 0);
	        shift: in std_logic_vector(4 downto 0);
	        shift_type: in std_logic_vector(3 downto 0);
	        data_out: out std_logic_vector(31 downto 0)
	    );
	end component shifter_t2;

	component logicals is
		generic (
			N: integer := 32
		);

		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic_vector(3 downto 0);
			res: out std_logic_vector(N-1 downto 0)
		);
	end component logicals;

	component alu_out_selector is
		generic(
			N: integer := 32
		);
	    port (	
	    	clk: in std_logic;
	    	rst: in std_logic;
	    	a: std_logic_vector(N-1 downto 0);
	    	b: std_logic_vector(N-1 downto 0);
	    	op_type: in std_logic_vector(1 downto 0);
	    	op_sign: in std_logic;                          -- 1 if the operands are signed, 0 otherwise
	    	sub_add: std_logic; 							
	    	adder_out: in std_logic_vector(N-1 downto 0);
	    	adder_cout: in std_logic;
	    	mul_out: in std_logic_vector(2*N-1 downto 0);
	    	shifter_out: in std_logic_vector(N-1 downto 0);
	    	logicals_out: in std_logic_vector(N-1 downto 0);
	    	alu_sel_out_high: out std_logic_vector(N-1 downto 0);
	    	alu_sel_out_low: out std_logic_vector(N-1 downto 0);
	    	alu_flags: out std_logic_vector(2 downto 0) 	-- Z: zero flag, V: overflow flag, S: sign flag
	    );
	end component alu_out_selector;
	
	component reg_en is
        generic (
            N: integer := 32
        );
        port (
            d: in std_logic_vector(N-1 downto 0);
            en: in std_logic;
            clk: in std_logic;
            rst: in std_logic;
            q: out std_logic_vector(N-1 downto 0)	
        );
    end component reg_en;

    type operand_array is array (0 to 3) of std_logic_vector(31 downto 0);
    signal a_array: operand_array;
	signal b_array: operand_array;
	
	signal adder_out, shifter_out, logicals_out: std_logic_vector(31 downto 0);
	signal mul_out: std_logic_vector(63 downto 0);
	signal adder_cout: std_logic;
	
	signal enable: std_logic_vector(3 downto 0);
	

begin

    with op_type select
        enable <= "0001" when "00",
                  "0010" when "01",
                  "0100" when "10",
                  "1000" when "11",
                  "0000" when others;
        
    regs: for i in 0 to 3 generate
        reg_i_op_a: reg_en
            generic map (
                N => 32
            )
            port map (
                d => op_a,
                en => enable(i),
                clk => clk,
                rst => rst,
                q => a_array(i)
            );
            
        reg_i_op_b: reg_en
            generic map (
                N => 32
            )
            port map (
                d => op_b,
                en => enable(i),
                clk => clk,
                rst => rst,
                q => b_array(i)
            );
    end generate regs;
    
	
	add_sub: p4_adder
		generic map (
			N => 32
		)
		port map (
			a => a_array(0),
			b => b_array(0),
			cin => sub_add,
			s => adder_out,
			cout => adder_cout,
			carries => open
		);

	mul: boothmul
		generic map (
			N => 32
		)
		port map (
			a => a_array(1),
			b => b_array(1),
			y => mul_out
		);

	shifter: shifter_t2
		port map (
			data_in => a_array(2),
			shift => b_array(2)(4 downto 0),
			shift_type => shift_type,
			data_out => shifter_out
		);

	log_unit: logicals
		generic map (
			N => 32
		)
		port map (
			a => a_array(3),
			b => b_array(3),
			sel => log_type,
			res => logicals_out
		);

	alu_sel: alu_out_selector
		generic map (
			N => 32
		)
		port map (
			clk => clk,
			rst => rst,
			a => op_a,
			b => op_b,
			sub_add => sub_add,
			op_type => op_type,
			op_sign => op_sign,
			adder_out => adder_out,
			adder_cout => adder_cout,
			mul_out => mul_out,
			shifter_out => shifter_out,
			logicals_out => logicals_out,
			alu_sel_out_high => alu_out_high,
			alu_sel_out_low => alu_out_low,
			alu_flags => alu_flags
		);
    

end beh;
