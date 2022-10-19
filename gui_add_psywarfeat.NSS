#include "ps_inc_functions"
#include "ps_class_inc"
#include "aaa_constants"


int PsyWarProgression(object oPC);

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
/*void DoPsyProgression(object oPC)
{
	int nPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC);
	int nWarMind = GetLevelByClass(CLASS_TYPE_WARMIND,oPC);
	int nGemDragon = GetLevelByClass(128, oPC) / 2 + 1;
	int iTotal = nPsywar + nGemDragon + nWarMind;
	
	if (iTotal >=20){
	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_VI);}
	else if (iTotal >= 16 ) {
		  FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_V);
  FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_VI, TRUE, TRUE, FALSE);
} else if (iTotal >= 13) {    
  FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_IV);
  FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_V, TRUE, TRUE, FALSE);
}
else if (iTotal >= 10) {    
	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_III);
	FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_IV, FALSE, FALSE, FALSE);
}
else if (iTotal >= 6)
{FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_II);
                FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_III, FALSE, FALSE, FALSE);}
else if (iTotal >= 3){ 
FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_I);
FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_II, FALSE, FALSE, FALSE);
            }
else if (iTotal >= 1){    
FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_I, FALSE, FALSE, FALSE);
                
}*/