// Poison sleep effect for distilled black lotus poison

void main()
{
	// Make a will save
	object oTarget = OBJECT_SELF;
	if (WillSave(oTarget, 27, SAVING_THROW_TYPE_POISON, oTarget) == 0)
	{
		effect eSleep = EffectSleep();
    	effect eVis = EffectVisualEffect(VFX_DUR_SLEEP);
    	effect eLink = EffectLinkEffects(eSleep, eVis);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
	}
}