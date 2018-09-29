void main(int whatlevel)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int xp = GetXP(oPC);
	int nextlvl = 1000;
	int totalxp = 0;
	
	int nECL = 0;
	string sECL;
	int nRace = GetSubRace(oPC);
	sECL = Get2DAString("racialsubtypes", "ECL", nRace);
	nECL = StringToInt(sECL);
		
	if (whatlevel == 0) whatlevel = GetHitDice(oPC) + 1; // increase level by 1
	if (whatlevel == 1) { // make level 1
		SetXP(oPC, 0);
		return;
	}
	
	whatlevel += nECL;

	// set your level
	int i;
	for (i = 1; i < whatlevel; i++) 
	{
	  	totalxp += nextlvl;
		nextlvl += 1000;
	}
	SetXP(oPC, totalxp + 1);
	
}