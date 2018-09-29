//::///////////////////////////////////////////////
//:: Dirge
//:: x0_s0_dirge.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2 points of Strength
    and Dexterity ability score damage.
    Lasts 1 round/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{
    location  lLocal       = GetLocation(OBJECT_SELF);
	object 	  oCaster 	   = GetOnHitAbilityCaster(OBJECT_SELF);
    int       nCasterLevel = GetCasterLevel(oCaster);
	effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD, "ps_onhit_dirgea", "ps_onhit_dirgec", "ps_onhit_dirgeb");
    int nDuration = nCasterLevel;

    
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(OBJECT_SELF));	// NWN1 VFX; this is now handled in spells.2da
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
	
    //Create an instance of the AOE Object using the Apply Effect function

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds(nDuration));
    


}