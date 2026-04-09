/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up plant state - for myconids */

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
		effect eMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
		effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
		effect eSleep = EffectImmunity(IMMUNITY_TYPE_SLEEP);
		effect eStun = EffectImmunity(IMMUNITY_TYPE_STUN);
		effect ePara = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
		effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
		effect eCritical = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);

		effect eLink = EffectLinkEffects(eMind, ePoison);
		eLink = EffectLinkEffects(eSleep, eLink);
		eLink = EffectLinkEffects(ePara, eLink);
		eLink = EffectLinkEffects(eCritical, eLink);
		eLink = EffectLinkEffects(eStun, eLink);
		eLink = EffectLinkEffects(eEntangle, eLink);
		
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}	
}