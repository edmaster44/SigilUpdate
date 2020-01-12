//***************************************************
//Handles new loot generation
//Created 11-2-18 - Mimi Fearthegn
//Modified 6/18/19 - Mimi Fearthegn (added epic quest pools)
//***************************************************
#include "ginc_debug"
#include "ps_inc_randomitems"
#include "ps_inc_gemstones"
#include "ps_inc_cards"
#include "ps_inc_treasurepool"
//***************************************************
//Loot Levels
const int TREASURE_LOW = 1;
const int TREASURE_MEDIUM = 2;
const int TREASURE_HIGH = 3;
const int TREASURE_EPIC = 4;
const int TREASURE_QUEST_LOW = 5; //epic quest pool #1
const int TREASURE_QUEST_MED = 6; //epic quest pool #2
const int TREASURE_QUEST_HIGH = 7; //epic quest pool #3
//Gold Levels
const float LOW_MOD_GOLD = 0.5;   
const float MEDIUM_MOD_GOLD = 1.0; 
const float HIGH_MOD_GOLD = 3.0;
const float EPIC_MOD_GOLD = 5.0;
//Categories / Probabilities
const int EQUIPPABLE_CHANCE = 25; //chance to get something you can wear
const int UNEQUIPPABLE_ALCHEMY_CHANCE = 42;
const int UNEQUIPPABLE_JUNK_CHANCE = 30;
const int UNEQUIPPABLE_SCROLL_CHANCE = 25;
const int UNEQUIPPABLE_GOLD_CHANCE = 0;
const int UNEQUIPPABLE_GEM_CHANCE = 2;
const int UNEQUIPPABLE_CARD_CHANCE = 1;
//***************************************************
//Utility
//***************************************************
//Database upload
void UploadItemToDatabase(string sItem, string sTable, object oTarget, int nTreasureLevel, string sSpecial = "") {
	object oItem = CreateItemOnObject(sItem, oTarget);
	string sTag = GetTag(oItem);
	string sName = SQLEncodeSpecialChars(GetName(oItem));
	string sQuery = "INSERT INTO "+sTable+" SET name='"+sName+"', resref='"+sTag+"', treasure_level='"+IntToString(nTreasureLevel)+"'";
	if (sSpecial != "") {
		sQuery += ", special='"+sSpecial+"'";
	}
	SendMessageToPC(oTarget, sQuery);
	SQLExecDirect(sQuery);
	DestroyObject(oItem, 0.1f);
}

int GetMaxItemsInDatabaseTable(string sTable, int nTreasureLevel, string sSubTable = "", int nCombineLevels = FALSE) {
	object oHolder = GetModule();
	int nMax = GetLocalInt(oHolder, sTable+sSubTable+"_"+IntToString(nTreasureLevel));
	if (nMax > 0)
		return nMax;
		
	string sQuery = "SELECT COUNT(*) FROM "+sTable+" WHERE ";
	if (nCombineLevels) 
		sQuery += "treasure_level <= "+IntToString(nTreasureLevel);
	else
		sQuery += "treasure_level = "+IntToString(nTreasureLevel);
	if (sSubTable != "") 
		sQuery += " AND special='"+sSubTable+"'";
	
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		nMax = StringToInt(SQLGetData(1));
	}
	
	SetLocalInt(oHolder, sTable+sSubTable+"_"+IntToString(nTreasureLevel), nMax);
	return nMax;
}

//Gets an item resref from the database tables
//sTable = table to draw off of
//nTreasureLevel = TREASURE_LOW, TREASURE_MEDIUM, TREASURE_HIGH, TREASURE_EPIC (treasure epic is currently unpopulated)
//sSubTable = corresponds to the special column in some database tables; only used for junk currently
//when in doubt leave sSubTable = ""
//nCombineLevels = whether to combine the given treasure level pool with lower pools. Useful on smaller pools like junk
//do not use nCombineLevels on large pools like weapons
string PickItemFromDatabase(string sTable, int nTreasureLevel, string sSubTable = "", int nCombineLevels = FALSE) {
	int nMax = GetMaxItemsInDatabaseTable(sTable, nTreasureLevel, sSubTable, nCombineLevels);
	if (nMax == 0 && nTreasureLevel == TREASURE_EPIC) { //don't have epic tables for too many things yet
		nTreasureLevel = TREASURE_HIGH;
		nMax = GetMaxItemsInDatabaseTable(sTable, nTreasureLevel, sSubTable, nCombineLevels);
	}
	int nRandom = Random(nMax);
	
	string sQuery = "SELECT resref FROM "+sTable+" WHERE ";
	if (nCombineLevels) 
		sQuery += "treasure_level <= "+IntToString(nTreasureLevel);
	else
		sQuery += "treasure_level = "+IntToString(nTreasureLevel);
	if (sSubTable != "") 
		sQuery += " AND special='"+sSubTable+"'";
	sQuery += " LIMIT "+IntToString(nRandom)+", 1";
		
	SQLExecDirect(sQuery);
	string sItem = "ps_utility_error";
	if (SQLFetch() != SQL_ERROR) { 
		sItem = SQLGetData(1);
	} else {
		WriteTimestampedLogEntry(sQuery+" returned an error");
	}
	return sItem;
	
}

