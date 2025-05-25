

string GetDifficultyName(object oPC)
{
	string sTXT = "Your current difficulty is ";
	int nDIFF = GetLocalInt(oPC, "DIFF");
	switch (nDIFF)
	{
		case 1: sTXT = sTXT + "Clueless"; break;
		case 3: sTXT = sTXT + "Planeswalker"; break;
		case 4: sTXT = sTXT + "Gatecrasher"; break;
		default: sTXT = sTXT + "Cutter";
	}
	return sTXT;
}

string GetDifficultyDescription(object oPC)
{
	string sTXT;
	int nDIFF = GetLocalInt(oPC, "DIFF");
	switch (nDIFF)
	{
		case 1: sTXT = "Spawns the lowest tier monster of a plane, regardless of your character level.  Useful if you have high ECL or your build is having problem with some place."; break;
		case 3: sTXT = "Every hostile plane will now spawn the highest tier of monsters available regardless of your character level, and elite monsters are a bit more common (use with caution)."; break;
		case 4: sTXT = "Like planewalker, but even more elites spawn, and extra monsters appear as well.  There might also be a few surprise spawns that don't appear on other difficulties (not for the faint of heart)."; break;
		default: sTXT = "This is the default setting everyone gets when logging in every day.";
	}
	return sTXT;
}

void main(string sCOMMAND)
{
	object oPC = OBJECT_SELF;
	string sSCREEN = "SCREEN_DIFFICULTY_SIGIL";
	if (sCOMMAND == "0")
	{
		SetGUIObjectText(oPC, sSCREEN, "CURRENT_DIFFICULTY", -1, GetDifficultyName(oPC));
		SetGUIObjectText(oPC, sSCREEN, "DESCRIPTION_DIFFICULTY", -1, GetDifficultyDescription(oPC));
	}
	else
	{
		int nDIFF = StringToInt(sCOMMAND);
		SetLocalInt(oPC,"DIFF",nDIFF);
		SetGUIObjectText(oPC, sSCREEN, "CURRENT_DIFFICULTY", -1, GetDifficultyName(oPC));
		SetGUIObjectText(oPC, sSCREEN, "DESCRIPTION_DIFFICULTY", -1, GetDifficultyDescription(oPC));
	}	
}