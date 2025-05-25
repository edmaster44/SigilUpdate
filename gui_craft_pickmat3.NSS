

#include "ps_inc_newcrafting"

void main (string sNum) {
	
	object oPC = OBJECT_SELF;
	
	//SendMessageToPC(oPC, "material 3: "+sNum);
	
	int nIndex = StringToInt(sNum);
	SetLocalInt(oPC, "Craft_Mat3", nIndex);
	
	GenerateCraftDetails(oPC);

}