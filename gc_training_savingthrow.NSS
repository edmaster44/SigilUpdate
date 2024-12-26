//Performs saving throw and gives exp if you should succeed on 
//a level appropriate challenge.

#include "ps_inc_training"
#include "ps_inc_functions"
/*
Warning: gc_training_savingthrow.nss(7): Warning: NSC6010: Entry point function "StartingConditional" has a default value for argument "maxExp", but the runtime will select default argument values from a hardcoded list of defaults for script entry point symbols.  Consider removing explicit default arguments from the function and handling the actual runtime default values (which are zero, OBJECT_INVALID, and an empty string, as appropriate).
*/
int StartingConditional(int nSave, int nDC, int maxExp)
{
	if (maxExp == 0) maxExp = 100;
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
			PS_GiveXPReward(oPC, nExp);
		return TRUE;
	}
	return FALSE;
}