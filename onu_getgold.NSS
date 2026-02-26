#include "ps_inc_functions"

void main () {

	object oPC = GetLastUsedBy();
	
	int nGold = 10000;
	
	PS_GiveGoldToCreature(oPC, nGold);

}