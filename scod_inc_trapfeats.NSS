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
int AOE_PER_ATTRAP = 101;

// Trap Ability Feats
int FEAT_SPIKE_TRAP = 3042;
int FEAT_BEE_TRAP = 3043;
int FEAT_FLASH_TRAP = 3044;
int FEAT_SONIC_TRAP = 3045;
int FEAT_CORROSIVE_TRAP = 3046;

// Arcane Trickster Trap Feats
int FEAT_ELEMENTAL_TRAP = 3048;

//Modifier Feats
int FEAT_STURDY_TRAPS = 3047;

int SPELL_SPIKE_TRAP = 1944;
int SPELL_BEE_TRAP = 1945;
int SPELL_FLASH_TRAP = 1946;
int SPELL_SONIC_TRAP = 1947;
int SPELL_CORROSIVE_TRAP = 1948;
int SPELL_ELEMENTAL_TRAP_FIRE = 6003;
int SPELL_ELEMENTAL_TRAP_ICE = 6004;
int SPELL_ELEMENTAL_TRAP_LIGHTNING = 6005;

float TRAP_RADIUS = 3.0f;
int STURDY_TRAP_ADJUSTMENT = 2;
int TRAP_DUR = 10;

//Get the Craft Trap adjusted damage dice
int GetSkillAdjustedTrapDamageDice(int nBaseDice, object oCaster, int nDivisor);

//Get the Craft Trap adjusted DC
int GetSkillAdjustedTrapDC(int nBaseDC, object oCaster, int nDivisor);

//Determine if the reflex save was failed
int GetReflexFailed(object oTarget, int nOrgDamage, int nFinalDamage);

// Get the ability modifier of Arcane Trickster spellcasting (intelligence or charisma)
int GetATTrapAbilityModifier(object oCaster);

// Get the levels the caster has in either Arcane Trickster or Arcane Trickster-Warlock
int GetArcaneTricksterLevels(object oCaster);

// Get the DC to set the trap
int GetAdjustedSetDC(int nBaseDC, object oCaster);

void ApplyTrapInvisibility(object oCaster, int nDC);

int GetSkillAdjustedTrapDamageDice(int nBaseDice, object oCaster, int nDivisor) {
	int nCraftTrap = GetSkillRank(SKILL_CRAFT_TRAP, oCaster, FALSE);
	return nBaseDice + (nCraftTrap / nDivisor);
}

int GetSkillAdjustedTrapDC(int nBaseDC, object oCaster, int nDivisor) {
	int nCraftTrap = GetSkillRank(SKILL_CRAFT_TRAP, oCaster, FALSE);
	int nDC = nBaseDC + (nCraftTrap / nDivisor);
	if (GetHasFeat(FEAT_STURDY_TRAPS, oCaster) == TRUE) {
		nDC = nDC + STURDY_TRAP_ADJUSTMENT;
	}
	return nDC;
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

int GetATTrapAbilityModifier(object oCaster) {
	int nATWizardFeat = 1514;
	if (GetHasFeat(1514, oCaster)) {
		return GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
	}
	
	return GetAbilityModifier(ABILITY_CHARISMA, oCaster);
}

int GetArcaneTricksterLevels(object oCaster) {
	int nLevels = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCaster);
	if (nLevels == 0) {
		nLevels = GetLevelByClass(83, oCaster);
	}
	return nLevels;
}

int GetAdjustedSetDC(int nBaseDC, object oCaster) {
	int nFinalDC = nBaseDC;
	// If the caster has Skill Mastery, reduce the DC by 4
	if (GetHasFeat(FEAT_SKILL_MASTERY, oCaster)) {
		nFinalDC = nFinalDC - 4;
	}
	return nFinalDC;
}

void ApplyTrapInvisibility(object oCaster, int nDC) {
	int nHideSuccess = GetIsSkillSuccessful(oCaster, SKILL_HIDE, nDC, FALSE);
	int nMSSuccess = GetIsSkillSuccessful(oCaster, SKILL_MOVE_SILENTLY, nDC, FALSE);
	if (nHideSuccess + nMSSuccess == 2) {
		effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
		effect eLink = EffectLinkEffects(eInvis, EffectVisualEffect(VFX_DUR_INVISIBILITY));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, 9.0f);
	}
}