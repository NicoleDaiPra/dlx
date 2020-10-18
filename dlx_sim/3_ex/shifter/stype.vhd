library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package stype is
	constant LOGRIGHT : std_logic_vector(3 downto 0) := "0010";
	constant LOGLEFT : std_logic_vector(3 downto 0) := "0011";
	constant ARITHRIGHT : std_logic_vector(3 downto 0) := "0100";
end stype;
