#include "ginc_var_ops"
#include "ps_inc_functions"

int GetHasJournalEntry(object oPC, string sQuestTag, string sCheck)
{
    int iQuestEntry = PS_GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sQuestTag);
 	return (CompareInts(iQuestEntry, sCheck));
}

void main () {

	object oPC = GetEnteringObject();
	string sLocation = PS_GetLocalString(OBJECT_SELF, "loc_place");
	int nMax = PS_GetLocalInt(OBJECT_SELF, "loc_max");
	string sQuestName = PS_GetLocalString(OBJECT_SELF, "loc_name");
	
	if (!GetIsPC(oPC))
		return;
		
	if (GetHasJournalEntry(oPC, sQuestName, "=0"))
		return;
		
	if (PS_GetLocalInt(OBJECT_SELF, GetName(oPC)) > 0)
		return;
	
	SendMessageToPC(oPC, "You have found "+sLocation+".");
	PS_SetLocalInt(oPC, sQuestName, PS_GetLocalInt(oPC, sQuestName)+1);
	if (PS_GetLocalInt(oPC, sQuestName) >= nMax) {
		AddJournalQuestEntry(sQuestName, 2, oPC);
		int nXP = 50*nMax;
		SendMessageToPC(oPC, "You've found everything on the map. Congratulations!");
		PS_GiveXPReward(oPC, nXP);
	} else {
		PS_GiveXPReward(oPC, 100);
	}
	
	
	PS_SetLocalInt(OBJECT_SELF, GetName(oPC), 1);
}