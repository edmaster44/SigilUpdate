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
		int nHD = GetHitDice(oTarget);
		int nSR = 20 + nHD;
		effect eDR = EffectDamageImmunityDecrease(DAMAGE_TYPE_PIERCING, 50);
		effect eDR2 = EffectDamageReduction(15, ALIGNMENT_GOOD, 0, DR_TYPE_ALIGNMENT);
		effect eLie = EffectSkillIncrease(SKILL_BLUFF, 4);
		effect eSR = EffectSpellResistanceIncrease(nSR, -1);

		effect eLink = EffectLinkEffects(eDR, eDR2);
		eLink = EffectLinkEffects(eLie, eLink);
		eLink = EffectLinkEffects(eSR, eLink);
		
	
		
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}	
}