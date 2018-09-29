/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up undead state */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	
    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		effect eDrown = EffectSpellImmunity(SPELL_DROWN);
		effect eMassDrown = EffectSpellImmunity(SPELL_MASS_DROWN);
		effect eDrownAura = EffectSpellImmunity(SPELL_DROWNED_AURA);
		effect eDrownPulse = EffectSpellImmunity(SPELLABILITY_PULSE_DROWN);
		effect eSwampLung = EffectSpellImmunity(SPELL_SWAMP_LUNG);
		effect eColdRes = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
		effect eFireWea = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 25);
		effect eMassDrownMarid = EffectSpellImmunity(1673);

		effect eLink = EffectLinkEffects(eDrown, eMassDrown);
		eLink = EffectLinkEffects(eDrownAura, eLink);
		eLink = EffectLinkEffects(eDrownPulse, eLink);
		eLink = EffectLinkEffects(eSwampLung, eLink);
		eLink = EffectLinkEffects(eColdRes, eLink);
		eLink = EffectLinkEffects(eFireWea, eLink);
		eLink = EffectLinkEffects(eMassDrownMarid, eLink);
		
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}	
}