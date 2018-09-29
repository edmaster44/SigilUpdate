const int XPAWARD = 50;
const int GPAWARD = 100;
const int GPAWARD2 = 110;

int GetFaction(object oPC)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	int nFaction = GetLocalInt(oItem,"Faction");
		return nFaction;
    }
	
	return 0;
}

void main (int max) {

	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	int iGold = 0;
	int iXp = 0;
	
	object oItem = GetFirstItemInInventory(oPC);
	int nCount = 0;
    while(GetIsObjectValid(oItem))
    {
		if(GetTag(oItem) == "ps_questobject_corpse")
		{
		 	DestroyObject(oItem);
			
			if (GetFaction(oPC) == 7) { // is Dustman
				iGold += GPAWARD2;
			} else {
				iGold += GPAWARD;
			}
			iXp += XPAWARD;
			nCount++;
	    }
		if (nCount >= max) 
			break;
     	oItem = GetNextItemInInventory(oPC);
    }
	
	SetLocalInt(oPC, "corpseNumber", nCount);
	GiveGoldToCreature(oPC, iGold);
	GiveXPToCreature(oPC, iXp);

}