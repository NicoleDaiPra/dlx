 library ieee;
use ieee.std_logic_1164.all;
use work.fun_pack.all;

-- BHT for the fetch stage implementation.
-- It takes in input the address fetched and checks if it is contained in its cache.
-- If so, it returns the predicted address if the jump will be taken and sets the 'predicted_taken'
-- signal to 1, otherwise it's set to 0 and the value in 'next_pc' must not be taken
-- in consideration.
-- A branch not known to the cache can be added by setting the update signal to a specified value
-- and the address is passed through the 'instr_to_update' signal. These pins are also
-- used to update the branch prediction bits after the instruction's execution.
entity bht is
	generic (
		A: integer := 32 -- address length
	);
	port (
		clk: in std_logic;
		rst: in std_logic;

		pc: in std_logic_vector(A-1 downto 0); -- current fetched instruction (program counter value)
		next_pc: out std_logic_vector(A-1 downto 0); -- memory address to be fetched in the next cycle
		predicted_taken: out std_logic; -- tells if a branch has been recognized and it's predicted to be taken
		addr_known: out std_logic; -- tells if the instruction in 'pc' is known to the BHT, regardless of the predictred_taken value
        
		-- "00" if nothing has to be done
		-- "01" if an already known instruction has to be updated (taken/not taken)
		-- "10" if a new instruction must be added
		-- "11" reserved
		update: in std_logic_vector(1 downto 0);
		instr_to_update: in std_logic_vector(A-1 downto 0); -- address instruction to be updated/added
		target_addr: in std_logic_vector(A-1 downto 0); -- next address to be fetched in case of a predicted taken
		taken: in std_logic -- if 1 the branch has been taken, 0 if not.
	);
end entity bht;

