//::///////////////////////////////////////////////
//:: Greater Restoration
//:: NW_S0_GrRestore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all negative effects of a temporary nature
    and all permanent effects of a supernatural nature
    from the character. Does not remove the effects
    relating to Mind-Affecting spells or movement alteration.
    Heals target for 5d8 + 1 point per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
// DBR 8/31/06 - RemoveEffect() messes up the iterators, start from beginning of list if RemoveEffect Occurs.
// Aug 20, 2024 FlattedFifth -  Streamlined Code by reducing the number of external function calls from 36 
//				per effect on target to 3. Introduced function call in spellhook to check for effects that
//				include some negative aspects but should NOT be removed due to them being racial, class feats
//				beneficial spells that are only partly negative, etc. Removed checks that are now redundant due
//				to aforementioned. Added Harm spell effect to heal undead.


#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"

// return TRUE if the effect created by a supernatural force and can't be dispelled by spells
int GetIsSupernaturalCurse(effect eEff);

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
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);
    effect eBad = GetFirstEffect(oTarget);
	int eType;
	int nId;
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
		eType = GetEffectType(eBad);
		nId = GetEffectSpellId(eBad);
        if ((eType == EFFECT_TYPE_ABILITY_DECREASE ||
            eType == EFFECT_TYPE_AC_DECREASE ||
            eType == EFFECT_TYPE_ATTACK_DECREASE ||
            eType == EFFECT_TYPE_DAMAGE_DECREASE ||
            eType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            eType == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            eType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            eType == EFFECT_TYPE_SKILL_DECREASE ||
            eType == EFFECT_TYPE_BLINDNESS ||
            eType == EFFECT_TYPE_DEAF ||
            eType == EFFECT_TYPE_CURSE ||
            eType == EFFECT_TYPE_DISEASE ||
            eType == EFFECT_TYPE_POISON ||
            eType == EFFECT_TYPE_PARALYZE ||
            eType == EFFECT_TYPE_CHARMED ||
            eType == EFFECT_TYPE_DOMINATED ||
            eType == EFFECT_TYPE_DAZED ||
            eType == EFFECT_TYPE_CONFUSED ||
            eType == EFFECT_TYPE_FRIGHTENED ||
            eType == EFFECT_TYPE_NEGATIVELEVEL ||
            eType == EFFECT_TYPE_PARALYZE ||
            eType == EFFECT_TYPE_SLOW ||
            eType == EFFECT_TYPE_STUNNED) &&
			!GetSkipByRestoration(nId)
			/* All the below checks are now made by the above, more thorough
				function call.
            nId != SPELL_ENLARGE_PERSON &&
            nId != SPELL_RIGHTEOUS_MIGHT &&
            nId != SPELL_STONE_BODY &&
            nId != SPELL_IRON_BODY &&
            nId != 803 && //grey dwarf enlarge
			nId != 2881 && // defensive stance
			nId != 2000 && //background stern
			nId != 2001 && // background misdirector
			nId != 1515 &&//Half-Undead
			nId != 1927 &&//Dervish Dance
			nId != 2002 && // background tinker
			nId != 2003 && //background naturalist
			nId != 2004 && // background amicable
			*/
			)
        {
            //Remove effect if it is negative.
            //if(!GetIsSupernaturalCurse(eBad))	// HOTU-SPECIFIC
			RemoveEffect(oTarget, eBad);
			eBad = GetFirstEffect(oTarget);
		}
		else
			eBad = GetNextEffect(oTarget);
    }
    if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        //Apply the VFX impact and effects
        int nHeal = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
        effect eHeal = EffectHeal(nHeal);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    } else {
		HealHarmTarget(oTarget, 30, SPELL_HARM, FALSE, FALSE);
	}
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_RESTORATION, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}

int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}