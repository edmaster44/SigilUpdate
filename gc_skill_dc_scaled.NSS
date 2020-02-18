//Standard skill roll with training exp added
//Scales the DC based on the Challenge Rating or QUEST_CR integer
//of the creature
//Refer to the SKILL_* constants for the correct SKILL int to use
#include "ps_inc_training"
#include "ps_inc_randomitems"

int StartingConditional(int nSkill, int maxExp = 100)
{
	int nCR = GetChallengeRatingOfTarget(OBJECT_SELF);
	int nDC = nCR+10+(d10());

	object oPC = GetPCSpeaker();
	int nMod = GetSkillRank(nSkill, oPC, TRUE);
	int diff = nDC-nMod;
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