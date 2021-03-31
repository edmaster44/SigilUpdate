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
	
	else
				if (nLEVEL >= 0)
			{
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_I, TRUE, TRUE, FALSE);
				
			}
			if (nLEVEL >= 2)
			{	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_I);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_II, TRUE, TRUE, FALSE);
				//FeatRemove(OBJECT_SELF,21464);
				
			}
			if (nLEVEL >= 5)
			{	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_II);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_III, TRUE, TRUE, FALSE);
					//FeatRemove(OBJECT_SELF,21465);
			}
			if (nLEVEL >= 8)
			{	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_III);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_IV, TRUE, TRUE, FALSE);
			}	//FeatRemove(OBJECT_SELF,21466);
			
			if (nLEVEL >= 11)
			{	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_IV);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_V, TRUE, TRUE, FALSE);
				//FeatRemove(OBJECT_SELF,21467);
			}
			if (nLEVEL >= 15)
			{	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_V);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_VI, TRUE, TRUE, FALSE);
				//FeatRemove(OBJECT_SELF,21468);
			}
			if (nLEVEL >= 19 )
			{
			FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_VI);
			}
			
		}