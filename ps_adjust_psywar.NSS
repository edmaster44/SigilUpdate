#include "ps_inc_functions"
#include "ps_class_inc"
#include "aaa_constants"







//Progression for Psychic Warrior and PRC
void DoPsyProgression(object oPC)
{
	int nPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC);
	if (nPsywar < 1) return;
	int nWarMind = GetLevelByClass(CLASS_TYPE_WARMIND,oPC);
	int nGemDragon = GetLevelByClass(128, oPC) / 2 + 1;
	int nLEVEL = nPsywar + nGemDragon + nWarMind;

	
	
		if (nLEVEL >= 1)

			{	


			int iHasBonus	= GetLocalInt(oPC, "PSYWAR1");
				if (iHasBonus == 1)
				{	return;		}
				else
				
				{AddScriptParameterString("START");
				AddScriptParameterString("");
				ExecuteScriptEnhanced("gui_extra_choices", oPC);}
				SetLocalInt(oPC, "PSYWAR1", 1);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_I, FALSE, FALSE, FALSE);
				
			}



			if (nLEVEL >= 4)
			{	FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_II, FALSE, FALSE, FALSE);
				FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_I);
				
				//FeatRemove(OBJECT_SELF,21464);
				
			}
			if (nLEVEL >= 6)
			{	
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_III, FALSE, FALSE, FALSE);
				FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_II);
				
					//FeatRemove(OBJECT_SELF,21465);
			}
			if (nLEVEL >= 9)
			{	
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_IV, FALSE, FALSE, FALSE);
				FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_III);
			}	//FeatRemove(OBJECT_SELF,21466);
			
			if (nLEVEL >= 12)
			{	
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_V, FALSE, FALSE, FALSE);
				FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_IV);
				//FeatRemove(OBJECT_SELF,21467);
			}
			if (nLEVEL >= 16)
			{	
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_VI, TRUE, TRUE, FALSE);
				FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_V);
				//FeatRemove(OBJECT_SELF,21468);
			}
			if (nLEVEL >= 21 )
			{
			FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_VI);
			}
			
			if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Augment Power");	}
		if (GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Empower Power");	}
		if (GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_EXTEND", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Extend Power");		}
		if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE", 0);	
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Maximize Power");	}
		if (GetLocalInt(OBJECT_SELF, "METAPSI_TWIN") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_TWIN", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Twin Power");		}
		}
		
