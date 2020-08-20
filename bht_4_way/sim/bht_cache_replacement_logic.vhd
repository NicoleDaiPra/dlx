library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fun_pack.all;

-- This component implements a per-set FIFO replacement logic
entity bht_cache_replacement_logic is
	generic (
		NL: integer := 64 -- total number of lines in the cache
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		cache_update: in std_logic; -- if 1 the cache wants to update a line
		set_rw: in std_logic_vector(n_width(NL/4)-1 downto 0); -- the set that is being updated
		line_update: out std_logic_vector(3 downto 0) -- if the i-th bit is set to 1 the i-th line updates its content
	);
end entity bht_cache_replacement_logic;

architecture behavioral of bht_cache_replacement_logic is
	type sets_array is array (0 to NL-1) of std_logic_vector(3 downto 0);

	signal curr_repl, next_repl: sets_array;
	signal cu_extended: std_logic_vector(3 downto 0);

begin
	state_reg: process(clk)
	begin
		if (rst = '0') then
			for i in 0 to NL-1 loop
				curr_repl(i) <= "0001";
			end loop;
		elsif (clk = '1' and clk'event) then
			curr_repl <= next_repl;	
		end if;
	end process state_reg;

	cu_extended <= (others => cache_update);
	line_update <= curr_repl(to_integer(unsigned(set_rw))) and cu_extended;

	comblogic: process(curr_repl, cache_update, set_rw)
	   variable tmp: std_logic_vector(3 downto 0);
	begin
		next_repl <= curr_repl;

		tmp := curr_repl(to_integer(unsigned(set_rw)));
		if (cache_update = '1') then
			next_repl(to_integer(unsigned(set_rw))) <= tmp(2 downto 0)&tmp(3);
		end if;
	end process comblogic;
end architecture behavioral;