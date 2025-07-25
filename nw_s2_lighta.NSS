

#include "x2_inc_spellhook"

void main(){

    object oTarget = GetEnteringObject();
	
	if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE){
		object oAOE = OBJECT_SELF;
		object oCaster = GetAreaOfEffectCreator();
		
		// make sure we have the right spell id and if the id isn't set on the AoE object, 
		// grab if from caster
		int nId = GetLocalInt(oAOE, "LightSpellId");
		if (nId == FALSE){
			nId = GetLocalInt(oCaster, "LightSpellId");
			// if we still don't have a spell id, just assume normal spell id for light
			if (nId == FALSE) nId = SPELL_LIGHT;
			SetLocalInt(oAOE, "LightSpellId", nId);
		}
		
		//now get the caster level the same way because PS_GetCasterLevel
		//involves getting the last spell cast class, which might be different
		//now if the caster has multiple caster classes or uses a feat or item
		int nLevel = GetLocalInt(oAOE, "LightCasterLevel");
		if (nLevel == FALSE){
			nLevel = GetLocalInt(oCaster, "LightCasterLevel");
			//if we still don't have a caster level, just assume 1
			if (nLevel < 1) nLevel = 1;
			SetLocalInt(oAOE, "LightCasterLevel", nLevel);
		}
		
		// find out if this was cast as a racial spell of a divine being
		int bDivineLight = GetLocalInt(oAOE, "LightIsDivine");
		if (bDivineLight == 0){// this would be the result of both a non-divine cast and not set
			bDivineLight = GetLocalInt(oCaster, "LightIsDivine");
			//so we'll set it to -1 if non-divine, to show that it is set and prevent unnecessary checks
			if (bDivineLight == 0) bDivineLight = -1;
			SetLocalInt(oAOE, "LightIsDivine", bDivineLight);
		}
		
		int nMeta = GetLocalInt(oAOE, "LightMetaMagic");
		if (nMeta == 0){ // this would be the result of both a no meta cast and not set
			nMeta = GetLocalInt(oCaster, "LightMetaMagic");
			//so we'll set it to -1 if no meta, to show that it is set and prevent unnecessary checks
			if (nMeta == 0) nMeta = -1;
			SetLocalInt(oAOE, "LightMetaMagic", nMeta);
		}
		
		if (nMeta == METAMAGIC_EXTEND || bDivineLight == 1) nLevel *= 2;
		int nBonus = 5;
		if (nMeta == METAMAGIC_EMPOWER) nBonus += nBonus / 2;
		else if (bDivineLight == 1) nBonus = 10;//can't be both divine & empowered, divine = racial feat
		
		effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nBonus);
		effect eSpot = EffectSkillIncrease(SKILL_SPOT, nBonus);
		eSearch = EffectLinkEffects(eSpot, eSearch);
		eSearch = EffectLinkEffects(EffectSkillDecrease(SKILL_HIDE, nBonus), eSearch);
		if (bDivineLight)
			eSearch = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_BLINDNESS), eSearch);
		SetEffectSpellId(eSearch, nId);
		
		SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, FALSE));
		if (bDivineLight == 1) RemoveEffect(oTarget, EffectBlindness());
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSearch, oTarget, HoursToSeconds(nLevel));
	}	
}