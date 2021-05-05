#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "nwn2_inc_spells"

/*Psychic Warrior - Eternal Warrior
	A level 20th Psychic Warrior Applies Their Wisdom Modfier to Movespeed * 5
	Attack Bonus
	and damage Bonus*/ 

void main()
{

    object oPC = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_DIVINE_FAVOR);
    int nScale = GetAbilityModifier(ABILITY_WISDOM,oPC);
	 if (nScale < 1)
        nScale = 1;
	 if (nScale >10)
	 nScale = 10;
	    float fDuration = TurnsToSeconds(nScale); 
	  effect eLink = EffectMovementSpeedIncrease(nScale*5);
	   		 eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nScale,DAMAGE_TYPE_SLASHING));
			 eLink = EffectLinkEffects(eLink,EffectAttackIncrease(nScale,ATTACK_BONUS_MISC));

	  
	  
	  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
	  
}