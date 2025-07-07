//This script will grant the proper bonus feats for the racial PRC Pack leader
void main()
{
	object oPC = OBJECT_SELF;
	int nRACE = GetSubRace(oPC);
	int nFEAT = 0;
	switch (nRACE)
	{
		case 231: nFEAT = FEAT_MOBILITY; break; //Blink Dog
		case 230: case 66: nFEAT = FEAT_IMPROVED_KNOCKDOWN; break; //Worg and Gnoll
		case 235: nFEAT = 5010; break; //Winter Wolf
	}
	if (nFEAT <= 0) return; //In case there's an error somewhere.
	if (GetHasFeat(nFEAT, oPC, TRUE) == TRUE) return; //If we already have the proper bonus feat.
	FeatAdd(oPC, nFEAT, FALSE, FALSE, TRUE); //In this case we also give a notice.
}