architecture behavioral of bht is
	component bht_4_way_associative_way is
		generic (
			T: integer := 8; -- width of the TAG bits
			W: integer := 8; -- line size
			NL: integer := 64 -- total number of lines in the cache (internally they're split in sets)
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			update_line: in std_logic; -- if update_line = '1' the cache adds a new entry to the cache
			update_data: in std_logic; -- if update_data = '1' the cache only replace the data corresponding to a tag
			read_address: in std_logic_vector(T+n_width(NL/4)-1 downto 0); -- address to be read from the cache
			rw_address: in std_logic_vector(T+n_width(NL/4)-1 downto 0); -- address to be written from the cache
			data_in: in std_logic_vector(W-1 downto 0); -- data to be added to the cache
			hit_miss_read: out std_logic; -- if read_address generates a hit then hit_miss_read = '1', otherwise hit_miss_read ='0'
			data_out_read: out std_logic_vector(W-1 downto 0); -- if hit_miss_read = '1' it contains the searched data, otherwise its value must not be considered
			hit_miss_rw: out std_logic; -- if rw_address generates a hit then hit_miss_rw = '1', otherwise hit_miss_rw ='0'

			data_out_rw: out std_logic_vector(W-1 downto 0) -- if hit_miss_rw = '1' it contains the searched data, otherwise its value must not be considered
		);
	end component bht_4_way_associative_way;

	constant STRONGLY_NOT_TAKEN: std_logic_vector(1 downto 0) := "00";
	constant WEAKLY_NOT_TAKEN: std_logic_vector(1 downto 0) := "01";
	constant WEAKLY_TAKEN: std_logic_vector(1 downto 0) := "10";
	constant STRONGLY_TAKEN: std_logic_vector(1 downto 0) := "11";

	constant NO_UPDATE: std_logic_vector(1 downto 0) := "00";
	constant HISTORY_UPDATE: std_logic_vector(1 downto 0) := "01";
	constant NEW_BRANCH_UPDATE: std_logic_vector(1 downto 0) := "10";
	constant RESERVED: std_logic_vector(1 downto 0) := "11";

	signal cache_update_line, cache_update_data: std_logic;
	signal cache_data_in, cache_data_out_read, cache_data_out_rw: std_logic_vector(A+2-1 downto 0); -- prediction_bits&target_address
	signal cache_hit_read, cache_hit_rw: std_logic;

begin
	cache: bht_4_way_associative_way
		generic map (
			T => A-3,
			W => A+2, -- store the target address + 2 prediction bits
			NL => 32
		)
		port map (
			clk => clk,
			rst => rst,
			update_line => cache_update_line,
			update_data => cache_update_data,
			read_address => pc,
			rw_address => instr_to_update,
			data_in => cache_data_in,
			hit_miss_read => cache_hit_read,
			data_out_read => cache_data_out_read,
			hit_miss_rw => cache_hit_rw,			
			data_out_rw => cache_data_out_rw
		);

	next_pc <= cache_data_out_read(A-1 downto 0);
	addr_known <= cache_hit_read;

	comblogic: process(cache_hit_read, cache_data_out_read, cache_hit_rw, cache_data_out_rw,
						pc, update, instr_to_update, target_addr, taken)
		variable predicted_t: std_logic;
		variable predicted_state_read, predicted_state_rw: std_logic_vector(1 downto 0);
	begin
		cache_data_in <= (others => '0');

		predicted_state_read := cache_data_out_read(A+2-1 downto A);
		predicted_state_rw := cache_data_out_rw(A+2-1 downto A);

		-- set the predicted_taken signal based on the history bits
		-- 00 -> not taken
		-- 01 -> not taken
		-- 10 -> taken
		-- 11 -> taken

		-- POSSOBLE MICRO-OPTIMIZATION:
		-- predicted_taken <= cache_hit_read (which corresponds to addr_known) and predicted_t (either 0 or 1)
		-- the and between the components could be spared since
		--		addr_known and 0 -> 0
		--		addr_known and 1 -> addr_known

		case (predicted_state_read) is
			when STRONGLY_NOT_TAKEN =>
				predicted_t := '0';

			when WEAKLY_NOT_TAKEN => 
				predicted_t := '0';

			when WEAKLY_TAKEN =>
				predicted_t := '1';

			when STRONGLY_TAKEN =>
				predicted_t := '1';

			when others =>
				predicted_t := '0';
		end case;

		-- an address is predicted taken only if it's also known
		predicted_taken <= cache_hit_read and predicted_t;

		-- update logic
		case (update) is
			when NO_UPDATE => -- nothing has to be done
				cache_update_line <= '0';
				cache_update_data <= '0';

			when HISTORY_UPDATE => -- an already known instruction must be updated
				cache_update_line <= '0';
				cache_update_data <= '1';
				case (predicted_state_rw) is
					when STRONGLY_NOT_TAKEN =>
						if (taken = '1') then
							cache_data_in <= WEAKLY_NOT_TAKEN&cache_data_out_rw(A-1 downto 0);
						else
							cache_data_in <= STRONGLY_NOT_TAKEN&cache_data_out_rw(A-1 downto 0);
						end if;	

					when WEAKLY_NOT_TAKEN =>
						if (taken = '1') then
							cache_data_in <= WEAKLY_TAKEN&cache_data_out_rw(A-1 downto 0);
						else
							cache_data_in <= STRONGLY_NOT_TAKEN&cache_data_out_rw(A-1 downto 0);
						end if;

					when WEAKLY_TAKEN =>
						if (taken = '1') then
							cache_data_in <= STRONGLY_TAKEN&cache_data_out_rw(A-1 downto 0);
						else
							cache_data_in <= WEAKLY_NOT_TAKEN&cache_data_out_rw(A-1 downto 0);
						end if;

					when STRONGLY_TAKEN =>
						if (taken = '1') then
							cache_data_in <= STRONGLY_TAKEN&cache_data_out_rw(A-1 downto 0);
						else
							cache_data_in <= WEAKLY_TAKEN&cache_data_out_rw(A-1 downto 0);
						end if;

					when others =>
						cache_update_data <= '0'; -- avoid any update
				end case;

			when NEW_BRANCH_UPDATE => -- a new branch has been discovered
				cache_update_line <= '1';
				cache_update_data <= '0';
				if (taken = '1') then
					cache_data_in <= WEAKLY_TAKEN&target_addr;
				else
					cache_data_in <= WEAKLY_NOT_TAKEN&target_addr;
				end if;

			when RESERVED =>
				-- this case has no use for now. In case it's accidentally entered do nothing
				cache_update_line <= '0';
				cache_update_data <= '0';

			-- unknown case (this is BAD): do nothing as in case "00"
			when others =>
				cache_update_line <= '0';
				cache_update_data <= '0';
		end case;
	end process comblogic;
end architecture behavioral;