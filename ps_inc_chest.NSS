#include "ff_safevar"

#include "ps_inc_treasuregeneration"
#include "ps_inc_time"

const int cChestWait = 915;
const float cChestDistance = 8.0f; //the distance monsters must be from chest for chest to spawn loot

//Creates gold on chest
//details depend on variables
//GOLDDICE, GOLDNR, GOLDCONS
void FillChestWithGold(object oChest) {

	int iGolddice = PS_GetLocalInt(oChest,"GOLDDICE");
	int iGoldnr = PS_GetLocalInt(oChest,"GOLDNR");
	int iGoldcons = PS_GetLocalInt(oChest,"GOLDCONS");
	int iGoldAmount = 0;
		
	if(iGolddice > 0 && iGoldnr > 0) {
		int i = 0;
		for ( i = 0; i < iGoldnr; i++) {
			iGoldAmount =  iGoldAmount + Random(iGolddice) +1;
		}
	}	
	
	iGoldAmount = iGoldAmount + iGoldcons;
	
	if ( iGoldAmount > 0 )
		CreateTreasureItemOnTarget("NW_IT_GOLD001", oChest, iGoldAmount);
		
}

//Makes sure there are no monsters nearby before you can loot
int CheckIfHostilesNearby(object oChest, object oPC) {

	//GetIsEnemy
	object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, cChestDistance, GetLocation(oChest), TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oCreature)) {
		
		if (GetIsEnemy(oPC, oCreature) && !GetIsDead(oCreature))
			return TRUE;
	
		oCreature = GetNextObjectInShape(SHAPE_SPHERE, cChestDistance, GetLocation(oChest), TRUE, OBJECT_TYPE_CREATURE);
	} 
	
	return FALSE;

}

//Create item of a particular type on the chest
//Options: BOOK, JUNK, GEM, ARCANE, AMMO, EQUIPPABLE, KIT, POTION, RANDOM
void FillChestWithSpecificItem(object oChest, string sTreasure, int nTreasureLevel = 1)
{
	if ( sTreasure == "BOOK" ) {
		CreatePaperItemsOnTarget(oChest, nTreasureLevel);
	} else if ( sTreasure == "JUNK" ) {
		CreateJunkOnTarget(oChest, nTreasureLevel);
	} else if ( sTreasure == "GEM") {
		CreateGemOnTarget(oChest, nTreasureLevel);
	} else if ( sTreasure == "ARCANE" ) {
		CreateScrollOnTarget(oChest, nTreasureLevel);
	} else if ( sTreasure == "AMMO" ) {
		int nStackSize = d10(4);
		string sResref = PickItemFromDatabase("treasure_junk", nTreasureLevel, "ammo", TRUE);
		CreateTreasureItemOnTarget(sResref, oChest, nStackSize);
	} else if ( sTreasure == "EQUIPPABLE") { //New; use sparingly
		int nRandom = Random(9)+1;
		switch (nRandom) {
			case 1: CreateArmorOnTarget(oChest, nTreasureLevel); break; // armor
			case 2: CreateWeaponOnTarget(oChest, nTreasureLevel); break; // weapon; slightly higher chance for weapons
			case 3: CreateWearableOnTarget(oChest, "treasure_boots", 71, nTreasureLevel); break; //boots
			case 4: CreateWearableOnTarget(oChest, "treasure_cloaks", 12, nTreasureLevel); break; //cloaks
			case 5: CreateGlovesOnTarget(oChest, nTreasureLevel); break; //gloves
			case 6: CreateWearableOnTarget(oChest, "treasure_belts", 5, nTreasureLevel); break; //belts
			case 7: CreateWearableOnTarget(oChest, "treasure_helmets", 35, nTreasureLevel); break; //hats
			case 8: CreateShieldOnTarget(oChest, nTreasureLevel); break;  //shields
			case 9: CreateJewelryOnTarget(oChest, nTreasureLevel); break;  //jewelry
		}
	} else if ( sTreasure == "KIT" ) {
		string sResref = "";
		switch(d3()) {
			case 1: sResref = PickItemFromDatabase("treasure_junk", nTreasureLevel, "healingkit", TRUE); break;
			case 2: sResref = PickItemFromDatabase("treasure_junk", nTreasureLevel, "thieveskit", TRUE); break;
			case 3: sResref = PickItemFromDatabase("treasure_junk", nTreasureLevel, "trapkit", TRUE); break;
		}
		CreateTreasureItemOnTarget(sResref, oChest);
	} else if ( sTreasure == "POTION" ) {
		CreatePotionOnTarget(oChest, nTreasureLevel);
	} else if ( sTreasure == "RANDOM" ) {
		int nRandom = Random(7)+1;
		switch (nRandom)
		{
        	case 1: FillChestWithSpecificItem(oChest, "BOOK", nTreasureLevel); break;
           	case 2: FillChestWithSpecificItem(oChest, "JUNK", nTreasureLevel); break;
            case 3: FillChestWithSpecificItem(oChest, "GEM", nTreasureLevel); break;
            case 4: FillChestWithSpecificItem(oChest, "ARCANE", nTreasureLevel); break;
            case 5: FillChestWithSpecificItem(oChest, "AMMO", nTreasureLevel); break;
			case 6: FillChestWithSpecificItem(oChest, "KIT", nTreasureLevel); break;
			case 7: FillChestWithSpecificItem(oChest, "POTION", nTreasureLevel); break;
        }
	}
}

