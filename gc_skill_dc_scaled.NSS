//Standard skill roll with training exp added
//Scales the DC based on the Challenge Rating or QUEST_CR integer
//of the creature
//Refer to the SKILL_* constants for the correct SKILL int to use
#include "ps_inc_training"
#include "ps_inc_randomitems"

int StartingConditional(int nSkill, int maxExp = 100, int nDifficulty = ENCOUNTER_DIFFICULTY_NORMAL)
{
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
			GiveXPToCreature(oPC, nExp);
		return TRUE;
	}
	return FALSE;
}