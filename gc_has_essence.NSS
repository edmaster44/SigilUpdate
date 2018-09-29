int StartingConditional()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
	 if(TestStringAgainstPattern("N2_CRFT_DIST**",GetTag(oItem)))
	 {
	 	return TRUE;
     }
     oItem = GetNextItemInInventory(oPC);
    }
	return FALSE;
}