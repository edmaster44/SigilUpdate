#include "ps_inc_functions"

void main () {

	object oPC = GetLastUsedBy();
	
	int nXP = 10000;
	
	PS_GiveXPReward(oPC, nXP);

}