//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons a Druid's animal companion
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

const int FEAT_PACK_HUNTER = 2880;
const int FEAT_ARMOR_OF_THE_CROCODILE = 2936;
const int FEAT_CLAWS_OF_THE_GRIZZLY = 2938;
const int FEAT_EARTH_RESILIENCE = 2939;
const int FEAT_NATURES_WEAPON = 2940;
const int FEAT_WILD_GROWTH = 2943;

void main()
{
    //Yep thats it
    SummonAnimalCompanion();
	
	// No it's not. Adding Pack Hunter - Electrohydra.
	object oPC = OBJECT_SELF;
	object oCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
	
	if (GetHasFeat(FEAT_ARMOR_OF_THE_CROCODILE,oPC)) FeatAdd(oCompanion, FEAT_ARMOR_OF_THE_CROCODILE, FALSE, FALSE, FALSE);
	if (GetHasFeat(FEAT_CLAWS_OF_THE_GRIZZLY,oPC)) FeatAdd(oCompanion, FEAT_CLAWS_OF_THE_GRIZZLY, FALSE, FALSE, FALSE);
	if (GetHasFeat(FEAT_EARTH_RESILIENCE,oPC)) FeatAdd(oCompanion, 493, FALSE, FALSE, FALSE);
	if (GetHasFeat(FEAT_NATURES_WEAPON,oPC)) FeatAdd(oCompanion, FEAT_NATURES_WEAPON, FALSE, FALSE, FALSE);
		if (GetHasFeat(FEAT_WILD_GROWTH,oPC)) FeatAdd(oCompanion, FEAT_WILD_GROWTH, FALSE, FALSE, FALSE);
	
	if (GetHasFeat(FEAT_PACK_HUNTER, oPC))
	{
	
		
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