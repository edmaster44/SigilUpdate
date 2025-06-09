	int StartingConditional(int selection)
	{
	object oPC = GetPCSpeaker();
	int cond = GetLocalInt(oPC,"SONGLIST"+IntToString(selection));
	
	if (cond <= 0) return FALSE;
	else return TRUE;
	}