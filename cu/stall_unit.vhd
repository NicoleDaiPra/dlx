library ieee;
use ieee.std_logic_1164.all;
use work.func_words.all;
use ieee.std_logic_misc.all;

entity stall_unit is
	port (
		curr_mul_in_prog: in std_logic; -- 1 if a mul is in progress
		next_mul_in_prog: in std_logic;
		mul_push: in std_logic; -- the mul has finished, push it through the pipeline
		cache_miss: in std_logic; -- 1 if a cache miss is in progress
		rd_idexe: in std_logic_vector(4 downto 0); -- the rd stored in id/exe regs
		rd_exemem: in std_logic_vector(4 downto 0); -- the rd stored in exe/mem regs
		rd_memwb: in std_logic_vector(4 downto 0); -- the rd stored in mem/wb regs
		rs_exe: in std_logic_vector(4 downto 0); -- the rs reg in the exe stage
		rt_exe: in std_logic_vector(4 downto 0); -- the rt reg in the exe stage
		rs_id: in std_logic_vector(4 downto 0); -- the rs reg in the id stage
		rt_id: in std_logic_vector(4 downto 0); -- the rt reg in the id stage

		cpu_is_reading: in std_logic; -- 1 if the CPU is performing a load

		-- specifies how the instruction in the ID/EXE regs expects forwarding
		-- "00": no forwarding supported (ex. jal)
		-- "01": rs only forwarding (ex. ld)
		-- "10": rs-rt forwarding (ex. add)
		-- "11": reserved
		id_fw_type: in std_logic_vector(1 downto 0);
		mul_id: in std_logic; -- 1 if a mul is detected in the ID stage, 0 otherwise

		rd_idexe_valid: in std_logic; -- the value in the id/ex regs corresponds to the rd stored in it
		rd_exemem_valid: in std_logic; -- the value in the ex/mem regs corresponds to the rd stored in it
		rd_memwb_valid: in std_logic; -- the value in the mem/wb regs corresponds to the rd stored in it

		curr_id: in std_logic_vector(62 downto 0);
		curr_exe: in std_logic_vector(41 downto 0);
		curr_mem: in std_logic_vector(14 downto 0);
		curr_wb: in std_logic_vector(3 downto 0);

		next_exe: out std_logic_vector(41 downto 0);
		next_mem: out std_logic_vector(14 downto 0);
		next_wb: out std_logic_vector(3 downto 0);
		fw_a: out std_logic_vector(1 downto 0);
		fw_b: out std_logic_vector(1 downto 0);
		op_b_fw_sel: out std_logic_vector(1 downto 0);
		en_npc_if: out std_logic;
		en_ir_if: out std_logic;
		pc_en_if: out std_logic;
		id_en: out std_logic;
		en_mul_id: out std_logic;
		exe_en: out std_logic;
		mem_en: out std_logic;
		wb_en: out std_logic;
		if_stall: out std_logic;
		id_stall: out std_logic;
		exe_stall: out std_logic;
		mem_stall: out std_logic;
		cache_miss_mem_wb_rst: out std_logic;
		mul_exe_mem_rst: out std_logic;
		flush_mul: out std_logic -- signal used to flush id/exe if there is a multiplication 
	);
end stall_unit;

architecture behavioral of stall_unit is
	signal hazards: std_logic_vector(9 downto 0);
