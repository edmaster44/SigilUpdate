// Poison daze effect for distilled wyvern poison

void main()
{
	// Make a will save
	object oTarget = OBJECT_SELF;
	if (WillSave(oTarget, 20, SAVING_THROW_TYPE_MIND_SPELLS, oTarget) == 0)
	{
		effect eDaze = EffectDazed();
    	effect eVis = EffectVisualEffect(EFFECT_TYPE_DAZED);
    	effect eLink = EffectLinkEffects(eDaze, eVis);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3));
	}
}