//::///////////////////////////////////////////////
//:: Invocation: Entropic Warding
//:: NW_S0_IEntrWard.nss
//:://////////////////////////////////////////////
/*
    Gives +4 Move Silently and Hide Skill Bonuses,
    and gives effect of Entropic Shield (Cleric)
    Spell:

    20% concealment to ranged attacks including
    ranged spell attacks
    Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: JLR - OEI 08/24/05 -- Metamagic changes
//:: Mimi Fearthegn 7/26/20 - Adding scaling based on level


#include "nwn2_inc_spells"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 

void main() {

	/* 
	  Spellcast Hook Code 
	  Added 2003-06-20 by Georg
	  If you want to make changes to all spells,
	  check x2_inc_spellhook.nss to find out more
	  
	*/
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    //Declare major variables
    object oTarget = OBJECT_SELF;
	int nCasterLevel = GetWarlockCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(GetCasterLevel(OBJECT_SELF));
	int nSkillBuff = (nCasterLevel/4);
	if (nSkillBuff < 1)
		nSkillBuff = 1;
	nSkillBuff = nSkillBuff+3;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the four unique armor bonuses
    effect eShield =  EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_ENTROPIC_SHIELD);	// Using the same VFX as entropic shield
    effect eMoveSilently = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nSkillBuff);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, nSkillBuff);
    effect eLink = EffectLinkEffects(eShield, eDur);
    eLink = EffectLinkEffects(eLink, eMoveSilently);
    eLink = EffectLinkEffects(eLink, eHide);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}