

//Weapon Proficiency fixes for Favored Souls

void main()
{
	object oPC = OBJECT_SELF;
	if (GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) < 1) return;
	if (GetLocalInt(oPC, "FAVSOUL_PROF_FIX") == 1) return; //This is to spare a lot of strain on the server.
	string sDEITY = GetDeity(oPC);
	string sCOMPARE;
	int nFEAT;
	int nREF;
	string s2DA = "nwn2_deities";
	int nROWS = GetNum2DARows(s2DA);
	int nCOUNT;
	while (nCOUNT <= nROWS)
	{	
		nREF = StringToInt(Get2DAString(s2DA, "NameStringref", nCOUNT));
		sCOMPARE = GetStringByStrRef(nREF);
		if (sCOMPARE == sDEITY) //We found our deity
		{
			nFEAT = StringToInt(Get2DAString(s2DA, "FavoredWeaponProficiency", nCOUNT));
			break; //Get out of loop
		}
		else nCOUNT = nCOUNT + 1;
	}
	if (nFEAT <= 0) return; //Just in case something wrong happened and we didn't find our deity.
	if (GetHasFeat(nFEAT, oPC, TRUE) == FALSE) 
	{
		SetLocalInt(oPC, "FAVSOUL_PROF_FIX", 1); //Makes sure we won't do this check again until server reset.
		FeatAdd(oPC, nFEAT, FALSE, FALSE, TRUE);
	}
}