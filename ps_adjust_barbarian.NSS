//This Script adds Base Barbarian Feats
//Based on iTotal,very adjustable
//

#include "aaa_constants"

void PS_BarbarianLevels(object oPC);



void PS_BarbarianLevels(object oPC)
{
	int iBarb = GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);
	int iBralani = GetLevelByClass(CLASS_TYPE_BRALANI_PRC,oPC);//Bralani
	int iSavage = GetLevelByClass(CLASS_TYPE_SAVAGE_MARAUDER_PRC,oPC);//Savage Marauder
	int iScaly = GetLevelByClass(CLASS_TYPE_SCALED_HUNTER_PRC,oPC);//Scaled Hunter
	int iHilly = GetLevelByClass(CLASS_TYPE_HILL_GIANT_PRC,oPC);//Hill Giant
	int iFrost = GetLevelByClass(CLASS_TYPE_FROST_GIANT_PRC,oPC);//Frost Giant PRC
	int iFrenzy = GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER,oPC);//Frenized Berserker.
	int iTotal = iBarb + iBralani + iSavage + iFrost + iFrenzy +iScaly + iHilly;
	if (iBarb < 1) return;
	else
	
	
	if(GetHasFeat(FEAT_LYCAN_BP_WEREBOAR,oPC,TRUE)) iTotal = iTotal + GetLevelByClass(CLASS_TYPE_LYCAN_PRC,oPC);
	
	

	if (iTotal >= 1)
	
		{FeatAdd(oPC,FEAT_BARBARIAN_RAGE,FALSE,FALSE,FALSE);
		}
		
	 if (iTotal >=  2)
{ 	FeatAdd(oPC,FEAT_UNCANNY_DODGE,FALSE,FALSE,FALSE);		
			}
	 if (iTotal  >= 3)
		{FeatAdd(oPC,FEAT_TRAP_SENSE_1,FALSE,FALSE,FALSE);
		}
		 if(iTotal >= 4)
		{FeatAdd(oPC,FEAT_BARBARIAN_RAGE_2,FALSE,FALSE,FALSE);
	}		 
		if (iTotal >= 5)
		{FeatAdd(oPC,FEAT_IMPROVED_UNCANNY_DODGE,FALSE,FALSE,FALSE);
		}	
		if (iTotal >= 6)
		{FeatAdd(oPC,FEAT_TRAP_SENSE_2,FALSE,FALSE,FALSE);
		}	
		
	if (iTotal >= 7)
		{FeatAdd(oPC,FEAT_DAMAGE_REDUCTION,FALSE,FALSE,FALSE);
		}	
			if (iTotal >= 8)
		{FeatAdd(oPC,FEAT_BARBARIAN_RAGE3,FALSE,FALSE,FALSE);
		}	
			if (iTotal >= 9)
		{FeatAdd(oPC,FEAT_TRAP_SENSE_3,FALSE,FALSE,FALSE);
		}	
			if (iTotal >= 10)
		{FeatAdd(oPC,FEAT_DAMAGE_REDUCTION2,FALSE,FALSE,FALSE);
		}	
		
	if (iTotal >= 11)
		{FeatAdd(oPC,FEAT_GREATER_RAGE,FALSE,FALSE,FALSE);
		}	
	if (iTotal >= 12)
		{{FeatAdd(oPC,FEAT_BARBARIAN_RAGE_4,FALSE,FALSE,FALSE);
		}	
	if (iTotal >= 13)
		{FeatAdd(oPC,FEAT_DAMAGE_REDUCTION3,FALSE,FALSE,FALSE);
		}	
	if (iTotal >= 14)
		{FeatAdd(oPC,FEAT_INDOMITABLE_WILL,FALSE,FALSE,FALSE);
		}	
	if (iTotal >= 15)
		{FeatAdd(oPC,FEAT_TRAP_SENSE_5,FALSE,FALSE,FALSE);
		}	
			if (iTotal >= 16)
		{FeatAdd(oPC,FEAT_DAMAGE_REDUCTION4,FALSE,FALSE,FALSE);
		FeatAdd(oPC,FEAT_BARBARIAN_RAGE_6,FALSE,FALSE,FALSE);
		
		}
			
			if (iTotal >= 17)
		{{FeatAdd(oPC,FEAT_TIRELESS_RAGE,FALSE,FALSE,FALSE);}
			}
			if (iTotal >= 18)
		{{FeatAdd(oPC,FEAT_TRAP_SENSE_6,FALSE,FALSE,FALSE);}
			}
			if (iTotal >= 20)
		{FeatAdd(oPC,FEAT_DAMAGE_REDUCTION5,FALSE,FALSE,FALSE);
		FeatAdd(oPC,FEAT_BARBARIAN_RAGE7,FALSE,FALSE,FALSE);
		
		}
			
			if (iTotal >= 21)
		{FeatAdd(oPC,FEAT_EPIC_BARBARIAN,FALSE,FALSE,FALSE);
		FeatAdd(oPC,FEAT_EPIC_BARBARIAN_RAGE,FALSE,FALSE,FALSE);
		}	
			
			}
			if (iTotal >= 22)
		{FeatAdd(oPC,FEAT_DAMAGE_REDUCTION_6,FALSE,FALSE,FALSE);
		}	
		if (iTotal >= 24)
		{FeatAdd(oPC,FEAT_TRAP_SENSE_8,FALSE,FALSE,FALSE);
		}	
			if (iTotal >= 25)
		{FeatAdd(oPC,FEAT_DAMAGE_REDUCTION7,FALSE,FALSE,FALSE);
		{FeatAdd(oPC,FEAT_TRAP_SENSE9,FALSE,FALSE,FALSE);
		}	
			if (iTotal >= 27)
		{FeatAdd(oPC,FEAT_DAMAGE_REDUCTION8,FALSE,FALSE,FALSE);
			}	
	
		

	
}

}