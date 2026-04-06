//::///////////////////////////////////////////////
//:: Aura of Despair
//:: NW_S2_AuraDespairB.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Blackguard supernatural ability that causes all
	enemies within 10' to take a -2 penalty on all saves.

	On Exit script.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/30/2006
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{	
	//SpeakString("nw_s2_auradespairB.nss: On Exit: function entry");

    object oTarget = GetExitingObject();
	object oCaster = GetAreaOfEffectCreator();
	if (oTarget == oCaster) return;
	
	PS_RemoveEffects(oTarget, SPELLABLILITY_AURA_OF_DESPAIR, NULL, oCaster);
}