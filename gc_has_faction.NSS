/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_faction"


int StartingConditional()
{
    object oPC = GetPCSpeaker();

	int nFaction = GetFaction(oPC);
	
    if (GetIsFaction(nFaction)) {
	
		// No need to select a new faction, but give them a badge if they don't have one for some reason.
		if (HasFactionBadge(oPC) == FALSE)
		{
			// As this sort of thing is also done in ps_setfaction should really make it a function in ps_inc_faction
			object oBadge = CreateItemOnObject("ps_faction_badge", oPC);
		
			if (GetIsObjectValid(oBadge))
			{
				SetBadgeFaction(oBadge, nFaction);
			}
			else
			{
				SendMessageToPC(oPC, FACTION_MESSAGE_TEXT_COLOUR + "ERROR: No badge created. Report a bug please");
			}
		}
		return TRUE;
	} else {
    	return FALSE;
	}
}