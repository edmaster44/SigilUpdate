//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables, including the Area of Effect object.
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGFIRE, "ps_onhit_incendiarya", "ps_onhit_incendiaryc",  "ps_onhit_incendiaryb");
    //Capture the spell target location so that the AoE object can be created.
    location lTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nDuration = PS_GetCasterLevel(oCaster);
	
    if(nDuration < 1)
    {
        nDuration = 1;
    }
    //Create the object at the location so that the objects scripts will start working.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}