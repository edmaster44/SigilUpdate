
//---------------------------------------------------------------------------------------------------------------------------
// Changing Dragon's size is only possible at Level 1.
//---------------------------------------------------------------------------------------------------------------------------

int StartingConditional()
{
	object oPC 	= GetPCSpeaker();		
	int iHD 	= GetTotalLevels(oPC, TRUE);
	int iSub 	= GetSubRace(oPC);
	
	string sCW1 = Get2DAString("racialsubtypes", "EqCW1", iSub);
	string sCW2 = Get2DAString("racialsubtypes", "EqCW2", iSub);
	string sCW3 = Get2DAString("racialsubtypes", "EqCW3", iSub);
	
	if (iHD == 1)
	{
		object oItem = GetFirstItemInInventory(oPC);
		while(GetIsObjectValid(oItem))
   		{
			if(TestStringAgainstPattern("s3_w_**",GetTag(oItem)))
			{
				return FALSE;
			}
    		oItem = GetNextItemInInventory(oPC);  		
   		}			
		return TRUE;
  	}
   	return FALSE;	
}	

