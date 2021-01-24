//This script will give the PC an item from the essential item table
//This table is made up primarily of AC items and must-have weapons
//or items relevant to those specific level ranges
//nCR = the expected PC level, determines item strength

#include "ps_inc_treasurepool"

void main(int nCR) {

	object oPC = GetPCSpeaker();
	
	//Pick an item, and then check if it already exists in the PCs inventory
	//if it does, pick again; this assumes that item tag and resref are the same
	//(unfortunate requirement)
	string sItem = PickEssentialItemReward(nCR);
	if (GetIsObjectValid(GetItemPossessedBy(oPC, sItem))) {
		sItem = PickEssentialItemReward(nCR);
	}
	
	if (sItem != "") {
		CreateItemOnObject(sItem, oPC);
	}

}