//Handles special material drops
//redo later
void SpecialDrop(string sAREA, object oSPAWN)
{
	string sSPECIAL;
	if(TestStringAgainstPattern("**abyss**", sAREA))
	{
		switch (Random(4))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_pd"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_bi"; break;
			case 2: sSPECIAL = "ps_crft_demonscale"; break;
			case 3: sSPECIAL = "ps_crft_plk_tb"; break;
		}
	}
	else if(TestStringAgainstPattern("**beastland**", sAREA))
	{
		switch (Random(7))
		{
			case 0: sSPECIAL = "ps_crft_dragonhide_blk"; break;
			case 1: sSPECIAL = "ps_crft_dragonhide_blu"; break;
			case 2: sSPECIAL = "ps_crft_plk_db"; break;
			case 3: sSPECIAL = "ps_crft_drgsnw"; break;
			case 4: sSPECIAL = "ps_crft_dragonhide_grn"; break;
			case 5: sSPECIAL = "ps_crft_dragonhide_red"; break;
			case 6: sSPECIAL = "ps_crft_dragonhide_wht"; break;
		}	
	}
	else if(TestStringAgainstPattern("**plateau**", sAREA))
	{
		switch (Random(7))
		{
			case 0: sSPECIAL = "ps_crft_dragonhide_blk"; break;
			case 1: sSPECIAL = "ps_crft_dragonhide_blu"; break;
			case 2: sSPECIAL = "ps_crft_plk_db"; break;
			case 3: sSPECIAL = "ps_crft_drgsnw"; break;
			case 4: sSPECIAL = "ps_crft_dragonhide_grn"; break;
			case 5: sSPECIAL = "ps_crft_dragonhide_red"; break;
			case 6: sSPECIAL = "ps_crft_dragonhide_wht"; break;
		}	
	}
	else if(TestStringAgainstPattern("**carceri**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_mi"; break;
			case 1: sSPECIAL = "ps_crft_ing_au"; break;
		}	
	}
	else if(TestStringAgainstPattern("**astral**", sAREA))
	{
		sSPECIAL = "ps_crft_ing_ms";
	}
	else if(TestStringAgainstPattern("**eearth**", sAREA))
	{
		switch (Random(3))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_bg"; break;
			case 1: sSPECIAL = "ps_crft_ing_gs"; break;
			case 2: sSPECIAL = "ps_crft_ing_rv"; break;
		}	
	}
	else if(TestStringAgainstPattern("**epicgraywaste**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_mi"; break;
			case 1: sSPECIAL = "ps_crft_plk_ao"; break;
		}	
	}
	else if(TestStringAgainstPattern("**Niflheim**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_mi"; break;
			case 1: sSPECIAL = "ps_crft_plk_ao"; break;
		}	
	}
	else if(TestStringAgainstPattern("**graywaste**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_by"; break;
			case 1: sSPECIAL = "ps_crft_ing_ap"; break;
		}	
	}
	else if(TestStringAgainstPattern("**ice-**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_crft_ing_rv"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_bg"; break;
		}	
	}
	else if(TestStringAgainstPattern("**mercuria**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_st"; break;
			case 1: sSPECIAL = "ps_crft_celestplume"; break;
		}	
	}
	else if(TestStringAgainstPattern("**minauros**", sAREA))
	{
		switch (Random(3))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_gm"; break;
			case 1: sSPECIAL = "ps_crft_devilscale"; break;
			case 2: sSPECIAL = "ps_cfrt_ing_tt"; break;
		}
	}
	else if(TestStringAgainstPattern("**ruins**", sAREA))
	{
		switch (Random(3))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_by"; break;
			case 1: sSPECIAL = "ps_crft_ophidian"; break;
			case 2: sSPECIAL = "ps_crft_neufly"; break;
		}
	}
	else if(TestStringAgainstPattern("**maldom**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_tt"; break;
			case 1: sSPECIAL = "ps_crft_ing_ap"; break;
		}	
	}
	else if(TestStringAgainstPattern("**clangor**", sAREA))
	{
		switch (Random(3))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_ab"; break;
			case 1: sSPECIAL = "ps_crft_ing_ob"; break;
			case 2: sSPECIAL = "ps_crft_ing_gs"; break;
		}
	}
	else if(TestStringAgainstPattern("**fire**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_crft_ophidian"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_ml"; break;
		}
	}
	else if(TestStringAgainstPattern("**eearth**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_crft_ing_ob"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_ml"; break;
		}
	}
	else if(TestStringAgainstPattern("**limbo**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_pd"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_ml"; break;
		}
	}
	else return;	
	CreateTreasureItemOnTarget(sSPECIAL, oSPAWN);
}

