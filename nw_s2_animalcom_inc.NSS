 
#include "aaa_constants"

const int FEAT_PACK_HUNTER = 2880;


void NatureWarriorCompanion(object oPC, object oCompanion){
 
	if (GetHasFeat(FEAT_ARMOR_OF_THE_CROCODILE,oPC)) FeatAdd(oCompanion, FEAT_ARMOR_OF_THE_CROCODILE, FALSE, FALSE, FALSE);
	if (GetHasFeat(FEAT_CLAWS_OF_THE_GRIZZLY,oPC)) FeatAdd(oCompanion, FEAT_CLAWS_OF_THE_GRIZZLY, FALSE, FALSE, FALSE);
	if (GetHasFeat(FEAT_EARTH_RESILIENCE,oPC)) FeatAdd(oCompanion, FEAT_EARTH_RESILIENCE, FALSE, FALSE, FALSE);
	if (GetHasFeat(FEAT_NATURES_WEAPON,oPC)) FeatAdd(oCompanion, FEAT_NATURES_WEAPON, FALSE, FALSE, FALSE);
	if (GetHasFeat(FEAT_WILD_GROWTH,oPC)) FeatAdd(oCompanion, FEAT_WILD_GROWTH, FALSE, FALSE, FALSE);
	
	if (GetHasFeat(FEAT_PACK_HUNTER, oPC)){
		int i;
		int j;
		// Add Favored Enemie feats
		for (i = FEAT_FAVORED_ENEMY_DWARF; i <= FEAT_FAVORED_ENEMY_VERMIN; ++i)
		{
			if (GetHasFeat(i, oPC)) FeatAdd(oCompanion, i, FALSE, FALSE, FALSE);
		}
		// Add Favored Improved Enemie feats
		for (j = FEAT_IMPROVED_FAVORED_ENEMY_DWARF; j <= FEAT_IMPROVED_FAVORED_ENEMY_VERMIN; ++j)
		{
			if (GetHasFeat(j, oPC)) FeatAdd(oCompanion, j, FALSE, FALSE, FALSE);
		}
		// Add Bane of Enemies
		if (GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES, oPC)) FeatAdd(oCompanion, FEAT_EPIC_BANE_OF_ENEMIES, FALSE, FALSE, FALSE);
	}
}