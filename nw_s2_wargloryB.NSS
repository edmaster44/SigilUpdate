//::///////////////////////////////////////////////
//:: War Glory
//:: NW_S2_WarGloryB.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Grants a bonus to hit to allies and penalties
	to saves for enemies.

	On Exit.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/19/2006
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{	
	//SpeakString("nw_s2_wargloryB.nss: On Exit: function entry");

    object oTarget = GetExitingObject();
	object oCaster = GetAreaOfEffectCreator();

	PS_RemoveEffects(oTarget, SPELLABILITY_WAR_GLORY, NULL, oCaster);
}