//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

void main()
{
	if(GetLevelByClass(213, OBJECT_SELF))
	{
	    //Yep thats it
		int nLevelSorc = GetLevelByClass(9, OBJECT_SELF);
		int nLevelRak = GetLevelByClass(213, OBJECT_SELF);
		int nLevelRakSorc = nLevelSorc + nLevelRak;
		
		switch(nLevelRakSorc)
		{
			case 1: case 2:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta1");
				break;
			}
			case 3: case 4:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta2");
				break;
			}
			case 5: case 6:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta3");
				break;
			}
			case 7: case 8:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta4");
				break;
			}
			case 9: case 10:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta5");
				break;
			}
			case 11: case 12:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta6");
				break;
			}
			case 13: case 14:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta7");
				break;
			}
			case 15: case 16:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta8");
				break;
			}
			case 17: case 18:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta9");
				break;
			}
			case 19: case 20:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta10");
				break;
			}
			case 21: case 22:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta11");
				break;
			}
			case 23: case 24:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta12");
				break;
			}
			case 25: case 26:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta13");
				break;
			}
			case 27: case 28:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta14");
				break;
			}
			case 29: case 30:
			{
				SummonFamiliar(OBJECT_SELF, "ps_fam_rakta15");
				break;
			}
		}
	}
}