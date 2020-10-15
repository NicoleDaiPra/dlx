library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

-- This component decides in which block an update must take place. It also detects whether an update has to be done
-- on existing data or a replacement must be performed
entity dcache_replacement_logic is
	port (
		clk: in std_logic;
		rst: in std_logic;
		update: in std_logic; -- 1 if an update must be performed, 0 otherwise
		hits: in std_logic_vector(3 downto 0); -- used to determine if a particular block must be updated
		block_enc: in std_logic_vector(1 downto 0); -- in case of a hit the block specified by this signal must be updated
		block_to_upd: out std_logic_vector(3 downto 0); -- tells which block must be updated
		replacement: out std_logic -- tells to the cache if a replacement is taking place
	);
end dcache_replacement_logic;

architecture behavioral of dcache_replacement_logic is
	signal curr_upd, next_upd: std_logic_vector(3 downto 0); -- circular buffer to keep the position where a replacement took place

begin
	state_reg: process(clk, rst)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				curr_upd <= (0 => '1', others  => '0');
			else
				curr_upd <= next_upd;	
			end if;
		end if;
	end process state_reg;

	comblogic: process(curr_upd, update, hits, block_enc)
	begin
		replacement <= '0';
		next_upd <= curr_upd;

		if (update = '0') then
			block_to_upd <= (others  => '0');
		else
			if (or_reduce(hits) = '1') then -- if a hit has occurred then the block_enc value must be used
				case (block_enc) is
					when "00" =>
						block_to_upd <= "0001";
					when "01" => 
						block_to_upd <= "0010";
					when "10" => 
						block_to_upd <= "0100";
					when "11" => 
						block_to_upd <= "1000";
					when others =>
						block_to_upd <= (others => '0');
				end case;
			else -- a replacement is taking place
				block_to_upd <= curr_upd;
				next_upd <= curr_upd(2 downto 0)&curr_upd(3); -- change the block where the next replacement will take place
				replacement <= '1';
			end if;
		end if;
	end process comblogic;
end behavioral;