//Handles things like essence / distillable items drops
//depends on two variables set on the creature: 
//creature_drop = item resref
//creature_drop_chance = drop chance
void CreateCreatureDrop(object oCreature) {

	int nChance = GetLocalInt(oCreature, "creature_drop_chance");
	string sItem = GetLocalString(oCreature, "creature_drop");
	
	if (d100() < nChance) {
		if (sItem == "Pearl") { //special case to handle pearls (gemstones)
			object oGem = CreateItemOnObject("gemstone_rough_pearl", oCreature);
			int nQuality = Random(3);
			int nSize = 0; //we don't split pearls!
			SetDetailsOfGemstone(oGem, nQuality, nSize, oCreature);
		} else {
			CreateItemOnObject(sItem, oCreature);
		}
	}
}
//***************************************************
//Books and Paper Products
//Does not use database; smaller sets of items
//***************************************************
//Generates one of the custom Sigil lore books on the target
//They all have very regular resrefs, so no database needed
void CreateSigilBookOnTarget(object oTarget) {
   	string sRes = "ps_lorebook_";
	
	int iBook = Random(93) + 1;
	if (iBook < 10) {
    	sRes += "00";
    } else if (iBook < 100) {
		sRes += "0";
	}
	
	sRes += IntToString(iBook);
	CreateTreasureItemOnTarget(sRes, oTarget);
}

//Creates a lore book or random book on target
void CreateBookOnTarget(object oTarget) {
	int nRand = Random(100)+1;
	if (nRand < 90) {
		CreateSigilBookOnTarget(oTarget);
	} else {
		CreateRandomBookOnTarget(oTarget); //novels and such
	}
}

//Gets the maximum id for arcane scrolls
int GetScrollMaxID(int nLevel)
{   
	int nMax = 0;
    switch (nLevel)
    {
        case 0: nMax = 10; break;
        case 1: nMax = 57; break;
        case 2: nMax = 64; break;
        case 3: nMax = 58; break;
        case 4: nMax = 47; break;
        case 5: nMax = 37; break;
        case 6: nMax = 43; break;
        case 7: nMax = 28; break;
        case 8: nMax = 28; break;
        case 9: nMax = 25; break;
    }
    return nMax;
}

//Gets a random scroll id for the given level
int GetScrollIDRandom(int nLevel)
{
	int nNumSpellsInLevel = GetScrollMaxID(nLevel);
	int nScrollNum =  Random(nNumSpellsInLevel) + 1;
	return nScrollNum;
}

