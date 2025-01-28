/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up undead state */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	/* Should any condition in spellscript ever stop a Racial ability? I don't think so. -FF
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }*/

    object oTarget = GetSpellTargetObject();
	
	effect eMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	effect eAcid = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100);
	effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
	effect eCharm = EffectImmunity(IMMUNITY_TYPE_CHARM);
	effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, 20, 0);
	effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 20, 0);
	effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 20, 0);
	effect eDR = EffectDamageReduction(15, DAMAGE_POWER_PLUS_THREE, 0, DR_TYPE_MAGICBONUS);
	effect eLie = EffectSkillIncrease(SKILL_BLUFF, 6);

	effect eLink = EffectLinkEffects(eMind, eAcid);
	eLink = EffectLinkEffects(ePoison, eLink);
	eLink = EffectLinkEffects(eCharm, eLink);
	eLink = EffectLinkEffects(eFire, eLink);
	eLink = EffectLinkEffects(eCold, eLink);
	eLink = EffectLinkEffects(eElec, eLink);
	eLink = EffectLinkEffects(eDR, eLink);
	eLink = EffectLinkEffects(eLie, eLink);

	eLink = SupernaturalEffect(eLink);
	int nSpell = GetSpellId();
	SetEffectSpellId(eLink, nSpell);
	RemoveEffectsFromSpell(oTarget, nSpell);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
		
}