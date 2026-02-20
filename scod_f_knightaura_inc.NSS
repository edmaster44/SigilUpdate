/*This Grants the Knight Saves that applies to his Allies
This is based on the total Knight level, as well as PRC.
*/


#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_functions"


void ApplyAura(object oTarget, object oCaster){

	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
	}
	
	if (oTarget == oCaster) return;
	if (GetIsDead(oTarget)) return;
	
	int cScale = PS_GetCasterLevel(oCaster, CLASS_TYPE_PALADIN)/6;
	if (cScale < 1) return;
	if (cScale > 4) cScale = 4;
	
	if (GetFactionEqual(oCaster, oTarget)){
		effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, cScale, SAVING_THROW_TYPE_ALL, FALSE);
		effect eAB = EffectAttackIncrease(cScale,ATTACK_BONUS_MISC);
		effect	eBuffs = EffectLinkEffects(eSaves, eAB);
		eBuffs = SupernaturalEffect(eBuffs);
		eBuffs = SetEffectSpellId(eBuffs, SPELLABILITY_KNIGHT_AURA); 
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuffs, oTarget);
	}

	
}