

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_faction"

// If not an anarchist with a cover faction then will use the characters main faction
// If an anarchist with a cover faction then the second int will be set to TRUE.

void main(int iToolFunction, int iUseAnarchistCover)
{
	object oDM = OBJECT_SELF;
	string sTargetName = GetLocalString(oDM, "TargetName");
	int iTargetFaction = GetLocalInt(oDM, "TargetFaction");
	int iTargetSecondaryFaction = GetLocalInt(oDM, "TargetSecondaryFaction");
	int iFaction;
	object oBadge;
	
	object oTarget = GetLocalObject(oDM, "TargetObject");
	
	if (oTarget == OBJECT_INVALID)
	{
		SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + "Unable to find character: " + sTargetName);
	}
	else
	{
		// Looking for the correct badge.
		object oItem = GetFirstItemInInventory(oTarget);
		int iBadgeFound = FALSE;
	
		while (oItem != OBJECT_INVALID && iBadgeFound == FALSE)
		{
			if (GetTag(oItem) == "ps_faction_badge")
			{
				iFaction = GetLocalInt(oItem, "Faction");
				if ((iUseAnarchistCover == 1 & iFaction == iTargetSecondaryFaction) | (iUseAnarchistCover == 0 & iFaction == iTargetFaction))
				{
					oBadge = oItem; // Wasn't sure about loop iterating once again, so store
					iBadgeFound = TRUE;
				}			
			}
			oItem = GetNextItemInInventory(oTarget);
		}
		
		if (oBadge == OBJECT_INVALID)
		{
			SendMessageToPC(oDM, "DEBUG: Warning, no badge found, but its ok if you are clearing faction data");
		}
		
		switch (iToolFunction)
		{
			case 1:
				// Report faction promotion
				//ReportFactionPromotionProspect(oDM, oTarget, oBadge);
				break;
		
			case 2:
				// Who are they?
				DiscreteShowBadge(oTarget, oDM);
				break;
			
			case 3:
				// How many points?
				SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " has " + IntToString(GetLocalInt(oBadge, "FactionPoints")) +
					"in the " + GetLocalString(oBadge, "FactionName") + ".");
				break;
			
			case 4:
				// Give points
				SetLocalInt(oBadge, "FactionPoints", GetLocalInt(oBadge, "FactionPoints") + 1);
				SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + "Granted 1 faction point to " + sTargetName + ". They now have "
					+ IntToString(GetLocalInt(oBadge, "FactionPoints")) + " points.");
				SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "You have received a Faction Point from the " + GetLocalString(oBadge, "FactionName") + ".");
				break;
		
			case 5:
				// Take points (just in case)
				if (GetLocalInt(oBadge, "FactionPoints") > 0)
				{
					SetLocalInt(oBadge, "FactionPoints", GetLocalInt(oBadge, "FactionPoints") - 1);
					SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + "Removed 1 faction point from " + sTargetName + ". They now have "
						+ IntToString(GetLocalInt(oBadge, "FactionPoints")) + " points.");
					SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "You have been deducted a Faction Point by the " + GetLocalString(oBadge, "FactionName") + ".");
				}
				else
				{
					SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " doesn't have any faction points to remove.");
				}
				break;
			
			case 6:
				// Promote
				PromoteInFaction(oDM, oTarget);
				break;
		
			case 7:
				// Demote
				DemoteInFaction(oDM, oTarget);
				break;
			case 8:
				RemoveFactionBadge(oBadge, oDM, oTarget);
				break;
			case 9:
				// remove all faction data including badges and faction info on ps_essence...
				RemoveAllFactionData(oDM, oTarget);
				break;
		}
	}
}