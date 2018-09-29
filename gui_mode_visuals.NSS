void RemoveVisualEffect(object oTarget, int nVisualID)
{
	effect	eRemove = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eRemove))
	{
		if (GetEffectInteger(eRemove, 0) == nVisualID)
		{
			RemoveEffect(oTarget, eRemove);
			break;
		}				
		eRemove = GetNextEffect(oTarget);
	}
}

void main()
{
	if (GetHasFeat(2165, OBJECT_SELF, TRUE) == 1 || GetHasFeat(2166, OBJECT_SELF, TRUE) == 1)
	{
		effect eHellfireVisual;
		SupernaturalEffect (eHellfireVisual);
	
		eHellfireVisual = EffectVisualEffect(1104);
		if (GetActionMode(OBJECT_SELF, ACTION_MODE_HELLFIRE_SHIELD))
			{
				RemoveVisualEffect(OBJECT_SELF, 1104);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHellfireVisual, OBJECT_SELF);	
			}	
		else
			RemoveVisualEffect(OBJECT_SELF, 1104);	
		
		eHellfireVisual = EffectVisualEffect(1105);
		if (GetActionMode(OBJECT_SELF, ACTION_MODE_HELLFIRE_BLAST))
		{
			RemoveVisualEffect(OBJECT_SELF, 1105);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHellfireVisual, OBJECT_SELF);
		}
		else
			RemoveVisualEffect(OBJECT_SELF, 1105);
	}
	
}