//called from dialog ps_mw_verminguy, note that you will need to edit the dialog to reflect new 
//prices and this script
#include "ps_inc_functions"

const int nRatGold = 200; // reward in copper pieces per dead rat
const int nRatXP = 15; // xp reward per rat

void main(int bAllPartyMembers){
	object oPC = GetPCSpeaker();
	if (oPC == OBJECT_INVALID) oPC = OBJECT_SELF;
	int nRats = 0;
	int i = 0;
	object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem)){
		i++;
		if (GetTag(oItem) == "ps_questobject_craniumrat"){
			nRats++;
			DestroyObject(oItem);
		}
        oItem = GetNextItemInInventory(oPC);
		// num of items a pc could have if inv full of full bags, including the bags
		if (i > 27072) break;
    }
	
	int nGP = nRats * nRatGold;
	int nXP = nRats * nRatXP;
	
    if (!bAllPartyMembers){
		PS_GiveGoldToCreature(oPC, nGP);
		PS_GiveXPReward(oPC, nXP);
	} else {
        object oTarg = GetFirstFactionMember(oPC);
        while(GetIsObjectValid(oTarg)){
            PS_GiveGoldToCreature(oTarg, nGP);
			PS_GiveXPReward(oTarg, nXP);
            oTarg = GetNextFactionMember(oPC);
        }
    }
}