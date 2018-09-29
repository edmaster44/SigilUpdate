int CancelIfNotInMeleeRange(object oCaller, object oTarget, int nFeatID)
{
	if (GetDistanceBetween(oCaller, oTarget) > 3.5f) // Melee range seems to be around a little less then 3.0f, so picked a number
	{                                                // a little higher to give some loose.
		SendMessageToPC(oCaller, "Target out of range.");
		ResetFeatUses(oCaller, nFeatID, FALSE, TRUE);
		return FALSE;
	}	
	return TRUE;
}

void main()
{
	object target = GetSpellTargetObject();
	if (CancelIfNotInMeleeRange(OBJECT_SELF, target, GetSpellFeatId()))
	{
		int touchAttackResult = TouchAttackMelee(target, TRUE, 0);
		
		if (touchAttackResult)
		{
			effect disruption = EffectCutsceneParalyze();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, disruption, target, 20.1f);
		}
	}
}