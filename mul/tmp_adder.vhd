----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/07/2020 11:31:44 AM
-- Design Name: 
-- Module Name: tmp_adder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tmp_adder is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		cin: in std_logic;
		sum: out std_logic_vector(N-1 downto 0);
		cout: out std_logic
	);
end tmp_adder;

architecture Behavioral of tmp_adder is

begin
	process(a, b, cin)
		variable tmp: std_logic_vector(N downto 0);
		variable a_i, b_i, c_i: std_logic_vector(N downto 0);
	begin
	    a_i := '0'&a;
	    b_i := '0'&b;
	    c_i := (0 => cin, others => '0');
		tmp := std_logic_vector(unsigned(a_i) + unsigned(b_i) + unsigned(c_i));
		sum <= tmp(N-1 downto 0);
		cout <= tmp(N);
	end process;

end Behavioral;
