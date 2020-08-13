library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fun_pack.n_width;

entity mux_nx1 is
	generic (
		N: integer := 32; -- data bit size
		M: integer := 128 -- number of elements to be muxed
	);
	port (
		i: in std_logic_vector(N*M-1 downto 0);
		sel: in std_logic_vector(n_width(M)-1 downto 0);
		o: out std_logic_vector(N-1 downto 0)
	);
end entity mux_nx1;

architecture behavioral of mux_nx1 is
type mux_array is array (0 to M-1) of std_logic_vector(N-1 downto 0);

begin
	process(i, sel)
		variable tmp: mux_array;
	begin
		for j in 0 to M-1 loop
			tmp(j) := i((j+1)*N-1 downto j*N);
		end loop;

		o <= tmp(to_integer(unsigned(sel)));
	end process;	
end architecture behavioral;