//This Script adds Base Barbarian Feats
//Based on iBarb,very adjustable
//

#include "aaa_constants"

void PS_BarbarianLevels(object oPC);
int GetBarbarianLevels(object oPC);


int GetBarbarianLevels(object oPC){
	int iBarb = GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);
	if (iBarb < 1) return 0; //prcs only advance barb if you have at least 1 base class barb
	
	iBarb += GetLevelByClass(CLASS_TYPE_BRALANI_PRC,oPC);//Bralani
	iBarb += GetLevelByClass(CLASS_TYPE_SAVAGE_MARAUDER_PRC,oPC);//Savage Marauder
	iBarb += GetLevelByClass(CLASS_TYPE_SCALED_HUNTER_PRC,oPC);//Scaled Hunter
	iBarb += GetLevelByClass(CLASS_TYPE_HILL_GIANT_PRC,oPC);//Hill Giant
	iBarb += GetLevelByClass(CLASS_TYPE_FROST_GIANT_PRC,oPC);//Frost Giant PRC
	iBarb += GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER,oPC);//Frenized Berserker.
	
	if(GetHasFeat(FEAT_LYCAN_BP_WEREBOAR,oPC,TRUE)) 
		iBarb += GetLevelByClass(CLASS_TYPE_LYCAN_PRC,oPC);


	return iBarb;
}

void PS_BarbarianLevels(object oPC){

	//barb rage 7 appears to be bugged, so let's remove it for now
	if (GetHasFeat(FEAT_BARBARIAN_RAGE7, oPC, TRUE))
		FeatRemove(oPC, FEAT_BARBARIAN_RAGE7);
		
	
	int iBarb = GetBarbarianLevels(oPC);
	if (iBarb < 1) return;

	if (iBarb >= 1){
		FeatAdd(oPC,FEAT_BARBARIAN_RAGE,FALSE);
	}	
	if (iBarb >= 2){ 	
		FeatAdd(oPC,FEAT_UNCANNY_DODGE,FALSE);		
	}
	if (iBarb >= 3){
		FeatAdd(oPC,FEAT_TRAP_SENSE_1,FALSE);
	}
	if(iBarb >= 4){
		FeatAdd(oPC,FEAT_BARBARIAN_RAGE_2,FALSE);
	}		 
	if (iBarb >= 5){
		FeatAdd(oPC,FEAT_IMPROVED_UNCANNY_DODGE,FALSE);
	}	
	if (iBarb >= 6){
		FeatAdd(oPC,FEAT_TRAP_SENSE_2,FALSE);
	}		
	if (iBarb >= 7){
		FeatAdd(oPC,FEAT_DAMAGE_REDUCTION,FALSE);
	}	
	if (iBarb >= 8){
		FeatAdd(oPC,FEAT_BARBARIAN_RAGE3,FALSE);
	}	
	if (iBarb >= 9){
		FeatAdd(oPC,FEAT_TRAP_SENSE_3,FALSE);
	}	
	if (iBarb >= 10){
		FeatAdd(oPC,FEAT_DAMAGE_REDUCTION2,FALSE);
	}		
	if (iBarb >= 11){
		FeatAdd(oPC,FEAT_GREATER_RAGE,FALSE);
	}	
	if (iBarb >= 12){
		FeatAdd(oPC,FEAT_BARBARIAN_RAGE_4,FALSE);
	}	
	if (iBarb >= 13){
		FeatAdd(oPC,FEAT_DAMAGE_REDUCTION3,FALSE);
	}	
	if (iBarb >= 14){
		FeatAdd(oPC,FEAT_INDOMITABLE_WILL,FALSE);
	}	
	if (iBarb >= 15){
		FeatAdd(oPC,FEAT_TRAP_SENSE_5,FALSE);
	}	
	if (iBarb >= 16){
		FeatAdd(oPC,FEAT_DAMAGE_REDUCTION4,FALSE);
		FeatAdd(oPC,FEAT_BARBARIAN_RAGE_6,FALSE);
	}		
	if (iBarb >= 17){
		FeatAdd(oPC,FEAT_TIRELESS_RAGE,FALSE);
	}
	if (iBarb >= 18){
		FeatAdd(oPC,FEAT_TRAP_SENSE_6,FALSE);
	}
	if (iBarb >= 20){
		FeatAdd(oPC,FEAT_DAMAGE_REDUCTION5,FALSE);
		//rage 7 appears to be bugged. Uses per day drops to 4
		// no matter what I set it to in feat.2da -FlattedFifth
		//FeatAdd(oPC,FEAT_BARBARIAN_RAGE7,FALSE);
	}		
	if (iBarb >= 21){
		FeatAdd(oPC,FEAT_EPIC_BARBARIAN,FALSE);
		FeatAdd(oPC,FEAT_EPIC_BARBARIAN_RAGE,FALSE);
	}	
	if (iBarb >= 22){
		FeatAdd(oPC,FEAT_DAMAGE_REDUCTION_6,FALSE);
	}	
	if (iBarb >= 24){
		FeatAdd(oPC,FEAT_TRAP_SENSE_8,FALSE);
	}	
	if (iBarb >= 25){
		FeatAdd(oPC,FEAT_DAMAGE_REDUCTION7,FALSE);
		FeatAdd(oPC,FEAT_TRAP_SENSE9,FALSE);
	}	
	if (iBarb >= 27){
		FeatAdd(oPC,FEAT_DAMAGE_REDUCTION8,FALSE);
	}	
}