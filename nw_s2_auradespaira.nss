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

	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	
	// Hexer 1-3 feats
	if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) { //Curse Master
		eSavePenalty = EffectLinkEffects(EffectACDecrease(4), eSavePenalty);
	} 
	else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) { //Hexer 3
		eSavePenalty = EffectLinkEffects(EffectACDecrease(3), eSavePenalty);
	}
	else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) { //Hexer 2
		eSavePenalty = EffectLinkEffects(EffectACDecrease(2), eSavePenalty);
	}
	else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) { //Hexer 1
		eSavePenalty = EffectLinkEffects(EffectACDecrease(1), eSavePenalty);
	}
	
	if (GetHasFeat(FEAT_HEXEN_DREADFUL_AURA, oCaster)) { //Dreadful Aura Curse
		eSavePenalty = EffectLinkEffects(EffectDamageImmunityDecrease(DAMAGE_TYPE_ACID, 15), eSavePenalty);
		eSavePenalty = EffectLinkEffects(EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, 15), eSavePenalty);
		eSavePenalty = EffectLinkEffects(EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 15), eSavePenalty);
		eSavePenalty = EffectLinkEffects(EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, 15), eSavePenalty);
		eSavePenalty = EffectLinkEffects(EffectDamageImmunityDecrease(DAMAGE_TYPE_ELECTRICAL, 15), eSavePenalty);
	}
	
	eSavePenalty		= SupernaturalEffect(eSavePenalty);
	eSavePenalty		= SetEffectSpellId(eSavePenalty, SPELLABLILITY_AURA_OF_DESPAIR);
	
	// Doesn't work on self
	if (oTarget != oCaster)
	{
		//SpeakString("nw_s2_auradespairA.nss: On Enter: target is not the same as the creator");

		SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABLILITY_AURA_OF_DESPAIR, FALSE));		

	    //Faction Check
		if (!GetIsDead(oTarget) && GetIsEnemy(oTarget, oCaster)) {
		
			//SpeakString("nw_s2_auradespairA.ns: On Enter: target is enemy");
	        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSavePenalty, oTarget);			
		}
	}
}