

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_faction"
#include "ps_inc_placeable_signs"

void main(int iBadgeFunction, int iParameter)
{
	object oPC = OBJECT_SELF;
	
	object oBadge = GetFactionBadgeObject(oPC);
	
	if (oBadge == OBJECT_INVALID)
	{
		SendMessageToPC(oPC, "<COLOR=red>ERROR: No Faction Badge Found");
		return;
	}
	
	switch (iBadgeFunction)
	{
		case 1:
			//ReportFactionPromotionProspect(oPC, oPC, oBadge);
			break;
		
		case 2:
			DiscreteShowBadge(oPC, oPC);
			break;
		 	
		case 3:
		//	SendMessageToPC(oPC, FACTION_MESSAGE_TEXT_COLOUR + "You have " + IntToString(GetLocalInt(oBadge, "FactionPoints")) +
		//		" Faction Points in the " + GetLocalString(oBadge, "FactionName") + ".");
			break;
			
		case 4:
			// summon faction henchman
			SummonFactionCohort(oBadge, oPC, iParameter);
			break;
		
		case 5:
			// boost faction henchman
			BoostFactionHenchman(oBadge, oPC);
			break;
			
		case 6:
			{
				object oCoverBadge = CreateItemOnObject("ps_faction_badge", oPC);
				if (GetIsObjectValid(oCoverBadge))
				{
					SetBadgeFaction(oCoverBadge, iParameter);
					SetLocalInt(oBadge, "Infiltrated", TRUE);
					SetLocalInt(oBadge, "InfiltratedFaction", iParameter);
					SendMessageToPC(oPC, FACTION_MESSAGE_TEXT_COLOUR + "Sucessfully infiltrated the " 
						+ GetLocalString(oCoverBadge, "FactionName") + ".");
				}
				else
				{
					SendMessageToPC(oPC, "<COLOR=red>ERROR: No badge created. Seek DM assistance.");
				}
			}
			break;
			
		case 7:
			 // Bleaker daily roll
			 {
				int iBleaker = d20(1);
				string sBleaker;	
				
				if (iBleaker == 1)
					sBleaker = "What? Who? Where?  Must do stuff! Today, tomorrow, no time no time. *mania sets in*";
				else if (iBleaker == 20)
					sBleaker = "Oh why bother?  I think ill just lie down here and curl into a ball *melencholia sets in*";
				else
					sBleaker = "Just another pointless day in Sigil.  Oh well, let's get this over with... *regular bleaker behaviour*";
					
				SendMessageToPC(oPC, FACTION_MESSAGE_TEXT_COLOUR + "<b>Bleaker Mood Roll Result</b>: " + sBleaker);
			}
			break;
			
		case 8:
			RemoveFaction(oPC, oPC);
			break;
		
		case 9:
			// help out a stuck henchman
			{
				object oHench = GetHenchman(oPC, 1);
				AssignCommand(oHench, JumpToObject(oPC, FALSE));
			}
			break;
		
		case 10:
			// respawn lost henchman
			FindOrReplaceHenchman(oBadge);
			break;
		
		case 11:
			// Make faction sign
			CreateFactionSignItem(oPC);
			break;
			
		case 12:
			// Send general faction call
			SendGenericFactionMessage(oPC);
			break;
		
		case 13:
			// Create faction specific placeable item on PC
			CreateItemOnObject(GetLocalString(oPC, "FACTION_PLACEABLE"), oPC);
			DeleteLocalString(oPC, "FACTION_PLACEABLE");
			break;
	}
}