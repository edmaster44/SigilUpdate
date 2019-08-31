//Uses the standard encounter trigger set up to spawn 
//an encounter - but only when quest parameters are met.
//Requires all the same variables as a normal encounter trigger
//PlUS the following:
//RequiredQuest = Quest Tag
//RequiredQuestStage = works like gc_local_int, takes values like 0, or >0
//RequiredQuestStage2 = same as RequiredQuestStage, but not required; use when you need to check 
//	that the quest stage is between two stages
#include "ps_inc_spawns"
#include "ginc_var_ops"

void main () {
	
	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC)) return;
	
	string sQuestTag = GetLocalString(OBJECT_SELF, "RequiredQuest");
	string sCheck = GetLocalString(OBJECT_SELF, "RequiredQuestStage");
	string sCheck2 = GetLocalString(OBJECT_SELF, "RequiredQuestStage2");
	
	int iQuestEntry = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sQuestTag);
 	int nCanSpawn = (CompareInts(iQuestEntry, sCheck));
	
	if (nCanSpawn && sCheck2 != "") {
		nCanSpawn = (CompareInts(iQuestEntry, sCheck2));
	}
	
	if (nCanSpawn)
		SpawnEncounter(OBJECT_SELF, oPC);

}