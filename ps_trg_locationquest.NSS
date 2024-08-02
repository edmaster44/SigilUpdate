#include "ginc_var_ops"
#include "ps_inc_functions"

int GetHasJournalEntry(object oPC, string sQuestTag, string sCheck)
{
    int iQuestEntry = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sQuestTag);
 	return (CompareInts(iQuestEntry, sCheck));
}

void main () {

	object oPC = GetEnteringObject();
	string sLocation = GetLocalString(OBJECT_SELF, "loc_place");
	int nMax = GetLocalInt(OBJECT_SELF, "loc_max");
	string sQuestName = GetLocalString(OBJECT_SELF, "loc_name");
	
	if (!GetIsPC(oPC))
		return;
		
	if (GetHasJournalEntry(oPC, sQuestName, "=0"))
		return;
		
	if (GetLocalInt(OBJECT_SELF, GetName(oPC)) > 0)
		return;
	
	SendMessageToPC(oPC, "You have found "+sLocation+".");
	SetLocalInt(oPC, sQuestName, GetLocalInt(oPC, sQuestName)+1);
	if (GetLocalInt(oPC, sQuestName) >= nMax) {
		AddJournalQuestEntry(sQuestName, 2, oPC);
		int nXP = 50*nMax;
		SendMessageToPC(oPC, "You've found everything on the map. Congratulations!");
		PS_GiveXPReward(oPC, nXP);
	} else {
		PS_GiveXPReward(oPC, 100);
	}
	
	
	SetLocalInt(OBJECT_SELF, GetName(oPC), 1);
}