void main(int GiveALot)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	int hd = GetHitDice(oPC);
	int gp = 0;
	
	if (GiveALot) gp = 1000000;
	else if (hd < 18)
	{
	
		switch (hd) {
			case 1:  gp = 150; break;
		    case 2:  gp = 900; break;
		    case 3:  gp = 2700; break;
		    case 4:  gp = 5400; break;
		    case 5:  gp = 9000; break;
		    case 6:  gp = 13000; break;
		    case 7:  gp = 19000; break;
		    case 8:  gp = 27000; break;
		    case 9:  gp = 36000; break;
		    case 10: gp = 49000; break;
		    case 11: gp = 66000; break;
		    case 12: gp = 88000; break;
		    case 13: gp = 110000; break;
		    case 14: gp = 150000; break;
		    case 15: gp = 200000; break;
		    case 16: gp = 260000; break;
		    case 17: gp = 340000; break;
		}
	}
	else
	{
		gp = 440000; // base at 18th level
		int i;
		int nLvlIncrease = 100000;
		for (i = 18; i < hd; i++)
		{
		    gp += nLvlIncrease;
			nLvlIncrease += 40000;
		}
	}
	
	if (gp != 0) {
	    if (!GiveALot)
		{
		    int hasgp = GetGold(oPC);
		    if (hasgp) TakeGoldFromCreature(hasgp, oPC, TRUE);
		}
		GiveGoldToCreature(oPC, gp);
	}
    	
}