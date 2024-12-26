// Gives xp and gold for runes
#include "ps_inc_functions"

const int XPAWARD = 25;
const int GPAWARD = 100;

void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	int iGold = 0;
	int iXp = 0;
	int nStack = 1;
	object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
		nStack = 1;
		if(TestStringAgainstPattern("ps_rune_**",GetTag(oItem))){
			nStack = GetNumStackedItems(oItem);
			DestroyObject(oItem);
			iGold += GPAWARD * nStack;
			iXp += XPAWARD * nStack;
		}
     oItem = GetNextItemInInventory(oPC);
    }
	
	GiveGoldToCreature(oPC, iGold);
	if (!ALLOW_ECL_LEVEL_30 || TAX_RUNES_FOR_ECL) PS_GiveXPReward(oPC, iXp);
	else GiveXPToCreature(oPC, iXp);
}