#include "ps_inc_treasuregeneration"
//***********************************************************************
//Creates an item on the PC as a quest reward
//standard treasure probabilities apply
//Allows you to specify what category to generate from
//The treasure level is set by the CR of the creature
//Or the QUEST_CR integer on the creature
//***********************************************************************
//Valid TREASURE_TYPE values
//Armor
//Weapon
//Boots
//Trinket
//Jewelry
//Cloak
//Gloves
//Belt
//Helmet
//Shield
//***********************************************************************

void main(string TREASURE_TYPE) {

	object oPC = GetPCSpeaker();

	int TREASURE_LEVEL = 1;
	int nCR = GetChallengeRatingOfTarget(OBJECT_SELF);
	if (nCR < 10)
		TREASURE_LEVEL = 1;
	else if (nCR < 20)
		TREASURE_LEVEL = 2;
	else if (nCR < 25)
		TREASURE_LEVEL = 3;
	else
		TREASURE_LEVEL = 4;
		
	if (TREASURE_TYPE == "Armor") {
		CreateArmorOnTarget(oPC, TREASURE_LEVEL);
	} else if (TREASURE_TYPE == "Weapon") {
		CreateWeaponOnTarget(oPC, TREASURE_LEVEL);
	} else if (TREASURE_TYPE == "Boots") {
		CreateWearableOnTarget(oPC, "treasure_boots", 71, TREASURE_LEVEL);
	} else if (TREASURE_TYPE == "Trinket") {
		CreateJunkOnTarget(oPC, TREASURE_LEVEL);
	} else if (TREASURE_TYPE == "Jewelry") {
		CreateJewelryOnTarget(oPC, TREASURE_LEVEL);
	} else if (TREASURE_TYPE == "Cloak") {
		CreateWearableOnTarget(oPC, "treasure_cloaks", 12, TREASURE_LEVEL);
	} else if (TREASURE_TYPE == "Gloves") {
		CreateGlovesOnTarget(oPC, TREASURE_LEVEL);
	} else if (TREASURE_TYPE == "Belt") {
		CreateWearableOnTarget(oPC, "treasure_belts", 5, TREASURE_LEVEL);
	} else if (TREASURE_TYPE == "Helmet") {
		CreateWearableOnTarget(oPC, "treasure_helmets", 35, TREASURE_LEVEL);
	} else if (TREASURE_TYPE == "Shield") {
		CreateShieldOnTarget(oPC, TREASURE_LEVEL);
	} else {
		SendMessageToPC(oPC, "invalid item type");
	}

}