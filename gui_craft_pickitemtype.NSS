

#include "ps_inc_newcrafting"

void main (string sNum) {
	
	object oPC = OBJECT_SELF;
	
	//SendMessageToPC(oPC, "picked: "+sNum);
	
	int nIndex = StringToInt(sNum);
	SetLocalInt(oPC, "Craft_BaseItemType", nIndex);
	
	GenerateMaterialList(oPC, nIndex, 1);
	GenerateMaterialList(oPC, nIndex, 2);
	GenerateMaterialList(oPC, nIndex, 3);

	GenerateCraftDetails(oPC);
}