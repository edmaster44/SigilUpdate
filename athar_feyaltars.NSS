#include "ps_inc_functions"

void main() 
{

	object oPC = GetPCSpeaker();
	int nOfferings = GetLocalInt(OBJECT_SELF, "offerings");
	
	PS_GiveGoldToCreature(oPC, nOfferings);
	SetLocalInt(OBJECT_SELF, "offerings", 0);
	
}