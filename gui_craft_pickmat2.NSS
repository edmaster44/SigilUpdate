#include "ff_safevar"

#include "ps_inc_newcrafting"

void main (string sNum) {
	
	object oPC = OBJECT_SELF;
	
	//SendMessageToPC(oPC, "material 2: "+sNum);
	
	int nIndex = StringToInt(sNum);
	PS_SetLocalInt(oPC, "Craft_Mat2", nIndex);
	
	GenerateCraftDetails(oPC);

}