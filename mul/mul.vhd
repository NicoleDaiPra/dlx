library ieee;
use ieee.std_logic_1164.all;

entity mul is
	port (
		a: in std_logic_vector(63 downto 0);
		a_neg: in std_logic_vector(63 downto 0);
		b10_1: in std_logic_vector(2 downto 0);
		b: in std_logic_vector(2 downto 0);
		it: in std_logic_vector(3 downto 0);
		neg: in std_logic; -- used to negate a before actually multiplying
		is_signed: in std_logic;
		adder_feedback: in std_logic_vector(63 downto 0);
		res: out std_logic_vector(63 downto 0)
	);
end entity mul;

architecture structural of mul is
	--component p4_adder is
	--	generic (
	--		N: integer := 32 
	--	);
	--	port (
	--		a: in std_logic_vector(N-1 downto 0);
	--		b: in std_logic_vector(N-1 downto 0);
	--		cin: in std_logic;
	--		s: out std_logic_vector(N-1 downto 0);
	--		cout: out std_logic;
	--		carries: out std_logic_vector(N/4 downto 0)
	--	);
	--end component p4_adder;

	--component rca_generic_struct is
	--	generic (
	--        N: integer := 8
	--    );
	--    port (
	--        a: in std_logic_vector(N-1 downto 0);
	--        b: in std_logic_vector(N-1 downto 0);
	--        cin: in std_logic;
	--        s: out std_logic_vector(N-1 downto 0);
	--        cout: out std_logic
 --   );
	--end component rca_generic_struct;

	component tmp_adder is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			cin: in std_logic;
			sum: out std_logic_vector(N-1 downto 0);
			cout: out std_logic
		);
	end component tmp_adder;

	component mux_2x1 is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic;
			o: out std_logic_vector(N-1 downto 0)
		);
	end component mux_2x1;

	component mux_4x1 is
		generic (
			N: integer := 22
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			c: in std_logic_vector(N-1 downto 0);
			d: in std_logic_vector(N-1 downto 0);
			sel: in std_logic_vector(1 downto 0);
			o: out std_logic_vector(N-1 downto 0)
		);	
	end component mux_4x1;

	component mux_5x1 is
		generic (
			NBIT: integer := 4
		);
		port (
	        a: in std_logic_vector(NBIT-1 downto 0);
	        b: in std_logic_vector(NBIT-1 downto 0);
	        c: in std_logic_vector(NBIT-1 downto 0);
	        d: in std_logic_vector(NBIT-1 downto 0);
	        e: in std_logic_vector(NBIT-1 downto 0);
	        sel: in std_logic_vector(2 downto 0);
	        y: out std_logic_vector(NBIT-1 downto 0)
		);
	end component mux_5x1;

	component mux_6x1 is
		generic (
			NBIT: integer := 4
		);
		port (
	        a: in std_logic_vector(NBIT-1 downto 0);
	        b: in std_logic_vector(NBIT-1 downto 0);
	        c: in std_logic_vector(NBIT-1 downto 0);
	        d: in std_logic_vector(NBIT-1 downto 0);
	        e: in std_logic_vector(NBIT-1 downto 0);
	        f: in std_logic_vector(NBIT-1 downto 0);
	        sel: in std_logic_vector(2 downto 0);
	        y: out std_logic_vector(NBIT-1 downto 0)
		);
	end component mux_6x1;

	component booth_encoder is
		port (
			b: in std_logic_vector(2 downto 0);
			y: out std_logic_vector(2 downto 0)
		);
	end component booth_encoder;

	component a_generator is
		port (
			a_in: in std_logic_vector(63 downto 0);
			neg_a_in: in std_logic_vector(63 downto 0);
			sel: in std_logic_vector(3 downto 0);
			--is_signed: in std_logic;
			a: out std_logic_vector(63 downto 0);
			neg_a: out std_logic_vector(63 downto 0);
			ax2: out std_logic_vector(63 downto 0);
			neg_ax2: out std_logic_vector(63 downto 0)
		);
	end component a_generator;

	component equality_comparator is
		generic (
			N: integer := 32 -- number of bits
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			o: out std_logic
		);
	end component equality_comparator;

	constant eq_zeros : std_logic_vector(3 downto 0) := "0000";
	constant sum_feedback_sel : std_logic_vector(2 downto 0) := "101";
	constant a_inv_sel : std_logic_vector(2 downto 0) := "101"; 
	constant zeros : std_logic_vector(63 downto 0) := (others => '0');

	signal a_int, neg_a_int, a_inv: std_logic_vector(63 downto 0);
	signal msb_a, msb_neg_a: std_logic_vector(31 downto 0);
	signal a_shift2, neg_a_shift2, a_shiftn, neg_a_shiftn, ax2_shiftn, neg_ax2_shiftn: std_logic_vector(63 downto 0);
	signal b_enc10_1, b_enc, op1_enc, op2_enc: std_logic_vector(2 downto 0);
	signal eq_comp_res: std_logic;
	signal op1, op2: std_logic_vector(63 downto 0);
	signal cin: std_logic;
	signal cout: std_logic;
	signal mux_op1_sel: std_logic_vector(1 downto 0);