//Creates a scroll on the targeted object. You can force the scroll to be arcane or divine
//if both nForceArcane and nForceDivine are false, then there's a 50/50 chance for one or the other
//Also 10% chance of experimental scroll
void CreateScrollOnTarget(object oTarget, int nTreasureLevel = TREASURE_LOW) {

	int nScroll = 1;
	int nLevel = 1;
	int nHD = GetChallengeRatingOfTarget(oTarget);
	
	if (nHD < 5) {
		nLevel = d2();
	} else if (nHD < 8) {
		nLevel = d4();
	} else if (nHD < 10) {
		nLevel = d6();
	  	if (nLevel < 2) nLevel = 2;
	} else if (nHD < 13) {
	  	nLevel = d8();
	  	if (nLevel < 3) nLevel = 3;
	} else if (nHD < 16) {
	  	nLevel = d8()+1;
	  	if (nLevel < 4) nLevel = 4;
	} else {
	  	nLevel = d8() + 1;
	  	if (nLevel < 5) nLevel = 5;
	}
	
	if (d100() < 10) {
		CreateExperimentalScrollOnTarget(oTarget, nTreasureLevel);
	} else {
		int nScroll = GetScrollIDRandom(nLevel);
		string sRes; 
		if (nScroll < 10) {
	   	 	sRes = "ps_scrolls" + IntToString(nLevel) + "_0" + IntToString(nScroll);
		} else {
	    	sRes = "ps_scrolls" + IntToString(nLevel) + "_" + IntToString(nScroll);
		}
		CreateTreasureItemOnTarget(sRes, oTarget, 1);
	}
}

//Main Paper Products generator
//Does not actually use the TREASURE constants for 
//anything but experimental scrolls
void CreatePaperItemsOnTarget(object oTarget, int nTreasureType = TREASURE_LOW) {
	int nRand = Random(100)+1;
	if (nRand < 80) {
		CreateScrollOnTarget(oTarget, nTreasureType);
	} else {
		CreateBookOnTarget(oTarget);
	}
}
//***************************************************
//Junk Generation
//***************************************************
void CreateJunkOnTarget(object oTarget, int nTreasureType) {

	string sResref = "";
	int nRandom = Random(13)+1;
	switch (nRandom) {
		case 1: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "rune", TRUE); break; //runes
		case 2: case 13: case 14: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "", TRUE); break; //Default Junk
		case 3: sResref = PickItemFromDatabase("treasure_miscellaneous", nTreasureType); break; //Misc Item
		case 4: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "coin", TRUE); break; //sigilian currency
		case 5: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "grenade", TRUE); break; //grenades!
		case 6: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "painting", TRUE); break; //paintings ><
		case 7: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "drug", TRUE); break; //drugs; because we are gritty or something
		case 8: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "healingkit", TRUE); break; //healing kit
		case 9: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "thieveskit", TRUE); break; //thieves kit
		case 10: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "trapkit", TRUE); break; //trap kits
		case 11: sResref = PickItemFromDatabase("treasure_junk", nTreasureType, "ammo", TRUE); break; //ammunition
		case 12: CreateTrinketOnTarget(oTarget, nTreasureType); return; //random trinket
	}
	int nStackSize = 1;
	if (nRandom == 11) { //Ammunition, generate stack
		nStackSize = d10(4);
	} else if (nRandom == 4) { //Coinage; generate a few
		nStackSize = d4();
	}
	CreateTreasureItemOnTarget(sResref, oTarget, nStackSize);
}
//***************************************************
//Alchemy Generation
//***************************************************
void CreatePotionOnTarget(object oTarget, int nTreasureLevel) {

	if (d100() < 10) {
		CreateExperimentalPotionOnTarget(oTarget, nTreasureLevel);
	} else {
		string sRes = PickItemFromDatabase("treasure_potions", nTreasureLevel, "", TRUE);
		CreateTreasureItemOnTarget(sRes, oTarget, 1);
	}
}
//***************************************************
//Gems Generation
//***************************************************
void CreateGemOnTarget(object oTarget, int nTreasureType) {

	CreateRandomGemstoneOnSpawnOrChest(oTarget, nTreasureType); return;
	  
}
//***************************************************
//Gold Generation
//***************************************************
void CreateGoldOnTarget(object oTarget, int nTreasureLevel) {

	int nHD = GetChallengeRatingOfTarget(oTarget);
	if (nHD <= 0) {
		nHD = 6*nTreasureLevel;
	}
	int nAmount = 0;

	if (nHD <= 3) nAmount = d12(2);
	else if (nHD <= 6) nAmount = d20(2);
	else if (nHD <= 9) nAmount = d20(3);
	else if (nHD <= 12) nAmount = d20(5);
	else if (nHD <= 15) nAmount = d20(8);
	else nAmount = d20(10);
		
	float nMod = 0.0;
	if (nTreasureLevel == TREASURE_LOW) nMod = LOW_MOD_GOLD;
	else if (nTreasureLevel == TREASURE_MEDIUM) nMod = MEDIUM_MOD_GOLD;
	else if (nTreasureLevel == TREASURE_HIGH) nMod = HIGH_MOD_GOLD;
	else if (nTreasureLevel == TREASURE_EPIC) nMod = EPIC_MOD_GOLD;

	// * always at least 1gp is created
	nAmount = FloatToInt(nAmount * nMod);
	if (nAmount <= 0) nAmount = 1;
		
	CreateTreasureItemOnTarget("NW_IT_GOLD001", oTarget, nAmount);
}
//***************************************************
//Main Treasure Generation Script
//***************************************************
//Creates an armor from the database on the target
//or 25% to generate a completely randomized armor
void CreateArmorOnTarget(object oTarget, int nTreasureLevel) {
	if (d100() < 75) { //Default spawning from database
		string sResref = PickItemFromDatabase("treasure_armor", nTreasureLevel);
		CreateTreasureItemOnTarget(sResref, oTarget, 1);
	} else {
		CreateRandomItemOfCategoryOnTarget(oTarget, "A");
	}
}

