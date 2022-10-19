//Performs skill check and gives exp if you should succeed on 
//a skill appropriate challenge.

#include "ps_inc_training"
#include "ps_inc_functions"

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
		
	int nD20 = d20();
	int nRoll = nD20+nMod;
	SendMessageToPC(oPC, "Rolled "+IntToString(nD20)+" + "+IntToString(nMod) + " = "+IntToString(nRoll));
	
	if (nRoll >= nDC) {
		SendMessageToPC(oPC, "Success!");
	 	if (!noExp)
			PS_GiveXPReward(oPC, nExp);
		return TRUE;
	} else {
		SendMessageToPC(oPC, "Failure");
	}
	return FALSE;
}