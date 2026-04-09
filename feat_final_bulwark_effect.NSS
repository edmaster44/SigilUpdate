#include "nw_i0_spells"
const int N_BULWARK = 2882;

void RemoveBulwark(object oTARGET, object oCASTER)
{
	if (GetHasSpellEffect(N_BULWARK, oTARGET)==TRUE) RemoveSpellEffects(N_BULWARK, oCASTER, oTARGET);
}

void ApplyBulwark(object oCASTER, object oTARGET, object oAURA)
{
	int nCON = GetAbilityModifier(ABILITY_CONSTITUTION, oCASTER);
	effect eSHARE = EffectShareDamage(oAURA, 90-nCON, 0);
	effect eVFX = EffectDamageImmunityIncrease(DAMAGE_TYPE_ALL, 10+nCON);
	effect eFX = EffectLinkEffects(eSHARE, eVFX);
	eFX = ExtraordinaryEffect(eFX);
	eFX = SetEffectSpellId(eFX, N_BULWARK);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oTARGET);
}

void ApplyAura(object oPC)
{
	effect eAURA = EffectAreaOfEffect(180);
	eAURA = ExtraordinaryEffect(eAURA);
	eAURA = SetEffectSpellId(eAURA, N_BULWARK);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAURA, oPC);
}