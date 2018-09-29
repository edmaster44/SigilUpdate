/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

//#include "ps_inc_faction"

int StartingConditional(int iFaction)
{
	object oPC = GetPCSpeaker();
	
	object oStoredBadge = GetLocalObject(oPC, "FactionBadgeUsed");
	int iBadgeFaction = GetLocalInt(oStoredBadge, "Faction");
	
	if (iBadgeFaction == iFaction)
		return TRUE;
	else
		return FALSE;
}