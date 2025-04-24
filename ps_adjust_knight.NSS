#include "aaa_constants"

void PS_KnightLevels(object oPC);
int KnightLevels(object oPC);
int LayOnHandsLevels(object oPC);

void PS_KnightLevels(object oPC){

	int iTotal = KnightLevels(oPC);

	if (iTotal < 1 ){
		return;
	} else if (iTotal >= 1){
		if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL){
			if(!GetHasFeat(FEAT_BLACKGUARD, oPC, TRUE))
				FeatAdd(oPC,FEAT_BLACKGUARD,FALSE,FALSE,FALSE);
			if (GetHasFeat(FEAT_PALADIN, oPC, TRUE))
				FeatRemove(oPC, FEAT_PALADIN);
			if (GetHasFeat(FEAT_KNIGHT, oPC, TRUE))
				FeatRemove(oPC, FEAT_KNIGHT);
		} else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD){
			if(!GetHasFeat(FEAT_PALADIN, oPC, TRUE))
				FeatAdd(oPC,FEAT_PALADIN,FALSE,FALSE,FALSE);
			if (GetHasFeat(FEAT_BLACKGUARD, oPC, TRUE))
				FeatRemove(oPC, FEAT_BLACKGUARD);
			if (GetHasFeat(FEAT_KNIGHT, oPC, TRUE))
				FeatRemove(oPC, FEAT_KNIGHT);
		} else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL){
			if(!GetHasFeat(FEAT_KNIGHT, oPC, TRUE))
				FeatAdd(oPC,FEAT_KNIGHT,FALSE,FALSE,FALSE);
			if (GetHasFeat(FEAT_BLACKGUARD, oPC, TRUE))
				FeatRemove(oPC, FEAT_BLACKGUARD);
			if (GetHasFeat(FEAT_PALADIN, oPC, TRUE))
				FeatRemove(oPC, FEAT_PALADIN);
		}
	}
	
	// BLACKGUARD FEATS:
	if (GetHasFeat(FEAT_BLACKGUARD,oPC, TRUE)){
		if (iTotal >= 1){
			FeatAdd(oPC,FEAT_USE_POISON,FALSE,FALSE,FALSE);//Use Poison, BG Path
			FeatAdd(oPC,FEAT_SMITE_GOOD,FALSE,FALSE,FALSE);//Smite Good, BG Path
			FeatAdd(oPC,FEAT_BULLS_STRENGTH,FALSE,FALSE,FALSE);//Bull's Strength Feat
		}
		if (iTotal >= 2){
			FeatAdd(oPC,FEAT_PRESTIGE_DARK_BLESSING,FALSE,FALSE,FALSE);//Dark Blessing, BG Path
			FeatAdd(oPC,1832,FALSE,FALSE,FALSE);//Aura of Despair, BG Path
		}
		if (iTotal >= 4){
			FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);//Turn Undead, BG Path
		}
		if (iTotal >= 5){
			FeatAdd(oPC,FEAT_INFLICT_LIGHT_WOUNDS,FALSE,FALSE,FALSE);
		}
		if (iTotal >= 7){
			FeatAdd(oPC,FEAT_CONTAGION,FALSE,FALSE,FALSE);//Contagion, BG Path
			FeatAdd(oPC,FEAT_FEINT,FALSE,FALSE,FALSE);//Feint
			FeatAdd(oPC,FEAT_INFLICT_CRITICAL_WOUNDS,FALSE,FALSE,FALSE);//Inflict Critical Wounds, BG Path
		}
		if (iTotal >= 9){
			FeatAdd(oPC,475,FALSE,FALSE,FALSE);//Summon Fiend , BG Path
			FeatAdd(oPC,2654,FALSE,FALSE,FALSE);//Unsummon Fiend, BG Path
		}
		if (iTotal >= 14 && GetHasFeat(FEAT_BLACKGUARD,oPC)){
			FeatAdd(oPC,FEAT_KNOCKDOWN,FALSE,FALSE,FALSE);//KnockDown , BG Path
		}
		if (iTotal >= 21){
			FeatAdd(oPC,1970,FALSE,FALSE,FALSE);//Expose Weakness , BG Path
		}
	} // END BLACKGUARD FEATS
	
	// PALADIN FEATS
	if (GetHasFeat(FEAT_PALADIN, oPC, TRUE)){
		if (iTotal >= 1){
			FeatAdd(oPC,FEAT_SMITE_EVIL,FALSE,FALSE,FALSE);//Smite Evil , Paladin Path
			FeatAdd(oPC,FEAT_LAY_ON_HANDS,FALSE,FALSE,FALSE);//Lay on Hands, Paladin
			FeatAdd(oPC,FEAT_DIVINE_GRACE,FALSE,FALSE,FALSE);//Divine Grace, Paladin
		}
		if (iTotal >= 3){
	  		FeatAdd(oPC,FEAT_DIVINE_HEALTH,FALSE,FALSE,FALSE);//Divine Health , Paladin Path
			FeatAdd(oPC,FEAT_AURA_OF_COURAGE,FALSE,FALSE,FALSE);//Aura of Courage , Paladin Path
		}
		if (iTotal >= 4){
	  		FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);// Turn Undead, Paladin Path
		}
		if (iTotal >= 6){
	  		FeatAdd(oPC,FEAT_REMOVE_DISEASE,FALSE,FALSE,FALSE);// Remove Disease, Paladin Path
		}
		if (iTotal >= 7){
	  		FeatAdd(oPC,2836,FALSE,FALSE,FALSE);// Armor Optimization, Paladin Path
		}
		if (iTotal >= 14){
	  		FeatAdd(oPC,2837,FALSE,FALSE,FALSE);// Greater Armor Optimization, Paladin Path
		}
	  	if (iTotal >= 21){
	  		FeatAdd(oPC,2838,FALSE,FALSE,FALSE);// Epic Armor Optimization, Paladin Path
		}	
	} // END PALADIN FEATS
	
	// KNIGHT FEATS
	if (GetHasFeat(FEAT_KNIGHT, oPC)){
		if (iTotal >= 1){
			FeatAdd(oPC,FEAT_LAY_ON_HANDS,FALSE,FALSE,FALSE);//Lay on Hands, Paladin & Knight
		}
		if (iTotal >= 2){
			FeatAdd(oPC,FEAT_DIVINE_GRACE,FALSE,FALSE,FALSE);//Divine Grace, Paladin & Knight
		}
		if (iTotal >= 3){
	  		FeatAdd(oPC,FEAT_DIVINE_RETRIBUTION,FALSE,FALSE,FALSE);//Divine Retribution , Knight Path
			FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);// Turn Undead, Knight Path
		}
		if (iTotal >= 5){
			FeatAdd(oPC,1761,FALSE,FALSE,FALSE);//Smite Infidel , Knight Path
		}
		if (iTotal >= 6){
	  		FeatAdd(oPC,FEAT_KNIGHTS_AURA,FALSE,FALSE,FALSE);// Knight's Aura, Knight Path
			FeatAdd(oPC,FEAT_PRACTICED_SPELLCASTER_PALADIN,FALSE,FALSE,FALSE);// Practiced Spell Caster
		}
		if (iTotal > 20){ 
			FeatAdd(oPC,1990,FALSE,FALSE,FALSE);//Rescue Feat , Knight Path
		}
	} // END KNIGHT FEATS

}


