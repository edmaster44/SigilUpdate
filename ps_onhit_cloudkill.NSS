//::///////////////////////////////////////////////
//:: Cloudkill
//:: NW_S0_CloudKill.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d10 Poison damage
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGKILL, "ps_onhit_cloudkilla", "ps_onhit_cloudkillc", "ps_onhit_cloudkillb");
    location lTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nDuration = PS_GetCasterLevel(oCaster) / 2;
	
    if(nDuration < 1)
    {
        nDuration = 1;
    }
	
    //Apply the AOE object to the specified location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}