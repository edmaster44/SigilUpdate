// Fixes tint on special races or gives wings/tails as appropriate.

//#include "nwnx_character"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "ps_inc_wingtail"

void main()
{
	object oPC = GetPCSpeaker();
	
	PS_WingTailSetup(oPC);
	PS_ApplyPCTail(oPC);
	PS_ApplyPCWings(oPC);

}