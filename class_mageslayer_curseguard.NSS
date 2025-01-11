const int CLASS_TYPE_MAGE_SLAYER = 70;

void applyCurseGuard(object oTarget, object oPC, int SpellResist, int tooFar);

void main()
{
	object oTarget = GetSpellTargetObject();

	int charLevel = GetTotalLevels(OBJECT_SELF, TRUE);
	int classLevels = GetLevelByClass(CLASS_TYPE_MAGE_SLAYER, OBJECT_SELF);
	
	int SR = (2 * classLevels) + charLevel - 5; // the () are prob unnecessary because OoO, but w/e
	
	applyCurseGuard(oTarget, OBJECT_SELF, SR, FALSE);
}

void applyCurseGuard(object oTarget, object oPC, int SR, int tooFar)
{
	if (GetDistanceBetween(oTarget, oPC) != 0.0f  && GetDistanceBetween(oTarget, oPC) < 20.0f)
	{
		effect eSpellResist = SupernaturalEffect(EffectSpellResistanceIncrease(SR, -1));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellResist, oTarget, 66.0f);
		DelayCommand(60.0f, applyCurseGuard(oTarget, oPC, SR, FALSE));
	}
	else if (!tooFar)
	{
		SendMessageToPC(oTarget, "You are too far away, Curseguard is about to fail.");
		DelayCommand(6.0f, applyCurseGuard(oTarget, oPC, SR, TRUE));
	}

	else
	{
		SendMessageToPC(oTarget, "Curseguard removed.");
	}
}