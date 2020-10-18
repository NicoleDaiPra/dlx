library ieee;
use ieee.std_logic_1164.all;

entity tb_shifter is
end tb_shifter;

architecture tb of tb_shifter is

	component shifter is
	    port ( 
	        data_in: in std_logic_vector(31 downto 0);
	        shift: in std_logic_vector(4 downto 0);
	        shift_type: in std_logic_vector(3 downto 0); -- arith, logical, rotate right/left
	        data_out: out std_logic_vector(31 downto 0)
	    );
	end component shifter;

	signal data_in, data_out: std_logic_vector(31 downto 0);
	signal shift: std_logic_vector(4 downto 0);
	signal shift_type: std_logic_vector(3 downto 0);

	begin
    
    dut: shifter 
        port map (
            data_in => data_in,
            shift => shift,
            shift_type => shift_type,
            data_out => data_out
        );
        
	test_p: process
		begin
			data_in <= X"00001100";
			wait for 10 ns;

			-- LOGLEFT 0001
			shift <= "00010";
			shift_type <= "0011";
			wait for 10 ns;

			-- LOGRIGHT 0000
			shift <= "00010";
			shift_type <= "0010";
			wait for 10 ns;

			-- ROTLEFT 1001

			shift <= "00100";
			shift_type <= "1001";
			wait for 10 ns;

			-- ROTRIGHT 1000
			shift <= "00101";
			shift_type <= "1000";
			
			wait;
		end process test_p;

end tb;
