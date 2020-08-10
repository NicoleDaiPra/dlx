library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_rom is
end tb_rom;

architecture tb of tb_rom is

    component rom is
        generic ( 
            N: integer := 32;
            M: integer := 8;
            T: time := 0 ns
        );
        port ( 
            rst: in std_logic;
            addr: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            data_out: out std_logic_vector(N-1 downto 0) 
        );
    end component rom;
    
    constant N: integer := 32;
    constant M: integer := 8;
    constant T: time := 2 ns;
    
    signal rst: std_logic;
    signal addr: std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
    signal data_out: std_logic_vector(N-1 downto 0);

begin
    dut: rom
        generic map(
            N => N,
            M => M,
            T => T
        )
        port map (
            rst => rst,
            addr => addr,
            data_out => data_out
        );
    test_p: process
    begin
        
        wait for 2 ns;
        rst <= '0';
        wait for 10 ns;
        rst <= '1';
        for index in 0 to M-1 loop
            addr <= std_logic_vector(to_unsigned(index, integer(ceil(log2(real(M))))));
            wait for 10 ns;
        end loop;
        wait;
    end process;


end tb;
