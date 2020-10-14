library ieee;
use ieee.std_logic_1164.all;

entity wb_stage is
	port (
		store_sel: in std_logic; -- 0 to select data_tbs, 1 to select the cache
		data_tbs_in: in std_logic_vector(31 downto 0);
		data_cache_in: in std_logic_vector(31 downto 0);
		data_rf: out std_logic_vector(31 downto 0) -- data to be stored in the RF
	);
end wb_stage;

architecture structural of wb_stage is
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
	rf_data_mux: mux_2x1
		generic map (
			N => 32
		)
		port map (
			a => data_tbs_in,
			b => data_cache_in,
			sel => store_sel,
			o => data_rf
		);

end structural;
