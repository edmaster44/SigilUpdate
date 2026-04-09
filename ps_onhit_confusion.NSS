//::///////////////////////////////////////////////
//:: [Confusion]
//:: [NW_S0_Confusion.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures within a 15 foot radius must
//:: save or be confused for a number of rounds
//:: equal to the casters level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30 , 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{
	//Declare major variables
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
	object oTarget;
    int nDuration = PS_GetCasterLevel(oCaster);
    //effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);	// NWN1 VFX
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);	// NWN1 VFX
    effect eConfuse = EffectConfused();
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);	// NWN1 VFX
    float fDelay;
    //Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eMind, eConfuse);
    //eLink = EffectLinkEffects(eLink, eDur);	// NWN1 VFX

    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());	// NWN1 VFX

    //Search through target area
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oTarget))
	{
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    	{
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CONFUSION));
           fDelay = GetRandomDelay();
           //Make SR Check and faction check
           if (!OnHitResistSpell(oCaster, oTarget))
    	   {
                //Make Will Save
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetOnHitAbilityDC(OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                   //Apply linked effect and VFX Impact
                   nDuration = GetScaledDuration(GetCasterLevel(oCaster), oTarget);

                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                   //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));	// NWN1 VFX
                }
            }
        }
        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
}