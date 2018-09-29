void main()
{
	object oItemHit = GetSpellCastItem();
	if (!GetIsObjectValid(oItemHit)) return;
	
	object oTarget = GetSpellTargetObject();
	object oPC = GetItemPossessor(oItemHit);
	
	int iRace = GetSubRace(oPC);
	
	if (iRace == 156 || iRace == 174)
	{
		int iDC = 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC) + GetTotalLevels(oPC, TRUE) / 2;
		
		int iRes = WillSave(oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC);
		
		if (iRes == 0)
		{
			effect eSleep = EffectSleep();
			int iDur = GetTotalLevels(oPC, TRUE) / 3;
			if (iDur < 1) iDur = 1;
			
			DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oTarget, RoundsToSeconds(iDur)));
		}
		else if (iRes == 1)
			SendMessageToPC(oPC, "<c=lightgreen>Failed to put target to sleep!");
		else if (iRes == 2)
			SendMessageToPC(oPC, "<c=lightgreen>Target is immune to your darts!");
	}
	else
	{
		SendMessageToPC(oPC, "<c=lightgreen>You are not a Pixie! The darts react to your touch and destroy themselves");
		DestroyObject(oItemHit);
	}

}