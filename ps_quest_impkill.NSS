#include "x2_inc_compon"
#include "x0_i0_spawncond"
#include "ps_inc_scriptcall"

void main()
{
	ExecuteScript("ps_xp_script",OBJECT_SELF);

	object oPC = GetLastKiller();
	while (GetIsObjectValid(GetMaster(oPC)))
   	{
   		oPC=GetMaster(oPC);
   	}
	
	string sTag = GetTag(OBJECT_SELF);
	
	int iQuestEntry = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + "ps_quest_animatedbottles");
	
	if (iQuestEntry >= 1 && sTag == "ps_quasit") {
		AddJournalQuestEntry("ps_quest_animatedbottles", 3, oPC, 1, 0, 0);
	} else if (iQuestEntry == 1) {
		AddJournalQuestEntry("ps_quest_animatedbottles", 2, oPC, 1, 0, 0);
	}
	
	if (!GetIsSpirit(OBJECT_SELF))
    	craft_drop_items(oPC);

} 