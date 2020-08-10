library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_ram is
end tb_ram;

architecture tb of tb_ram is

    component ram is
        generic ( N: integer := 32;
                  M: integer := 8;
                  T: time := 0 ns
        );
        port ( rst: in std_logic;
               clk: in std_logic;
               rw: in std_logic; -- rw = '1' read, rw = '0' write
               addr: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
               data_in: in std_logic_vector(n-1 downto 0);
               data_out: out std_logic_vector(n-1 downto 0) );
    end component ram;
    
    constant N: integer := 32;
    constant M: integer := 8;
    constant T: time := 2 ns;
    
    signal rst, clk, rw: std_logic;
    signal addr: std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
    signal data_in, data_out: std_logic_vector(N-1 downto 0);

begin

    dut: entity work.ram(beh) 
        generic map (
            N => N,
            M =>M,
            T => T
        )
        port map (
            rst => rst, 
            clk => clk, 
            rw => rw, 
            addr => addr, 
            data_in => data_in, 
            data_out => data_out
        );
    
    clkP: process
          begin
            clk <= '1';
            wait for 10 ns;
            clk <= '0';
            wait for 10 ns;
          end process;
          
    vecP: process
          begin
            
            -- reset the memory
            wait for 2 ns;
            rst <= '0';
            wait until clk = '1' and clk'event;
            wait for 2 ns;
            rst <= '1';
            addr <= (others => '0');
            wait until clk = '1' and clk'event;
            rw <= '0';
            
            -- for each cell read 0 and write index;
            for index in 0 to 7 loop
                
                wait for 2 ns;
                rw <= '0';
                wait until clk = '1' and clk'event;
                
                data_in <= std_logic_vector(to_unsigned(index, 32));
                wait until clk = '1' and clk'event;
                wait for 2 ns;
                rw <= '1';
                wait until clk = '1' and clk'event;
                addr <= std_logic_vector(unsigned(addr) + 1);
            end loop;  
                  
            wait;
          end process;
end tb;
