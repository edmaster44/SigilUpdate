//Standard skill roll with training exp added
//Scales the DC based on the Challenge Rating or QUEST_CR integer
//of the creature
//Refer to the SKILL_* constants for the correct SKILL int to use
#include "ps_inc_training"
#include "ps_inc_randomitems"
#include "ps_inc_functions"

/*
Warning: gc_skill_dc_scaled.nss(9): Warning: NSC6010: Entry point function "StartingConditional" has a default value for argument "maxExp", but the runtime will select default argument values from a hardcoded list of defaults for script entry point symbols.  Consider removing explicit default arguments from the function and handling the actual runtime default values (which are zero, OBJECT_INVALID, and an empty string, as appropriate).
*/
int StartingConditional(int nSkill, int maxExp, int nDifficulty)
{
	if (maxExp == 0) maxExp = 100;
	if (nDifficulty == 0) nDifficulty = ENCOUNTER_DIFFICULTY_NORMAL;
	int nBase = 10;
	
	if (nDifficulty >= ENCOUNTER_DIFFICULTY_HARD)
		nBase = 15;
	else if (nDifficulty >= ENCOUNTER_DIFFICULTY_IMPOSSIBLE)
		nBase = 20;
	
	int nCR = GetChallengeRatingOfTarget(OBJECT_SELF);
	int nDC = nCR+nBase+(d4());

	object oPC = GetPCSpeaker();
	int nMod = GetSkillRank(nSkill, oPC, TRUE);
	int nDifficulty = GetDifficultyOfCheck(nDC, nMod);
	
	int noExp = FALSE;
	if (nDifficulty < 0) {
		noExp = TRUE;
		nDifficulty = TRAINING_DIFFICULTY_VERY_EASY;
	}
		
	int nExp = GetXPForSkillTrainingQuest(oPC, nSkill, nDifficulty);
	if (nExp > maxExp)
		nExp = maxExp;
	
	if (GetIsSkillSuccessful(oPC, nSkill, nDC, TRUE)) {
	 	if (!noExp)
			PS_GiveXPReward(oPC, nExp);
		return TRUE;
	}
	return FALSE;
}