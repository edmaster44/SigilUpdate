void main()
{
	object oPC = GetFirstEnteringPC();
	object oWAY = GetObjectByTag("wp_herald_annhi_entrance");
	while (oPC != OBJECT_INVALID)
	{
		if (GetIsDead(oPC) == TRUE) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
		AssignCommand(oPC, JumpToObject(oWAY));
		oPC = GetNextEnteringPC();
	}
}