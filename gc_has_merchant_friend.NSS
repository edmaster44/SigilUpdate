/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/


int StartingConditional()
{
    object oPC = GetPCSpeaker();
	
	// check for Merchant's Friend
	if (GetHasFeat(1764, oPC, TRUE) == TRUE)
		return TRUE;
	else if (GetIsObjectValid(GetItemPossessedBy(oPC, "ps_it_merkh_mrcbelt")) == TRUE)
    	return TRUE;
	else
		return FALSE;
}