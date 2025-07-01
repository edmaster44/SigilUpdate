

#include "ps_inc_treasuregeneration"
#include "ps_inc_time"

const int cChestWait = 915;
const float cChestDistance = 8.0f; //the distance monsters must be from chest for chest to spawn loot

// creates a random craft material from a craft 2da.
// valid args for s2da are "SCOD_CRAFT_LEATHER", "SCOD_CRAFT_METAL", "SCOD_CRAFT_MISC", 
// and "SCOD_CRAFT_WOOD"
void CreateCraftItemOnObjectFrom2da(string s2da, object oObject);

//Creates gold on chest
//details depend on variables
//GOLDDICE, GOLDNR, GOLDCONS
void FillChestWithGold(object oChest) {

	int iGolddice = GetLocalInt(oChest,"GOLDDICE");
	int iGoldnr = GetLocalInt(oChest,"GOLDNR");
	int iGoldcons = GetLocalInt(oChest,"GOLDCONS");
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
	string sResref = "";
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
		sResref = PickItemFromDatabase("treasure_junk", nTreasureLevel, "ammo", TRUE);
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
	} else if (sTreasure == "CRAFT_UNDEAD") {
		switch (Random(4)){
			case 0: sResref = "ps_golem_bone"; break; // giant bone
			case 1: sResref = "ps_crft_plk_tb"; break; // twelvetrees
			case 2: sResref = "ps_crft_fleshgolem"; break;
			case 3: sResref = "ps_cfrt_ing_gm"; break; // morguth iron
		}
		CreateTreasureItemOnTarget(sResref, oChest);
	} else if (sTreasure == "CRAFT_MERCURIA") {
		switch (Random(4)){
			case 0: sResref = "ps_crft_celestplume"; break;
			case 1: sResref = "ps_crft_plk_ao"; break; // arboreal oak
			case 2: sResref = "ps_crft_mercrose"; break;
			case 3: sResref = "ps_cfrt_ing_st"; break; //truesteel
		}
		CreateTreasureItemOnTarget(sResref, oChest);
	} else if (sTreasure == "CRAFT_DRAGON") {
		switch (Random(8)){
			case 0: sResref = "ps_crft_plk_db"; break; // dragon bone
			case 1: sResref = "ps_crft_drgsnw"; break; // dragon sinew
			case 2: sResref = "ps_crft_dragonhide_blk"; break;
			case 3: sResref = "ps_crft_dragonhide_red"; break;
			case 4: sResref = "ps_crft_dragonhide_wht"; break;
			case 5: sResref = "ps_crft_dragonhide_blu"; break;	
			case 6: sResref = "ps_crft_dragonhide_grn"; break;
			case 7: sResref = "ps_crft_ing_ada"; break; // pure adamantine
		}
		CreateTreasureItemOnTarget(sResref, oChest);
	} else if (sTreasure == "CRAFT_FEYWILD"){
		switch (Random(6)){
			case 0: sResref = "ps_crft_moonpearl"; break;
			case 1: sResref = "ps_crft_pyrite"; break;
			case 2: sResref = "ps_crft_manticore"; break;
			case 3: sResref = "ps_crft_chimera"; break;
			case 4: sResref = "ps_crft_rowan"; break;
			case 5: sResref = "ps_crft_ironwood"; break;
		}
		CreateTreasureItemOnTarget(sResref, oChest);
	} else if (sTreasure == "CRAFT_WOOD") {
		CreateCraftItemOnObjectFrom2da("SCOD_CRAFT_WOOD", oChest);
	} else if (sTreasure == "CRAFT_LEATHER") {
		CreateCraftItemOnObjectFrom2da("SCOD_CRAFT_LEATHER", oChest);
	} else if (sTreasure == "CRAFT_METAL") {
		CreateCraftItemOnObjectFrom2da("SCOD_CRAFT_METAL", oChest);
	} else if (sTreasure == "CRAFT_MISC") {
		CreateCraftItemOnObjectFrom2da("SCOD_CRAFT_MISC", oChest);
	}
}

void CreateCraftItemOnObjectFrom2da(string s2da, object oObject){
	int n2daRows = GetNum2DARows(s2da) - 1;
	string sResref = Get2DAString(s2da, "BASE_RESREF", Random(n2daRows));
	CreateTreasureItemOnTarget(sResref, oObject);
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
	
	string sItem = GetLocalString(oChest,"TAG");
	int nChance = GetLocalInt(oChest, "TAGCHANCE");
	if ( sItem != "") {
		if (nChance == 0 || d100() < nChance)
			CreateTreasureItemOnTarget(sItem, oChest, 1);
	}
	
	int nType = GetLocalInt(oChest,"TYPE");
	if (nType == 0)
		nType = 1;
		
	int nCR = GetLocalInt(oChest, "CR");
	if (nCR == 0) {
		nCR = nType*7;
		SetLocalInt(oChest, "CR", nCR);
	}
		
	sItem = GetLocalString(oChest,"TREASURE1");
	nAmount = GetLocalInt(oChest,"TREASURE1N");
	if ( nAmount == 0 ) nAmount = 1;
	
	for ( i = 0; i < nAmount; i++ ) {
		FillChestWithSpecificItem(oChest, sItem, nType);
	}
	
	sItem = GetLocalString(oChest,"TREASURE2");
	nAmount = GetLocalInt(oChest,"TREASURE2N");
	if (nAmount == 0) nAmount = 1;
	
	for ( i = 0; i < nAmount; i++ ) {
		FillChestWithSpecificItem(oChest, sItem, nType);
	}
	
	sItem = GetLocalString(oChest,"TREASURE3");
	nAmount = GetLocalInt(oChest,"TREASURE3N");
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