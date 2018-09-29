// Poison combust effect for distilled dragon bile poison
// if the creature goes the full minute, and secondary effect activates, they will explode in flame

void main()
{
	object oTarget = OBJECT_SELF;
	// Damage from 10 to 100.
	effect eFire = EffectDamage(d10(10), DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);
    effect eVis = EffectVisualEffect(VFX_DUR_FIRE);
    effect eLink = EffectLinkEffects(eFire, eVis);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}