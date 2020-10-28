//This Script adds Base Monk Feats
//Based on iTotal,very adjustable, scritp wise 
//

#include "aaa_constants"

void PS_MonkLevels(object oPC);



void PS_MonkLevels(object oPC)
{
	int iMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC);
	int iAustereOne = GetLevelByClass(CLASS_TYPE_AUSTERE_ONE, oPC);//Rakshasa

	int iTotal = iMonk + iAustereOne;
	if (iMonk < 1) return;
	else
	
	

	
	

	if (iTotal >= 1)
	
		{FeatAdd(oPC,FEAT_MONK_AC_BONUS,FALSE,FALSE,FALSE);
		}
		
	if (iTotal >= 1)
	
		{FeatAdd(oPC,FEAT_FLURRY_OF_BLOWS,FALSE,FALSE,FALSE);
		}	
		
	if (iTotal >= 1)
	
		{FeatAdd(oPC,FEAT_IMPROVED_UNARMED_STRIKE,FALSE,FALSE,FALSE);
		}	
		
	if (iTotal >= 1)
	
		{FeatAdd(oPC,FEAT_STUNNING_FIST,FALSE,FALSE,FALSE);
		}
				
	 if (iTotal >=  2)
{ 	FeatAdd(oPC,FEAT_EVASION,FALSE,FALSE,FALSE);

	 if (iTotal >=  2)
{ 	FeatAdd(oPC,FEAT_DEFLECT_ARROWS,FALSE,FALSE,FALSE);		
			}
	 if (iTotal  >= 3)
		{FeatAdd(oPC,FEAT_STILL_MIND,FALSE,FALSE,FALSE);
		}
		 if(iTotal >= 4)
		{FeatAdd(oPC,FEAT_KI_STRIKE,FALSE,FALSE,FALSE);
	}		 
		if (iTotal >= 5)
		{FeatAdd(oPC,FEAT_PURITY_OF_BODY,FALSE,FALSE,FALSE);
		}
			
		if (iTotal >= 6)
		{FeatAdd(oPC,FEAT_KNOCKDOWN,FALSE,FALSE,FALSE);
		}
		
		if (iTotal >= 6)
		{FeatAdd(oPC,FEAT_IMPROVED_KNOCKDOWN,FALSE,FALSE,FALSE);
		}			
		
	if (iTotal >= 7)
		{FeatAdd(oPC,FEAT_WHOLENESS_OF_BODY,FALSE,FALSE,FALSE);
		}	
			if (iTotal >= 9)
		{FeatAdd(oPC,FEAT_IMPROVED_EVASION,FALSE,FALSE,FALSE);
		}	
			if (iTotal >= 11)
		{FeatAdd(oPC,FEAT_DIAMOND_BODY,FALSE,FALSE,FALSE);
		}	
			if (iTotal >= 13)
		{FeatAdd(oPC,FEAT_DIAMOND_SOUL,FALSE,FALSE,FALSE);
		}	
		
	if (iTotal >= 15)
		{FeatAdd(oPC,FEAT_QUIVERING_PALM,FALSE,FALSE,FALSE);
		}	
	if (iTotal >= 19)
		{{FeatAdd(oPC,FEAT_EMPTY_BODY,FALSE,FALSE,FALSE);
		}	
		
	
		

	
}

}}