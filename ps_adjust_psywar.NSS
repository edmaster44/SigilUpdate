#include "ps_inc_functions"
#include "ps_class_inc"
#include "aaa_constants"




//GUI Stuff
int PsyWarProgression(object oPC)
{
	
	int nPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC);

	if (GetLevelByClass(nPsywar, oPC) >= 0)
{	
	
	if (!GetHasFeat(FEAT_PSYWAR_FERAL,oPC)||!GetHasFeat(FEAT_PSYWAR_LURK,oPC))
		
	{AddScriptParameterString("START");
	AddScriptParameterString("");
	ExecuteScriptEnhanced("gui_extra_choices", oPC); }
	

}
return nPsywar;
}

//Progression for Psychic Warrior and PRC
void DoPsyProgression(object oPC)
{
	int nPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC);
	if (nPsywar < 1) return;
	int nWarMind = GetLevelByClass(CLASS_TYPE_WARMIND,oPC);
	int nGemDragon = GetLevelByClass(128, oPC) / 2 + 1;
	int iTotal = nPsywar + nGemDragon + nWarMind;
	
			if (iTotal >= 0)
			{	
			
			FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_I, FALSE, FALSE, FALSE);
			//FeatRemove(OBJECT_SELF,21464);
				
			}
			if (iTotal >= 3)
			{	
				
				FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_I);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_II, FALSE, FALSE, FALSE);
					//FeatRemove(OBJECT_SELF,21465);
			}
			if (iTotal >= 6)
			{	
			
				FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_II);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_III, FALSE, FALSE, FALSE);
			}	//FeatRemove(OBJECT_SELF,21466);
			
			if (iTotal >= 10)
			{	
			
				FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_III);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_IV, FALSE, FALSE, FALSE);
				
				//FeatRemove(OBJECT_SELF,21467);
			}
			if (iTotal >= 13)
			{	
			
				FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_IV);
				FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_V, TRUE, TRUE, FALSE);
				
				//FeatRemove(OBJECT_SELF,21468);
			}
			if (iTotal >= 16 )
			{
			FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_VI, TRUE, TRUE, FALSE);
				
			}
				if (iTotal >= 21 )
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
		