// Kiai Smite
// works with any equipped weapon.

#include "x2_inc_itemprop"

void main()
{
	object oPC = OBJECT_SELF;

	int iAllow = FALSE;
	int iChaBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	effect eBonus =  EffectAttackIncrease(iChaBonus);
	int dBonus = iChaBonus;
	// jiggery pokery to get damage bonus in line with actual bloody constants
	if (dBonus > 5) dBonus += 10;
	eBonus = EffectLinkEffects(eBonus, EffectDamageIncrease(dBonus, DAMAGE_TYPE_DIVINE));
	eBonus = SupernaturalEffect(eBonus);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 6.0);
}