#include "ginc_var_ops"

void main()
{
	object oPC = GetLastKiller();
	while (GetIsObjectValid(GetMaster(oPC)))
   	{
   		oPC=GetMaster(oPC);
   	}
	
    int iQuestEntry = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + "ps_quest_wildlife");
 	if (iQuestEntry==1)
	{
		AddJournalQuestEntry("ps_quest_wildlife", 11, oPC, 1, 0, 0);
		return;
	}
	return;
}