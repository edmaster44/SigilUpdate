//
/*
   Stores a permanent integer on a PC, usually to mark an achievement
   The follow variables must be on the item this is attached to:
   quest_name (the name of the quest/achievment)
   quest_status (the integer value to set, usually 1)
   
*/
#include "ps_inc_quests"
#include "ps_inc_functions"

void main()
{
    object oDM      = GetItemActivator();
	
	if (!GetIsDM(oDM)) //DM Only
		return;
		
	object oPC = GetItemActivatedTarget();
	string sID = PS_GetCharID(oPC);
	
    object oItem    = GetItemActivated();
	
	string sQuestName = PS_GetLocalString(oItem, "quest_name");
	int nQuestStatus = PS_GetLocalInt(oItem, "quest_status");
	
	SetPermanentInt(sID, sQuestName, nQuestStatus);
	SendMessageToPC(oDM, sQuestName+" achievement given to "+GetFirstName(oPC));
}