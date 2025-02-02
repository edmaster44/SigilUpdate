#include "ff_safevar"

#include "ps_inc_faction"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	object oStoredBadge = PS_GetLocalObject(oPC, "FactionBadgeUsed");
	int iRank = PS_GetLocalInt(oStoredBadge, "FactionRank");
	int nFaction = PS_GetLocalInt(oStoredBadge,"Faction");
	
	if (nFaction == 10 && iRank <= 6)
		return TRUE; 
	else if (iRank == 1)
		return TRUE;
	else
		return FALSE;
}