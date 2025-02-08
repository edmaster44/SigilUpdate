#include "ff_safevar"

//A script for incrementing journal entries on kill
//Ideally this should be called from the default ondeath script
//by setting the DeathScript variable on the creature to this script
//
//Variables:
//Quest_Tag - the tag of the quest to increment
//Quest_Stage_Required - the minimum quest stage required
//Will check all the members of the PC's party
void main () {

	object oPC = GetLastKiller();
	while (GetIsObjectValid(GetMaster(oPC))) {
   		oPC=GetMaster(oPC);
   	}

	string sQuest = PS_GetLocalString(OBJECT_SELF, "Quest_Tag");
	int nCurrent = PS_GetLocalInt(OBJECT_SELF, "Quest_Stage_Required");
	
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oPartyMember) == TRUE) {	
	
		int iQuestEntry = PS_GetLocalInt(oPartyMember, "NW_JOURNAL_ENTRY" + sQuest);
		if (iQuestEntry >= nCurrent) {
			AddJournalQuestEntry(sQuest, iQuestEntry+1, oPartyMember, 1, 0, 0);
		}

        oPartyMember = GetNextFactionMember(oPC, TRUE);		
	}

}