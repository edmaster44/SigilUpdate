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
		effect ePetrify = EffectSpellImmunity(SPELL_FLESH_TO_STONE);
		effect eStoneHold = EffectSpellImmunity(SPELL_STONEHOLD);
		effect eEarthquake = EffectSpellImmunity(SPELL_EARTHQUAKE);
		effect eEarthBreath = EffectSpellImmunity(1677);
		effect ePetBreath = EffectSpellImmunity(495);
		effect ePetWord = EffectSpellImmunity(1012);
		effect ePetEye = EffectSpellImmunity(1359);
		effect ePetGaze = EffectSpellImmunity(497);
		effect eStability = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
		

		effect eLink = EffectLinkEffects(ePetrify, eStoneHold);
		eLink = EffectLinkEffects(eEarthquake, eLink);
		eLink = EffectLinkEffects(eStability, eLink);
		eLink = EffectLinkEffects(eEarthBreath, eLink);
		eLink = EffectLinkEffects(ePetBreath, eLink);
		eLink = EffectLinkEffects(ePetGaze, eLink);
		eLink = EffectLinkEffects(ePetWord, eLink);
		eLink = EffectLinkEffects(ePetEye, eLink);
		
	
		
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}	
}