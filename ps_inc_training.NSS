#include "ps_inc_functions"

const int TRAINING_DIFFICULTY_VERY_EASY = 0;
const int TRAINING_DIFFICULTY_EASY = 1;
const int TRAINING_DIFFICULTY_NORMAL = 2;
const int TRAINING_DIFFICULTY_HARD = 3;
const int TRAINING_DIFFICULTY_IMPOSSIBLE = 3;

const int BASE_XP_REWARD = 10;

//Get the average number of skill points per
//level for this PC
int GetAverageSkillPoints(object oPC);

//Gets the average amount of BAB the PC
//gains every level
float GetAverageBABPerLevel(object oPC);

//Gets whether the skill specified is a class skill.
//This is a slow function (lots of looping through 2das.
//Use Sparingly.
int GetIsClassSkill(object oPC, int nSkill);

//Loops through 2da to get the row which has the
//value sought for in the column specified.
//returns -1 on failure.
int CycleThrough2DAForRow(string sTable, string sColumn, string sSought);

//Get the xp reward for the training quest.
//The xp is based on the system's best guess about
//your build plans. If you're taking skill points on level
//up, then you'll gain more exp.
int GetXPForTrainingQuest(object oPC, int nSkill, int nDifficulty);

//Get whether the ability in question is a "primary ability"
//for any of your classes.
int GetIsPrimaryAbility(object oPC, int nAbility);

//Get whether the ability in question is a "primary save"
//for any of your classes.
int GetIsPrimarySave(object oPC, int nSave);

//Gets the xp for an ability training quest. It bases its total
//on your ability score, level, whether its a primary ability, and 
//the difficulty.
int GetXPForAbilityTrainingQuest(object oPC, int nAbility, int nDifficulty);

//Gets the xp for a save training quest. It bases its total
//on your saving throw and level.
int GetXPForSaveTrainingQuest(object oPC, int nSave, int nDifficulty);

//Give the xp; the only reason why its in this function
//is to allow me to add in rp exp to the equation later.
void GiveTrainingQuestXP(object oPC, int nAmount);

//Gives an appropriate gold/item reward to the PC
//on completion
void GiveTrainingReward(object oPC, int nDifficulty);

int GetAverageSkillPoints(object oPC) {

	int nCount = 1;
	int nClass = 0;
	int nSkill = 0;
	int runningTotal = 0;
	while (nCount <= 4) {
		
		nClass = GetClassByPosition(nCount, oPC);
		if (nClass == CLASS_TYPE_INVALID)
			break;
		
		nSkill = StringToInt(Get2DAString("classes", "SkillPointBase", nClass));
		runningTotal += (nSkill*GetLevelByClass(nClass, oPC));
		nCount++;
	}
	
	int intMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
	int nLevel = GetHitDice(oPC);
	
	int total = runningTotal+(intMod*nLevel);
	total = total/nLevel;
	return total;

}

float GetAverageBABPerLevel(object oPC) {

	float nBAB = IntToFloat(GetBaseAttackBonus(oPC));
	float nLevel = IntToFloat(GetHitDice(oPC));
	return (nBAB/nLevel);

}

int GetIsClassSkill(object oPC, int nSkill) {
	
	int nCount = 1;
	int nClass;
	string sTable;
	while (nCount <= 4) {
		
		nClass = GetClassByPosition(nCount, oPC);
		if (nClass == CLASS_TYPE_INVALID)
			break;
		
		sTable = Get2DAString("classes", "SkillsTable", nClass);
		int nSkillRow = CycleThrough2DAForRow(sTable, "SkillIndex", IntToString(nSkill));
		if (nSkillRow != -1) {
			string sResult = Get2DAString(sTable, "ClassSkill", nSkillRow);
			int nResult = StringToInt(sResult);
			if (nResult == 1)
				return TRUE;
		}
	}
	return FALSE;
}

int CycleThrough2DAForRow(string sTable, string sColumn, string sSought) {

	int nRows = GetNum2DARows(sTable);
	int n;
	for (n = 0; n < nRows; n++) {
		string sValue = Get2DAString(sTable, sColumn, n);
		if (sValue == sSought)
			return n;
	}
	return -1;
}

int GetIsPrimaryAbility(object oPC, int nAbility) {

	int nCount = 1;
	int nClass = 0;
	int nPrimary = 0;
	while (nCount <= 4) {
		
		nClass = GetClassByPosition(nCount, oPC);
		if (nClass == CLASS_TYPE_INVALID)
			break;
		
		nPrimary = StringToInt(Get2DAString("classes", "PrimaryAbil", nClass));
		if (nPrimary == 1)
			return TRUE;
		nCount++;
	}
	
	return FALSE;
}

