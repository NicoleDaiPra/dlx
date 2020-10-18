library ieee;
use ieee.std_logic_1164.all;

entity mem_sign_extender is
	generic (
		N: integer := 32
	);
	port (
		ld_sign: in std_logic; -- 1 if load is signed, 0 if unsigned
		-- controls how many bits of the word are kept after a load
		-- 00: load N bits
		-- 01: load N/2 bits
		-- 10: load N/4 bits
		-- 11: reserved
		ld_type: in std_logic_vector(1 downto 0);
		mem_data: in std_logic_vector(N-1 downto 0); -- data to be extended
		ext_data: out std_logic_vector(N-1 downto 0) -- extended data
	);
end mem_sign_extender;

architecture behavioral of mem_sign_extender is
	constant zero_4 : std_logic_vector((3*N/4)-1 downto 0) := (others => '0');
	constant zero_2 : std_logic_vector(N/2-1 downto 0) := (others => '0');
	constant one_4 : std_logic_vector((3*N/4)-1 downto 0) := (others => '1');
	constant one_2 : std_logic_vector(N/2-1 downto 0) := (others => '1');
begin
	comblogic: process(ld_sign, ld_type, mem_data)
	begin
		if (ld_sign = '0') then
			case (ld_type) is
				when "00" => -- load N bits
					ext_data <= mem_data;

				when "01" => -- load N/2 bits
					ext_data <= zero_2&mem_data(N/2-1 downto 0);

				when "10" => -- load N/4 bits
					ext_data <= zero_4&mem_data(N/4-1 downto 0);

				when "11" => -- this shouldn't happens
					ext_data <= mem_data;

				when others =>
					ext_data <= mem_data;
			end case;
		else -- ld_type = '1'
			case (ld_type) is
				when "00" => -- load N signed bits
					ext_data <= mem_data;

				when "01" => -- load N/2 signed bits
					if (mem_data(N/2-1) = '1') then
						ext_data <= one_2&mem_data((N/2)-1 downto 0);
					else
						ext_data <= zero_2&mem_data((N/2)-1 downto 0);
					end if;

				when "10" => -- load N/4 signed bits
					if (mem_data(N/4-1) = '1') then
						ext_data <= one_4&mem_data(N/4-1 downto 0);
					else
					 	ext_data <= zero_4&mem_data(N/4-1 downto 0);
					end if;

				when "11" => -- this shouldn't happens
					ext_data <= mem_data;
					
				when others =>
					ext_data <= mem_data;
			end case;
		end if;
	end process comblogic;

end behavioral;
