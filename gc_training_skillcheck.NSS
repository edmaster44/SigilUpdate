//For NPCs with a CR (or CR variable) which corresponds with the "challenge level" of this conversation/quest
//For a standard skill roll with exp, use gc_training_

#include "ps_inc_training"
#include "ps_inc_functions"

int StartingConditional(int nSkill, int nDC, int maxExp = 100)
{

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
			PS_GiveXPReward(oPC, nExp);
		return TRUE;
	}
	return FALSE;
}