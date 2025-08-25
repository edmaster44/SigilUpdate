//::///////////////////////////////////////////////
//:: True Seeing
//:: NW_S0_TrueSee.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature can seen all invisible, sanctuared,
    or hidden opponents.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: [date]
//:://////////////////////////////////////////////
//:: PKM-OEI: 07.08.06- VFX pass, removed NWN1 and redundant VFX
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
	int nDuration = PS_GetCasterLevel(OBJECT_SELF);
	int nMetaMagic = GetMetaMagicFeat();
	int nSightBonus = 10;
	if (nMetaMagic == METAMAGIC_EMPOWER) nSightBonus = 15;
	if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
	int nId = GetSpellId();
	//Declare major variables
    object oTarget = GetSpellTargetObject();
	//effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);//NWN1 VFX
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_TRUE_SEEING);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSight = EffectTrueSeeing();
    effect eLink = EffectLinkEffects(eVis, eSight);
    eLink = EffectLinkEffects(eLink, eDur);
	eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_BLINDNESS), eLink);
	eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SEARCH, nSightBonus), eLink);
	eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, nSightBonus), eLink);
	eLink = SetEffectSpellId(eLink, nId); 
	
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TRUE_SEEING, FALSE));
    
    //Apply the VFX impact and effects
	RemoveEffect(oTarget, EffectNewBlindness());
	PS_RemoveEffects(oTarget, nId);
	PS_RemoveEffects(oTarget, SPELL_DARKNESS, EFFECT_TYPE_MISS_CHANCE);
	PS_RemoveEffects(oTarget, SPELL_DARKNESS, EFFECT_TYPE_SKILL_DECREASE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}