int GetIsPrimarySave(object oPC, int nSave) {

	int nCount = 1;
	int nClass = 0;
	string sTable = "";
	int nValue = 0;
	while (nCount <= 4) {
		
		nClass = GetClassByPosition(nCount, oPC);
		if (nClass == CLASS_TYPE_INVALID)
			break;
		
		sTable = Get2DAString("classes", "SavingThrowTable", nClass);
		if (nSave == SAVING_THROW_FORT)
			nValue = StringToInt(Get2DAString(sTable, "FortSave", 0));
		else if (nSave == SAVING_THROW_REFLEX)
			nValue = StringToInt(Get2DAString(sTable, "RefSave", 0));
		else if (nSave == SAVING_THROW_WILL)
			nValue = StringToInt(Get2DAString(sTable, "WillSave", 0));
		
		if (nValue >= 2)
			return TRUE;
			
		nCount++;
	}
	
	return FALSE;
}

/* Returns BASE_XP_REWARD * your saving throw * a modifier 
based on the difficulty of the check.
oPC = the one making the check
nSkill = SAVING_THROW_* constant
nDifficulty = TRAINING_DIFFICULTY_* constant
*/
int GetXPForSaveTrainingQuest(object oPC, int nSave, int nDifficulty) {
	int nLevel = GetHitDice(oPC);
	int nScore = GetFortitudeSavingThrow(oPC);
	if (nSave == SAVING_THROW_REFLEX)
		nScore = GetReflexSavingThrow(oPC);
	else if (nSave == SAVING_THROW_WILL)
		nScore = GetWillSavingThrow(oPC);
		
	if (nScore > nLevel)
		nScore = nLevel;
		
	float nModifier = 1.0f;
	if (nDifficulty == TRAINING_DIFFICULTY_VERY_EASY)
		nModifier = 0.5f;
	else if (nDifficulty == TRAINING_DIFFICULTY_EASY)
		nModifier = 0.75f;
	else if (nDifficulty == TRAINING_DIFFICULTY_HARD)
		nModifier = 1.25f;
	else if (nDifficulty == TRAINING_DIFFICULTY_IMPOSSIBLE)
		nModifier = 1.5f;
		
	int total = FloatToInt((BASE_XP_REWARD*nScore)*nModifier);
	return total;
}

/* Returns BASE_XP_REWARD * your base ability score * a modifier 
based on the difficulty of the check. In theory, this should return between 
BASE_XP_REWARD (currently 10) and BASE_XP_REWARD*20*1.5 (currently 300).
oPC = the one making the check
nSkill = ABILITY_* constant
nDifficulty = TRAINING_DIFFICULTY_* constant
*/
int GetXPForAbilityTrainingQuest(object oPC, int nAbility, int nDifficulty) {
	int nLevel = GetHitDice(oPC);
	int nScore = GetAbilityModifier(nAbility, oPC);
	if (nScore > nLevel)
		nScore = nLevel;
		
	float nModifier = 1.0f;
	if (nDifficulty == TRAINING_DIFFICULTY_VERY_EASY)
		nModifier = 0.5f;
	else if (nDifficulty == TRAINING_DIFFICULTY_EASY)
		nModifier = 0.75f;
	else if (nDifficulty == TRAINING_DIFFICULTY_HARD)
		nModifier = 1.25f;
	else if (nDifficulty == TRAINING_DIFFICULTY_IMPOSSIBLE)
		nModifier = 1.5f;
		
	float xp = (BASE_XP_REWARD*nScore)*nModifier;
	
	if (nLevel > 24) { //level 25+ penalty
		float nDiff = ((30.0f-nLevel)/6.0f);
		xp = xp*nDiff;
	}
	
	int total = FloatToInt(xp);
	return total;
}

/* Returns BASE_XP_REWARD * your base ranks in the give skill * a modifier 
based on the difficulty of the check. In theory, this should return between 
BASE_XP_REWARD (currently 10) and BASE_XP_REWARD*33*1.5 (currently 495).
oPC = the one making the check
nSkill = SKILL_* constant
nDifficulty = TRAINING_DIFFICULTY_* constant
*/
int GetXPForSkillTrainingQuest(object oPC, int nSkill, int nDifficulty) {

	//get level, according to skill ranks
	int nLevel = GetHitDice(oPC);
	int nRank = GetSkillRank(nSkill, oPC, TRUE);
	if (nRank <= 0)
		nRank = 1;
	
	int nXPSoFar = BASE_XP_REWARD*nRank;
	
	float nModifier = 1.0f;
	if (nDifficulty == TRAINING_DIFFICULTY_VERY_EASY)
		nModifier = 0.5f;
	else if (nDifficulty == TRAINING_DIFFICULTY_EASY)
		nModifier = 0.75f;
	else if (nDifficulty == TRAINING_DIFFICULTY_HARD)
		nModifier = 1.25f;
	else if (nDifficulty == TRAINING_DIFFICULTY_IMPOSSIBLE)
		nModifier = 1.5f;
		
	nXPSoFar = FloatToInt(nXPSoFar*nModifier);
	float xp = nXPSoFar*nModifier;
	
	if (nLevel > 24) { //level 25+ penalty
		float nDiff = ((30.0f-nLevel)/6.0f);
		xp = xp*nDiff;
	}
	
	nXPSoFar = FloatToInt(xp);
	return nXPSoFar;
}

