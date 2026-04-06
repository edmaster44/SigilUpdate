//::///////////////////////////////////////////////
//:: War Glory
//:: NW_S2_WarGloryA.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Grants a bonus to hit to allies and penalties
	to saves for enemies.

	On Enter.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/19/2006
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("nw_s2_wargloryA.nss: On Enter: function entry");

	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	if (oTarget == oCaster) return;

	effect eAttackBonus = EffectAttackIncrease(1);
	eAttackBonus		= SupernaturalEffect(eAttackBonus);
	eAttackBonus 		= SetEffectSpellId(eAttackBonus, SPELLABILITY_WAR_GLORY);
	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1);
	eSavePenalty		= SupernaturalEffect(eSavePenalty);
	eSavePenalty		= SetEffectSpellId(eSavePenalty, SPELLABILITY_WAR_GLORY);
	
	//SpeakString("nw_s2_wargloryA.nss: On Enter: target is not the same as the creator");
	PS_RemoveEffects(oTarget, SPELLABILITY_WAR_GLORY, NULL, oCaster);
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_WAR_GLORY, FALSE));		
	
	//Faction Check
	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
	{
		//SpeakString("nw_s2_wargloryA.ns: On Enter: target is friend");
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackBonus, oTarget);
	}
	else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		//SpeakString("nw_s2_wargloryA.ns: On Enter: target is enemy");
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSavePenalty, oTarget);			
	}
	
}