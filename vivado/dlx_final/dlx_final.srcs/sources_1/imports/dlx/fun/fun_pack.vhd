library ieee;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package fun_pack is
    -- compute the number of bits needed to encode a generic N
    function n_width (
        n: integer
    ) return integer;

    -- return the level of the parent of the unit at index j (j refers to the position of the unit inside a block)
    function level_index (
        j: integer
    ) return integer;

    -- return the index of the last g_unit instantiated at level lvl
    function last_g_unit_prev_lvl (
        lvl: integer
    ) return integer;

    -- calculate if curr_i is the index of the first pg_unit in a block
    function pg_i_start_block (
        curr_i: integer; 
        lvl: integer; 
        nbit: integer
    ) return integer;
end package fun_pack;

package body fun_pack is 

    function n_width (
        n: integer
    ) return integer is
    begin
        return integer(ceil(log2(real(n))));
    end function n_width;

    function level_index (
        j: integer
    ) return integer is
        variable index: integer;
    begin
        index := integer(ceil(log2(real((j+1)*2))));
        return index;
    end function level_index;
    
    function last_g_unit_prev_lvl (
        lvl: integer
    ) return integer is
        variable index: integer;
    begin
        index := 2**(lvl)-1;
        return index;
    end function last_g_unit_prev_lvl;
    
    function pg_i_start_block (
        curr_i: integer; 
        lvl: integer; 
        nbit: integer
    ) return integer is        
        constant units_per_block: integer := 2**(lvl-2);
        -- position of the last g_unit expressed as bit position
        constant last_g_unit: integer := (4*(2**(lvl-2)+1)-1) + 4*(units_per_block-1);
        
        variable start: integer := 0; -- if 0 the first block of units block doesn't start at curr_i, if 1 it does
        variable index: integer := last_g_unit + 4*(units_per_block+1);
    begin
        while (index < curr_i+1) loop
            if (index = curr_i) then
                start := 1;
                exit;
            else
                index := index + 4*(units_per_block-1); -- go to the last unit in the block
                index := index + 4*(units_per_block+1); -- form the last unit in the block jump to the first unit of the next block      
            end if;
        end loop;
        
        return start;
    end function pg_i_start_block;
end package body fun_pack;