/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_3530(char*, char *);
extern void execute_3531(char*, char *);
extern void execute_46(char*, char *);
extern void execute_47(char*, char *);
extern void execute_48(char*, char *);
extern void execute_49(char*, char *);
extern void execute_50(char*, char *);
extern void execute_51(char*, char *);
extern void execute_52(char*, char *);
extern void execute_53(char*, char *);
extern void execute_54(char*, char *);
extern void execute_2267(char*, char *);
extern void execute_2268(char*, char *);
extern void execute_56(char*, char *);
extern void execute_57(char*, char *);
extern void execute_58(char*, char *);
extern void execute_59(char*, char *);
extern void execute_60(char*, char *);
extern void execute_61(char*, char *);
extern void execute_62(char*, char *);
extern void execute_2246(char*, char *);
extern void execute_2247(char*, char *);
extern void execute_2263(char*, char *);
extern void execute_212(char*, char *);
extern void execute_213(char*, char *);
extern void execute_214(char*, char *);
extern void execute_2223(char*, char *);
extern void execute_2229(char*, char *);
extern void execute_2230(char*, char *);
extern void execute_2240(char*, char *);
extern void execute_2244(char*, char *);
extern void execute_2245(char*, char *);
extern void execute_65(char*, char *);
extern void execute_78(char*, char *);
extern void execute_67(char*, char *);
extern void execute_69(char*, char *);
extern void execute_71(char*, char *);
extern void execute_73(char*, char *);
extern void execute_74(char*, char *);
extern void execute_75(char*, char *);
extern void execute_80(char*, char *);
extern void execute_84(char*, char *);
extern void execute_86(char*, char *);
extern void execute_88(char*, char *);
extern void execute_89(char*, char *);
extern void execute_92(char*, char *);
extern void execute_93(char*, char *);
extern void execute_205(char*, char *);
extern void execute_91(char*, char *);
extern void execute_95(char*, char *);
extern void execute_96(char*, char *);
extern void execute_195(char*, char *);
extern void execute_99(char*, char *);
extern void execute_197(char*, char *);
extern void execute_198(char*, char *);
extern void execute_199(char*, char *);
extern void execute_200(char*, char *);
extern void execute_201(char*, char *);
extern void execute_202(char*, char *);
extern void execute_203(char*, char *);
extern void execute_204(char*, char *);
extern void execute_207(char*, char *);
extern void execute_232(char*, char *);
extern void execute_233(char*, char *);
extern void execute_238(char*, char *);
extern void execute_245(char*, char *);
extern void execute_223(char*, char *);
extern void execute_235(char*, char *);
extern void execute_240(char*, char *);
extern void execute_242(char*, char *);
extern void execute_243(char*, char *);
extern void execute_244(char*, char *);
extern void execute_388(char*, char *);
extern void execute_2202(char*, char *);
extern void execute_2203(char*, char *);
extern void execute_2204(char*, char *);
extern void execute_2205(char*, char *);
extern void execute_2206(char*, char *);
extern void execute_2207(char*, char *);
extern void execute_2210(char*, char *);
extern void execute_252(char*, char *);
extern void execute_253(char*, char *);
extern void execute_254(char*, char *);
extern void execute_257(char*, char *);
extern void execute_258(char*, char *);
extern void execute_387(char*, char *);
extern void execute_390(char*, char *);
extern void execute_2199(char*, char *);
extern void execute_2200(char*, char *);
extern void execute_2201(char*, char *);
extern void execute_1132(char*, char *);
extern void execute_1133(char*, char *);
extern void execute_1134(char*, char *);
extern void execute_400(char*, char *);
extern void execute_402(char*, char *);
extern void execute_404(char*, char *);
extern void execute_406(char*, char *);
extern void execute_408(char*, char *);
extern void execute_410(char*, char *);
extern void execute_412(char*, char *);
extern void execute_414(char*, char *);
extern void execute_416(char*, char *);
extern void execute_418(char*, char *);
extern void execute_420(char*, char *);
extern void execute_422(char*, char *);
extern void execute_424(char*, char *);
extern void execute_426(char*, char *);
extern void execute_428(char*, char *);
extern void execute_430(char*, char *);
extern void execute_432(char*, char *);
extern void execute_434(char*, char *);
extern void execute_436(char*, char *);
extern void execute_438(char*, char *);
extern void execute_440(char*, char *);
extern void execute_442(char*, char *);
extern void execute_444(char*, char *);
extern void execute_446(char*, char *);
extern void execute_448(char*, char *);
extern void execute_450(char*, char *);
extern void execute_452(char*, char *);
extern void execute_454(char*, char *);
extern void execute_456(char*, char *);
extern void execute_458(char*, char *);
extern void execute_460(char*, char *);
extern void execute_462(char*, char *);
extern void execute_600(char*, char *);
extern void execute_1131(char*, char *);
extern void execute_724(char*, char *);
extern void execute_888(char*, char *);
extern void execute_892(char*, char *);
extern void execute_1066(char*, char *);
extern void execute_1070(char*, char *);
extern void execute_1074(char*, char *);
extern void execute_1078(char*, char *);
extern void execute_603(char*, char *);
extern void execute_604(char*, char *);
extern void execute_597(char*, char *);
extern void execute_469(char*, char *);
extern void execute_472(char*, char *);
extern void execute_473(char*, char *);
extern void execute_1139(char*, char *);
extern void execute_1140(char*, char *);
extern void execute_1141(char*, char *);
extern void execute_1181(char*, char *);
extern void execute_1506(char*, char *);
extern void execute_1507(char*, char *);
extern void execute_1519(char*, char *);
extern void execute_1528(char*, char *);
extern void execute_1529(char*, char *);
extern void execute_1509(char*, char *);
extern void execute_1511(char*, char *);
extern void execute_1517(char*, char *);
extern void execute_1518(char*, char *);
extern void execute_1521(char*, char *);
extern void execute_1523(char*, char *);
extern void execute_1527(char*, char *);
extern void execute_1533(char*, char *);
extern void execute_1534(char*, char *);
extern void execute_1535(char*, char *);
extern void execute_1795(char*, char *);
extern void execute_1796(char*, char *);
extern void execute_1798(char*, char *);
extern void execute_1799(char*, char *);
extern void execute_1802(char*, char *);
extern void execute_2091(char*, char *);
extern void execute_2187(char*, char *);
extern void execute_2189(char*, char *);
extern void execute_2190(char*, char *);
extern void execute_2191(char*, char *);
extern void execute_2192(char*, char *);
extern void execute_2193(char*, char *);
extern void execute_2194(char*, char *);
extern void execute_2195(char*, char *);
extern void execute_2196(char*, char *);
extern void execute_2197(char*, char *);
extern void execute_2198(char*, char *);
extern void execute_2209(char*, char *);
extern void execute_2212(char*, char *);
extern void execute_2221(char*, char *);
extern void execute_2222(char*, char *);
extern void execute_2226(char*, char *);
extern void execute_2252(char*, char *);
extern void execute_2253(char*, char *);
extern void execute_2254(char*, char *);
extern void execute_2258(char*, char *);
extern void execute_2259(char*, char *);
extern void execute_2260(char*, char *);
extern void execute_2261(char*, char *);
extern void execute_2262(char*, char *);
extern void execute_2256(char*, char *);
extern void execute_2257(char*, char *);
extern void execute_2265(char*, char *);
extern void execute_2266(char*, char *);
extern void execute_2271(char*, char *);
extern void execute_2272(char*, char *);
extern void execute_2896(char*, char *);
extern void execute_2897(char*, char *);
extern void execute_2281(char*, char *);
extern void execute_2282(char*, char *);
extern void execute_2283(char*, char *);
extern void execute_2284(char*, char *);
extern void execute_2285(char*, char *);
extern void execute_2287(char*, char *);
extern void execute_2288(char*, char *);
extern void execute_2290(char*, char *);
extern void execute_2275(char*, char *);
extern void execute_2276(char*, char *);
extern void execute_2277(char*, char *);
extern void execute_2278(char*, char *);
extern void execute_2889(char*, char *);
extern void execute_2893(char*, char *);
extern void execute_3512(char*, char *);
extern void execute_3523(char*, char *);
extern void execute_3524(char*, char *);
extern void execute_3525(char*, char *);
extern void execute_3526(char*, char *);
extern void execute_3046(char*, char *);
extern void execute_2903(char*, char *);
extern void execute_2904(char*, char *);
extern void execute_2905(char*, char *);
extern void execute_2906(char*, char *);
extern void execute_2907(char*, char *);
extern void execute_2908(char*, char *);
extern void execute_2909(char*, char *);
extern void execute_3048(char*, char *);
extern void execute_3049(char*, char *);
extern void execute_3514(char*, char *);
extern void execute_3515(char*, char *);
extern void execute_3519(char*, char *);
extern void execute_3520(char*, char *);
extern void execute_3522(char*, char *);
extern void execute_3528(char*, char *);
extern void execute_3529(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_179(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[236] = {(funcp)execute_3530, (funcp)execute_3531, (funcp)execute_46, (funcp)execute_47, (funcp)execute_48, (funcp)execute_49, (funcp)execute_50, (funcp)execute_51, (funcp)execute_52, (funcp)execute_53, (funcp)execute_54, (funcp)execute_2267, (funcp)execute_2268, (funcp)execute_56, (funcp)execute_57, (funcp)execute_58, (funcp)execute_59, (funcp)execute_60, (funcp)execute_61, (funcp)execute_62, (funcp)execute_2246, (funcp)execute_2247, (funcp)execute_2263, (funcp)execute_212, (funcp)execute_213, (funcp)execute_214, (funcp)execute_2223, (funcp)execute_2229, (funcp)execute_2230, (funcp)execute_2240, (funcp)execute_2244, (funcp)execute_2245, (funcp)execute_65, (funcp)execute_78, (funcp)execute_67, (funcp)execute_69, (funcp)execute_71, (funcp)execute_73, (funcp)execute_74, (funcp)execute_75, (funcp)execute_80, (funcp)execute_84, (funcp)execute_86, (funcp)execute_88, (funcp)execute_89, (funcp)execute_92, (funcp)execute_93, (funcp)execute_205, (funcp)execute_91, (funcp)execute_95, (funcp)execute_96, (funcp)execute_195, (funcp)execute_99, (funcp)execute_197, (funcp)execute_198, (funcp)execute_199, (funcp)execute_200, (funcp)execute_201, (funcp)execute_202, (funcp)execute_203, (funcp)execute_204, (funcp)execute_207, (funcp)execute_232, (funcp)execute_233, (funcp)execute_238, (funcp)execute_245, (funcp)execute_223, (funcp)execute_235, (funcp)execute_240, (funcp)execute_242, (funcp)execute_243, (funcp)execute_244, (funcp)execute_388, (funcp)execute_2202, (funcp)execute_2203, (funcp)execute_2204, (funcp)execute_2205, (funcp)execute_2206, (funcp)execute_2207, (funcp)execute_2210, (funcp)execute_252, (funcp)execute_253, (funcp)execute_254, (funcp)execute_257, (funcp)execute_258, (funcp)execute_387, (funcp)execute_390, (funcp)execute_2199, (funcp)execute_2200, (funcp)execute_2201, (funcp)execute_1132, (funcp)execute_1133, (funcp)execute_1134, (funcp)execute_400, (funcp)execute_402, (funcp)execute_404, (funcp)execute_406, (funcp)execute_408, (funcp)execute_410, (funcp)execute_412, (funcp)execute_414, (funcp)execute_416, (funcp)execute_418, (funcp)execute_420, (funcp)execute_422, (funcp)execute_424, (funcp)execute_426, (funcp)execute_428, (funcp)execute_430, (funcp)execute_432, (funcp)execute_434, (funcp)execute_436, (funcp)execute_438, (funcp)execute_440, (funcp)execute_442, (funcp)execute_444, (funcp)execute_446, (funcp)execute_448, (funcp)execute_450, (funcp)execute_452, (funcp)execute_454, (funcp)execute_456, (funcp)execute_458, (funcp)execute_460, (funcp)execute_462, (funcp)execute_600, (funcp)execute_1131, (funcp)execute_724, (funcp)execute_888, (funcp)execute_892, (funcp)execute_1066, (funcp)execute_1070, (funcp)execute_1074, (funcp)execute_1078, (funcp)execute_603, (funcp)execute_604, (funcp)execute_597, (funcp)execute_469, (funcp)execute_472, (funcp)execute_473, (funcp)execute_1139, (funcp)execute_1140, (funcp)execute_1141, (funcp)execute_1181, (funcp)execute_1506, (funcp)execute_1507, (funcp)execute_1519, (funcp)execute_1528, (funcp)execute_1529, (funcp)execute_1509, (funcp)execute_1511, (funcp)execute_1517, (funcp)execute_1518, (funcp)execute_1521, (funcp)execute_1523, (funcp)execute_1527, (funcp)execute_1533, (funcp)execute_1534, (funcp)execute_1535, (funcp)execute_1795, (funcp)execute_1796, (funcp)execute_1798, (funcp)execute_1799, (funcp)execute_1802, (funcp)execute_2091, (funcp)execute_2187, (funcp)execute_2189, (funcp)execute_2190, (funcp)execute_2191, (funcp)execute_2192, (funcp)execute_2193, (funcp)execute_2194, (funcp)execute_2195, (funcp)execute_2196, (funcp)execute_2197, (funcp)execute_2198, (funcp)execute_2209, (funcp)execute_2212, (funcp)execute_2221, (funcp)execute_2222, (funcp)execute_2226, (funcp)execute_2252, (funcp)execute_2253, (funcp)execute_2254, (funcp)execute_2258, (funcp)execute_2259, (funcp)execute_2260, (funcp)execute_2261, (funcp)execute_2262, (funcp)execute_2256, (funcp)execute_2257, (funcp)execute_2265, (funcp)execute_2266, (funcp)execute_2271, (funcp)execute_2272, (funcp)execute_2896, (funcp)execute_2897, (funcp)execute_2281, (funcp)execute_2282, (funcp)execute_2283, (funcp)execute_2284, (funcp)execute_2285, (funcp)execute_2287, (funcp)execute_2288, (funcp)execute_2290, (funcp)execute_2275, (funcp)execute_2276, (funcp)execute_2277, (funcp)execute_2278, (funcp)execute_2889, (funcp)execute_2893, (funcp)execute_3512, (funcp)execute_3523, (funcp)execute_3524, (funcp)execute_3525, (funcp)execute_3526, (funcp)execute_3046, (funcp)execute_2903, (funcp)execute_2904, (funcp)execute_2905, (funcp)execute_2906, (funcp)execute_2907, (funcp)execute_2908, (funcp)execute_2909, (funcp)execute_3048, (funcp)execute_3049, (funcp)execute_3514, (funcp)execute_3515, (funcp)execute_3519, (funcp)execute_3520, (funcp)execute_3522, (funcp)execute_3528, (funcp)execute_3529, (funcp)transaction_0, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_179};
const int NumRelocateId= 236;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/tb_arith_behav/xsim.reloc",  (void **)funcTab, 236);
	iki_vhdl_file_variable_register(dp + 396936);
	iki_vhdl_file_variable_register(dp + 396992);
	iki_vhdl_file_variable_register(dp + 805056);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/tb_arith_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/tb_arith_behav/xsim.reloc");

	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstantiate();

extern void implicit_HDL_SCcleanup();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/tb_arith_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/tb_arith_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/tb_arith_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
