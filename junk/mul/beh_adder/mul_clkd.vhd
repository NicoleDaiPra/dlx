library ieee;
use ieee.std_logic_1164.all;

entity mul_clkd is
	port (
		clk: in std_logic;
		rst: in std_logic;
		en: in std_logic;
		en_a_neg: in std_logic;
		en_shift: in std_logic;
		shift: in std_logic;
		neg: in std_logic; -- used to negate "a" before actually multiply
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		it: in std_logic_vector(3 downto 0);
		res: out std_logic_vector(63 downto 0)
	);
end mul_clkd;

architecture behavioral of mul_clkd is
	component mul is
		port (
			a: in std_logic_vector(63 downto 0);
			a_neg: in std_logic_vector(63 downto 0);
			b10_1: in std_logic_vector(2 downto 0);
			b: in std_logic_vector(2 downto 0);
			it: in std_logic_vector(3 downto 0);
			neg: in std_logic; -- used to negate "a" before actually multiply
			adder_feedback: in std_logic_vector(63 downto 0);
			res: out std_logic_vector(63 downto 0)
		);
	end component mul;

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

	component rshift_reg is
		generic (
			N: integer := 32;
			S: integer := 2
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			shift: in std_logic; -- tell whether the register have to sample the input data or the shifted one
			en: in std_logic;
			d: in std_logic_vector(N-1 downto 0);
			q: out std_logic_vector(N-1 downto 0)
		);
	end component rshift_reg;

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

	constant zeros : std_logic_vector(31 downto 0) := (others => '0'); 

	signal a_out, a_neg_out, a_int: std_logic_vector(63 downto 0);
	signal b10_1_in, b10_1_out: std_logic_vector(2 downto 0);
	signal b_out: std_logic_vector(30 downto 0);
	signal adder_feedback, adder_res, curr_feedback: std_logic_vector(63 downto 0);
	signal msb_a: std_logic_vector(31 downto 0);
begin
	state_reg: process(clk)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				curr_feedback <= (others => '0');
			else
				curr_feedback <= adder_res;
			end if;
		end if;
	end process state_reg;

	-- sign extend "a"
	msb_a <= (others => a(31));
	a_int <= msb_a&a;

	a_reg: reg_en
		generic map (
			N => 64
		)
		port map (
			d => a_int,
			en => en,
			clk => clk,
			rst => rst,
			q => a_out
		);

	a_neg_reg: reg_en
		generic map (
			N => 64
		)
		port map (
			d => adder_res, -- it samples a negated
			en => en_a_neg,
			clk => clk,
			rst => rst,
			q => a_neg_out
		);

	b10_1_in <= b(1 downto 0)&'0';
	b10_1_reg: reg_en
		generic map (
			N => 3
		)
		port map (
			d => b10_1_in,
			en => en,
			clk => clk,
			rst => rst,
			q => b10_1_out
		);

	b_shift_reg: rshift_reg
		generic map (
			N => 31,
			S => 2
		)
		port map (
			clk => clk,
			rst => rst,
			shift => shift,
			en => en_shift,
			d => b(31 downto 1),
			q => b_out
		);

	multiplier: mul
		port map (
			a => a_out,
			a_neg => a_neg_out,
			b10_1 => b10_1_out,
			b => b_out(2 downto 0),
			it => it,
			neg => neg,
			adder_feedback => curr_feedback,
			res => adder_res
		);

	res <= adder_res;

end behavioral;