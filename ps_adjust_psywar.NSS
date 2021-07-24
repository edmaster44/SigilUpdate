
#include "aaa_constants"
#include "gui_add_psywarfeat"


void DoPsyProgression(object oPC);

//Progression for Psychic Warrior and PRC
void DoPsyProgression(object oPC)
{	
	int iTotal;
	int nPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC);
	int nWarMind = GetLevelByClass(CLASS_TYPE_WARMIND,oPC);
	int nGemDragon = GetLevelByClass(128, oPC) / 2 + 1;
	iTotal = nPsywar + nGemDragon + nWarMind;

switch (iTotal)

{ case 1: FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_I, FALSE, FALSE, FALSE); break;
  case 3: FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_II, FALSE, FALSE, FALSE); FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_I); break;
  case 6:FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_III, FALSE, FALSE, FALSE);FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_II); break;
  case 9:FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_IV, FALSE, FALSE, FALSE);	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_III); break;
  case 12:FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_V, TRUE, TRUE, FALSE); FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_IV);break;
  case 16:FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_VI, TRUE, TRUE, FALSE);  FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_V);break;
  case 21:FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_VI); break;
  }
  

	
 PsyWarProgression(oPC);
	
	/*if (iTotal >=20){
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
                
}
else if (iTotal < 1){
return; }*/
}