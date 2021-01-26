//This script will give the PC an item from the essential item table
//This table is made up primarily of AC items and must-have weapons
//or items relevant to those specific level ranges
//nCR = the expected PC level, determines item strength
//Gives 1 item to everyone in the party

#include "ps_inc_treasurepool"

void main(int nCR) {

	object oPC = GetPCSpeaker();
	
	//Pick an item, and then check if it already exists in the PCs inventory
	//if it does, pick again; this assumes that item tag and resref are the same
	//(unfortunate requirement)
	string sItem = PickEssentialItemReward(nCR);
	
	if (sItem != "") {
	
   		object oPlayer = GetFirstFactionMember(oPC, TRUE); 
		while (GetIsObjectValid(oPlayer))  {
			
			if (GetArea(oPlayer) == GetArea(oPC)) {
			
				if (GetIsObjectValid(GetItemPossessedBy(oPlayer, sItem))) {
					sItem = PickEssentialItemReward(nCR);
				}
				
				CreateItemOnObject(sItem, oPlayer);
				sItem = PickEssentialItemReward(nCR);
			}
			
			oPlayer = GetNextFactionMember(oPC, FALSE);
		}
	}

}