/*Currently just a rewrapped GiveXPToCreature */
void GiveTrainingQuestXP(object oPC, int nAmount) {

	GiveXPToCreature(oPC, nAmount);

}

/*Give an arbitrary amount of gold based on your level
for completing a training task */
void GiveTrainingReward(object oPC, int nDifficulty) {

	int nBaseGold = 10;
	int nLevel = GetHitDice(oPC);
	
	float nModifier = 1.0f;
	nModifier = 1.0f;
	if (nDifficulty == TRAINING_DIFFICULTY_VERY_EASY)
		nModifier = 0.5f;
	else if (nDifficulty == TRAINING_DIFFICULTY_EASY)
		nModifier = 0.75f;
	else if (nDifficulty == TRAINING_DIFFICULTY_HARD)
		nModifier = 1.25f;
	else if (nDifficulty == TRAINING_DIFFICULTY_IMPOSSIBLE)
		nModifier = 1.5f;
		
	nLevel = FloatToInt(IntToFloat(nLevel)*nModifier);
	int nReward = nBaseGold*nLevel;
	GiveGoldToCreature(oPC, nReward);
}

/* Makes a skill check. If successful, it awards exp
Based on the difficulty of the check, and the synergy of that ability
To the PC's build. 
object oPC = the one making the check
int nAbility = SKILL_ Constant
int nDC = the DC of the check */
int GetIsTrainingSkillSuccessful(object oPC, int nSkill, int nDC) {

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
	
	if (GetIsSkillSuccessful(oPC, nSkill, nDC, TRUE)) {
	 	if (!noExp)
			PS_GiveXPReward(oPC, nExp);
		return TRUE;
	}
	return FALSE;

}

/* Makes an ability check. If successful, it awards exp
Based on the difficulty of the check, and the synergy of that ability
To the PC's build. 
object oPC = the one making the check
int nAbility = ABILITY_ Constant
int nDC = the DC of the check */
int GetIsTrainingAbilitySuccessful(object oPC, int nAbility, int nDC) {

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
		
	int nRoll = d20()+nMod;
	
	if (nRoll >= nDC) {
	 	if (!noExp)
			PS_GiveXPReward(oPC, nExp);
		return TRUE;
	}
	return FALSE;

}

//Takes the DC and the PC's modifier (usually skill bonus)
//and returns the TRAINING_DIFFICULTY_* int
int GetDifficultyOfCheck(int nDC, int nMod) {
	int diff = nDC-nMod;
	int nDifficulty = TRAINING_DIFFICULTY_NORMAL;
	if (diff <= 0) 
		return -1;
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
	return nDifficulty;
}

/* Makes a saving throw. If successful, it awards exp
Based on the difficulty of the check, and the synergy of that ability
To the PC's build. Returns results of check
object oPC = the one making the check
int nSave = SAVING_THROW_ Constant
int nDC = the DC of the check 
nSaveType = Save Type constant
oSaveVersus = the thing "attacking"*/
int GetIsTrainingSavingThrowSuccessful(object oPC, int nSave, int nDC, int nSaveType, object oSaveVersus) {

	int nLevel = GetHitDice(oPC);
	int nScore = 0;
	int nResult = 0;
	if (nSave == SAVING_THROW_REFLEX) {
		nScore = GetReflexSavingThrow(oPC);
		nResult = ReflexSave(oPC, nDC, nSaveType, oSaveVersus);
	} else if (nSave == SAVING_THROW_WILL) {
		nScore = GetWillSavingThrow(oPC);
		nResult = WillSave(oPC, nDC, nSaveType, oSaveVersus);
	} else if (nSave == SAVING_THROW_FORT) {
		nScore = GetWillSavingThrow(oPC);
		nResult = FortitudeSave(oPC, nDC, nSaveType, oSaveVersus);
	}
		
	if (nScore > nLevel)
		nScore = nLevel;
		
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
		
	int nRoll = d20()+nScore;
	
	if (nResult == SAVING_THROW_CHECK_SUCCEEDED) {
	 	if (!noExp)
			PS_GiveXPReward(oPC, nExp);
		return TRUE;
	} else if (nResult == SAVING_THROW_CHECK_IMMUNE) {
		return TRUE;
	}
	return FALSE;

}