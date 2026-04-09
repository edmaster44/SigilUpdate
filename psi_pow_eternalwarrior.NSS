#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "nwn2_inc_spells"

/*Psychic Warrior - Eternal Warrior
	A level 20th Psychic Warrior Applies Their Wisdom Modfier to Movespeed * 5
	Attack Bonus
	and damage Bonus*/ 

// old code put wis mod direct into damage bonus effect, but EffectDamageIncrease(6) == 1d4, not 6
// so get the actual damage constant we need
int GetDamConstant(int nDam){

	switch (nDam){
		case 1: return DAMAGE_BONUS_1;
		case 2: return DAMAGE_BONUS_2;
		case 3: return DAMAGE_BONUS_3;
		case 4: return DAMAGE_BONUS_4;
		case 5: return DAMAGE_BONUS_5;
		case 6: return DAMAGE_BONUS_6;
		case 7: return DAMAGE_BONUS_7;
		case 8: return DAMAGE_BONUS_8;
		case 9: return DAMAGE_BONUS_9;
		case 10: return DAMAGE_BONUS_10;
	}
	return 0;
}

void main(){
	
    object oPC = OBJECT_SELF;
    int nScale = GetAbilityModifier(ABILITY_WISDOM,oPC);
	if (nScale < 0) nScale = 0;
	else if (nScale > 10) nScale = 10;
		
	if (nScale > 0){
		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_DIVINE_FAVOR);
		float fDuration = TurnsToSeconds(nScale); 
		effect eLink = EffectMovementSpeedIncrease(nScale*5);
		eLink = EffectLinkEffects(EffectDamageIncrease(GetDamConstant(nScale), DAMAGE_TYPE_SLASHING), eLink);
		eLink = EffectLinkEffects(EffectAttackIncrease(nScale,ATTACK_BONUS_MISC), eLink);
		eLink = SupernaturalEffect(eLink);
		  
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
	}
	  
}