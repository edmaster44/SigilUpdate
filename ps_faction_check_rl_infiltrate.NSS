#include "ff_safevar"

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

//#include "ps_inc_faction"
// original version looked for a cover faction badge.
// However, as can quit factions, we actually want to see if there was infiltrated
// set, which is stored on the Anarchist badge as Infiltrated (INT) is true.
// This will never be unset except in a wipe of faction information, so its cool to use.

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	
	object oItem = GetFirstItemInInventory(oPC);
	int iInfiltrated = FALSE;
	int iFaction;
	int iBadgeFound = FALSE;
	
	while (oItem != OBJECT_INVALID && iBadgeFound == FALSE)
	{
		if (GetTag(oItem) == "ps_faction_badge")
		{
			iFaction = PS_GetLocalInt(oItem, "Faction");
			if (iFaction == 12)
			{
				iBadgeFound = TRUE;
				if (PS_GetLocalInt(oItem, "Infiltrated") == TRUE)
					iInfiltrated = TRUE;	
			}
		}
	oItem = GetNextItemInInventory(oPC);
	}
	return iInfiltrated;
}