library ieee;
use ieee.std_logic_1164.all;

entity mem_stage is
	port (
		alu_data_tbs_selector: in std_logic; -- 0 to select the output of the alu, 1 to select data_tbs (op_b) to be stored in the RF
		ld_sign: in std_logic; -- 1 if load is signed, 0 if unsigned
		-- controls how many bits of the word are kept after a load
		-- 00: load N bits
		-- 01: load N/2 bits
		-- 10: load N/4 bits
		-- 11: reserved
		ld_type: in std_logic_vector(1 downto 0);
		op_b_in: in std_logic_vector(31 downto 0);
		alu_out_low_in: in std_logic_vector(31 downto 0);
		mem_data_in: in std_logic_vector(31 downto 0);
		mem_data_out: out std_logic_vector(31 downto 0);
		data_tbs: out std_logic_vector(31 downto 0)
	);
end mem_stage;

architecture structural of mem_stage is
	component mem_sign_extender is
		generic (
			N: integer := 32
		);
		port (
			ld_sign: in std_logic; -- 1 if load is signed, 0 if unsigned
			-- controls how many bits of the word are kept after a load
			-- 00: load N bits
			-- 01: load N/2 bits
			-- 10: load N/4 bits
			-- 11: reserved
			ld_type: in std_logic_vector(1 downto 0);
			mem_data: in std_logic_vector(N-1 downto 0); -- data to be extended
			ext_data: out std_logic_vector(N-1 downto 0) -- extended data
		);
	end component mem_sign_extender;

	component mux_2x1 is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic;
			o: out std_logic_vector(N-1 downto 0)
		);
	end component mux_2x1;

begin
	mem_data_ext: mem_sign_extender
		generic map (
			N => 32
		)
		port map (
			ld_sign => ld_sign,
			ld_type => ld_type,
			mem_data => mem_data_in,
			ext_data => mem_data_out
		);

	data_tbs_mux: mux_2x1
		generic map (
			N => 32
		)
		port map (
			a => op_b_in,
			b => alu_out_low_in,
			sel => alu_data_tbs_selector,
			o => data_tbs
		);
end structural;
