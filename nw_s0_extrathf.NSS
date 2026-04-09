//::///////////////////////////////////////////////
//:: Rogues Cunning AKA Potion of Extra Theiving
//:: NW_S0_ExtraThf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the user +10 Search, Disable Traps and
    Move Silently, Open Lock (+5), Pick Pockets
    Set Trap for 5 Turns
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: November 9, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode()) return;
	
	int nMod = 5;
	int nDur = 10 * PS_GetCasterLevel(OBJECT_SELF);
	int nMetaMagic = GetMetaMagicFeat();


	if (nMetaMagic == METAMAGIC_EXTEND) nDur *= 2;
	if (nMetaMagic == METAMAGIC_EMPOWER) nMod += nMod / 2;
   

    object oTarget = GetSpellTargetObject();
    effect eDisable = EffectSkillIncrease(SKILL_DISABLE_TRAP, nMod);
	effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nMod);
	effect eHide = EffectSkillIncrease(SKILL_HIDE, nMod);
	effect eOpen = EffectSkillIncrease(SKILL_OPEN_LOCK, nMod);
    effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nMod);
    effect ePick = EffectSkillIncrease(SKILL_SLEIGHT_OF_HAND, nMod);
    effect eTrap = EffectSkillIncrease(SKILL_SET_TRAP, nMod);
    
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    //Link Effects
    effect eLink = EffectLinkEffects(eMove, eDisable);
	eLink = EffectLinkEffects(eLink, eHide);
	eLink = EffectLinkEffects(eLink, eOpen);
    eLink = EffectLinkEffects(eLink, eSearch);
    eLink = EffectLinkEffects(eLink, ePick);
    eLink = EffectLinkEffects(eLink, eTrap);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDur));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
