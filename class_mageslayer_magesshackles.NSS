void applyShackle(object oTarget, int FailureAmount);

void main()
{
	SendMessageToPC(OBJECT_SELF, "Searching for shackle targets..");
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
	
	while (oTarget != OBJECT_INVALID)
	{   
		SendMessageToPC(OBJECT_SELF, "apply shackle on " + GetName(oTarget));
		applyShackle(oTarget, 100);
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
		
	
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