//Creates random armor on target
//Uses the creature CR to judge power level
//Override: local int QUEST_CR on creatures, local int CR on chests
void CreateRandomArmorOnTarget(object oTarget) {
	CreateRandomItemOfCategoryOnTarget(oTarget, "A");
}

//Creates a weapon from the database on the target
//or 25% to generate a completely randomized weapon
void CreateWeaponOnTarget(object oTarget, int nTreasureLevel) {
	if (d100() < 75) { //Default spawning from database
		string sResref = PickItemFromDatabase("treasure_weapons", nTreasureLevel);
		CreateTreasureItemOnTarget(sResref, oTarget, 1);
	} else {
		CreateRandomItemOfCategoryOnTarget(oTarget, "W");
	}
}

//Creates random armor on target
//Uses the creature CR to judge power level
//Override: local int QUEST_CR on creatures, local int CR on chests
void CreateRandomWeaponOnTarget(object oTarget) {
	CreateRandomItemOfCategoryOnTarget(oTarget, "W");
}

//Creates an wearable item from the database on the target
//or 25% to generate a completely randomized wearable item
//sTable = database table
//nBaseType is the index of the item in scod_craft_baseitems
//Note this is not the same as the BASE_ITEM_* constants
//Random wearables use the CR of the target (or its stored CR local int);
//Database wearables use nTreasureLevel to determine power level
void CreateWearableOnTarget(object oTarget, string sTable, int nBaseType, int nTreasureLevel) {
	if (d100() < 75) { //Default spawning from database
		string sResref = PickItemFromDatabase(sTable, nTreasureLevel);
		CreateTreasureItemOnTarget(sResref, oTarget, 1);
	} else {
		CreateRandomItemOfTypeOnTarget(oTarget, nBaseType);
	}
}

//Creates a random shield (light, heavy, tower) on target
//Uses the creature CR to judge power level
//Override: local int QUEST_CR on creatures, local int CR on chests
void CreateRandomShieldOnTarget(object oTarget) {

	int nRandom = Random(3)+1;
	switch (nRandom) {
		case 1: CreateRandomItemOfTypeOnTarget(oTarget, 55); break; //shield, heavy
		case 2: CreateRandomItemOfTypeOnTarget(oTarget, 56); break; //shield, light
		case 3: CreateRandomItemOfTypeOnTarget(oTarget, 57); break; //shield, tower
		default: CreateRandomItemOfTypeOnTarget(oTarget, 57); break; //shield, tower
	}
}

//Creates a shield from the database on the target
//or 25% to generate a completely randomized shield (light, heavy, tower)
void CreateShieldOnTarget(object oTarget, int nTreasureLevel) {
	if (d100() < 75) { //Default spawning from database
		string sResref = PickItemFromDatabase("treasure_shields", nTreasureLevel);
		CreateTreasureItemOnTarget(sResref, oTarget, 1);
	} else {
		CreateRandomShieldOnTarget(oTarget);
	}
}

//Creates random gloves or bracers on target (50/50)
//Uses the creature CR to judge power level
//Override: local int QUEST_CR on creatures, local int CR on chests
void CreateRandomGlovesOnTarget(object oTarget) {

	int nRandom = d2();
	switch (nRandom) {
		case 1: CreateRandomItemOfTypeOnTarget(oTarget, 7); break; //bracers
		case 2: CreateRandomItemOfTypeOnTarget(oTarget, 27); break; //gloves
		default: CreateRandomItemOfTypeOnTarget(oTarget, 7); break; //bracers
	}
}

