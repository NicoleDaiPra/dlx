library ieee;
use ieee.std_logic_1164.all;

-- This component implements a FIFO replacement logic
entity btb_cache_replacement_logic is
	generic (
		NL: integer := 128
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		cache_update: in std_logic; -- if 1 the cache wants to update a line
		line_update: out std_logic_vector(NL-1 downto 0) -- if the i-th bit is set to 1 the i-th line updates its content
	);
end entity btb_cache_replacement_logic;

architecture behavioral of btb_cache_replacement_logic is
	signal curr_repl, next_repl: std_logic_vector(NL-1 downto 0);
	signal cu_extended: std_logic_vector(NL-1 downto 0);
begin
	state_reg: process(clk)
	begin
		if (rst = '0') then
			curr_repl <= (0 => '1', others => '0');
		elsif (clk = '1' and clk'event) then
			curr_repl <= next_repl;	
		end if;
	end process state_reg;

	cu_extended <= (others => cache_update);
	line_update <= curr_repl and cu_extended; -- raise an update only when requested

	comblogic: process(curr_repl, cache_update)
	begin
		next_repl <= curr_repl;
		
		-- a rotation it's enough to perform a FIFO replacement as
		-- the position of the 1 indicates which cache line must be updated
		if (cache_update = '1') then
			next_repl <= curr_repl(NL-2 downto 0)&curr_repl(NL-1);
		end if;
	end process comblogic;
end architecture behavioral;