begin
	hazard_check: process(rd_idexe, rd_exemem, rd_memwb, rs_id, rt_id, rs_exe, rt_exe, cpu_is_reading, rd_idexe_valid, rd_exemem_valid, rd_memwb_valid)
	begin
		hazards <= (others => '0');

		if (rs_exe = rd_exemem and rd_exemem_valid = '1') then
			hazards(0) <= '1';
		end if;

		if (rt_exe = rd_exemem and rd_exemem_valid = '1') then
			hazards(1) <= '1';
		end if;

		if (rs_exe = rd_memwb and rd_memwb_valid = '1') then
			hazards(2) <= '1';
		end if;

		if (rt_exe = rd_memwb and rd_memwb_valid = '1') then
			hazards(3) <= '1';
		end if;

		if (rs_id = rd_idexe and rd_idexe_valid = '1') then
			hazards(4) <= '1';
		end if;

		if (rt_id = rd_idexe and rd_idexe_valid = '1') then
			hazards(5) <= '1';
		end if;

		if (rs_id = rd_exemem and rd_exemem_valid = '1') then
			hazards(6) <= '1';
		end if;

		if (rt_id = rd_exemem and rd_exemem_valid = '1') then
			hazards(7) <= '1';
		end if;

		if (rs_id = rd_memwb and rd_memwb_valid = '1') then
			hazards(8) <= '1';
		end if;

		if (rt_id = rd_memwb and rd_memwb_valid = '1') then
			hazards(9) <= '1';
		end if;

	end process hazard_check;

	comblogic: process(curr_id, curr_exe, curr_mem, curr_mul_in_prog, next_mul_in_prog, mul_push, mul_id, cache_miss, cpu_is_reading, id_fw_type, hazards)
	begin
		mul_exe_mem_rst <= '1';
		cache_miss_mem_wb_rst <= '1';
		en_npc_if <= '1';
		en_ir_if <= '1';
		pc_en_if <= '1';
		id_en <= '1';
		en_mul_id <= '1';
		exe_en <= '1';
		mem_en <= '1';
		wb_en <= '1';
		if_stall <= '0';
		id_stall <= '0';
		exe_stall <= '0';
		mem_stall <= '0';
		flush_mul <= '1';
		fw_a <= "00";
		fw_b <= "00";
		op_b_fw_sel <= "00";

		next_exe <= curr_id(41 downto 0);
		next_mem <= curr_exe(14 downto 0); -- propagate the control signals to the MEM stage
		next_wb <= curr_mem(3)&curr_mem(2 downto 0); -- concatenate rd valid bit with control word

		if (cache_miss = '1') then
			en_npc_if <= '0';
			en_ir_if <= '0';
			pc_en_if <= '0';
			id_en <= '0';
			en_mul_id <= '0';
			exe_en <= '0';
			if_stall <= '1';
			id_stall <= '1';
			exe_stall <= '1';
			mem_stall <= '1';
			next_exe <= curr_exe;
			next_mem <= curr_mem;
			next_wb <= curr_wb; -- keep the old value in wb
			--cache_miss_mem_wb_rst <= '0'; 

		elsif (curr_mul_in_prog = '1' or next_mul_in_prog = '1') then
			en_npc_if <= '0';
			en_ir_if <= '0';
			pc_en_if <= '0';
			id_en <= '0';
			if_stall <= '1';
			id_stall <= '1';
			if (mul_push = '0')  then
				next_exe <= curr_exe;
				next_mem <= nop_fw(14 downto 0); -- force nop operation
				mul_exe_mem_rst <= '0';
			else
				--next_exe <= curr_exe;
				next_exe <= nop_fw(41 downto 0); -- force nop operation
				flush_mul <= '0';
			end if;
		elsif (mul_id = '1') then
			if (or_reduce(hazards(9 downto 4)) = '1') then
				en_npc_if <= '0';
				en_ir_if <= '0';
				pc_en_if <= '0';
				id_en <= '0';
				en_mul_id <= '0';
				if_stall <= '1';
				id_stall <= '1';
				next_exe <= nop_fw(41 downto 0); -- force nop operation
				flush_mul <= '0';
			end if;
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
							en_mul_id <= '0';
							exe_en <= '0';
							if_stall <= '1';
							id_stall <= '1';
							exe_stall <= '1';
							next_exe <= curr_exe;
							next_mem <= nop_fw(14 downto 0); -- force nop operation
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
							en_mul_id <= '0';
							exe_en <= '0';
							if_stall <= '1';
							id_stall <= '1';
							exe_stall <= '1';
							next_exe <= curr_exe;
							next_mem <= nop_fw(14 downto 0); -- force nop operation
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
							en_mul_id <= '0';
							exe_en <= '0';
							if_stall <= '1';
							id_stall <= '1';
							exe_stall <= '1';
							next_exe <= curr_exe;
							next_mem <= nop_fw(14 downto 0); -- force nop operation
						else
							-- rs can be forwarded
							fw_b <= "01";
						end if;
					elsif (hazards(3) = '1') then
						-- hazard between id/exe and mem/wb
						fw_b <= "10";
					end if;

				when "11"  => 
					if (hazards(0) = '1') then
						-- hazard between id/exe and exe/mem
						if (cpu_is_reading = '1') then
							-- the result should come from a load which hasn't finished yet
							en_npc_if <= '0';
							en_ir_if <= '0';
							pc_en_if <= '0';
							id_en <= '0';
							en_mul_id <= '0';
							exe_en <= '0';
							if_stall <= '1';
							id_stall <= '1';
							exe_stall <= '1';
							next_exe <= curr_exe;
							next_mem <= nop_fw(14 downto 0); -- force nop operation
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
							en_mul_id <= '0';
							exe_en <= '0';
							if_stall <= '1';
							id_stall <= '1';
							exe_stall <= '1';
							next_exe <= curr_exe;
							next_mem <= nop_fw(14 downto 0); -- force nop operation
						else
							-- rt can be forwarded
							op_b_fw_sel <= "01";
						end if;
					elsif (hazards(3) = '1') then
						-- hazard between id/exe and mem/wb
						op_b_fw_sel <= "10";
					end if; 

				when others =>
					null;
			end case;
		end if;
	end process comblogic;
end behavioral;
