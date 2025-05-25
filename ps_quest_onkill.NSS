

//A script for incrementing journal entries on kill
//Ideally this should be called from the default ondeath script
//by setting the DeathScript variable on the creature to this script
//
//Variables:
//Quest_Tag - the tag of the quest to increment
//Quest_Stage_Required - the quest stage required to have any effect
//Quest_Stage - the quest stage to increment to
void main () {

	object oPC = GetLastKiller();
	while (GetIsObjectValid(GetMaster(oPC))) {
   		oPC=GetMaster(oPC);
   	}

	string sQuest = GetLocalString(OBJECT_SELF, "Quest_Tag");
	int nCurrent = GetLocalInt(OBJECT_SELF, "Quest_Stage_Required");
	int nStage = GetLocalInt(OBJECT_SELF, "Quest_Stage");
	
	int iQuestEntry = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sQuest);
	if (iQuestEntry >= nCurrent) {
		AddJournalQuestEntry(sQuest, nStage, oPC, 1, 0, 0);
	}

}