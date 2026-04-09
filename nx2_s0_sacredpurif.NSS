//::///////////////////////////////////////////////
//:: Sacred Purification
//:: NX2_S0_SacredPurif.nss
//:: Copyright (c) 2008 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    you can expend a turn undead
	attempt to create a pulse of divine energy. All living
	creatures within 60 feet of you heal an amount of damage
	equal to 1d8 points + your Charisma bonus (if any). All undead
	creatures in this area take damage equal to 1d8 points + your
	Charisma bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: JWR-OEI
//:: Created On: May 23 2008
//:://////////////////////////////////////////////
//:: RPGplayer1 12/18/2008: Separate healing roll for each target

#include "x0_i0_spells"
#include "x2_inc_itemprop"
#include "nwn2_inc_spells"


void main(){

	if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF)){
		SpeakStringByStrRef(STR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
		return;
	}
	location lLoc = GetLocation(OBJECT_SELF);
	int nId = GetSpellId();
	int nRace;
	effect eAmount;
	effect eVis;
	effect eLink;
	int bApply;
	int nBonus = GetAbilityModifier(ABILITY_CHARISMA);
	if (nBonus < 0) nBonus = 0;
	
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, lLoc, TRUE);
	while(GetIsObjectValid(oTarget)){
		bApply = FALSE;
		nRace = GetRacialType(oTarget);

		if (nRace == RACIAL_TYPE_UNDEAD){
			if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF)){
				bApply = TRUE;
				eAmount = EffectDamage(d6(2) + nBonus, DAMAGE_TYPE_DIVINE);
				eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, TRUE));
			}
		} else {
			if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF) && nRace != RACIAL_TYPE_CONSTRUCT){
				bApply = TRUE;
				eAmount = EffectHeal(d6(2) + nBonus);
				eVis = EffectVisualEffect(VFX_HIT_CURE_AOE);
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));
			}
		}
		
		if (bApply){
				eLink = EffectLinkEffects(eAmount, eVis);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		}
		
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, lLoc, TRUE);
	}
	
	effect eImpactVis = EffectVisualEffect(VFX_FEAT_TURN_UNDEAD);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lLoc);	
	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
} 