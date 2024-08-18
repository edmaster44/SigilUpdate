/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up undead state */

// FlattedFifth, Aug 17, 2024: Removed spellhook code because there's no condition in spellhook that
// should ever interfere with an undead having undead properties. If for any reason we want to put 
// the spellhook back in, suggest having this script get the feat id and if the feat id = 2344 
// (undead properties feat) then ignore spellhook, like 
// if (!X2PreSpellCastCode && GetSpellFeatId() != 2344) return;

//#include "nw_i0_spells"
//#include "x2_inc_spellhook"

void main()
{
	//SpeakString("Firing Aura");
	/*
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	// unless it's from the permanent feat that undead pcs get.
        return;
    }
	*/
    object oTarget = GetSpellTargetObject();
	
    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		effect eMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
		effect eCharm = EffectImmunity(IMMUNITY_TYPE_CHARM);
		effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
		effect eSleep = EffectImmunity(IMMUNITY_TYPE_SLEEP);
		effect ePara = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
		effect eDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
		effect eCritical = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
		effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
		effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
		effect eAbility = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
		effect eDisease = EffectImmunity(IMMUNITY_TYPE_DISEASE);

		effect eLink = EffectLinkEffects(eMind, eCharm);
		eLink = EffectLinkEffects(ePoison, eLink);
		eLink = EffectLinkEffects(eSleep, eLink);
		eLink = EffectLinkEffects(ePara, eLink);
		eLink = EffectLinkEffects(eDeath, eLink);
		eLink = EffectLinkEffects(eCritical, eLink);
		eLink = EffectLinkEffects(eSneak, eLink);
		eLink = EffectLinkEffects(eLevel, eLink);
		eLink = EffectLinkEffects(eAbility, eLink);
		eLink = EffectLinkEffects(eDisease, eLink);
		
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}	
}