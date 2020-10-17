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
extern void execute_3533(char*, char *);
extern void execute_3534(char*, char *);
extern void execute_43(char*, char *);
extern void execute_44(char*, char *);
extern void execute_45(char*, char *);
extern void execute_46(char*, char *);
extern void execute_47(char*, char *);
extern void execute_48(char*, char *);
extern void execute_49(char*, char *);
extern void execute_50(char*, char *);
extern void execute_51(char*, char *);
extern void execute_2270(char*, char *);
extern void execute_2271(char*, char *);
extern void execute_53(char*, char *);
extern void execute_54(char*, char *);
extern void execute_55(char*, char *);
extern void execute_56(char*, char *);
extern void execute_57(char*, char *);
extern void execute_58(char*, char *);
extern void execute_59(char*, char *);
extern void execute_2245(char*, char *);
extern void execute_2246(char*, char *);
extern void execute_2265(char*, char *);
extern void execute_2266(char*, char *);
extern void execute_209(char*, char *);
extern void execute_210(char*, char *);
extern void execute_211(char*, char *);
extern void execute_2222(char*, char *);
extern void execute_2228(char*, char *);
extern void execute_2229(char*, char *);
extern void execute_2239(char*, char *);
extern void execute_2243(char*, char *);
extern void execute_2244(char*, char *);
extern void execute_62(char*, char *);
extern void execute_75(char*, char *);
extern void execute_64(char*, char *);
extern void execute_66(char*, char *);
extern void execute_68(char*, char *);
extern void execute_70(char*, char *);
extern void execute_71(char*, char *);
extern void execute_72(char*, char *);
extern void execute_77(char*, char *);
extern void execute_81(char*, char *);
extern void execute_83(char*, char *);
extern void execute_85(char*, char *);
extern void execute_86(char*, char *);
extern void execute_89(char*, char *);
extern void execute_90(char*, char *);
extern void execute_202(char*, char *);
extern void execute_88(char*, char *);
extern void execute_92(char*, char *);
extern void execute_93(char*, char *);
extern void execute_192(char*, char *);
extern void execute_96(char*, char *);
extern void execute_194(char*, char *);
extern void execute_195(char*, char *);
extern void execute_196(char*, char *);
extern void execute_197(char*, char *);
extern void execute_198(char*, char *);
extern void execute_199(char*, char *);
extern void execute_200(char*, char *);
extern void execute_201(char*, char *);
extern void execute_204(char*, char *);
extern void execute_229(char*, char *);
extern void execute_230(char*, char *);
extern void execute_235(char*, char *);
extern void execute_242(char*, char *);
extern void execute_220(char*, char *);
extern void execute_232(char*, char *);
extern void execute_237(char*, char *);
extern void execute_239(char*, char *);
extern void execute_240(char*, char *);
extern void execute_241(char*, char *);
extern void execute_385(char*, char *);
extern void execute_2201(char*, char *);
extern void execute_2202(char*, char *);
extern void execute_2203(char*, char *);
extern void execute_2204(char*, char *);
extern void execute_2205(char*, char *);
extern void execute_2206(char*, char *);
extern void execute_2209(char*, char *);
extern void execute_249(char*, char *);
extern void execute_250(char*, char *);
extern void execute_251(char*, char *);
extern void execute_254(char*, char *);
extern void execute_255(char*, char *);
extern void execute_384(char*, char *);
extern void execute_387(char*, char *);
extern void execute_2198(char*, char *);
extern void execute_2199(char*, char *);
extern void execute_2200(char*, char *);
extern void execute_1131(char*, char *);
extern void execute_1132(char*, char *);
extern void execute_1133(char*, char *);
extern void execute_399(char*, char *);
extern void execute_401(char*, char *);
extern void execute_403(char*, char *);
extern void execute_405(char*, char *);
extern void execute_407(char*, char *);
extern void execute_409(char*, char *);
extern void execute_411(char*, char *);
extern void execute_413(char*, char *);
extern void execute_415(char*, char *);
extern void execute_417(char*, char *);
extern void execute_419(char*, char *);
extern void execute_421(char*, char *);
extern void execute_423(char*, char *);
extern void execute_425(char*, char *);
extern void execute_427(char*, char *);
extern void execute_429(char*, char *);
extern void execute_431(char*, char *);
extern void execute_433(char*, char *);
extern void execute_435(char*, char *);
extern void execute_437(char*, char *);
extern void execute_439(char*, char *);
extern void execute_441(char*, char *);
extern void execute_443(char*, char *);
extern void execute_445(char*, char *);
extern void execute_447(char*, char *);
extern void execute_449(char*, char *);
extern void execute_451(char*, char *);
extern void execute_453(char*, char *);
extern void execute_455(char*, char *);
extern void execute_457(char*, char *);
extern void execute_459(char*, char *);
extern void execute_461(char*, char *);
extern void execute_599(char*, char *);
extern void execute_1130(char*, char *);
extern void execute_723(char*, char *);
extern void execute_887(char*, char *);
extern void execute_891(char*, char *);
extern void execute_1065(char*, char *);
extern void execute_1069(char*, char *);
extern void execute_1073(char*, char *);
extern void execute_1077(char*, char *);
extern void execute_602(char*, char *);
extern void execute_603(char*, char *);
extern void execute_596(char*, char *);
extern void execute_468(char*, char *);
extern void execute_471(char*, char *);
extern void execute_472(char*, char *);
extern void execute_1138(char*, char *);
extern void execute_1139(char*, char *);
extern void execute_1140(char*, char *);
extern void execute_1180(char*, char *);
extern void execute_1505(char*, char *);
extern void execute_1506(char*, char *);
extern void execute_1518(char*, char *);
extern void execute_1527(char*, char *);
extern void execute_1528(char*, char *);
extern void execute_1508(char*, char *);
extern void execute_1510(char*, char *);
extern void execute_1516(char*, char *);
extern void execute_1517(char*, char *);
extern void execute_1520(char*, char *);
extern void execute_1522(char*, char *);
extern void execute_1526(char*, char *);
extern void execute_1532(char*, char *);
extern void execute_1533(char*, char *);
extern void execute_1534(char*, char *);
extern void execute_1794(char*, char *);
extern void execute_1795(char*, char *);
extern void execute_1797(char*, char *);
extern void execute_1798(char*, char *);
extern void execute_1801(char*, char *);
extern void execute_2090(char*, char *);
extern void execute_2186(char*, char *);
extern void execute_2188(char*, char *);
extern void execute_2189(char*, char *);
extern void execute_2190(char*, char *);
extern void execute_2191(char*, char *);
extern void execute_2192(char*, char *);
extern void execute_2193(char*, char *);
extern void execute_2194(char*, char *);
extern void execute_2195(char*, char *);
extern void execute_2196(char*, char *);
extern void execute_2197(char*, char *);
extern void execute_2208(char*, char *);
extern void execute_2211(char*, char *);
extern void execute_2220(char*, char *);
extern void execute_2221(char*, char *);
extern void execute_2225(char*, char *);
extern void execute_2251(char*, char *);
extern void execute_2252(char*, char *);
extern void execute_2253(char*, char *);
extern void execute_2254(char*, char *);
extern void execute_2255(char*, char *);
extern void execute_2256(char*, char *);
extern void execute_2260(char*, char *);
extern void execute_2261(char*, char *);
extern void execute_2262(char*, char *);
extern void execute_2263(char*, char *);
extern void execute_2264(char*, char *);
extern void execute_2258(char*, char *);
extern void execute_2259(char*, char *);
extern void execute_2268(char*, char *);
extern void execute_2269(char*, char *);
extern void execute_2274(char*, char *);
extern void execute_2275(char*, char *);
extern void execute_2899(char*, char *);
extern void execute_2900(char*, char *);
extern void execute_2284(char*, char *);
extern void execute_2285(char*, char *);
extern void execute_2286(char*, char *);
extern void execute_2287(char*, char *);
extern void execute_2288(char*, char *);
extern void execute_2290(char*, char *);
extern void execute_2291(char*, char *);
extern void execute_2293(char*, char *);
extern void execute_2278(char*, char *);
extern void execute_2279(char*, char *);
extern void execute_2280(char*, char *);
extern void execute_2281(char*, char *);
extern void execute_2892(char*, char *);
extern void execute_2896(char*, char *);
extern void execute_3515(char*, char *);
extern void execute_3526(char*, char *);
extern void execute_3527(char*, char *);
extern void execute_3528(char*, char *);
extern void execute_3529(char*, char *);
extern void execute_3049(char*, char *);
extern void execute_2906(char*, char *);
extern void execute_2907(char*, char *);
extern void execute_2908(char*, char *);
extern void execute_2909(char*, char *);
extern void execute_2910(char*, char *);
extern void execute_2911(char*, char *);
extern void execute_2912(char*, char *);
extern void execute_3051(char*, char *);
extern void execute_3052(char*, char *);
extern void execute_3517(char*, char *);
extern void execute_3518(char*, char *);
extern void execute_3522(char*, char *);
extern void execute_3523(char*, char *);
extern void execute_3525(char*, char *);
extern void execute_3531(char*, char *);
extern void execute_3532(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_184(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[240] = {(funcp)execute_3533, (funcp)execute_3534, (funcp)execute_43, (funcp)execute_44, (funcp)execute_45, (funcp)execute_46, (funcp)execute_47, (funcp)execute_48, (funcp)execute_49, (funcp)execute_50, (funcp)execute_51, (funcp)execute_2270, (funcp)execute_2271, (funcp)execute_53, (funcp)execute_54, (funcp)execute_55, (funcp)execute_56, (funcp)execute_57, (funcp)execute_58, (funcp)execute_59, (funcp)execute_2245, (funcp)execute_2246, (funcp)execute_2265, (funcp)execute_2266, (funcp)execute_209, (funcp)execute_210, (funcp)execute_211, (funcp)execute_2222, (funcp)execute_2228, (funcp)execute_2229, (funcp)execute_2239, (funcp)execute_2243, (funcp)execute_2244, (funcp)execute_62, (funcp)execute_75, (funcp)execute_64, (funcp)execute_66, (funcp)execute_68, (funcp)execute_70, (funcp)execute_71, (funcp)execute_72, (funcp)execute_77, (funcp)execute_81, (funcp)execute_83, (funcp)execute_85, (funcp)execute_86, (funcp)execute_89, (funcp)execute_90, (funcp)execute_202, (funcp)execute_88, (funcp)execute_92, (funcp)execute_93, (funcp)execute_192, (funcp)execute_96, (funcp)execute_194, (funcp)execute_195, (funcp)execute_196, (funcp)execute_197, (funcp)execute_198, (funcp)execute_199, (funcp)execute_200, (funcp)execute_201, (funcp)execute_204, (funcp)execute_229, (funcp)execute_230, (funcp)execute_235, (funcp)execute_242, (funcp)execute_220, (funcp)execute_232, (funcp)execute_237, (funcp)execute_239, (funcp)execute_240, (funcp)execute_241, (funcp)execute_385, (funcp)execute_2201, (funcp)execute_2202, (funcp)execute_2203, (funcp)execute_2204, (funcp)execute_2205, (funcp)execute_2206, (funcp)execute_2209, (funcp)execute_249, (funcp)execute_250, (funcp)execute_251, (funcp)execute_254, (funcp)execute_255, (funcp)execute_384, (funcp)execute_387, (funcp)execute_2198, (funcp)execute_2199, (funcp)execute_2200, (funcp)execute_1131, (funcp)execute_1132, (funcp)execute_1133, (funcp)execute_399, (funcp)execute_401, (funcp)execute_403, (funcp)execute_405, (funcp)execute_407, (funcp)execute_409, (funcp)execute_411, (funcp)execute_413, (funcp)execute_415, (funcp)execute_417, (funcp)execute_419, (funcp)execute_421, (funcp)execute_423, (funcp)execute_425, (funcp)execute_427, (funcp)execute_429, (funcp)execute_431, (funcp)execute_433, (funcp)execute_435, (funcp)execute_437, (funcp)execute_439, (funcp)execute_441, (funcp)execute_443, (funcp)execute_445, (funcp)execute_447, (funcp)execute_449, (funcp)execute_451, (funcp)execute_453, (funcp)execute_455, (funcp)execute_457, (funcp)execute_459, (funcp)execute_461, (funcp)execute_599, (funcp)execute_1130, (funcp)execute_723, (funcp)execute_887, (funcp)execute_891, (funcp)execute_1065, (funcp)execute_1069, (funcp)execute_1073, (funcp)execute_1077, (funcp)execute_602, (funcp)execute_603, (funcp)execute_596, (funcp)execute_468, (funcp)execute_471, (funcp)execute_472, (funcp)execute_1138, (funcp)execute_1139, (funcp)execute_1140, (funcp)execute_1180, (funcp)execute_1505, (funcp)execute_1506, (funcp)execute_1518, (funcp)execute_1527, (funcp)execute_1528, (funcp)execute_1508, (funcp)execute_1510, (funcp)execute_1516, (funcp)execute_1517, (funcp)execute_1520, (funcp)execute_1522, (funcp)execute_1526, (funcp)execute_1532, (funcp)execute_1533, (funcp)execute_1534, (funcp)execute_1794, (funcp)execute_1795, (funcp)execute_1797, (funcp)execute_1798, (funcp)execute_1801, (funcp)execute_2090, (funcp)execute_2186, (funcp)execute_2188, (funcp)execute_2189, (funcp)execute_2190, (funcp)execute_2191, (funcp)execute_2192, (funcp)execute_2193, (funcp)execute_2194, (funcp)execute_2195, (funcp)execute_2196, (funcp)execute_2197, (funcp)execute_2208, (funcp)execute_2211, (funcp)execute_2220, (funcp)execute_2221, (funcp)execute_2225, (funcp)execute_2251, (funcp)execute_2252, (funcp)execute_2253, (funcp)execute_2254, (funcp)execute_2255, (funcp)execute_2256, (funcp)execute_2260, (funcp)execute_2261, (funcp)execute_2262, (funcp)execute_2263, (funcp)execute_2264, (funcp)execute_2258, (funcp)execute_2259, (funcp)execute_2268, (funcp)execute_2269, (funcp)execute_2274, (funcp)execute_2275, (funcp)execute_2899, (funcp)execute_2900, (funcp)execute_2284, (funcp)execute_2285, (funcp)execute_2286, (funcp)execute_2287, (funcp)execute_2288, (funcp)execute_2290, (funcp)execute_2291, (funcp)execute_2293, (funcp)execute_2278, (funcp)execute_2279, (funcp)execute_2280, (funcp)execute_2281, (funcp)execute_2892, (funcp)execute_2896, (funcp)execute_3515, (funcp)execute_3526, (funcp)execute_3527, (funcp)execute_3528, (funcp)execute_3529, (funcp)execute_3049, (funcp)execute_2906, (funcp)execute_2907, (funcp)execute_2908, (funcp)execute_2909, (funcp)execute_2910, (funcp)execute_2911, (funcp)execute_2912, (funcp)execute_3051, (funcp)execute_3052, (funcp)execute_3517, (funcp)execute_3518, (funcp)execute_3522, (funcp)execute_3523, (funcp)execute_3525, (funcp)execute_3531, (funcp)execute_3532, (funcp)transaction_0, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_184};
const int NumRelocateId= 240;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/tb_branches_behav/xsim.reloc",  (void **)funcTab, 240);
	iki_vhdl_file_variable_register(dp + 398496);
	iki_vhdl_file_variable_register(dp + 398552);
	iki_vhdl_file_variable_register(dp + 808952);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/tb_branches_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/tb_branches_behav/xsim.reloc");

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
    iki_set_sv_type_file_path_name("xsim.dir/tb_branches_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/tb_branches_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/tb_branches_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
