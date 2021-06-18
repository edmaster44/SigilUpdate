//::///////////////////////////////////////////////
//:: Evards Black Tentacles
//:: NW_S0_Evards.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the mass of rubbery tentacles the
    target is struck by 1d4 tentacles.  Each has
    a chance to hit of 5 + 1d20. If it succeeds then
    it does 1d6 damage and the target must make
    a Fortitude Save versus paralysis or be paralyzed
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001

#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_EVARDS_BLACK_TENTACLES, "ps_onhit_evardsa", "ps_onhit_evardsc");
    location lTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nDuration = PS_GetCasterLevel(OBJECT_SELF);
    //Check Extend metamagic feat.
	
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}