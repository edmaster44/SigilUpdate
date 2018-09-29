#include "ps_inc_newcrafting"

void main (string sNum) {
	
	object oPC = OBJECT_SELF;
	
	//SendMessageToPC(oPC, "picked: "+sNum);
	
	int nIndex = StringToInt(sNum);
	SetLocalInt(oPC, "Craft_BaseItemType", nIndex);
	
	GenerateMaterial1List(oPC, nIndex);
	GenerateMaterial2List(oPC, nIndex);
	GenerateMaterial3List(oPC, nIndex);

	GenerateCraftDetails(oPC);
}