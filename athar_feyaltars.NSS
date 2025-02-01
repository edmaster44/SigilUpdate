#include "ff_safevar"

void main() 
{

	object oPC = GetPCSpeaker();
	int nOfferings = PS_GetLocalInt(OBJECT_SELF, "offerings");
	
	GiveGoldToCreature(oPC, nOfferings);
	PS_SetLocalInt(OBJECT_SELF, "offerings", 0);
	
}