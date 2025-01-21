#include "nw_i0_spells"

void main()
{
	object oPC = OBJECT_SELF;
	int nID = GetSpellId();
	if (GetHasSpellEffect(nID, oPC)==TRUE)
	{
		RemoveEffectsFromSpell(oPC, nID);
		FeatRemove(oPC, FEAT_STAL_DEF_STANCE_AC);
		FloatingTextStringOnCreature("*Defensive Stance OFF*", oPC, FALSE);
	}
	else
	{
		if (!GetHasFeat(FEAT_STAL_DEF_STANCE_AC, oPC, TRUE))
			FeatAdd(oPC, FEAT_STAL_DEF_STANCE_AC, FALSE);
		effect eKNOCK = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
		effect eSTILL = EffectAttackDecrease(4);
		effect eSpellFail = EffectSpellFailure(20, SPELL_SCHOOL_GENERAL);
		effect eLINK = EffectLinkEffects(eKNOCK, eSTILL);
		eLINK = EffectLinkEffects(eLINK, eSpellFail);
		eLINK = ExtraordinaryEffect(eLINK);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLINK, oPC);
		FloatingTextStringOnCreature("*Defensive Stance ON*", oPC, FALSE);
		ResetFeatUses(oPC, GetSpellFeatId(), TRUE, TRUE); //Cooldown triggers only on deactivation
	}
}