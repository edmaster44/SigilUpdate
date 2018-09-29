const int IUD_ID = -14000;

int FailSafeIUD(object oPC)
{
	int nMOB;
	int nPC = GetTotalLevels(oPC, TRUE);
	location lPC = GetLocation(oPC);
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, lPC);
	while (oTARGET != OBJECT_INVALID)
	{
 		if (GetIsEnemy(oTARGET, oPC)==TRUE)
 		{
  			nMOB = GetTotalLevels(oTARGET, TRUE);
  			if (nMOB > nPC + 3)	return FALSE;
		}
 		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, lPC);
	}
	return TRUE;
}

void RemoveIUD(object oPC)
{
	effect eFX = GetFirstEffect(oPC);
	while(GetIsEffectValid(eFX)==TRUE)
	{
		if ((GetEffectSpellId(eFX) == IUD_ID))
		{
			RemoveEffect(oPC, eFX);
			eFX = GetFirstEffect(oPC); //Removed Linked effects safely
		}
		else eFX = GetNextEffect(oPC);
	}
}

void ApplyIUD(object oPC)
{
	effect eFX = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	eFX = ExtraordinaryEffect(eFX);
	eFX = SetEffectSpellId(eFX, IUD_ID);
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC));
}