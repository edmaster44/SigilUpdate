// Give books for xp and gold

#include "ps_inc_functions"

const int XPAWARD = 50;
const int GPAWARD = 10;

void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	int iGold = 0;
	int iXp = 0;
	
	object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
	 if(TestStringAgainstPattern("ps_lorebook_**",GetTag(oItem))) {
	 	DestroyObject(oItem);
		iGold += GPAWARD;
		iXp += XPAWARD;
     } else if (GetTag(oItem) == "ps_crft_basebook" || 
	 	GetTag(oItem) == "ps_book_special") {
	 	DestroyObject(oItem);
		iGold += GPAWARD;
		iXp += XPAWARD;
	 }
     oItem = GetNextItemInInventory(oPC);
    }
	
	GiveGoldToCreature(oPC, iGold);
	PS_GiveXPReward(oPC, iXp);
}