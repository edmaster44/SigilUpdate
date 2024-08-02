const int XPAWARD = 75;
const int GPAWARD = 150;

#include "ps_inc_functions"

void main () {

	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	int iGold = 0;
	int iXp = 0;
	
	object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
		if(GetTag(oItem) == "ps_dead_contract")
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