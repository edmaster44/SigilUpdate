

#include "ps_inc_faction"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	object oStoredBadge = GetLocalObject(oPC, "FactionBadgeUsed");
	int iRank = GetLocalInt(oStoredBadge, "FactionRank");
	int nFaction = GetLocalInt(oStoredBadge,"Faction");
	
	if (nFaction == 10 && iRank <= 6)
		return TRUE; 
	else if (iRank == 1)
		return TRUE;
	else
		return FALSE;
}