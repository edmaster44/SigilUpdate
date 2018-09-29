//Performs skill check and gives exp if you should succeed on 
//a skill appropriate challenge.

#include "ps_inc_training"

int StartingConditional(int nAbility, int nDC, int maxExp = 100)
{

	object oPC = GetPCSpeaker();
	int nMod = GetAbilityModifier(nAbility, oPC);
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
		
	int nExp = GetXPForAbilityTrainingQuest(oPC, nAbility, nDifficulty);
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