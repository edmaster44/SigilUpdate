//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewld
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of noxious air goes forth from the caster.
    Enemies in the area of effect are stunned and blinded
    1d6 rounds. Foritude save negates effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: November 04, 2002
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    effect eAOE = EffectAreaOfEffect( AOE_PER_FOG_OF_BEWILDERMENT, "ps_onhit_cloudbewildera", "ps_onhit_cloudbewilderb");
    location lTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
	
    int nDuration = PS_GetCasterLevel(oCaster);
    effect eImpact = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    if (nDuration < 1)
    {
        nDuration = 1;
    }
	
    //Create the AOE object at the selected location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	
}