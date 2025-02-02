#include "ff_safevar"

//requires ps_inc_functions, included in ps_inc_training
#include "ps_inc_training"
#include "ginc_var_ops"

const int spotDC = 15;
const int maxExp = 100;

int HasJournalEntry(string sQuestTag, string sCheck)
{
	object oPC = GetPCSpeaker();
    int iQuestEntry = PS_GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sQuestTag);
 	return (CompareInts(iQuestEntry, sCheck));
}

void main() {

	object oPC = GetEnteringObject();
	
	if (!GetIsPC(oPC))
		return;
	
	object oRat = GetNearestObjectByTag("ps_chirpers_wererat");
	if (!GetIsObjectValid(oRat) || GetArea(oRat) != GetArea(oPC))
		return;
		
	int nDone = PS_GetLocalInt(oPC, "thieftrigger");
	if (nDone > 0)
		return;
		
	if (HasJournalEntry("ps_quest_chirperskulls", "1"))
		return;
	
	int nMod = GetSkillRank(SKILL_SPOT, oPC, TRUE);
	int diff = spotDC-nMod;
	int noExp = FALSE;
	int nDifficulty = TRAINING_DIFFICULTY_NORMAL;
	if (diff <= 0) 
		noExp = TRUE;
	else if (diff <= 5)
		nDifficulty = TRAINING_DIFFICULTY_VERY_EASY;
	else if (diff <= 10) 
		nDifficulty = TRAINING_DIFFICULTY_EASY;
	else if (diff <= 15)
		nDifficulty = TRAINING_DIFFICULTY_NORMAL;
	else if (diff <= 19)
		nDifficulty = TRAINING_DIFFICULTY_HARD;
	else
		nDifficulty = TRAINING_DIFFICULTY_IMPOSSIBLE;

	int nExp = GetXPForSkillTrainingQuest(oPC, SKILL_SPOT, nDifficulty);
	
	if (nExp > maxExp)
		nExp = maxExp;
	
	if (GetIsSkillSuccessful(oPC, SKILL_SPOT, spotDC, TRUE)) {
	 	if (!noExp)
			PS_GiveXPReward(oPC, nExp);
		SendMessageToPC(oPC, "You see the wererat patron snatch a small but exotic looking skull from the shelf and shove it into his trenchcoat.");
		AddJournalQuestEntry("ps_quest_chirperskulls", 2, oPC, TRUE);
	} else {
		AssignCommand(oRat, ActionMoveToLocation(GetLocation(GetWaypointByTag("wp_chirpers_wererat_2")), FALSE));
		DelayCommand(3.0f, PS_SetLocalInt(oRat, "Thief", 1));
		DelayCommand(3.0f, AssignCommand(oRat, ActionMoveToLocation(GetLocation(GetWaypointByTag("wp_chirpers_wererat_2")), FALSE)));
	}

	PS_SetLocalInt(oPC, "thieftrigger", 1);

}