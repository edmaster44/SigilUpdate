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
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CHARM_PERSON);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);

    //Link persistant effects
    effect eLink = EffectLinkEffects(eVis, eCharm);

    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PS_GetCasterLevel(oCaster);
    int nDC = GetSpellSaveDC();

	//Has same SpellId as Charm Person, not an item, but returns no valid class -> it's racial ability
	if (GetSpellId() == SPELL_CHARM_PERSON && !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID)
	{
		nCasterLevel = PS_GetLevel(oCaster);
		nDC = 10 + GetSpellLevel(SPELL_CHARM_PERSON) + GetAbilityModifier(ABILITY_CHARISMA);
	}

    int nDuration = 2 + nCasterLevel/3;
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = GetRacialType(oTarget);
    //Make Metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
		nCasterLevel *= 2;
    }
	
	if (oTarget == oCaster){
		int nBonus = nCasterLevel;
		if (nBonus > 10) nBonus = 10;
		if (nMetaMagic == METAMAGIC_EMPOWER) nBonus += nBonus / 2;
		effect eSkill = EffectSkillIncrease(SKILL_BLUFF, nBonus);
		eSkill = EffectLinkEffects(EffectSkillIncrease(SKILL_DIPLOMACY, nBonus), eSkill);
		eSkill = EffectLinkEffects(EffectSkillIncrease(SKILL_PERFORM, nBonus), eSkill);
		eSkill = SetEffectSpellId( eSkill, SPELL_CHARM_PERSON);
		SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_CHARM_PERSON, FALSE));
		PS_RemoveEffects(oCaster, SPELL_CHARM_PERSON, EFFECT_TYPE_SKILL_INCREASE, oCaster);
		PS_RemoveEffects(oCaster, 1320, EFFECT_TYPE_SKILL_INCREASE, oCaster); // vampire gaze to boost skills
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, oCaster, HoursToSeconds(nCasterLevel));
	} else if (GetIsPC(oTarget) && GetIsPC(oCaster) && oTarget != oCaster){
		string sCasterMessage = "<c=orange>";
		string sTargetMessage = "<c=orange>";
		string sName = GetFirstName(oCaster);
		string sLast = GetLastName(oCaster);
		if (sLast != "") sName += " " + sLast;
		string sTargetName = GetFirstName(oTarget);
		string sTargetLast = GetLastName(oTarget);
		if (sTargetLast != "") sTargetName += " " + sTargetLast;
		if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster)){
			sCasterMessage += sTargetName + " is immune to mind spells!";
			sTargetMessage += sName + " tried to dominate you but you're immune.";
		} else if (!ResistCheck(oTarget, nDC, oCaster) && 
				MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, 1.0) < 1){
			sCasterMessage += "You have succeeded in casting Charm Person on " + sTargetName + ".";
			sCasterMessage += "\nNote that this is NOT domination. It ONLY makes " + sTargetName + " like you.";
			sCasterMessage += "\nIf you do anything that would normally make someone dislike you, the effect will end.";
			sCasterMessage += "\nTheir free will is unaffected.";
			sTargetMessage += sName + " has cast Charm Person on you but you are not IC aware of it.";
			sTargetMessage += "\nThis is NOT domination. It ONLY makes your character like" + sName + ".";
			sTargetMessage += "\nIf " +sName+ " does anything that would normally make someone dislike them, ";
			sTargetMessage += "you will dislike them. Your free will is unaffected.";
		} else {
			sCasterMessage += sTargetName + " has resisted your attempt to charm them.";
			sCasterMessage += "\nThey are IC aware of the attempt.";
			sTargetMessage += sName + " has attempted to cast Charm Person on you but failed.";
			sTargetMessage += "\nNote that the spell would have made you like " +sName;
			sTargetMessage += " but not otherwise affected your free will, had it succeeded.";
			sTargetMessage += "\nThis information may guide roleplaying your reaction to the failed attempt.";
		}
		sCasterMessage += "\n(Note that you cannot force RP upon another player. If they tell you they do not wish";
		sCasterMessage += " to engage in RP related to your actions, you MUST retcon this use of charm person and RP ";
		sCasterMessage += "as if nothing happened, and you must not attempt it again.</c>";
		sTargetMessage += "\n(Note that no one can force RP upon you. If you do not wish to RP this effect ";
		sTargetMessage += "then tell " + sName + " that you do not wish to RP this and they MUST retcon ";
		sTargetMessage += "their actions and you both must RP as if nothing happened.</c>";
		SendMessageToPC(oCaster, sCasterMessage);
		SendMessageToPC(oTarget, sTargetMessage);
	} else if (spellsIsTarget(oTarget, SPELL_TARGET_NON_ALLIED, oCaster)){
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CHARM_PERSON, TRUE));
		//Verify that the Racial Type is humanoid
		if  (GetIsPlayableRacialType(oTarget) ||
			(nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
			(nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
			(nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
			(nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
		{
			if (!ResistCheck(oTarget, nDC, oCaster))
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
		}
    } else SendMessageToPC(oCaster, "Invalid target");
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
	