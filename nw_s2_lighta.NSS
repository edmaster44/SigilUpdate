
#include "x2_inc_spellhook"

void main(){

    object oTarget = GetEnteringObject();
	
	if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE){
		object oAOE = OBJECT_SELF;
		object oCaster = GetAreaOfEffectCreator();
		
		struct dSpellData data = GetSpellDataForAoE("Light", oCaster);
		
		int bDivineLight = FALSE;
		if (data.nId == SPELL_RACIAL_LIGHT){
			int nRace = GetSubRace(oCaster);
			if (nRace == 13 || nRace == 203) bDivineLight = TRUE;
		}
		
		int nLevel = data.nCL;
		int nMeta = GetMetaMagicFeat();
		if (nMeta == METAMAGIC_EXTEND || bDivineLight) nLevel *= 2;
		int nBonus = 5;
		if (nMeta == METAMAGIC_EMPOWER) nBonus += nBonus / 2;
		else if (bDivineLight) nBonus = 10;//can't be both divine & empowered, divine = racial feat
		
		effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nBonus);
		effect eSpot = EffectSkillIncrease(SKILL_SPOT, nBonus);
		eSearch = EffectLinkEffects(eSpot, eSearch);
		eSearch = EffectLinkEffects(EffectSkillDecrease(SKILL_HIDE, nBonus), eSearch);
		if (bDivineLight)
			eSearch = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_BLINDNESS), eSearch);
		SetEffectSpellId(eSearch, data.nId);
		
		SignalEvent(oTarget, EventSpellCastAt(oCaster, data.nId, FALSE));
		if (bDivineLight){
			RemoveSpecificEffect(EFFECT_TYPE_BLINDNESS, oTarget);
			RemoveSpecificEffect(EFFECT_TYPE_MISS_CHANCE, oTarget);
		}
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSearch, oTarget, HoursToSeconds(nLevel));
	}	
}