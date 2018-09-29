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
	int nSubRace = GetSubRace(oTarget);
	
    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		
		effect eElec = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
		effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
		effect eBanish = EffectSpellImmunity(SPELL_BANISHMENT);
		effect eDismiss = EffectSpellImmunity(SPELL_DISMISSAL);
		effect eDismissR = EffectSpellImmunity(1686);
		effect eGBind = EffectSpellImmunity(SPELL_GREATER_PLANAR_BINDING);
		effect eLBind = EffectSpellImmunity(SPELL_LESSER_PLANAR_BINDING);
		effect eBind = EffectSpellImmunity(SPELL_PLANAR_BINDING);
		effect eFire = EffectDamageResistance(DAMAGE_TYPE_SONIC, 20, 0);
		effect eCold = EffectDamageResistance(DAMAGE_TYPE_ACID, 20, 0);
		effect eCraft = EffectSkillIncrease(SKILL_CRAFT_ARMOR, 2);
		effect eCraft2 = EffectSkillIncrease(SKILL_CRAFT_WEAPON, 2);
		effect eCraft3 = EffectSkillIncrease(SKILL_CRAFT_ALCHEMY, 2);
		effect eCraft4 = EffectSkillIncrease(SKILL_CRAFT_TRAP, 2);
		

		effect eLink = EffectLinkEffects(eElec, eBanish);
		eLink = EffectLinkEffects(ePoison, eLink);
		eLink = EffectLinkEffects(eDismiss, eLink);
		eLink = EffectLinkEffects(eDismissR, eLink);
		eLink = EffectLinkEffects(eFire, eLink);
		eLink = EffectLinkEffects(eCold, eLink);
		eLink = EffectLinkEffects(eGBind, eLink);
		eLink = EffectLinkEffects(eLBind, eLink);
		eLink = EffectLinkEffects(eBind, eLink);
		
		if (nSubRace == 190)
		{
			eLink = EffectLinkEffects(eCraft, eLink);
			eLink = EffectLinkEffects(eCraft2, eLink);
			eLink = EffectLinkEffects(eCraft3, eLink);
			eLink = EffectLinkEffects(eCraft4, eLink);
		}
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}	
}