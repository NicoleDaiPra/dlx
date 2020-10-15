library ieee;
use ieee.std_logic_1164.all;

entity sign_extender is
	port (
		i0_15: in std_logic_vector(15 downto 0);
		i16_25: in std_logic_vector(9 downto 0);
		is_signed: in std_logic; -- 1 if signed, 0 if unsigned
		sel: in std_logic; -- 1 if 16 bits input must be used, 0 if 26 bit input must be used
		o: out std_logic_vector(31 downto 0)
	);
end sign_extender;

architecture behavioral of sign_extender is
	signal i16_ext_signed, i16_ext_unsigned: std_logic_vector(31 downto 0);
	signal i26_ext_signed, i26_ext_unsigned: std_logic_vector(31 downto 0);
	signal ones, zeros: std_logic_vector(15 downto 0);
	signal o_sel: std_logic_vector(1 downto 0);

begin
	ones  <= (others => '1');
	zeros  <= (others => '0');

	i16_ext_unsigned <= zeros&i0_15;
	i26_ext_unsigned <= zeros(5 downto 0)&i16_25&i0_15;
	
	with i0_15(15) select i16_ext_signed <= 
		ones&i0_15 when '1',
		zeros&i0_15 when others;

	with i16_25(9) select i26_ext_signed <= 
		ones(5 downto 0)&i16_25&i0_15 when '1',
		zeros(5 downto 0)&i16_25&i0_15 when others;

	o_sel <= sel&is_signed;
	with o_sel select o <= 
		i26_ext_unsigned when "00",
		i26_ext_signed when "01",
		i16_ext_unsigned when "10",
		i16_ext_signed when others;

end behavioral;
