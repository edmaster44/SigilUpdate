

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

// returns true if henchman should still exist.
// Used only by faction badge as it has to be a convo conditional
// The summoner feather will call the actual checking routine directly from ps_inc_faction

#include "ps_inc_faction"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	
	object oBadge = GetLocalObject(oPC, "FactionBadgeUsed");
	
	if (AllowRespawnHench(oBadge) == TRUE)
		return TRUE;
	else
		return FALSE;
}