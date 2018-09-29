/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/


int StartingConditional()
{
    object oPC = GetPCSpeaker();
	
	// check for SToA Reputation
	if (GetHasFeat(1566, oPC, TRUE) == TRUE)
		return TRUE;
	else
		return FALSE;
}