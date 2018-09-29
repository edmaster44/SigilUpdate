//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S0_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
// ChazM 7/14/06 If cast on an object, signal the object cast on (needed for crafting)
//:: AFW-OEI 08/03/2007: Account for Assassins.

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS, "ps_onhit_darknessa", "", "ps_onhit_darknessb");
    object oTarget = OBJECT_SELF;
	if (GetIsObjectValid(oTarget))
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DARKNESS));
	
    location lTarget = GetLocation(OBJECT_SELF);
    int nDuration = GetCasterLevel(oCaster);
	
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
	
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}