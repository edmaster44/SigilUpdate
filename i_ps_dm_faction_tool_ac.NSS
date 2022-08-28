/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_faction"

void main()
{
	object	oDM     = GetItemActivator();
    object	oTarget = GetItemActivatedTarget();
	int		iFaction;
	int		iFactionFound = FALSE;
	
	if (GetIsDM(oDM))
	{
		if (GetIsPC(oTarget))
		{
			iFaction = GetFaction(oTarget);
			
			if (GetIsFaction(iFaction))
				iFactionFound = TRUE;
			
			SetLocalObject(oDM, "TargetObject", oTarget);
			//SendMessageToPC(oDM,"DEBUG: Targetted Player is " + GetName(oTarget));
			string sTargetName = GetName(oTarget);
			SetLocalString(oDM, "TargetName", sTargetName);
			SetLocalInt(oDM, "TargetFaction", iFaction);
			// just in case of previous target, let's clear this one.
			SetLocalInt(oDM, "TargetSecondaryFaction", 0);
			//SendMessageToPC(oDM, "DEBUG: Faction Found is: " + IntToString(iFaction));
			if (iFactionFound == TRUE)
			{
				//SendMessageToPC(oDM, "DEBUG: Resolved iFactionFound to be TRUE");
				
				int iSecondaryFaction = 0;
				
				// Now check to see if they have a secondary faction if they are an Anarchist...
				if (iFaction == 12) // comes from essence
				{
					// we don't mind which badge we find because its either going to be the
					// Rev League one or an infiltrated one, so no need to loop or anything.
					object oBadge = GetItemPossessedBy(oTarget,"ps_faction_badge");
   					if(GetIsObjectValid(oBadge))
					{
						if (GetLocalInt(oBadge, "Faction") == 12)
						{
							if (GetLocalInt(oBadge, "Infiltrated") == TRUE) // this is on the first badge found, so works if it is anarchist
								iSecondaryFaction = GetLocalInt(oBadge, "InfiltratedFaction");
							else
								iSecondaryFaction = 0; // FALSE, no infiltrated faction
						}
						else
						{
							// so we have found the non-anarch badge
							iSecondaryFaction = GetLocalInt(oBadge, "Faction");
						}
											
						SetLocalInt(oDM, "TargetSecondaryFaction", iSecondaryFaction);
					}
					else
					{
						SendMessageToPC(oDM, "DEBUG: Didn't find a badge but there should be a Rev League one");
					}
				}
				
				//SendMessageToPC(oDM, "DEBUG: Secondary Faction set to:  " + IntToString(iSecondaryFaction));
				
				AssignCommand(oDM, ActionStartConversation(oDM, "ps_conv_dm_faction_tool", TRUE, FALSE, FALSE, TRUE));
			}
			else
			{
				AssignCommand(oDM, ActionStartConversation(oDM, "ps_conv_dm_faction_tool_nofac", TRUE, FALSE, FALSE, TRUE));
			}
		}
		else
		{
			SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + "Target must be a player");
		}
	}
	else
	{
		SendMessageToPC(oDM, "Oy! You shouldn't have this! It doesn't work for peons anyway. Trash it.");
	}
}