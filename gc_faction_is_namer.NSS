/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_faction"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	object oStoredBadge = GetLocalObject(oPC, "FactionBadgeUsed");
	int iRank = GetLocalInt(oStoredBadge, "FactionRank");
	
	if (iRank == 1)
		return TRUE;
	else
		return FALSE;
}