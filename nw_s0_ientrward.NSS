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


#include "ps_inc_invocations" 


void main(){
	DoSelfOnlyInvocation(SPELL_I_ENTROPIC_WARDING);
}

/*
void main() {


    if (!X2PreSpellCastCode())
        return;
    
	
    //Declare major variables
    object oTarget = OBJECT_SELF;
	int nCasterLevel = GetWarlockCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(GetCasterLevel(OBJECT_SELF));
	int nSkillBuff = (nCasterLevel/4);
	if (nSkillBuff < 1)
		nSkillBuff = 1;
	nSkillBuff = nSkillBuff+3;

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the four unique armor bonuses
    effect eShield =  EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMoveSilently = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nSkillBuff);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, nSkillBuff);
	effect eLink = EffectLinkEffects(eShield, eMoveSilently);
    eLink = EffectLinkEffects(eHide, eLink);
  
	
	
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_ENTROPIC_SHIELD);
	eLink = EffectLinkEffects(eDur, eLink);
	 //Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
   
}
*/