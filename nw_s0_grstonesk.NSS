//::///////////////////////////////////////////////
//:: Greater Stoneskin
//:: NW_S0_GrStoneSk
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the gives the creature touched 20/Adamantine
    damage reduction.  This lasts for 1 hour per
    caster level or until 10 * Caster Level (150 Max)
    is dealt to the person.  -FlattedFifth changed to 200 max, June 4 2024
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs March 4, 2003


// (Update JLR - OEI 07/22/05) -- Changed Damage Reduction
// Flatted Fifth June 4, 2024 - Changed dr to absorb 200, not 150,
//					changed call from GetCasterLevel to PS_GetCasterLevel

#include "ps_inc_functions"


#include "nw_i0_spells"
#include "x2_inc_spellhook" 

void main()
{

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

// End of Spell Cast Hook


    //Declare major variables
    int nAmount = PS_GetCasterLevel(OBJECT_SELF);
    int nDuration = nAmount;
    object oTarget = GetSpellTargetObject();

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_STONESKIN, FALSE));

    if (nAmount > 20) //changed from 15. FlattedFifth
    {
        nAmount = 20;
    }
    int nDamage = nAmount * 10;
    if (GetMetaMagicFeat() == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    effect eVis2 = EffectVisualEffect( VFX_DUR_SPELL_GREATER_STONESKIN );
    // (JLR - OEI 07/22/05) -- Changed Damage Reduction
//    effect eStone = EffectDamageReduction(20, DAMAGE_POWER_PLUS_FIVE, nDamage);
    effect eStone = EffectDamageReduction(20, GMATERIAL_METAL_ADAMANTINE, nDamage, DR_TYPE_GMATERIAL);	// JLR-OEI 02/14/06: NWN2 3.5 -- New Damage Reduction Rules
	eStone = EffectLinkEffects( eStone, eVis2 );
	
    //Remove effects from target if they have Greater Stoneskin cast on them already.
    RemoveEffectsFromSpell(oTarget, SPELL_GREATER_STONESKIN);

    //Apply the linked effect
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStone, oTarget, HoursToSeconds(nDuration));
}