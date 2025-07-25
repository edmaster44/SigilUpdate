//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
// ChazM 1/18/07 - EvenFlw modifications -  evenflw edited to stop AI lockups
// Nov 21, 2024- FlattedFifth: Darkness changed to be a cloud that can move with a target
// that provides concealment versus ranged and blinds anyone who does not have
// a light spell, true seeing, or immunity to blindness (as granted by blindsight spell and now
// also by aasimar light spell). Also the tiefling version is now a self-only effect and doesn'target
// impose the miss chance on the creator. The tief version the darkness is drawn from within, 
// not cast as a spell, though it can still be dispelled, ofc. In other words, everyone in the cloud will
// now have 50% conceal vs ranged, and those who are not immune become blind, thereby having a 50% miss chance
#include "x2_inc_spellhook"


void main(){

	object oTarget = GetEnteringObject();
	
	if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE){
		object oAOE = OBJECT_SELF;
		object oCaster = GetAreaOfEffectCreator();	
	
		// make sure we have the right spell id and if the id isn't set on the AoE object, 
		// grab if from caster variable because GetSpellId() does NOT work within an aoe script
		int nId = GetLocalInt(oAOE, "DarknessSpellId");
		if (nId == FALSE){
			nId = GetLocalInt(oCaster, "DarknessSpellId");
			// if we still don't have a spell id, just assume normal spell id for darkness
			if (nId == FALSE) nId = SPELL_DARKNESS;
			SetLocalInt(oAOE, "DarknessSpellId", nId);
		}
		
		//now get the caster level the same way because PS_GetCasterLevel
		//involves getting the last spell cast class, which might be different
		//now if the caster has multiple caster classes or uses a feat or item
		int nLevel = GetLocalInt(oAOE, "DarknessCasterLevel");
		if (nLevel == FALSE){
			nLevel = GetLocalInt(oCaster, "DarknessCasterLevel");
			//minimum duration of 5 rounds
			if (nLevel < 5) nLevel = 5;
			SetLocalInt(oAOE, "DarknessCasterLevel", nLevel);
		}
		
		
		// find out if this was cast as a racial spell of an abyssal being
		int bAbyssalDark = GetLocalInt(oAOE, "DarknessIsAbyssal");
		if (bAbyssalDark == 0){// this would be the result of both a non-abyssal cast and not set
			bAbyssalDark = GetLocalInt(oCaster, "DarknessIsAbyssal");
			//so we'll set it to -1 if non-abyssal, to show that it is set and prevent unnecessary checks
			if (bAbyssalDark == 0) bAbyssalDark = -1;
			SetLocalInt(oAOE, "DarknessIsAbyssal", bAbyssalDark);
		}
		
		int nMeta = GetLocalInt(oAOE, "DarknessMetaMagic");
		if (nMeta == 0){ // this would be the result of both a no meta cast and not set
			nMeta = GetLocalInt(oCaster, "DarknessMetaMagic");
			//so we'll set it to -1 if no meta, to show that it is set and prevent unnecessary checks
			if (nMeta == 0) nMeta = -1;
			SetLocalInt(oAOE, "DarknessMetaMagic", nMeta);
		}
	
		if (nMeta == METAMAGIC_EXTEND || bAbyssalDark == 1) nLevel *= 2;
		float fDur = RoundsToSeconds(nLevel);
		
		int nBonus = 10;
		if (nMeta  == METAMAGIC_EMPOWER || bAbyssalDark == 1) nBonus += nBonus / 2;
		
		//impact vfx
		effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
		
		//beneficial effects
		effect eHide = EffectSkillIncrease(SKILL_HIDE, nBonus);
		effect eConceal = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
		eConceal = EffectLinkEffects(eHide, eConceal);
		
		// determine if immune to negative effects
		int bImmuneNeg = (GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS, oCaster) ||
			(bAbyssalDark == 1 && oTarget == oCaster)); 
		
		// if not immune to negative effects, add them
		if (!bImmuneNeg){
			eConceal = EffectLinkEffects(EffectMissChance(50), eConceal);
			eConceal = EffectLinkEffects(EffectSkillDecrease(SKILL_SEARCH, nBonus), eConceal);
			eConceal = EffectLinkEffects(EffectSkillDecrease(SKILL_SPOT, nBonus), eConceal);
		}

		SetEffectSpellId(eConceal, nId); 
		
		if(bImmuneNeg) {// if no harmful effect, signal non-hostile cast
			SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, FALSE));
		} else {
			// if the target is the caster or the target cannot see caster,
			// signal non-hostile cast
			if (oTarget == oCaster || !GetObjectSeen(oCaster, oTarget)){
				SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, FALSE));
			} else {
				// if target will get neg effects and can see caster,
				// signal hostile cast
				SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, TRUE));
			}
		} 
		
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, fDur);
	
	}
}
// previous code
/*
void main()
{

    int nMetaMagic = GetMetaMagicFeat();
    effect eInvis = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);

    effect eLink2 =  EffectLinkEffects(eInvis, eDur);
	SetEffectSpellId(eLink2, nId); 
	
    effect eBlindness = EffectBlindness();
	SetEffectSpellId(eBlindness, nId); 

    int nDuration = PS_GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration *2; //Duration is +100%
    }
	
    object oTarget = GetEnteringObject();

    if(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        }
		
        // Creatures immune to the darkness spell are not affected.
		if (GetIsEnemy(oTarget, OBJECT_SELF)) {
	        if ( ResistSpell(OBJECT_SELF,oTarget) != 2 )
	        {
	            //Fire cast spell at event for the specified target
	            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, RoundsToSeconds(20));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	        }
		} else {
	     	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(20));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		}
    }
}
*/