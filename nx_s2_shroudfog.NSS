//::///////////////////////////////////////////////
//:: Shroud of Fog (Water Genasi Racial Ability)
//:: nx_s2_shroudfog.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Repurposed from Darkness (nw_s2_darkness).

    Creates a globe of fog around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables including Area of Effect Object
    effect eAOE      = EffectAreaOfEffect(AOE_PER_SHROUDING_FOG);
    location lTarget = GetSpellTargetLocation();
    int nDuration    = GetTotalLevels(OBJECT_SELF, TRUE);
	if (nDuration < 5) nDuration = 5;
    int nMetaMagic   = GetMetaMagicFeat();
	
	object oTarget = GetSpellTargetObject();
	if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") == 3)
	{
		SendMessageToPC(OBJECT_SELF, "You find that it is impossible to cast water-based spells on this plane!");
		SetModuleOverrideSpellScriptFinished();
		return;
	}
	else if (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_SHROUDING_FOG));	
	}
		
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}