int StartingConditional()
{
	object oPC = GetPCSpeaker();
	int iSub = GetSubRace(oPC);
	string sCW1 = Get2DAString("racialsubtypes", "EqCW1", iSub);
	string sCW2 = Get2DAString("racialsubtypes", "EqCW2", iSub);
	string sCW3 = Get2DAString("racialsubtypes", "EqCW3", iSub);

	object oItem = GetFirstItemInInventory(oPC);
	while(GetIsObjectValid(oItem))
   	{
		if(TestStringAgainstPattern("s3_w_**",GetTag(oItem)))
		{
			return TRUE;
		}
    	oItem = GetNextItemInInventory(oPC);
   	}

    return FALSE;

}