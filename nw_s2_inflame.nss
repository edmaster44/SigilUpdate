//::///////////////////////////////////////////////
//:: Implacable Foe
//:: NW_S2_ImpFoe
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	The Warpriests grants all allies within 30'

	10 rounds.

	(This ability burns Turn Undead attempts.)
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////
//:: AFW-OEI 05/22/2006:
//::  Does not use Turn Undead attempts anymore.
//:: RPGplayer1 03/19/2008: EventSpellCastAt not Harmful anymore


#include "NW_I0_SPELLS"   
#include "x0_i0_spells"
#include "nwn2_inc_spells"
 
void main()
{
//	if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
//	{
//		SpeakStringByStrRef(STR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
//	}
//	else
	{
		//SpeakString("nw_s2_ImpFoe: function entry");
	
	    //Declare major variables
		effect eVis	   		= EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	    effect eHP     		= EffectTemporaryHitpoints(30);
		//effect eMovePenalty	= EffectMovementSpeedDecrease(20);	// 20% movement penalty
	    effect eDur    		= EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		//Divine Damage applied on Weapon
		int nBonus = DAMAGE_BONUS_1d6;
		effect eDivine = EffectDamageIncrease(nBonus, DAMAGE_TYPE_DIVINE);
		effect eAllyLink	= EffectLinkEffects(eHP, eDur);
		effect eDivineLink 	= EffectLinkEffects(eDivine, eAllyLink);
		eDivineLink 		= SupernaturalEffect(eDivineLink);
	
	    float fDelay;
		float fDuration	=  RoundsToSeconds(50);
	
		// Apply movement decrease to self
		//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDivine, OBJECT_SELF, fDuration);
	
	    //Get first target in spell area
	    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	    while(GetIsObjectValid(oTarget))
	    {
	    	if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF) && oTarget != OBJECT_SELF)
	    	{
	            fDelay = GetDistanceToObject(oTarget)/10;

		        //Fire cast spell at event for the specified target
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_IMPLACABLE_FOE, FALSE));
	
	            //Apply the VFX impact and effects and extra damage
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAllyLink, oTarget, fDuration));
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		
	        }
	        //Get next target in spell area
	        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	    }
	
		//DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
	}
}