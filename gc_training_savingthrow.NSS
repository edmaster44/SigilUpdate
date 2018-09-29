//Performs saving throw and gives exp if you should succeed on 
//a level appropriate challenge.

#include "ps_inc_training"

int StartingConditional(int nSave, int nDC, int maxExp = 100)
{

	object oPC = GetPCSpeaker();
	int nSuccess = 0;
	
	int nScore = GetFortitudeSavingThrow(oPC);
	if (nSave == SAVING_THROW_REFLEX) {
		nScore = GetReflexSavingThrow(oPC);
		nSuccess = ReflexSave(oPC, nDC);
	} else if (nSave == SAVING_THROW_WILL) {
		nScore = GetWillSavingThrow(oPC);
		nSuccess = WillSave(oPC, nDC);
	} else {
		nSuccess = FortitudeSave(oPC, nDC);
	}
		
	int diff = nDC-nScore;
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
		
	int nExp = GetXPForSaveTrainingQuest(oPC, nSave, nDifficulty);
	if (nExp > maxExp)
		nExp = maxExp;
	
	if (nSuccess > 0) {
	 	if (!noExp)
			GiveXPToCreature(oPC, nExp);
		return TRUE;
	}
	return FALSE;
}