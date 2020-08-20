library ieee;
use ieee.std_logic_1164.all;

entity mux_32x1 is
	generic (
		NBIT: integer := 32
	);
	port (
		a: in std_logic_vector(NBIT-1 downto 0);
		b: in std_logic_vector(NBIT-1 downto 0);
		c: in std_logic_vector(NBIT-1 downto 0);
		d: in std_logic_vector(NBIT-1 downto 0);
		e: in std_logic_vector(NBIT-1 downto 0);
		f: in std_logic_vector(NBIT-1 downto 0);
		g: in std_logic_vector(NBIT-1 downto 0);
		h: in std_logic_vector(NBIT-1 downto 0);
		i: in std_logic_vector(NBIT-1 downto 0);
		j: in std_logic_vector(NBIT-1 downto 0);
		k: in std_logic_vector(NBIT-1 downto 0);
		l: in std_logic_vector(NBIT-1 downto 0);
		m: in std_logic_vector(NBIT-1 downto 0);
		n: in std_logic_vector(NBIT-1 downto 0);
		o: in std_logic_vector(NBIT-1 downto 0);
		p: in std_logic_vector(NBIT-1 downto 0);
		q: in std_logic_vector(NBIT-1 downto 0);
		r: in std_logic_vector(NBIT-1 downto 0);
		s: in std_logic_vector(NBIT-1 downto 0);
		t: in std_logic_vector(NBIT-1 downto 0);
		u: in std_logic_vector(NBIT-1 downto 0);
		v: in std_logic_vector(NBIT-1 downto 0);
		w: in std_logic_vector(NBIT-1 downto 0);
		x: in std_logic_vector(NBIT-1 downto 0);
		y: in std_logic_vector(NBIT-1 downto 0);
		z: in std_logic_vector(NBIT-1 downto 0);
		aa: in std_logic_vector(NBIT-1 downto 0);
		ab: in std_logic_vector(NBIT-1 downto 0);
		ac: in std_logic_vector(NBIT-1 downto 0);
		ad: in std_logic_vector(NBIT-1 downto 0);
		ae: in std_logic_vector(NBIT-1 downto 0);
		af: in std_logic_vector(NBIT-1 downto 0);
		sel: in std_logic_vector(4 downto 0);
		outp: out std_logic_vector(NBIT-1 downto 0)
	);
end entity mux_32x1;

architecture behavioral of mux_32x1 is

begin
	with sel select outp <=
		a when "00000",
		b when "00001",
		c when "00010",
		d when "00011",
		e when "00100",
		f when "00101",
		g when "00110",
		h when "00111",
		i when "01000",
		j when "01001",
		k when "01010",
		l when "01011",
		m when "01100",
		n when "01101",
		o when "01110",
		p when "01111",
		q when "10000",
		r when "10001",
		s when "10010",
		t when "10011",
		u when "10100",
		v when "10101",
		w when "10110",
		x when "10111",
		y when "11000",
		z when "11001",
		aa when "11010",
		ab when "11011",
		ac when "11100",
		ad when "11101",
		ae when "11110",
		af when others;
end architecture behavioral;