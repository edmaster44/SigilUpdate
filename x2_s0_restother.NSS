//::///////////////////////////////////////////////
//:: Restoration
//:: x2_s0_restother.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all negative effects unless they come
    from Poison, Disease or Curses.
    Can only be cast on Others - not on oneself.
    Caster takes 5 points of damage when this
    spell is cast.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 3/03
//:://////////////////////////////////////////////
//::
// Aug 20, 2024 FlattedFifth -  Streamlined Code by reducing the number of external function calls from 36 
//				per effect on target to 3. Introduced function call in spellhook to check for effects that
//				include some negative aspects but should NOT be removed due to them being racial, class feats
//				beneficial spells that are only partly negative, etc. Removed checks that are now redundant due
//				to aforementioned. 

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-07-07 by Georg Zoeller
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
    effect eVisual = PS_EffectVisualEffect(VFX_IMP_RESTORATION);
    // int bValid; // this integer is not used
	int eType;
	int nId;
    if (oTarget != OBJECT_SELF)
    {
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
				/* The below checks are now made by the above, more thorough
					function call
				nId != SPELL_ENLARGE_PERSON &&
				nId != SPELL_RIGHTEOUS_MIGHT &&
				nId != SPELL_STONE_BODY &&
				nId != SPELL_IRON_BODY
				*/
				)
                {
                    //Remove effect if it is negative.
					RemoveEffect(oTarget, eBad);
					eBad = GetFirstEffect(oTarget);
				}
				else
					eBad = GetNextEffect(oTarget);
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
        
        //Apply Damage Effect to the Caster
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(5), OBJECT_SELF);
    }
}