//astral_quest_obj 70%
//Fill the chest up with items!
//Local variables:
//TAG = special item blueprint which can appear in the chest
//TAGCHANCE = chance the TAG item will appear; defaults to 100% if not set
//TREASURE1 = type of treasure (takes FillChestWithSpecificItem options)
//TREASURE1N = number of items of TREASURE1 to generate
//TREASURE2 = type of treasure (takes FillChestWithSpecificItem options)
//TREASURE2N = number of items of TREASURE2 to generate
//TREASURE3 = type of treasure (takes FillChestWithSpecificItem options)
//TREASURE3N = number of items of TREASURE3 to generate
void FillChestWithItems(object oChest) {

	int nAmount=0;
	int i=0;
	
	string sItem = PS_GetLocalString(oChest,"TAG");
	int nChance = PS_GetLocalInt(oChest, "TAGCHANCE");
	if ( sItem != "") {
		if (nChance == 0 || d100() < nChance)
			CreateTreasureItemOnTarget(sItem, oChest, 1);
	}
	
	int nType = PS_GetLocalInt(oChest,"TYPE");
	if (nType == 0)
		nType = 1;
		
	int nCR = PS_GetLocalInt(oChest, "CR");
	if (nCR == 0) {
		nCR = nType*7;
		PS_SetLocalInt(oChest, "CR", nCR);
	}
		
	sItem = PS_GetLocalString(oChest,"TREASURE1");
	nAmount = PS_GetLocalInt(oChest,"TREASURE1N");
	if ( nAmount == 0 ) nAmount = 1;
	
	for ( i = 0; i < nAmount; i++ ) {
		FillChestWithSpecificItem(oChest, sItem, nType);
	}
	
	sItem = PS_GetLocalString(oChest,"TREASURE2");
	nAmount = PS_GetLocalInt(oChest,"TREASURE2N");
	if (nAmount == 0) nAmount = 1;
	
	for ( i = 0; i < nAmount; i++ ) {
		FillChestWithSpecificItem(oChest, sItem, nType);
	}
	
	sItem = PS_GetLocalString(oChest,"TREASURE3");
	nAmount = PS_GetLocalInt(oChest,"TREASURE3N");
	if (nAmount == 0) nAmount = 1;
	
	for ( i = 0; i < nAmount; i++ ) {
		FillChestWithSpecificItem(oChest, sItem, nType);
	}
}

//Deletes all items from the object
void CleanChest(object oChest) {

	object oItem = GetFirstItemInInventory(oChest);
    while(GetIsObjectValid(oItem)) {
        SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        oItem = GetNextItemInInventory();
    }
	
}