//Creates gloves or bracers from the database on the target
//or 25% to generate a completely randomized set of gloves (or bracers)
void CreateGlovesOnTarget(object oTarget, int nTreasureLevel) {
	if (d100() < 75) { //Default spawning from database
		string sResref = PickItemFromDatabase("treasure_shields", nTreasureLevel);
		CreateTreasureItemOnTarget(sResref, oTarget, 1);
	} else {
		CreateRandomGlovesOnTarget(oTarget);
	}
}

//Creates random piece of jewelry (ring, amulet) on target (50/50)
//Uses the creature CR to judge power level
//Override: local int QUEST_CR on creatures, local int CR on chests
void CreateRandomJewelryOnTarget(object oTarget) {

	int nRandom = d2();
	switch (nRandom) {
		case 1: CreateRandomItemOfTypeOnTarget(oTarget, 0); break; //amulet
		case 2: CreateRandomItemOfTypeOnTarget(oTarget, 51); break; //ring
		default: CreateRandomItemOfTypeOnTarget(oTarget, 51); break; //ring
	}
	
}

//Creates a ring or necklace from the database on the target
//or 25% to generate a completely randomized ring or necklace
void CreateJewelryOnTarget(object oTarget, int nTreasureLevel) {
	if (d100() < 75) { //Default spawning from database
		string sResref = PickItemFromDatabase("treasure_jewelry", nTreasureLevel);
		CreateTreasureItemOnTarget(sResref, oTarget, 1);
	} else {
		CreateRandomJewelryOnTarget(oTarget);
	}
}

//Creates random helmet on target
//Uses the creature CR to judge power level
//Override: local int QUEST_CR on creatures, local int CR on chests
void CreateRandomHelmetOnTarget(object oTarget) {
	CreateRandomItemOfTypeOnTarget(oTarget, 35);
}

//Creates random belt on target
//Uses the creature CR to judge power level
//Override: local int QUEST_CR on creatures, local int CR on chests
void CreateRandomBeltOnTarget(object oTarget) {
	CreateRandomItemOfTypeOnTarget(oTarget, 5);
}

//Creates random cloak on target
//Uses the creature CR to judge power level
//Override: local int QUEST_CR on creatures, local int CR on chests
void CreateRandomCloakOnTarget(object oTarget) {
	CreateRandomItemOfTypeOnTarget(oTarget, 12);
}

//Creates random boots on target
//Uses the creature CR to judge power level
//Override: local int QUEST_CR on creatures, local int CR on chests
void CreateRandomBootsOnTarget(object oTarget) {
	CreateRandomItemOfTypeOnTarget(oTarget, 71);
}

//The main treasure generation script. It creates one item on the target.
//Use this function anywhere you want treasure.
void GenerateTreasureItemOnTarget(object oTarget, int nTreasureLevel) {
	string sResref = "";
	if (d100() <= EQUIPPABLE_CHANCE) {
		int nRandom = Random(10)+1;
		switch (nRandom) {
			case 1: CreateArmorOnTarget(oTarget, nTreasureLevel); break; // armor
			case 2: case 10: CreateWeaponOnTarget(oTarget, nTreasureLevel); break; // weapon; slightly higher chance for weapons
			case 3: CreateWearableOnTarget(oTarget, "treasure_boots", 71, nTreasureLevel); break; //boots
			case 4: CreateWearableOnTarget(oTarget, "treasure_cloaks", 12, nTreasureLevel); break; //cloaks
			case 5: CreateGlovesOnTarget(oTarget, nTreasureLevel); break; //gloves
			case 6: CreateWearableOnTarget(oTarget, "treasure_belts", 5, nTreasureLevel); break; //belts
			case 7: CreateWearableOnTarget(oTarget, "treasure_helmets", 35, nTreasureLevel); break; //hats
			case 8: CreateShieldOnTarget(oTarget, nTreasureLevel); break;  //shields
			case 9: CreateJewelryOnTarget(oTarget, nTreasureLevel); break;  //jewelry
		}
	} else {
		int nRandom = Random(100)+1;
		if (nRandom <= UNEQUIPPABLE_ALCHEMY_CHANCE) {
			CreatePotionOnTarget(oTarget, nTreasureLevel); //Potions
		} else if (nRandom <= UNEQUIPPABLE_ALCHEMY_CHANCE+UNEQUIPPABLE_JUNK_CHANCE) {
			CreateJunkOnTarget(oTarget, nTreasureLevel); //Junk
		} else if (nRandom <= UNEQUIPPABLE_ALCHEMY_CHANCE+UNEQUIPPABLE_JUNK_CHANCE+UNEQUIPPABLE_SCROLL_CHANCE) {
			CreatePaperItemsOnTarget(oTarget, nTreasureLevel); //Paper
		} else if (nRandom <= UNEQUIPPABLE_ALCHEMY_CHANCE+UNEQUIPPABLE_JUNK_CHANCE+UNEQUIPPABLE_SCROLL_CHANCE+UNEQUIPPABLE_GEM_CHANCE) {
			CreateGemOnTarget(oTarget, nTreasureLevel); //Gems
		} else if (nRandom <= UNEQUIPPABLE_ALCHEMY_CHANCE+UNEQUIPPABLE_JUNK_CHANCE+UNEQUIPPABLE_SCROLL_CHANCE+UNEQUIPPABLE_GEM_CHANCE+UNEQUIPPABLE_GOLD_CHANCE) {
			CreateGoldOnTarget(oTarget, nTreasureLevel); //Gold
		} else {
			CardsCreateCardOnSpawnOrChest(oTarget); //Cards
		}
	}
}

