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
		effect eSAVE = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
		effect eSTILL = EffectCutsceneImmobilize();
		effect eVFX = EffectVisualEffect(VFX_DUR_IOUN_STONE_CON);
		effect eLINK = EffectLinkEffects(eKNOCK, eAC);
		eLINK = EffectLinkEffects(eLINK, eSAVE);
		eLINK = EffectLinkEffects(eLINK, eSTILL);
		eLINK = EffectLinkEffects(eLINK, eVFX);
		eLINK = ExtraordinaryEffect(eLINK);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLINK, oPC);
		FloatingTextStringOnCreature("*Defensive Stance ON*", oPC, FALSE);
		ResetFeatUses(oPC, GetSpellFeatId(), TRUE, TRUE); //Cooldown triggers only on deactivation
	}
}