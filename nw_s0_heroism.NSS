//::///////////////////////////////////////////////
//:: Heroism
//:: NW_S0_Heroism.nss
//:://////////////////////////////////////////////
/*
    Target gets a +2 morale bonus to Attack, saves,
    and skill checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 11, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


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
	
	object oTarget	= GetSpellTargetObject();
	object oCaster	= OBJECT_SELF;
	
	if (GetHasSpellEffect(SPELL_GREATER_HEROISM, oTarget) || 
		!GetIsObjectValid(oTarget) ||
		!spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) 
			return;


    //Declare major variables
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl * 10);
	
    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eAttack = EffectAttackIncrease(2);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 2);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HEROISM );
	effect eLink = EffectLinkEffects(eAttack, eSave);
	eLink = EffectLinkEffects(eSkill, eLink);
	eLink = EffectLinkEffects(eDur, eLink);
	eLink = SetEffectSpellId(eLink, SPELL_HEROISM);

	RemoveEffectsFromSpell(oTarget, SPELL_ANIMALISTIC_POWER);	
	RemoveEffectsFromSpell(oTarget, SPELL_HEROISM); //857

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HEROISM, FALSE));

	//Apply the VFX impact and effects
	//ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    
}