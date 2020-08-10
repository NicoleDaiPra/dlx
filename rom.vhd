library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity rom is
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
end rom;

architecture behavioral of rom is

    type storage is array (0 to M-1) of std_logic_vector(N-1 downto 0);
    signal rom_mem: storage;
    
    constant file_name: string := "C:\Users\Nicole\Desktop\mem.txt";

begin

    data_out <= rom_mem(to_integer(unsigned(addr))) after T;

	fill_mem_p: process(rst)
			file file_pointer: text;
			variable file_line: line;
			variable index: integer := 0;
			variable tmp_data: std_logic_vector (N-1 downto 0);
		begin

			if (rst = '0') then
				file_open(file_pointer, file_name, READ_MODE);
				while(not endfile(file_pointer)) loop
					readline(file_pointer, file_line);
					hread(file_line, tmp_data);
					rom_mem(index) <= std_logic_vector(unsigned(tmp_data));
					index := index + 1;
				end loop;
			end if;

		end process;

end behavioral;