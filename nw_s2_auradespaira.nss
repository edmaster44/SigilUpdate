//::///////////////////////////////////////////////
//:: Aura of Despair
//:: NW_S2_AuraDespairA.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Blackguard supernatural ability that causes all
	enemies within 10' to take a -2 penalty on all saves.

	On Enter script.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/30/2006
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("nw_s2_auradespairA.nss: On Enter: function entry");

	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	
	if (oTarget == oCaster) return;
	if (!spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)) return;

	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	eSavePenalty		= SupernaturalEffect(eSavePenalty);
	eSavePenalty 		= SetEffectSpellId(eSavePenalty, SPELLABLILITY_AURA_OF_DESPAIR);
	PS_RemoveEffects(oTarget, SPELLABLILITY_AURA_OF_DESPAIR, NULL, oCaster);
	SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABLILITY_AURA_OF_DESPAIR, FALSE));		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSavePenalty, oTarget);			

}