library ieee;
use ieee.std_logic_1164.all;

entity stall_unit is
	port (
		mul_in_prog: in std_logic; -- 1 if a mul is in progress
		cache_miss: in std_logic; -- 1 if a cache miss is in progress
		rd_exemem: in std_logic_vector(4 downto 0); -- the rd stored in exe/mem regs
		rd_memwb: in std_logic_vector(4 downto 0); -- the rd stored in mem/wb regs
		rs: in std_logic_vector(4 downto 0); -- the rs reg in the id stage
		rt: in std_logic_vector(4 downto 0); -- the rt reg in the id stage

		cpu_is_reading: in std_logic; -- 1 if the CPU is performing a load

		-- specifies how the instruction in the ID/EXE regs expects forwarding
		-- "00": no forwarding supported (ex. jal)
		-- "01": rs only forwarding (ex. ld)
		-- "10": rs-rt forwarding (ex. add)
		-- "11": reserved
		id_fw_type: in std_logic_vector(1 downto 0);

		rd_exemem_valid: in std_logic; -- the value in the ex/mem regs corresponds to the rd stored in it
		rd_memwb_valid: in std_logic; -- the value in the mem/wb regs corresponds to the rd stored in it

		fw_a: out std_logic_vector(1 downto 0);
		fw_b: out std_logic_vector(1 downto 0);
		en_npc_if: out std_logic;
		en_ir_if: out std_logic;
		pc_en_if: out std_logic;
		id_en: out std_logic;
		exe_en: out std_logic;
		mem_en: out std_logic;
		wb_en: out std_logic;
		if_stall: out std_logic;
		id_stall: out std_logic;
		exe_stall: out std_logic;
		mem_stall: out std_logic
	);
end stall_unit;

architecture behavioral of stall_unit is
	signal hazards: std_logic_vector(3 downto 0);
begin
	hazard_check: process(rd_exemem, rd_memwb, rs, rt, cpu_is_reading, rd_exemem_valid, rd_memwb_valid)
	begin
		hazards <= "0000";

		if (rs = rd_exemem and rd_exemem_valid = '1') then
			hazards(0) <= '1';
		end if;

		if (rt = rd_exemem and rd_exemem_valid = '1') then
			hazards(1) <= '1';
		end if;

		if (rs = rd_memwb and rd_memwb_valid = '1') then
			hazards(2) <= '1';
		end if;

		if (rt = rd_memwb and rd_memwb_valid = '1') then
			hazards(3) <= '1';
		end if;
	end process hazard_check;

	comblogic: process(mul_in_prog, cache_miss, rd_exemem, rd_memwb, rs, rt, cpu_is_reading, id_fw_type, rd_exemem_valid, rd_memwb_valid, hazards)
	begin
		en_npc_if <= '1';
		en_ir_if <= '1';
		pc_en_if <= '1';
		id_en <= '1';
		exe_en <= '1';
		mem_en <= '1';
		wb_en <= '1';
		if_stall <= '0';
		id_stall <= '0';
		exe_stall <= '0';
		mem_stall <= '0';
		fw_a <= "00";
		fw_b <= "00";

		if (cache_miss = '1') then
			en_npc_if <= '0';
			en_ir_if <= '0';
			pc_en_if <= '0';
			id_en <= '0';
			exe_en <= '0';
			if_stall <= '1';
			id_stall <= '1';
			exe_stall <= '1';
		elsif (mul_in_prog = '1') then
			en_npc_if <= '0';
			en_ir_if <= '0';
			pc_en_if <= '0';
			id_en <= '0';
			if_stall <= '1';
			id_stall <= '1';
		else
			case (id_fw_type) is
				when "00" =>
					null;

				when "01" => 
					if (hazards(0) = '1') then
						-- hazard between id/exe and exe/mem
						if (cpu_is_reading = '1') then
							-- the result should come from a load which hasn't finished yet
							en_npc_if <= '0';
							en_ir_if <= '0';
							pc_en_if <= '0';
							id_en <= '0';
							exe_en <= '0';
							if_stall <= '1';
							id_stall <= '1';
							exe_stall <= '1';
						else
							-- rs can be forwarded
							fw_a <= "01";
						end if;
					elsif (hazards(2) = '1') then
						-- hazard between id/exe and mem/wb
						fw_a <= "10";
					end if;

				when "10" => 
					if (hazards(0) = '1') then
						-- hazard between id/exe and exe/mem
						if (cpu_is_reading = '1') then
							-- the result should come from a load which hasn't finished yet
							en_npc_if <= '0';
							en_ir_if <= '0';
							pc_en_if <= '0';
							id_en <= '0';
							exe_en <= '0';
							if_stall <= '1';
							id_stall <= '1';
							exe_stall <= '1';
						else
							-- rs can be forwarded
							fw_a <= "01";
						end if;
					elsif (hazards(2) = '1') then
						-- hazard between id/exe and mem/wb
						fw_a <= "10";
					end if;

					if (hazards(1) = '1') then
						-- hazard between id/exe and exe/mem
						if (cpu_is_reading = '1') then
							-- the result should come from a load which hasn't finished yet
							en_npc_if <= '0';
							en_ir_if <= '0';
							pc_en_if <= '0';
							id_en <= '0';
							exe_en <= '0';
							if_stall <= '1';
							id_stall <= '1';
							exe_stall <= '1';
						else
							-- rs can be forwarded
							fw_b <= "01";
						end if;
					elsif (hazards(3) = '1') then
						-- hazard between id/exe and mem/wb
						fw_b <= "10";
					end if;
				when others =>
					null;
			end case;
		end if;
	end process comblogic;
end behavioral;
