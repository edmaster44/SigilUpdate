//::///////////////////////////////////////////////
//:: Trap Feat Include File
//:: scod_inc_trapfeats.nss
//:://////////////////////////////////////////////
/*
    Include file for constants and common functions related to the trap feats.
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: August 23, 2021
//:://////////////////////////////////////////////

int AOE_PER_TRAPVIS = 81;
int AOE_PER_TRAPINVIS = 82;

int FEAT_SPIKE_TRAP = 3042;
int FEAT_BEE_TRAP = 3043;
int FEAT_FLASH_TRAP = 3044;
int FEAT_SONIC_TRAP = 3045;
int FEAT_CORROSIVE_TRAP = 3046;

int SPELL_SPIKE_TRAP = 1944;
int SPELL_BEE_TRAP = 1945;
int SPELL_FLASH_TRAP = 1946;
int SPELL_SONIC_TRAP = 1947;
int SPELL_CORROSIVE_TRAP = 1948;

//Get the Craft Trap adjusted damage dice
int GetSkillAdjustedTrapDamageDice(int nBaseDice, int nSkillRanks, int nDivisor);

//Get the Craft Trap adjusted DC
int GetSkillAdjustedTrapDC(int nBaseDC, int nSkillRanks, int nDivisor);

//Determine if the reflex save was failed
int GetReflexFailed(object oTarget, int nOrgDamage, int nFinalDamage);

int GetSkillAdjustedTrapDamageDice(int nBaseDice, int nSkillRanks, int nDivisor) {
	return nBaseDice + (nSkillRanks / nDivisor);
}

int GetSkillAdjustedTrapDC(int nBaseDC, int nSkillRanks, int nDivisor) {
	return nBaseDC + (nSkillRanks / nDivisor);
}

int GetReflexFailed(object oTarget, int nOrgDamage, int nFinalDamage) {
	if (nOrgDamage == nFinalDamage) {
		return TRUE;
	}
	
	if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget) && nFinalDamage == (nOrgDamage / 2)) {
		return TRUE;
	}
	
	return FALSE;
}