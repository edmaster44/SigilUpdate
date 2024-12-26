#include "ps_inc_functions"

const int XPAWARD = 75;
const int GPAWARD = 150;

void main () {

	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	int iGold = 0;
	int iXp = 0;
	int nStack = 1;
	object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
		nStack = 1;
		if (GetBaseItemType(oItem) == BASE_ITEM_GEM) {
			
			if (FindSubString(GetTag(oItem), "gemstone_rough") >= 0) {
				nStack = GetNumStackedItems(oItem);
			 	DestroyObject(oItem);
				iGold += GPAWARD * nStack;
				iXp += XPAWARD * nStack;
		
		    }
			
		}
		
     	oItem = GetNextItemInInventory(oPC);
    }
	
	GiveGoldToCreature(oPC, iGold);
	if (!ALLOW_ECL_LEVEL_30 || TAX_GEMS_FOR_ECL) PS_GiveXPReward(oPC, iXp);
	else GiveXPToCreature(oPC, iXp);

}