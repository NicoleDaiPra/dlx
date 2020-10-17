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
extern void execute_3545(char*, char *);
extern void execute_3546(char*, char *);
extern void execute_53(char*, char *);
extern void execute_54(char*, char *);
extern void execute_55(char*, char *);
extern void execute_56(char*, char *);
extern void execute_57(char*, char *);
extern void execute_58(char*, char *);
extern void execute_59(char*, char *);
extern void execute_60(char*, char *);
extern void execute_61(char*, char *);
extern void execute_2282(char*, char *);
extern void execute_2283(char*, char *);
extern void execute_63(char*, char *);
extern void execute_64(char*, char *);
extern void execute_65(char*, char *);
extern void execute_66(char*, char *);
extern void execute_67(char*, char *);
extern void execute_68(char*, char *);
extern void execute_69(char*, char *);
extern void execute_2256(char*, char *);
extern void execute_2257(char*, char *);
extern void execute_2277(char*, char *);
extern void execute_2278(char*, char *);
extern void execute_219(char*, char *);
extern void execute_220(char*, char *);
extern void execute_256(char*, char *);
extern void execute_2233(char*, char *);
extern void execute_2239(char*, char *);
extern void execute_2240(char*, char *);
extern void execute_2250(char*, char *);
extern void execute_2254(char*, char *);
extern void execute_2255(char*, char *);
extern void execute_72(char*, char *);
extern void execute_85(char*, char *);
extern void execute_74(char*, char *);
extern void execute_76(char*, char *);
extern void execute_78(char*, char *);
extern void execute_80(char*, char *);
extern void execute_81(char*, char *);
extern void execute_82(char*, char *);
extern void execute_87(char*, char *);
extern void execute_91(char*, char *);
extern void execute_93(char*, char *);
extern void execute_95(char*, char *);
extern void execute_96(char*, char *);
extern void execute_99(char*, char *);
extern void execute_100(char*, char *);
extern void execute_212(char*, char *);
extern void execute_98(char*, char *);
extern void execute_102(char*, char *);
extern void execute_103(char*, char *);
extern void execute_202(char*, char *);
extern void execute_106(char*, char *);
extern void execute_204(char*, char *);
extern void execute_205(char*, char *);
extern void execute_206(char*, char *);
extern void execute_207(char*, char *);
extern void execute_208(char*, char *);
extern void execute_209(char*, char *);
extern void execute_210(char*, char *);
extern void execute_211(char*, char *);
extern void execute_214(char*, char *);
extern void execute_238(char*, char *);
extern void execute_239(char*, char *);
extern void execute_244(char*, char *);
extern void execute_251(char*, char *);
extern void execute_229(char*, char *);
extern void execute_241(char*, char *);
extern void execute_246(char*, char *);
extern void execute_248(char*, char *);
extern void execute_249(char*, char *);
extern void execute_250(char*, char *);
extern void execute_395(char*, char *);
extern void execute_2211(char*, char *);
extern void execute_2212(char*, char *);
extern void execute_2213(char*, char *);
extern void execute_2214(char*, char *);
extern void execute_2215(char*, char *);
extern void execute_2216(char*, char *);
extern void execute_2219(char*, char *);
extern void execute_259(char*, char *);
extern void execute_260(char*, char *);
extern void execute_261(char*, char *);
extern void execute_264(char*, char *);
extern void execute_265(char*, char *);
extern void execute_394(char*, char *);
extern void execute_397(char*, char *);
extern void execute_2208(char*, char *);
extern void execute_2209(char*, char *);
extern void execute_2210(char*, char *);
extern void execute_1141(char*, char *);
extern void execute_1142(char*, char *);
extern void execute_1143(char*, char *);
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
extern void execute_463(char*, char *);
extern void execute_465(char*, char *);
extern void execute_467(char*, char *);
extern void execute_469(char*, char *);
extern void execute_471(char*, char *);
extern void execute_609(char*, char *);
extern void execute_1140(char*, char *);
extern void execute_733(char*, char *);
extern void execute_897(char*, char *);
extern void execute_901(char*, char *);
extern void execute_1075(char*, char *);
extern void execute_1079(char*, char *);
extern void execute_1083(char*, char *);
extern void execute_1087(char*, char *);
extern void execute_612(char*, char *);
extern void execute_613(char*, char *);
extern void execute_606(char*, char *);
extern void execute_478(char*, char *);
extern void execute_481(char*, char *);
extern void execute_482(char*, char *);
extern void execute_1148(char*, char *);
extern void execute_1149(char*, char *);
extern void execute_1150(char*, char *);
extern void execute_1190(char*, char *);
extern void execute_1515(char*, char *);
extern void execute_1516(char*, char *);
extern void execute_1528(char*, char *);
extern void execute_1537(char*, char *);
extern void execute_1538(char*, char *);
extern void execute_1518(char*, char *);
extern void execute_1520(char*, char *);
extern void execute_1526(char*, char *);
extern void execute_1527(char*, char *);
extern void execute_1530(char*, char *);
extern void execute_1532(char*, char *);
extern void execute_1536(char*, char *);
extern void execute_1542(char*, char *);
extern void execute_1543(char*, char *);
extern void execute_1544(char*, char *);
extern void execute_1804(char*, char *);
extern void execute_1805(char*, char *);
extern void execute_1807(char*, char *);
extern void execute_1808(char*, char *);
extern void execute_1811(char*, char *);
extern void execute_2100(char*, char *);
extern void execute_2196(char*, char *);
extern void execute_2198(char*, char *);
extern void execute_2199(char*, char *);
extern void execute_2200(char*, char *);
extern void execute_2201(char*, char *);
extern void execute_2202(char*, char *);
extern void execute_2203(char*, char *);
extern void execute_2204(char*, char *);
extern void execute_2205(char*, char *);
extern void execute_2206(char*, char *);
extern void execute_2207(char*, char *);
extern void execute_2218(char*, char *);
extern void execute_2221(char*, char *);
extern void execute_2222(char*, char *);
extern void execute_2231(char*, char *);
extern void execute_2232(char*, char *);
extern void execute_2236(char*, char *);
extern void execute_2262(char*, char *);
extern void execute_2263(char*, char *);
extern void execute_2264(char*, char *);
extern void execute_2265(char*, char *);
extern void execute_2266(char*, char *);
extern void execute_2267(char*, char *);
extern void execute_2268(char*, char *);
extern void execute_2272(char*, char *);
extern void execute_2273(char*, char *);
extern void execute_2274(char*, char *);
extern void execute_2275(char*, char *);
extern void execute_2276(char*, char *);
extern void execute_2270(char*, char *);
extern void execute_2271(char*, char *);
extern void execute_2280(char*, char *);
extern void execute_2281(char*, char *);
extern void execute_2286(char*, char *);
extern void execute_2287(char*, char *);
extern void execute_2911(char*, char *);
extern void execute_2912(char*, char *);
extern void execute_2296(char*, char *);
extern void execute_2297(char*, char *);
extern void execute_2298(char*, char *);
extern void execute_2299(char*, char *);
extern void execute_2300(char*, char *);
extern void execute_2302(char*, char *);
extern void execute_2303(char*, char *);
extern void execute_2305(char*, char *);
extern void execute_2290(char*, char *);
extern void execute_2291(char*, char *);
extern void execute_2292(char*, char *);
extern void execute_2293(char*, char *);
extern void execute_2904(char*, char *);
extern void execute_2908(char*, char *);
extern void execute_3527(char*, char *);
extern void execute_3538(char*, char *);
extern void execute_3539(char*, char *);
extern void execute_3540(char*, char *);
extern void execute_3541(char*, char *);
extern void execute_3061(char*, char *);
extern void execute_2918(char*, char *);
extern void execute_2919(char*, char *);
extern void execute_2920(char*, char *);
extern void execute_2921(char*, char *);
extern void execute_2922(char*, char *);
extern void execute_2923(char*, char *);
extern void execute_2924(char*, char *);
extern void execute_3063(char*, char *);
extern void execute_3064(char*, char *);
extern void execute_3529(char*, char *);
extern void execute_3530(char*, char *);
extern void execute_3534(char*, char *);
extern void execute_3535(char*, char *);
extern void execute_3537(char*, char *);
extern void execute_3543(char*, char *);
extern void execute_3544(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_187(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[242] = {(funcp)execute_3545, (funcp)execute_3546, (funcp)execute_53, (funcp)execute_54, (funcp)execute_55, (funcp)execute_56, (funcp)execute_57, (funcp)execute_58, (funcp)execute_59, (funcp)execute_60, (funcp)execute_61, (funcp)execute_2282, (funcp)execute_2283, (funcp)execute_63, (funcp)execute_64, (funcp)execute_65, (funcp)execute_66, (funcp)execute_67, (funcp)execute_68, (funcp)execute_69, (funcp)execute_2256, (funcp)execute_2257, (funcp)execute_2277, (funcp)execute_2278, (funcp)execute_219, (funcp)execute_220, (funcp)execute_256, (funcp)execute_2233, (funcp)execute_2239, (funcp)execute_2240, (funcp)execute_2250, (funcp)execute_2254, (funcp)execute_2255, (funcp)execute_72, (funcp)execute_85, (funcp)execute_74, (funcp)execute_76, (funcp)execute_78, (funcp)execute_80, (funcp)execute_81, (funcp)execute_82, (funcp)execute_87, (funcp)execute_91, (funcp)execute_93, (funcp)execute_95, (funcp)execute_96, (funcp)execute_99, (funcp)execute_100, (funcp)execute_212, (funcp)execute_98, (funcp)execute_102, (funcp)execute_103, (funcp)execute_202, (funcp)execute_106, (funcp)execute_204, (funcp)execute_205, (funcp)execute_206, (funcp)execute_207, (funcp)execute_208, (funcp)execute_209, (funcp)execute_210, (funcp)execute_211, (funcp)execute_214, (funcp)execute_238, (funcp)execute_239, (funcp)execute_244, (funcp)execute_251, (funcp)execute_229, (funcp)execute_241, (funcp)execute_246, (funcp)execute_248, (funcp)execute_249, (funcp)execute_250, (funcp)execute_395, (funcp)execute_2211, (funcp)execute_2212, (funcp)execute_2213, (funcp)execute_2214, (funcp)execute_2215, (funcp)execute_2216, (funcp)execute_2219, (funcp)execute_259, (funcp)execute_260, (funcp)execute_261, (funcp)execute_264, (funcp)execute_265, (funcp)execute_394, (funcp)execute_397, (funcp)execute_2208, (funcp)execute_2209, (funcp)execute_2210, (funcp)execute_1141, (funcp)execute_1142, (funcp)execute_1143, (funcp)execute_409, (funcp)execute_411, (funcp)execute_413, (funcp)execute_415, (funcp)execute_417, (funcp)execute_419, (funcp)execute_421, (funcp)execute_423, (funcp)execute_425, (funcp)execute_427, (funcp)execute_429, (funcp)execute_431, (funcp)execute_433, (funcp)execute_435, (funcp)execute_437, (funcp)execute_439, (funcp)execute_441, (funcp)execute_443, (funcp)execute_445, (funcp)execute_447, (funcp)execute_449, (funcp)execute_451, (funcp)execute_453, (funcp)execute_455, (funcp)execute_457, (funcp)execute_459, (funcp)execute_461, (funcp)execute_463, (funcp)execute_465, (funcp)execute_467, (funcp)execute_469, (funcp)execute_471, (funcp)execute_609, (funcp)execute_1140, (funcp)execute_733, (funcp)execute_897, (funcp)execute_901, (funcp)execute_1075, (funcp)execute_1079, (funcp)execute_1083, (funcp)execute_1087, (funcp)execute_612, (funcp)execute_613, (funcp)execute_606, (funcp)execute_478, (funcp)execute_481, (funcp)execute_482, (funcp)execute_1148, (funcp)execute_1149, (funcp)execute_1150, (funcp)execute_1190, (funcp)execute_1515, (funcp)execute_1516, (funcp)execute_1528, (funcp)execute_1537, (funcp)execute_1538, (funcp)execute_1518, (funcp)execute_1520, (funcp)execute_1526, (funcp)execute_1527, (funcp)execute_1530, (funcp)execute_1532, (funcp)execute_1536, (funcp)execute_1542, (funcp)execute_1543, (funcp)execute_1544, (funcp)execute_1804, (funcp)execute_1805, (funcp)execute_1807, (funcp)execute_1808, (funcp)execute_1811, (funcp)execute_2100, (funcp)execute_2196, (funcp)execute_2198, (funcp)execute_2199, (funcp)execute_2200, (funcp)execute_2201, (funcp)execute_2202, (funcp)execute_2203, (funcp)execute_2204, (funcp)execute_2205, (funcp)execute_2206, (funcp)execute_2207, (funcp)execute_2218, (funcp)execute_2221, (funcp)execute_2222, (funcp)execute_2231, (funcp)execute_2232, (funcp)execute_2236, (funcp)execute_2262, (funcp)execute_2263, (funcp)execute_2264, (funcp)execute_2265, (funcp)execute_2266, (funcp)execute_2267, (funcp)execute_2268, (funcp)execute_2272, (funcp)execute_2273, (funcp)execute_2274, (funcp)execute_2275, (funcp)execute_2276, (funcp)execute_2270, (funcp)execute_2271, (funcp)execute_2280, (funcp)execute_2281, (funcp)execute_2286, (funcp)execute_2287, (funcp)execute_2911, (funcp)execute_2912, (funcp)execute_2296, (funcp)execute_2297, (funcp)execute_2298, (funcp)execute_2299, (funcp)execute_2300, (funcp)execute_2302, (funcp)execute_2303, (funcp)execute_2305, (funcp)execute_2290, (funcp)execute_2291, (funcp)execute_2292, (funcp)execute_2293, (funcp)execute_2904, (funcp)execute_2908, (funcp)execute_3527, (funcp)execute_3538, (funcp)execute_3539, (funcp)execute_3540, (funcp)execute_3541, (funcp)execute_3061, (funcp)execute_2918, (funcp)execute_2919, (funcp)execute_2920, (funcp)execute_2921, (funcp)execute_2922, (funcp)execute_2923, (funcp)execute_2924, (funcp)execute_3063, (funcp)execute_3064, (funcp)execute_3529, (funcp)execute_3530, (funcp)execute_3534, (funcp)execute_3535, (funcp)execute_3537, (funcp)execute_3543, (funcp)execute_3544, (funcp)transaction_0, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_187};
const int NumRelocateId= 242;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/tb_mult_behav/xsim.reloc",  (void **)funcTab, 242);
	iki_vhdl_file_variable_register(dp + 400304);
	iki_vhdl_file_variable_register(dp + 400360);
	iki_vhdl_file_variable_register(dp + 812264);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/tb_mult_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/tb_mult_behav/xsim.reloc");

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
    iki_set_sv_type_file_path_name("xsim.dir/tb_mult_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/tb_mult_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/tb_mult_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
