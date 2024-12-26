//::///////////////////////////////////////////////
//:: [Charm Person]
//:: [NW_S0_CharmPer.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 5, 2001
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: RPGplayer1 12/20/2008:
//::  Use total character level, for racial version
//::  Use charisma based DC, for racial version (per PnP)
//:: RPGplayer1 01/05/2009: Will affect all playable humanoids (Planetouched, Grey Orcs, Yuan-ti)

#include "x0_I0_SPELLS"    
#include "x2_inc_spellhook" 

int ResistCheck(object oTarget, int nDC, object oCaster);

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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CHARM_PERSON);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);

    //Link persistant effects
    effect eLink = EffectLinkEffects(eVis, eCharm);

    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    int nDC = GetSpellSaveDC();

	//Has same SpellId as Charm Person, not an item, but returns no valid class -> it's racial ability
	if (GetSpellId() == SPELL_CHARM_PERSON && !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID)
	{
		nCasterLevel = GetHitDice(OBJECT_SELF);
		nDC = 10 + GetSpellLevel(SPELL_CHARM_PERSON) + GetAbilityModifier(ABILITY_CHARISMA);
	}

    int nDuration = 2 + nCasterLevel/3;
	int nSelfDuration = 15 + nCasterLevel;
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = GetRacialType(oTarget);
    //Make Metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
		nSelfDuration *= 2;
    }
	
	string sName = GetFirstName(OBJECT_SELF);
	string sLast = GetLastName(OBJECT_SELF);
	if (sLast != "") sName += " " + sLast;
	string sMessage = "";
	if (oTarget == OBJECT_SELF){
		int nBonus = nCasterLevel;
		if (nBonus > 10) nBonus = 10;
		if (nMetaMagic == METAMAGIC_EMPOWER) nBonus += nBonus / 2;
		effect eSkill = EffectSkillIncrease(SKILL_BLUFF, nBonus);
		eSkill = EffectLinkEffects(EffectSkillIncrease(SKILL_DIPLOMACY, nBonus), eSkill);
		eSkill = EffectLinkEffects(EffectSkillIncrease(SKILL_PERFORM, nBonus), eSkill);
		eSkill = SetEffectSpellId( eSkill, SPELL_CHARM_PERSON);
		SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON, FALSE));
		PS_RemoveEffects(OBJECT_SELF, SPELL_CHARM_PERSON, EFFECT_TYPE_SKILL_INCREASE, OBJECT_SELF);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, OBJECT_SELF, TurnsToSeconds(nSelfDuration));
	} else if (GetIsPC(oTarget)){
		if (!ResistCheck(oTarget, nDC, OBJECT_SELF)){
			sMessage = sName + " has cast Charm Person on you but you are not IC aware of it.";
			sMessage += "\nNote that this is NOT domination. It ONLY makes your character like" + sName + ".";
			sMessage += "\nIf " +sName+ " does anything that would normally make someone dislike them, ";
			sMessage += "you will dislike them. Your free will is unaffected.";
		} else {
			sMessage = sName + " has attempted to cast Charm Person on you but failed.";
			sMessage += "\nNote that the spell would have made you like " +sName;
			sMessage += " but not otherwise affected your free will, had it succeeded.";
			sMessage += "\nThis information may guide roleplaying your reaction to the failed attempt.";
		}
		SendMessageToPC(oTarget, sMessage);
	} else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)){
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON, FALSE));
		//Verify that the Racial Type is humanoid
		if  (GetIsPlayableRacialType(oTarget) ||
			(nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
			(nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
			(nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
			(nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
		{
			if (!ResistCheck(oTarget, nDC, OBJECT_SELF))
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
		}
    } else SendMessageToPC(OBJECT_SELF, "Invalid target");
}

int ResistCheck(object oTarget, int nDC, object oCaster){
	int bResisted = FALSE;
	if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) ||
		GetIsImmune(oTarget, IMMUNITY_TYPE_CHARM, oCaster)) bResisted = TRUE;
	if (!bResisted && MyResistSpell(oCaster, oTarget)) bResisted = TRUE;
	if (!bResisted && MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		bResisted = TRUE;
	
	string sMessage;
	if (bResisted) sMessage = "Target resisted Charm Person";
	else sMessage = "Target failed to resist Charm Person";
	SendMessageToPC(oCaster, sMessage);
	return bResisted;
}		
	