//Translate treasure level to CR
//For cases in which the target's CR shouldn't matter
int PickCRFromTreasureLevel(int nTreasureLevel) {
	if (nTreasureLevel == TREASURE_LOW) {
		return Random(9)+1;
	} else if (nTreasureLevel == TREASURE_MEDIUM) {
		return Random(10)+10;
	} else if (nTreasureLevel == TREASURE_HIGH) {
		return Random(6)+20;
	} else if (nTreasureLevel == TREASURE_EPIC) {
		return Random(6)+25;
	} else if (nTreasureLevel == TREASURE_QUEST_LOW) {
		return Random(6)+28;
	} else if (nTreasureLevel == TREASURE_QUEST_MED) {
		return Random(6)+29;
	} else if (nTreasureLevel == TREASURE_QUEST_HIGH) {
		return Random(6)+30;
	}
	
	return 1;
}

//Creates quest reward
//Uses standard item generation on TREASURE_LOW-TREASURE_EPIC
//Picks from the Epic level reward pools for TREASURE_QUEST_LOW+
//allowRandom - only matters for TREASURE_QUEST_* levels
//0 = no random items, only pulled from the epic pools
//1 = randomized items allowed 50/50 chance
void GenerateQuestRewardOnTarget(object oTarget, int nTreasureLevel, int allowRandom = FALSE) {

	int nCR = PickCRFromTreasureLevel(nTreasureLevel);
	SetLocalInt(oTarget, "QUEST_CR", nCR);

	//Default to standard system for lower level quests
	if (nTreasureLevel <= TREASURE_EPIC) {
		GenerateTreasureItemOnTarget(oTarget, nTreasureLevel);
		return;
	} 
	
	//Otherwise, pick from the epic treasure pool
	if (allowRandom && d100() < 50) {
		int nRandom = Random(10)+1;
		switch (nRandom) {
			case 1: CreateRandomArmorOnTarget(oTarget); break; // armor
			case 2: case 10: CreateRandomWeaponOnTarget(oTarget); break; // weapon; slightly higher chance for weapons
			case 3: CreateRandomBootsOnTarget(oTarget); break; //boots
			case 4: CreateRandomCloakOnTarget(oTarget); break; //cloaks
			case 5: CreateRandomGlovesOnTarget(oTarget); break; //gloves
			case 6: CreateRandomBeltOnTarget(oTarget); break; //belts
			case 7: CreateRandomHelmetOnTarget(oTarget); break; //hats
			case 8: CreateRandomShieldOnTarget(oTarget); break;  //shields
			case 9: CreateRandomJewelryOnTarget(oTarget); break;  //jewelry
		}
	} else {
		string sItem = PickEpicLevelReward(nTreasureLevel);
		if (sItem != "")
			CreateTreasureItemOnTarget(sItem, oTarget, 1);
	}
	
	DelayCommand(0.2f, DeleteLocalInt(oTarget, "QUEST_CR"));

}