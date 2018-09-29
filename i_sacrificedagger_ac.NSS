// Sacrificial dagger on activate script script. Deals 10d10 negative energy damage
// on a touch attack. If it kills the target, gain bonuses to spells and blasts
// By Electrohydra
// Last edit 19/09/2015

void main()
{
	object dagger = GetSpellCastItem();
	object oPC = GetItemPossessor(dagger);
	object oTarget = GetSpellTargetObject();
	
	if (GetDistanceBetween(oPC, oTarget) > 4.0f) // Melee range seems to be around a little less then 3.0f, so picked a number
	{                                                // a little higher to give some loose.
		SendMessageToPC(oPC, "Target must be in melee range.");
		return;
	}	
	
	effect damage = EffectDamage(d10(10), DAMAGE_TYPE_NEGATIVE);
	effect visualEffect = EffectVisualEffect(VFX_INVOCATION_BESHADOWED_HIT);
	effect link = EffectLinkEffects(damage, visualEffect);
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, link, oTarget, 0.0f);
	
	if (GetIsDead(oTarget))
	{
		SendMessageToPC(oPC, "You absorb a part of your victim's life force, bolstering your dark magics.");
		SetLocalInt(oPC, "BlastBonus_2", 5);
		SetLocalInt(oPC, "FingerDCBonus_2", 3);
		SetLocalInt(oPC, "WailDCBonus_2", 1);
	}
}