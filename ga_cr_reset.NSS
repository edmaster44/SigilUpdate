//For resetting the CR on a creature
//Based on the level of the PC interacting with them
#include "ps_inc_functions"

void main() {

	object oPC = GetPCSpeaker();
	int iMAX = PS_GetMaxPartylevel(oPC);
	int nLevel = FloatToInt(PS_GetAvgPartylevel(oPC, iMAX));
	
	SetLocalInt(OBJECT_SELF, "QUEST_CR", nLevel);
}