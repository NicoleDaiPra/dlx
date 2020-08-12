library ieee;
use ieee.math_real.all;

package fun_pack is
	function n_width (
		n: integer
	) return integer;
end package fun_pack;

package body fun_pack is
	function n_width (
		n: integer
	) return integer is
	begin
		return integer(ceil(log2(real(n))));
	end function n_width;
end package body fun_pack;