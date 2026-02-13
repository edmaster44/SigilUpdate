#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_functions"
#include "class_samurai_feats_inc"


void ApplyPresence(object oTarget, object oCaster){

	if (!GetIsDead(oTarget) && oTarget != oCaster){
		int nLevel = GetSamKenLevel(oCaster);
		int nMax = nLevel / 5;
		if (nMax > 4) nMax = 4;
		
		if (GetFactionEqual(oCaster, oTarget)){
			int nBonus = GetSkillRank(SKILL_DIPLOMACY, oCaster) / 5;
			int nPerf = GetSkillRank(SKILL_PERFORM, oCaster) / 5;
			if (nPerf > nBonus) nBonus = nPerf;
			if (nBonus > nMax) nBonus = nMax;
			effect eBonus;
			if (nLevel >= 19){
				eBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
			} else if (nLevel >= 13){
				eBonus = EffectSavingThrowIncrease(SAVING_THROW_WILL, nBonus);
				effect eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nBonus);
				eBonus = EffectLinkEffects(eReflex, eBonus);
			} else {
				eBonus = EffectSavingThrowIncrease(SAVING_THROW_WILL, nBonus);
			}
			eBonus = SupernaturalEffect(eBonus);
			eBonus = SetEffectSpellId(eBonus, SAMURAI_COMMANDING_PRESENCE_SPELL_ID);
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SAMURAI_COMMANDING_PRESENCE_SPELL_ID, FALSE));
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oTarget);	
			
		} else if (GetIsReactionTypeHostile(oTarget, oCaster)){
			if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster))
				return;
				
			if (GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 3)
				return;
				
			int nPenalty = GetSkillRank(SKILL_INTIMIDATE, oCaster) / 5;
			int nTaunt = GetSkillRank(SKILL_TAUNT, oCaster) / 5;
			if (nTaunt > nPenalty) nPenalty = nTaunt;
			if (nPenalty > nMax) nPenalty = nMax;
			
			effect ePenalty;
			if (nLevel >= 19){
				ePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty);
			} else if (nLevel >= 13){
				ePenalty = EffectSavingThrowDecrease(SAVING_THROW_WILL, nPenalty);
				effect eReflex = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, nPenalty);
				ePenalty = EffectLinkEffects(eReflex, ePenalty);
			} else {
				ePenalty = EffectSavingThrowDecrease(SAVING_THROW_WILL, nPenalty);
			}
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SAMURAI_COMMANDING_PRESENCE_SPELL_ID, TRUE));
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePenalty, oTarget);	
		}
	}
}