/*This Grants the Knight Saves that applies to his Allies
This is based on the total Knight level, as well as PRC.
*/


#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_functions"


void main(){
	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)) DestroyObject(OBJECT_SELF);
	
	object oTarget = GetEnteringObject();
	
	if (!GetIsDead(oTarget) && oTarget != oCaster && GetFactionEqual(oCaster, oTarget)){
	
		//Prevent multiple auras from stacking
		PS_RemoveEffects(oTarget, SPELLABILITY_KNIGHT_AURA, NULL, oCaster);
	
		int cScale = PS_GetCasterLevel(oCaster)/6 ;
		effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, cScale, SAVING_THROW_TYPE_ALL, FALSE);
		effect eAB = EffectAttackIncrease(cScale,ATTACK_BONUS_MISC);
		effect	eBuffs = EffectLinkEffects(eSaves, eAB);
		eBuffs = SupernaturalEffect(eBuffs);
		eBuffs = SetEffectSpellId(eBuffs, SPELLABILITY_KNIGHT_AURA); 
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuffs, oTarget);
	}
	
}