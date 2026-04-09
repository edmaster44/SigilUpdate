//::///////////////////////////////////////////////
//:: Slow
//:: NW_S0_Slow.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Character can take only one partial action
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 

void main()
{
    //Declare major variables
    location lSpell = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nCasterLevel = PS_GetCasterLevel(oCaster);
	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nID = GetOnHitAbilityID(OBJECT_SELF);
    effect eSlow = EffectSlow();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
	eSlow = EffectLinkEffects( eSlow, eVis );
    int nMetaMagic = GetMetaMagicFeat();
    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = nCasterLevel;
    int nLevel = nDuration;
    int nCount = 0;
	object oTarget;

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    while(GetIsObjectValid(oTarget) && nCount < nLevel)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SLOW));
            if (!OnHitResistSpell(oCaster, oTarget) && !/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
            {
                //Apply the slow effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(nDuration));
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                //Count the number of creatures affected
                nCount++;
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    }
}