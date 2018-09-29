

void main()
{

	object oPC = GetLastKiller();
	while (GetIsObjectValid(GetMaster(oPC)))
   	{
   		oPC=GetMaster(oPC);
   	}
	
	int iQuestEntry = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + "ps_quest_innratproblem");
	
	if ( iQuestEntry == 1 )
	{
		AddJournalQuestEntry("ps_quest_innratproblem", 11, oPC, 1, 0, 0);
	}
	else if ( iQuestEntry == 31 )
	{
		AddJournalQuestEntry("ps_quest_innratproblem", 41, oPC, 1, 0, 0);
	}

} 