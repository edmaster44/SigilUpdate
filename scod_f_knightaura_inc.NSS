/*This Grants the Knight Saves that applies to his Allies
This is based on the total Knight level, as well as PRC.
*/


#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_functions"


void ApplyAura(object oTarget, object oCaster){{

		if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
	}
	
	}
	if (oTarget == oCaster || GetIsDead(oTarget)) return;
	if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
		return;
	if (!GetFactionEqual(oCaster, oTarget))
		return;
	
	
	int cScale = PS_GetCasterLevel(oCaster, CLASS_TYPE_PALADIN)/6;
	if (cScale < 1) return;
	if (cScale > 4) cScale = 4;
	
	if (GetHasSpellEffect(SPELLABILITY_KNIGHT_AURA, oTarget)){
		effect eFX = GetFirstEffect(oTarget);
		int nBonus = 0;
		// there can be only one!
		while(GetIsEffectValid(eFX)){
			if(GetEffectSpellId(eFX) == SPELLABILITY_KNIGHT_AURA && 
				   GetEffectType(eFX) == EFFECT_TYPE_SAVING_THROW_INCREASE){
					nBonus = GetEffectInteger(eFX, 1);
					break;
			}
			eFX = GetNextEffect(oTarget);
		}
		if (nBonus >= cScale) return;
		PS_RemoveEffects(oTarget, SPELLABILITY_KNIGHT_AURA);
	}
	
	effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, cScale, SAVING_THROW_TYPE_ALL, FALSE);
	effect eAB = EffectAttackIncrease(cScale,ATTACK_BONUS_MISC);
	effect	eBuffs = EffectLinkEffects(eSaves, eAB);
	eBuffs = SetEffectSpellId(eBuffs, SPELLABILITY_KNIGHT_AURA); 
	eBuffs = SupernaturalEffect(eBuffs);
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_KNIGHT_AURA, FALSE));
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuffs, oTarget);

	
}