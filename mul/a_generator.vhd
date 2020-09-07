library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity a_generator is
	port (
		a_in: in std_logic_vector(63 downto 0);
		neg_a_in: in std_logic_vector(63 downto 0);
		sel: in std_logic_vector(3 downto 0);
		a: out std_logic_vector(63 downto 0);
		neg_a: out std_logic_vector(63 downto 0);
		ax2: out std_logic_vector(63 downto 0);
		neg_ax2: out std_logic_vector(63 downto 0)
	);
end a_generator;

architecture behavioral of a_generator is
	constant zeros : std_logic_vector(31 downto 0) := (others => '0'); 

begin
	comblogic: process(a_in, neg_a_in, sel)
	begin
		case (sel) is
			when "0000" =>
				a <= a_in(61 downto 0)&zeros(1 downto 0);
				neg_a <= neg_a_in(61 downto 0)&zeros(1 downto 0);
				ax2 <= a_in(60 downto 0)&zeros(2 downto 0);
				neg_ax2 <= neg_a_in(60 downto 0)&zeros(2 downto 0);

			when "0001" =>
				a <= a_in(59 downto 0)&zeros(3 downto 0);
				neg_a <= neg_a_in(59 downto 0)&zeros(3 downto 0);
				ax2 <= a_in(58 downto 0)&zeros(4 downto 0);
				neg_ax2 <= neg_a_in(58 downto 0)&zeros(4 downto 0);

			when "0010" =>
				a <= a_in(57 downto 0)&zeros(5 downto 0);
				neg_a <= neg_a_in(57 downto 0)&zeros(5 downto 0);
				ax2 <= a_in(56 downto 0)&zeros(6 downto 0);
				neg_ax2 <= neg_a_in(56 downto 0)&zeros(6 downto 0);

			when "0011" =>
				a <= a_in(55 downto 0)&zeros(7 downto 0);
				neg_a <= neg_a_in(55 downto 0)&zeros(7 downto 0);
				ax2 <= a_in(54 downto 0)&zeros(8 downto 0);
				neg_ax2 <= neg_a_in(54 downto 0)&zeros(8 downto 0);

			when "0100" =>
				a <= a_in(53 downto 0)&zeros(9 downto 0);
				neg_a <= neg_a_in(53 downto 0)&zeros(9 downto 0);
				ax2 <= a_in(52 downto 0)&zeros(10 downto 0);
				neg_ax2 <= neg_a_in(52 downto 0)&zeros(10 downto 0);

			when "0101" =>
				a <= a_in(51 downto 0)&zeros(11 downto 0);
				neg_a <= neg_a_in(51 downto 0)&zeros(11 downto 0);
				ax2 <= a_in(50 downto 0)&zeros(12 downto 0);
				neg_ax2 <= neg_a_in(50 downto 0)&zeros(12 downto 0);

			when "0110" =>
				a <= a_in(49 downto 0)&zeros(13 downto 0);
				neg_a <= neg_a_in(49 downto 0)&zeros(13 downto 0);
				ax2 <= a_in(48 downto 0)&zeros(14 downto 0);
				neg_ax2 <= neg_a_in(48 downto 0)&zeros(14 downto 0);

			when "0111" =>
				a <= a_in(47 downto 0)&zeros(15 downto 0);
				neg_a <= neg_a_in(47 downto 0)&zeros(15 downto 0);
				ax2 <= a_in(46 downto 0)&zeros(16 downto 0);
				neg_ax2 <= neg_a_in(46 downto 0)&zeros(16 downto 0);

			when "1000" =>
				a <= a_in(45 downto 0)&zeros(17 downto 0);
				neg_a <= neg_a_in(45 downto 0)&zeros(17 downto 0);
				ax2 <= a_in(44 downto 0)&zeros(18 downto 0);
				neg_ax2 <= neg_a_in(44 downto 0)&zeros(18 downto 0);

			when "1001" =>
				a <= a_in(43 downto 0)&zeros(19 downto 0);
				neg_a <= neg_a_in(43 downto 0)&zeros(19 downto 0);
				ax2 <= a_in(42 downto 0)&zeros(20 downto 0);
				neg_ax2 <= neg_a_in(42 downto 0)&zeros(20 downto 0);

			when "1010" =>
				a <= a_in(41 downto 0)&zeros(21 downto 0);
				neg_a <= neg_a_in(41 downto 0)&zeros(21 downto 0);
				ax2 <= a_in(40 downto 0)&zeros(22 downto 0);
				neg_ax2 <= neg_a_in(40 downto 0)&zeros(22 downto 0);

			when "1011" =>
				a <= a_in(39 downto 0)&zeros(23 downto 0);
				neg_a <= neg_a_in(39 downto 0)&zeros(23 downto 0);
				ax2 <= a_in(38 downto 0)&zeros(24 downto 0);
				neg_ax2 <= neg_a_in(38 downto 0)&zeros(24 downto 0);

			when "1100" =>
				a <= a_in(37 downto 0)&zeros(25 downto 0);
				neg_a <= neg_a_in(37 downto 0)&zeros(25 downto 0);
				ax2 <= a_in(36 downto 0)&zeros(26 downto 0);
				neg_ax2 <= neg_a_in(36 downto 0)&zeros(26 downto 0);

			when "1101" =>
				a <= a_in(35 downto 0)&zeros(27 downto 0);
				neg_a <= neg_a_in(35 downto 0)&zeros(27 downto 0);
				ax2 <= a_in(34 downto 0)&zeros(28 downto 0);
				neg_ax2 <= neg_a_in(34 downto 0)&zeros(28 downto 0);

			when others =>
				a <= a_in(33 downto 0)&zeros(29 downto 0);
				neg_a <= neg_a_in(33 downto 0)&zeros(29 downto 0);
				ax2 <= a_in(32 downto 0)&zeros(30 downto 0);
				neg_ax2 <= neg_a_in(32 downto 0)&zeros(30 downto 0);

			--when others =>
			--	a <= a_in(35 downto 0)&zeros(31 downto 0);
			--	neg_a <= neg_a_in(35 downto 0)&zeros(31 downto 0);
			--	ax2 <= a_in(34 downto 0)&zeros(32 downto 0);
			--	neg_ax2 <= neg_a_in(34 downto 0)&zeros(32 downto 0);
		end case;
	end process comblogic;

end behavioral;