begin
	-- generate the required shifts of "a"
	--msb_a <= (others => a(31));
	--msb_neg_a <= (others => a_neg(31));

	--with is_signed select a_int <= 
	--	zeros(31 downto 0)&a when '0',
	--	msb_a&a when others;

	--neg_a_int <= msb_neg_a&a_neg;

	a_shift2 <= a(62 downto 0)&'0';
	neg_a_shift2 <= a_neg(62 downto 0)&'0';

	a_gen: a_generator
		port map (
			a_in => a,
			neg_a_in => a_neg,
			sel => it,
			--is_signed => is_signed,
			a => a_shiftn,
			neg_a => neg_a_shiftn,
			ax2 => ax2_shiftn,
			neg_ax2 => neg_ax2_shiftn
		);

	-- logic to select the first adder's operand
	-- it can be either the booth's encoder value or the adder's feedback

	booth_enc_10_1: booth_encoder
		port map (
			b => b10_1,
			y => b_enc10_1
		);

		-- in the first iteration ("0000") the value of booth_enc_10_1 must be picked, otherwise the adder's feedback
	eq_comp: equality_comparator
		generic map (
			N => 4
		)
		port map (
			a => eq_zeros,
			b => it,
			o => eq_comp_res
		);

	mux_op1_sel <= neg&eq_comp_res;

	op1_selector: mux_4x1
		generic map (
			N => 3
		)
		port map (
			a => sum_feedback_sel,
			b => b_enc10_1,
			c => zeros(2 downto 0),
			d => zeros(2 downto 0),
			sel => mux_op1_sel,
			o => op1_enc
		);

	-- set the first input of the adder
	op1_output: mux_6x1
		generic map (
			NBIT => 64
		)
		port map (
			a => zeros,
			--b => a_int,
			--c => neg_a_int,
			b => a,
			c => a_neg,
			d => a_shift2,
			e => neg_a_shift2,
			f => adder_feedback,
			sel => op1_enc,
			y => op1
		);

	-- select the second adder's operand. It's chosen only by the booth's encoder
	booth_enc: booth_encoder
		port map (
			b => b,
			y => b_enc
		);

	op2_selector: mux_2x1
		generic map (
			N => 3
		)
		port map (
			a => a_inv_sel,
			b => b_enc,
			sel => neg,
			o => op2_enc
		);

	with neg select cin <=  
		'1' when '1',
		'0' when others;

	-- perform 1's complement of a
	a_inv <= not a;

	op2_output: mux_6x1
		generic map (
			NBIT => 64
		)
		port map (
			a => zeros,
			b => a_shiftn,
			c => neg_a_shiftn,
			d => ax2_shiftn,
			e => neg_ax2_shiftn,
			f => a_inv,
			sel => op2_enc,
			y => op2
		);

	-- calculate the partial sum
	adder: tmp_adder
		generic map (
			N => 64
		)
		port map (
			a => op1,
			b => op2,
			cin => cin,
			sum => res,
			cout => open--,
			--carries => open
		);
end architecture structural;