int KnightLevels(object oPC){

	int nLevel = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);//Paladin, aka, Knight
	if (nLevel < 1 ) return 0;
	
	nLevel += GetLevelByClass(CLASS_TYPE_WARPRIEST,oPC) + 
		GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,oPC);
	
	// add knight path new dragon PRC, gets +1 knight lvl for lvls 3 through 6 of new prc
	if (GetHasFeat(3676, oPC)){
		int iDragonKnight = GetLevelByClass(129, oPC) - 2;
		if (iDragonKnight > 0) nLevel += iDragonKnight;
	}
	
	if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL){
		nLevel += GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC,oPC)
		+ GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION,oPC) + GetLevelByClass(CLASS_TYPE_ERINYES,oPC);
		if (GetHasFeat(FEAT_OUTSIDER_BLOODLINE_FIENDISH,oPC)){
			nLevel += GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);
			if (GetHasFeat(3036,oPC)) nLevel += GetLevelByClass(CLASS_TYPE_HALFOUTSIDERMAGE_PRC,oPC);
		}
	} else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD){
		nLevel += GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC,oPC);
		if (GetHasFeat(2455)){
			nLevel += GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC,oPC) + 
				GetLevelByClass(CLASS_TYPE_GHAELE_PRC,oPC);
		}
		if (GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL,oPC)){
			nLevel += GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);
			if (GetHasFeat(3036,oPC)){
				nLevel += GetLevelByClass(CLASS_TYPE_HALFOUTSIDERMAGE_PRC,oPC);
			}
		}
	} else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL){
		nLevel += GetLevelByClass(CLASS_NWNINE_WARDER,oPC) + 
			GetLevelByClass(CLASS_TYPE_DOOMGUIDE,oPC) +
			GetLevelByClass(CLASS_TYPE_GHAELE_PRC,oPC);
		if (GetHasFeat(2673)) nLevel += GetLevelByClass(CLASS_TYPE_ASTRAL_DEVA_PRC,oPC);
		if (GetHasFeat(2635)) nLevel += GetLevelByClass(42,oPC);	
	}
	
	return nLevel;
}

int LayOnHandsLevels(object oPC){
	return KnightLevels(oPC);
}