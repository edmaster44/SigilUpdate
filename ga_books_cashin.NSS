// Give books for xp and gold

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
	 if(TestStringAgainstPattern("ps_lorebook_**",GetTag(oItem)))
	 {
	 	DestroyObject(oItem);
		iGold += GPAWARD;
		iXp += XPAWARD;
     }
     oItem = GetNextItemInInventory(oPC);
    }
	
	GiveGoldToCreature(oPC, iGold);
	GiveXPToCreature(oPC, iXp);
}