
#include "aaa_constants"


int DoPsyProgression(object oPC);

//Progression for Psychic Warrior and PRC
int DoPsyProgression(object oPC)
{	
	int iTotal;	
	int nPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, OBJECT_SELF);
	int nWarMind = GetLevelByClass(CLASS_TYPE_WARMIND,OBJECT_SELF);
	int nGemDragon = GetLevelByClass(128, OBJECT_SELF) / 2 + 1;
	iTotal = nPsywar + nGemDragon + nWarMind;


	if (iTotal >=21){
	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_VI);}
	else if (iTotal >= 17 ) {
		  FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_V);
  FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_VI, TRUE, TRUE, FALSE);
} else if (iTotal >= 14) {    
  FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_IV);
  FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_V, TRUE, TRUE, FALSE);
}
else if (iTotal >= 11) {    
	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_III);
	FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_IV, FALSE, FALSE, FALSE);
}
else if (iTotal >= 7)
{FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_II);
                FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_III, FALSE, FALSE, FALSE);}
else if (iTotal >= 4){ 
FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_I);
FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_II, FALSE, FALSE, FALSE);
            }
else if (iTotal >= 1){    
FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_I, FALSE, FALSE, FALSE);}

return iTotal;
}