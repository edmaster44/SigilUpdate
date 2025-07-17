

#include "x2_inc_spellhook"

void main(){

	object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
	
	
	if (GetIsObjectValid(oTarget)){
		int nId = GetLocalInt(oCaster, "LightSpellId");
		int nMeta = GetLocalInt(oCaster, "LightMetaMagic");
		int nDur;
		int bDivineLight = FALSE;
		if (nId == SPELL_RACIAL_LIGHT){
			nDur = GetTotalLevels(oCaster, TRUE); 
			int nRace = GetSubRace(oCaster);
			if (nRace == 13 || nRace == 203) bDivineLight = TRUE;
		} else {
			nDur = PS_GetCasterLevel(oCaster);
		}
		if (nMeta == METAMAGIC_EXTEND) nDur *= 2;
		int nBonus = 5;
		if (nMeta == METAMAGIC_EMPOWER) nBonus += nBonus / 2;
		else if (bDivineLight) nBonus = 10;
		
		effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nBonus);
		effect eSpot = EffectSkillIncrease(SKILL_SPOT, nBonus);
		eSearch = EffectLinkEffects(eSpot, eSearch);
		eSearch = EffectLinkEffects(EffectSkillDecrease(SKILL_HIDE, nBonus), eSearch);
		if (bDivineLight)
			eSearch = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_BLINDNESS), eSearch);
		SetEffectSpellId(eSearch, nId);
		
		SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, FALSE));
		if (bDivineLight) RemoveEffect(oTarget, EffectBlindness());
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSearch, oTarget, HoursToSeconds(nDur));
	}	
}