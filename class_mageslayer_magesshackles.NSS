void applyShackle(object oTarget, int FailureAmount);

void main()
{
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
	
	while (oTarget != OBJECT_INVALID)
	{
		applyShackle(oTarget, 100);
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
	}
}

void applyShackle(object oTarget, int FailureAmount)
{
	effect spellFail = SupernaturalEffect(EffectSpellFailure(FailureAmount));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, spellFail, oTarget, 6.0f);
	if (FailureAmount > 10)
	{
		DelayCommand(6.0f, applyShackle(oTarget, FailureAmount - 10));
	}
}