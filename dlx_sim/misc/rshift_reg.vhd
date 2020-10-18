library ieee;
use ieee.std_logic_1164.all;

-- right shift register
entity rshift_reg is
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
end entity rshift_reg;

architecture behavioral of rshift_reg is
	signal curr_data, next_data: std_logic_vector(N-1 downto 0);

begin
	state_reg: process(clk)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				curr_data <= (others => '0');
			elsif (en = '1') then
				curr_data <= next_data;	
			end if;
		end if;
	end process state_reg;

	q <= curr_data;

	comblogic: process(curr_data, d, shift)
	begin
		next_data <= curr_data;

		if (shift = '1') then
			shift_loop: for i in 0 to N-S-1 loop
				next_data(i) <= curr_data(i+S);
			end loop shift_loop;

			if (S = 1) then
				next_data(N-1) <= '0';
			else
				next_data(N-1 downto N-S) <= (others => '0');	
			end if;
		else
			next_data <= d;
		end if;
	end process comblogic;
end architecture behavioral;