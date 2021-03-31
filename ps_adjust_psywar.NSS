#include "ps_inc_functions"
#include "ps_class_inc"
#include "aaa_constants"





//This determines the Psychic warrior Progression feat they receive during leveling up
void DoPsyProgression(object oPC);
//Progression for Psychic Warrior and PRC
void DoPsyProgression(object oPC)
{
	int nPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC);
	int nWarMind = GetLevelByClass(CLASS_TYPE_WARMIND,oPC);
	int nGemDragon = GetLevelByClass(128, oPC) / 2 + 1;
	int nLEVEL = nPsywar + nGemDragon + nWarMind;
	if (nPsywar < 1) return;
	
	if (nLEVEL <1) return;
	else
				if (LEVEL >= 1)
			{
				FeatAdd(OBJECT_SELF, 21464, TRUE, TRUE, FALSE);
				
			}
			if (nLEVEL >= 3)
			{	FeatRemove(OBJECT_SELF,21464);
				FeatAdd(OBJECT_SELF, 21465, TRUE, TRUE, FALSE);
				//FeatRemove(OBJECT_SELF,21464);
				
			}
			if (nLEVEL >= 6)
			{	FeatRemove(OBJECT_SELF,21465);
				FeatAdd(OBJECT_SELF, 21466, TRUE, TRUE, FALSE);
					//FeatRemove(OBJECT_SELF,21465);
			}
			if (nLEVEL >= 9)
			{	FeatRemove(OBJECT_SELF,21466);
				FeatAdd(OBJECT_SELF, 21467, TRUE, TRUE, FALSE);
			}	//FeatRemove(OBJECT_SELF,21466);
			
			if (nLEVEL >= 12)
			{	FeatRemove(OBJECT_SELF,21467);
				FeatAdd(OBJECT_SELF, 21468, TRUE, TRUE, FALSE);
				//FeatRemove(OBJECT_SELF,21467);
			}
			if (nLEVEL >= 16)
			{	FeatRemove(OBJECT_SELF,21468);
				FeatAdd(OBJECT_SELF, 21469, TRUE, TRUE, FALSE);
				//FeatRemove(OBJECT_SELF,21468);
			}
			if (nLEVEL >= 20 )
			{
			FeatRemove(OBJECT_SELF,21469);
			}
			
		}
