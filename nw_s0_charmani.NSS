//::///////////////////////////////////////////////
//:: [Charm Person or Animal]
//:: [NW_S0_DomAni.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////

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
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);
    //Link the charm and duration visual effects
    effect eLink = EffectLinkEffects(eVis, eCharm);
    
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    int nDuration = 2 + nCasterLevel/3;
	int nSelfDuration = 15 + nCasterLevel;
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = GetRacialType(oTarget);
    //Meta magic duration check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
		nSelfDuration *= 2;
    }
	
	int nDC = GetSpellSaveDC();
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
		eSkill = EffectLinkEffects(EffectSkillIncrease(SKILL_SURVIVAL, nBonus), eSkill);
		eSkill = SetEffectSpellId(eSkill, SPELL_CHARM_PERSON);
		SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON, FALSE));
		PS_RemoveEffects(OBJECT_SELF, SPELL_CHARM_PERSON, EFFECT_TYPE_SKILL_INCREASE, OBJECT_SELF);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, OBJECT_SELF, TurnsToSeconds(nSelfDuration));
	} else if (GetIsPC(oTarget)){
		if (!ResistCheck(oTarget, nDC, OBJECT_SELF)){
			sMessage = sName + " has cast Charm Person or Animal on you but you are not IC aware of it.";
			sMessage += "\nNote that this is NOT domination. It ONLY makes your character like" + sName + ".";
			sMessage += "\nIf " +sName+ " does anything that would normally make someone dislike them, ";
			sMessage += "you will dislike them. Your free will is unaffected.";
		} else {
			sMessage = sName + " has attempted to cast Charm Person or Animal on you but failed.";
			sMessage += "\nNote that the spell would have made you like " +sName;
			sMessage += " but not otherwise affected your free will, had it succeeded.";
			sMessage += "\nThis information may guide roleplaying your reaction to the failed attempt.";
		}
		SendMessageToPC(oTarget, sMessage);
	} else if (GetIsPC(GetMaster(oTarget))){
		object oMaster = GetMaster(oTarget);
		if (!ResistCheck(oTarget, nDC, OBJECT_SELF)){
			sMessage = sName + " has cast Charm Person or Animal on your companion but your companion is not aware of it.";
			sMessage += "\nWhether or not YOU are aware of it depends upon your Spellcraft skill. You might be aware of it, you might only be aware that SOME kind of spell was cast. Use your own judgement.";
			sMessage += "\nNote that this is NOT domination. It ONLY makes your companion like" + sName + ".";
			sMessage += "\nIf " +sName+ " does anything that would normally make someone dislike them, ";
			sMessage += "your companion will dislike them. Their free will is unaffected.";
		} else {
			sMessage = sName + " has attempted to cast Charm Person or Animal on your companion but failed.";
			sMessage += "\nNote that the spell would have made your companion like " +sName;
			sMessage += " but not otherwise affected their free will, had it succeeded.";
			sMessage += "\nThis information may guide roleplaying your reaction to the failed attempt.";
		}
		SendMessageToPC(oMaster, sMessage);
	} else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)){
        //Fire spell cast at event to fire on the target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON_OR_ANIMAL, FALSE));
		//Make sure the racial type of the target is applicable
		if  (GetIsPlayableRacialType(oTarget) ||
			(nRacial == RACIAL_TYPE_DWARF) ||
			(nRacial == RACIAL_TYPE_ANIMAL) ||
			(nRacial == RACIAL_TYPE_ELF) ||
			(nRacial == RACIAL_TYPE_GNOME) ||
			(nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
			(nRacial == RACIAL_TYPE_HALFLING) ||
			(nRacial == RACIAL_TYPE_HUMAN) ||
			(nRacial == RACIAL_TYPE_HALFELF) ||
			(nRacial == RACIAL_TYPE_HALFORC) ||
			(nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
			(nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
			(nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
		{
			//Make Will Save
			if (!ResistCheck(oTarget, GetSpellSaveDC(), OBJECT_SELF))
			{
				//Apply impact effects and linked duration and charm effect
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
			}
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
	if (bResisted) sMessage = "Target resisted Charm Person or Animal";
	else sMessage = "Target failed to resist Charm Person or Animal";
	SendMessageToPC(oCaster, sMessage);
	return bResisted;
}