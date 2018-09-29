// Poison paralysis effect for the low level spider venom.
// Relatively low DC as its a nasty effect and designed for low level poison users.

void main()
{
	// In addition to the DC chance, we also have a random factor as to whether this applies.
	if (Random(2) == 1)
	{
    	object oTarget = OBJECT_SELF;
		// Allow a save every round.
		effect eParal = EffectParalyze(15, SAVING_THROW_FORT, TRUE);
    	effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
    	effect eLink = EffectLinkEffects(eParal, eVis);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
	}
}