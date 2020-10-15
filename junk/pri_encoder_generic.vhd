library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use work.fun_pack.n_width;

-- Generic priority encoder implementation. It works only for power-of-two N values
-- The implementation was taken from https://github.com/yugr/primogen/blob/master/src/prio_enc.v
-- and converted from Verilog to VHDL.
-- This component provides a good trade-off between performance and HW complexity.
entity pri_encoder_generic is
	generic (
		N: integer := 128
	);
	port (
		i: in std_logic_vector(N-1 downto 0);
		enc: out std_logic_vector(n_width(N)-1 downto 0)
	);
end entity pri_encoder_generic;

architecture behavioral of pri_encoder_generic is
begin
    process(i)
        variable width: integer;
        variable part: std_logic_vector(N-1 downto 0);
        variable msb: std_logic_vector(n_width(N)-1 downto 0) := (others => '0');
    begin
        part := i;

        -- The loop iterates log2(N) times. It's based on a tree search
        -- where the MSBs bits are analyzed in tranches of 2^j bits one after the other.
        -- 'width' specifies the number of bits analyzed in a tranche.
        -- If in a tranche there's at least 1 bit sets to 1, the j-th bit of the encoded
        -- signal is set to 1 and the input is shifted by 'width' bits, then it is passed to the next stage.
        -- Instead, if there are no bits set to 1 the MSBs are cleared with a mask and the
        -- input is passed as is to the next tranche.
        for j in n_width(N)-1 downto 0 loop
            width := to_integer(to_unsigned(1, N) sll j);
            if (or_reduce(std_logic_vector(unsigned(part) srl width)) = '1') then
                msb(j) := '1';
            else
                msb(j) := '0';    
            end if;
            
            if (msb(j) = '1') then
                part := std_logic_vector(unsigned(part) srl width);
            else
                part := part and std_logic_vector((to_unsigned(1, N) sll width) - 1);    
            end if;
        end loop;
        
        enc <= msb;
    end process;
end architecture behavioral;