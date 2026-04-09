//::///////////////////////////////////////////////
//:: Restoration
//:: NW_S0_Restore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all negative effects unless they come
    from Poison, Disease or Curses.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
// DBR 8/31/06 - RemoveEffect() messes up the iterators, start from beginning of list if RemoveEffect Occurs.
// Aug 20, 2024 FlattedFifth -  Streamlined Code by reducing the number of external function calls from 36 
//				per effect on target to 3. Introduced function call in spellhook to check for effects that
//				include some negative aspects but should NOT be removed due to them being racial, class feats
//				beneficial spells that are only partly negative, etc. Removed checks that are now redundant due
//				to aforementioned. 

#include "x2_inc_spellhook" 

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
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
   // int bValid;
   	int eType;
	int nId;

    effect eBad = GetFirstEffect(oTarget);
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
            eType == EFFECT_TYPE_PARALYZE ||
            eType == EFFECT_TYPE_NEGATIVELEVEL) &&
			!GetSkipByRestoration(nId)
			/* the following are redundant since the addition of the more expansive
			function call above
            nId != SPELL_ENLARGE_PERSON &&
            nId != SPELL_RIGHTEOUS_MIGHT &&
            nId != SPELL_STONE_BODY &&
            nId != SPELL_IRON_BODY &&
			nId != 803 &&
			nId != 2881 &&
			nId != 2000 &&
			nId != 2001 &&
			nId != 1515 &&//Half-Undead
			nId != 1927 &&//Dervish Dance
			nId != 2002 &&
			nId != 2003 &&
			nId != 2004
			*/
			)
            {
                //Remove effect if it is negative.
                //if(!GetIsSupernaturalCurse(eBad))	// THIS IS HOTU-SPECIFIC AND ISN'T RELEVANT TO NWN2
                RemoveEffect(oTarget, eBad);
				eBad = GetFirstEffect(oTarget);
            }
			else
        		eBad = GetNextEffect(oTarget);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}

int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}