#include "ps_inc_functions"
#include "ps_class_inc"
#include "aaa_constants"

//Progression for Psychic Warrior and PRC
void DoPsyProgression(object oPC)
{
	int nPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC);
	int nWarMind = GetLevelByClass(CLASS_TYPE_WARMIND,oPC);
	if (nPsywar < 1) return;
	int nGemDragon = GetLevelByClass(128, oPC) / 2 + 1;
	int nLEVEL = nPsywar + nGemDragon + nWarMind;
	
	if (nLEVEL <1) return;
	else
				if (!GetHasFeat(21464, oPC) && nLEVEL >= 0)
			{
				FeatAdd(OBJECT_SELF, 21464, TRUE, TRUE, FALSE);
				
			}
			if (!GetHasFeat(21465, oPC) && nLEVEL >= 2)
			{	FeatRemove(OBJECT_SELF,21464);
				FeatAdd(OBJECT_SELF, 21465, TRUE, TRUE, FALSE);
				//FeatRemove(OBJECT_SELF,21464);
				
			}
			if (!GetHasFeat(21466, oPC) && nLEVEL >= 5)
			{	FeatRemove(OBJECT_SELF,21465);
				FeatAdd(OBJECT_SELF, 21466, TRUE, TRUE, FALSE);
					//FeatRemove(OBJECT_SELF,21465);
			}
			if (!GetHasFeat(21467, oPC) && nLEVEL >= 8)
			{	FeatRemove(OBJECT_SELF,21466);
				FeatAdd(OBJECT_SELF, 21467, TRUE, TRUE, FALSE);
			}	//FeatRemove(OBJECT_SELF,21466);
			
			if (!GetHasFeat(21468, oPC) && nLEVEL >= 11)
			{	FeatRemove(OBJECT_SELF,21467);
				FeatAdd(OBJECT_SELF, 21468, TRUE, TRUE, FALSE);
				//FeatRemove(OBJECT_SELF,21467);
			}
			if (!GetHasFeat(21469, oPC) && nLEVEL >= 15)
			{	FeatRemove(OBJECT_SELF,21468);
				FeatAdd(OBJECT_SELF, 21469, TRUE, TRUE, FALSE);
				//FeatRemove(OBJECT_SELF,21468);
			}
			if (nLEVEL >= 19 )
			{
			FeatRemove(OBJECT_SELF,21469);
			}
			
		}
