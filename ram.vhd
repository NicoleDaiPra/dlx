library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity ram is
    generic ( 
            N: integer := 32;
            M: integer := 8;
            T: time := 0 ns
    );
    port ( 
        rst: in std_logic;
        clk: in std_logic;
        rw: in std_logic; -- rw = '1' read, rw = '0' write
        addr: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
        data_in: in std_logic_vector(N-1 downto 0);
        data_out: out std_logic_vector(N-1 downto 0) 
    );
end ram;

architecture behavioral of ram is

type storage is array (0 to M-1) of std_logic_vector(N-1 downto 0);
signal ram_mem: storage;

begin

    read_p: process(ram_mem, rw, addr, data_in)
    begin
        if (rw = '1') then
            data_out <= ram_mem(to_integer(unsigned(addr))) after T;   
        end if;
    end process read_p;

    write_p: process(clk)
    begin
        if(clk = '1' and clk'event) then
            if (rst = '0') then
                ram_mem <= (others => (others => '0'));
            elsif (rst = '1') then
                if (rw = '0') then
                    ram_mem(to_integer(unsigned(addr))) <= data_in; 
                end if; 
            end if;
        end if;
    end process write_p;
end behavioral;
