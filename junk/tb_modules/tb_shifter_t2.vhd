library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_shifter_t2 is
end tb_shifter_t2;

architecture tb of tb_shifter_t2 is

    component shifter_t2 is
    port (
        data_in: in std_logic_vector(31 downto 0);
        shift: in std_logic_vector(4 downto 0);
        shift_type: in std_logic_vector(3 downto 0);
        data_out: out std_logic_vector(31 downto 0)
    );
    end component shifter_t2;
    
    signal data_in, data_out: std_logic_vector(31 downto 0);
	signal shift: std_logic_vector(4 downto 0);
	signal shift_type: std_logic_vector(3 downto 0);
    
    begin

    dut: shifter_t2
        port map (
            data_in => data_in,
            shift => shift,
            shift_type => shift_type,
            data_out => data_out
        );
    
    test_p: process
        begin
            data_in <= "11010011000000000001011000110011";
            
            shift_type <= "0010"; -- logical right
            for index in 0 to 31 loop
                shift <= std_logic_vector(to_unsigned(index,5));
                wait for 5 ns;
            end loop;
            
            shift_type <= "0011"; -- logical left
            for index in 0 to 31 loop
                shift <= std_logic_vector(to_unsigned(index,5));
                wait for 5 ns;
            end loop;
            
            shift_type <= "0100"; -- arithmetic right
            for index in 0 to 31 loop
                shift <= std_logic_vector(to_unsigned(index,5));
                wait for 5 ns;
            end loop;
            
            shift_type <= "0101"; -- arithmetic left
            for index in 0 to 31 loop
                shift <= std_logic_vector(to_unsigned(index,5));
                wait for 5 ns;
            end loop;
            
            shift_type <= "1000"; -- rotate right
            for index in 0 to 31 loop
                shift <= std_logic_vector(to_unsigned(index,5));
                wait for 5 ns;
            end loop;
            
            shift_type <= "1001"; -- rotate left
            for index in 0 to 31 loop
                shift <= std_logic_vector(to_unsigned(index,5));
                wait for 5 ns;
            end loop;
            
            -- arithmetic shift right with a positive number
            data_in <= "01010011000000000001011000110011";
            shift_type <= "0100"; -- arithmetic right
            for index in 0 to 31 loop
                shift <= std_logic_vector(to_unsigned(index,5));
                wait for 5 ns;
            end loop;
            
            wait;
        end process test_p;

end tb;
