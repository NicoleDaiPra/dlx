library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rf is

end tb_rf;

architecture test of tb_rf is
	component rf is
		generic (
			N: integer := 32 -- size of a single register
		);
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- ISA accessible registers interface
			rp1_addr: in std_logic_vector(4 downto 0); -- register address for rp1
			rp2_addr: in std_logic_vector(4 downto 0); -- register address for rp2
			wp_addr: in std_logic_vector(4 downto 0); -- register address for wp
			wp_en: in std_logic; -- write enable
			wp: in std_logic_vector(N-1 downto 0); -- write port
			rp1: out std_logic_vector(N-1 downto 0); -- read port 1
			rp2: out std_logic_vector(N-1 downto 0); -- read port 2

			-- special registers interface
			-- rp1_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 reserved
			rp1_out_sel: in std_logic_vector(1 downto 0);
			-- rp2_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 reserved
			rp2_out_sel: in std_logic_vector(1 downto 0);
			hilo_wr_en: in std_logic; -- 1 if the HI and LO register must be written
			lo_in: in std_logic_vector(N-1 downto 0); -- input data for the LO register
			hi_in: in std_logic_vector(N-1 downto 0) -- input data for the HI register
		);
	end component rf;

	constant period : time := 1 ns; 

	signal clk, rst, wp_en, hilo_wr_en: std_logic;
	signal rp1_out_sel, rp2_out_sel: std_logic_vector(1 downto 0);
	signal rp1_addr, rp2_addr, wp_addr: std_logic_vector(4 downto 0);
	signal wp, rp1, rp2, lo_in, hi_in: std_logic_vector(31 downto 0);

begin
	dut: rf
		generic map (
			N => 32
		)
		port map (
			clk => clk,
			rst => rst,
			rp1_addr => rp1_addr,
			rp2_addr => rp2_addr,
			wp_addr => wp_addr,
			wp_en => wp_en,
			wp => wp,
			rp1 => rp1,
			rp2 => rp2,
			rp1_out_sel => rp1_out_sel,
			rp2_out_sel => rp2_out_sel,
			hilo_wr_en => hilo_wr_en,
			lo_in => lo_in,
			hi_in => hi_in
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_proc;

	test_proc: process
		variable raddr1, raddr2, waddr: unsigned(4 downto 0) := (others => '1');
		variable wdata: unsigned(31 downto 0) := (0 => '1', others => '0');
	begin
		rst <= '0';
		wait for period/2;

		rst <= '1';
		hilo_wr_en <= '0';
		wp_en <= '0';
		rp1_out_sel <= "00";
		rp2_out_sel <= "00";
		-- check that all registers are set to 0
		for i in 0 to 15 loop
			raddr1 := to_unsigned(2*i, 5);
			raddr2 := to_unsigned(2*i + 1, 5);
			rp1_addr <= std_logic_vector(raddr1);
			rp2_addr <= std_logic_vector(raddr2);
			wait for period;
		end loop;

		-- write some data
		wp <= X"00001111";
		wp_addr <= "00100";
		wp_en <= '1';
		wait for period;

		wp <= X"11112222";
		wp_addr <= "01001";
		wait for period;

		-- try to unsuccessfully write the register "r0"
		wp <= X"55555555";
		wp_addr <= "00000";
		wait for period;

		wp_en <= '0';
		rp1_out_sel <= "00";
		rp2_out_sel <= "00";
		-- check all register values
		for i in 0 to 15 loop
			raddr1 := to_unsigned(2*i, 5);
			raddr2 := to_unsigned(2*i + 1, 5);
			rp1_addr <= std_logic_vector(raddr1);
			rp2_addr <= std_logic_vector(raddr2);
			wait for period;
		end loop;

		-- write the LO and HI registers
		lo_in <= X"12345678";
		hi_in <= X"9ABCDEF0";
		hilo_wr_en <= '1';
		wait for period;

		-- check that their outputs are correct
		hilo_wr_en <= '0';
		rp1_out_sel <= "01";
		rp2_out_sel <= "10";
		wait for period;

		rp1_out_sel <= "10";
		rp2_out_sel <= "01";
		wait for period;

		rp1_out_sel <= "00";
		rp2_out_sel <= "00";
		wait;
	end process test_proc;
end test;
