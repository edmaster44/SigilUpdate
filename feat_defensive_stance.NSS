#include "nw_i0_spells"

void main()
{
	object oPC = OBJECT_SELF;
	int nID = GetSpellId();
	if (GetHasSpellEffect(nID, oPC)==TRUE)
	{
		RemoveEffectsFromSpell(oPC, nID);
		FloatingTextStringOnCreature("*Defensive Stance OFF*", oPC, FALSE);
	}
	else
	{
		effect eKNOCK = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
		effect eAC = EffectACIncrease(4);
		effect eSTILL = EffectDamageDecrease(5);
		effect eLINK = EffectLinkEffects(eKNOCK, eAC);
		eLINK = EffectLinkEffects(eLINK, eSTILL);
		eLINK = ExtraordinaryEffect(eLINK);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLINK, oPC);
		FloatingTextStringOnCreature("*Defensive Stance ON*", oPC, FALSE);
		ResetFeatUses(oPC, GetSpellFeatId(), TRUE, TRUE); //Cooldown triggers only on deactivation
	}
}