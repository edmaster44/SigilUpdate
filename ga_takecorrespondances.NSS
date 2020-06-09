const int XPAWARD = 150;
const int GPAWARD = 300;
#include "ps_inc_functions"

void main () {

	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	int iGold = 0;
	int iXp = 0;
	
	object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
		if(GetTag(oItem) == "mirror_cdcorrespondance")
		{
		 	DestroyObject(oItem);
			
			iGold += GPAWARD;
			iXp += XPAWARD;
	    }
		
     	oItem = GetNextItemInInventory(oPC);
    }
	
	GiveGoldToCreature(oPC, iGold);
	PS_GiveXPReward(oPC, iXp);

}