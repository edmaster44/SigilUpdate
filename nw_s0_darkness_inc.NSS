

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"



void ApplyDarkness(object oCaster, object oTarget, int nId, float fDur, int bAbyssalDark){


	int nBonus = 10;
	if (GetMetaMagicFeat() == METAMAGIC_EMPOWER || bAbyssalDark) nBonus += nBonus / 2;
	
	effect eConceal = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eHide = EffectSkillIncrease(SKILL_HIDE, nBonus);
	//eConceal = EffectLinkEffects(eDur, eConceal);
	eConceal = EffectLinkEffects(eHide, eConceal);
	SetEffectSpellId(eConceal, nId); 
	
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
    effect eBlindness = EffectMissChance(50);
	eBlindness = EffectLinkEffects(EffectSkillDecrease(SKILL_SEARCH, nBonus), eBlindness);
	eBlindness = EffectLinkEffects(EffectSkillDecrease(SKILL_SPOT, nBonus), eBlindness);
	SetEffectSpellId(eBlindness, nId * -1); 
	
	int bImmuneNeg = (GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS, oCaster) ||
		(bAbyssalDark && oTarget == oCaster)); 
		

	SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, FALSE));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, fDur);
	if(!bImmuneNeg) {
		if (oTarget == oCaster || !GetObjectSeen(oCaster, oTarget)){
			SignalEvent(oTarget, EventSpellCastAt(oCaster, nId * -1, FALSE));
		} else {
			SignalEvent(oTarget, EventSpellCastAt(oCaster, nId * -1, TRUE));
		}
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, fDur);
    /*
	if (bImmuneNeg){
		SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, FALSE));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, fDur);
	} else {
		if (oTarget == oCaster || !GetObjectSeen(oCaster, oTarget)){
			SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, FALSE));
		} else {
			SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, TRUE));
		}
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, fDur);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, fDur);
	}*/
	  
}
