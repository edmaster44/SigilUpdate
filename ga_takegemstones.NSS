const int XPAWARD = 75;
const int GPAWARD = 150;

void main () {

	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	int iGold = 0;
	int iXp = 0;
	
	object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
		
		if (GetBaseItemType(oItem) == BASE_ITEM_GEM) {
			
			if (FindSubString(GetTag(oItem), "gemstone_rough") >= 0) {
			
			 	DestroyObject(oItem);
				
				iGold += GPAWARD;
				iXp += XPAWARD;
		
		    }
			
		}
		
     	oItem = GetNextItemInInventory(oPC);
    }
	
	GiveGoldToCreature(oPC, iGold);
	GiveXPToCreature(oPC, iXp);

}