


#include "x2_inc_spellhook"

void ApplyLight(object oCaster, object oTarget, int nId, float fDur, int bDivineLight){
	
	int nBonus = 5;
	if (GetMetaMagicFeat() == METAMAGIC_EMPOWER) nBonus += nBonus / 2;
	else if (bDivineLight) nBonus = 10;
	
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nBonus);
	effect eSpot = EffectSkillIncrease(SKILL_SPOT, nBonus);
	//effect eVis = EffectVisualEffect(VFX_DUR_LIGHT);
	eSearch = EffectLinkEffects(eSpot, eSearch);
	//eSearch = EffectLinkEffects(eVis, eSearch);
	eSearch = EffectLinkEffects(EffectSkillDecrease(SKILL_HIDE, nBonus), eSearch);
	if (bDivineLight)
		eSearch = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_BLINDNESS), eSearch);
	SetEffectSpellId(eSearch, nId);
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, FALSE));
	if (bDivineLight) RemoveEffect(oTarget, EffectBlindness());
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSearch, oTarget, fDur);

  
}