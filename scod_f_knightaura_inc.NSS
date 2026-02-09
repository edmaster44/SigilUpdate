#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_functions"


void ApplyAura(object oTarget, object oCaster){

	if (!GetIsDead(oTarget) && oTarget != oCaster && GetFactionEqual(oCaster, oTarget)){
	
		int cScale = PS_GetCasterLevel(oCaster, CLASS_TYPE_PALADIN)/6;
		if (cScale > 4) cScale = 4; // max bonus 4
		int nExisting;
		
		//Prevent multiple auras from stacking by removing any weaker versions because attack bonuses WILL stack
		effect eLoop = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eLoop)){
			if (GetEffectSpellId(eLoop) == SPELLABILITY_KNIGHT_AURA && GetEffectType(eLoop) == EFFECT_TYPE_ATTACK_INCREASE){
				nExisting = GetEffectInteger(eLoop, 0);
				if (nExisting < cScale){
					PS_RemoveEffects(oTarget, SPELLABILITY_KNIGHT_AURA); // remove a weaker version of this effect
				} else return; // if the existing effect is the same or stronger, bail
				break;
			}
			eLoop = GetNextEffect(oTarget);
		}

		effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, cScale, SAVING_THROW_TYPE_ALL, FALSE);
		effect eAB = EffectAttackIncrease(cScale,ATTACK_BONUS_MISC);
		effect	eBuffs = EffectLinkEffects(eSaves, eAB);
		eBuffs = SupernaturalEffect(eBuffs);
		eBuffs = SetEffectSpellId(eBuffs, SPELLABILITY_KNIGHT_AURA); 
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuffs, oTarget);
	}
	
}