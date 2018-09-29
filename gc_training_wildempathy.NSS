//Performs a wild empathy check
//gives exp if druid or ranger

#include "ps_inc_training"

int StartingConditional(int nDC, int maxExp = 100)
{

	object oPC = GetPCSpeaker();
	int nMod = GetAbilityModifier(ABILITY_CHARISMA, oPC)+GetLevelByClass(CLASS_TYPE_DRUID, oPC)+GetLevelByClass(CLASS_TYPE_RANGER, oPC);
	int diff = nDC-nMod;
	int noExp = FALSE;
	int nDifficulty = TRAINING_DIFFICULTY_NORMAL;
	if (diff <= 0 || GetLevelByClass(CLASS_TYPE_DRUID, oPC) < 1 || GetLevelByClass(CLASS_TYPE_RANGER, oPC) < 1) 
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
		
	int nExp = GetXPForAbilityTrainingQuest(oPC, ABILITY_CHARISMA, nDifficulty);
	if (nExp > maxExp)
		nExp = maxExp;
		
	int nRoll = d20()+nMod;
	
	if (nRoll >= nDC) {
	 	if (!noExp)
			GiveXPToCreature(oPC, nExp);
		return TRUE;
	}
	return FALSE;
}