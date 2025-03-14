

#include "ps_inc_gemstones"
#include "ps_inc_randomitems"
#include "ginc_param_const"
#include "ginc_item"
#include "ps_inc_cards"
#include "dethia_shop_sys"
#include "ps_inc_time"

const int MAX_MARKUP = 30;
const int MIN_MARKUP = 1;
const int MAX_MARKDOWN = -30;
const int MIN_MARKDOWN = -1;

const int APPRAISE_DIVISOR = 2;
const int CLEAN_TIME = 3600;

//Function for fetching stores from the store area
//MUST use, or the store will return invalid
object GetStoreFromStoreArea(string sTag);

//Clears store inventory for re-generation
void ClearStore(object oStore);

//Populate Zharak's store
void PopulateGemstoneStore(object oStore);

//Creates 3 copies of each of the items in the must-have list
void AddMustHaveItems(object oStore);

//Fetch the enchantment index saved on the store itself
//Enchantment indices are defined in the DB and in scodenchantments.2da
int GetStoreAppropriateEnchantmentIndex(string sType, object oStore, int nTries = 0);

//Add an appropriate item to one of the planar stores
void CreateItemForStore(object oStore, object oPC = OBJECT_INVALID);

//*****************************************************
object GetStoreFromStoreArea(string sTag)
{
	int iStoreArea = GetGlobalInt("STORE_AREA");
	object oStoreArea = IntToObject(iStoreArea);
	
	object oStore = GetFirstObjectInArea(oStoreArea);
	
	while (GetTag(oStore) != sTag && oStore != OBJECT_INVALID) {
		oStore = GetNextObjectInArea(oStoreArea);
	}
	
	// just in case someone drops a store outside the store area, it will still work.
	if (oStore == OBJECT_INVALID) {	oStore = GetTarget(sTag); }
	
	return oStore;
}

void ClearStore(object oStore) {

	object oItem = GetFirstItemInInventory(OBJECT_SELF);
	while (GetIsObjectValid(oItem)) {
		DestroyObject(oItem);
		oItem = GetNextItemInInventory(OBJECT_SELF);
	}
	
}

void PopulateGemstoneStore(object oStore) {

	CreateGemstoneOfType("gemstone_jasmal", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_jasmal", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_jasmal", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_diamond_white", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_diamond_white", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_diamond_white", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_diamond_black", 0, 0, oStore);
	
	int gemCount = 0;
	while (gemCount < 10) {
	
		int nRand = Random(12)+1;
		switch(nRand) {
			case 1: CreateGemstoneOfType("gemstone_tourmaline_red", 0, 0, oStore); break;
			case 2: CreateGemstoneOfType("gemstone_tourmaline_white", 0, 0, oStore); break;
			case 3: CreateGemstoneOfType("gemstone_tourmaline_black", 0, 0, oStore); break;
			case 4: CreateGemstoneOfType("gemstone_tourmaline_green", 0, 0, oStore); break;
			case 5: CreateGemstoneOfType("gemstone_tourmaline_blue", 0, 0, oStore); break;
			case 6: CreateGemstoneOfType("gemstone_zircon_white", 0, 0, oStore); break;
			case 7: CreateGemstoneOfType("gemstone_zircon_red", 0, 0, oStore); break;
			case 8: CreateGemstoneOfType("gemstone_zircon_blue", 0, 0, oStore); break;
			case 9: CreateGemstoneOfType("gemstone_zircon_green", 0, 0, oStore); break;
			case 10: CreateGemstoneOfType("gemstone_jasmal", 0, 0, oStore); break;
			case 11: CreateGemstoneOfType("gemstone_diamond_white", 0, 0, oStore); break;
			case 12: CreateGemstoneOfType("gemstone_diamond_black", 0, 0, oStore); break;
		}
	
		gemCount++;
	}

}

void PopulateCardStore(object oStore, object oPC = OBJECT_INVALID) {

	int nMax = 20; //The number of cards to populate in the store

	int n;
	float fDelay = 0.01f;
	for (n = 0; n < nMax; n++) {
		DelayCommand(fDelay, CardsCreateCardOnSpawnOrChest(oStore, oPC));
		fDelay += 0.01f;
	}
}

void AddMustHaveItems(object oStore) {

	int nMax = GetLocalInt(oStore, "MustHaveNum");
	int nCount = 0;
	while (nCount < nMax) {
		string sHave = GetLocalString(oStore, "MustHaveItem_"+IntToString(nCount+1));
		CreateItemOnObject(sHave, oStore);
		CreateItemOnObject(sHave, oStore);
		CreateItemOnObject(sHave, oStore);
		
		nCount++;
	}

}

int GetStoreAppropriateEnchantmentIndex(string sType, object oStore, int nTries = 0) {
	
	int nIndex = 0;
	if (sType == "W") {
		int nNum = GetLocalInt(oStore, "NumWeaponEnchants");
		int nChosen = Random(nNum)+1;
		nIndex = GetLocalInt(oStore, "WeaponEnchant_"+IntToString(nChosen));
	} else if (sType == "A") {
		int nNum = GetLocalInt(oStore, "NumArmorEnchants");
		int nChosen = Random(nNum)+1;
		nIndex = GetLocalInt(oStore, "ArmorEnchant_"+IntToString(nChosen));
	} else if (sType == "M") {
		int nNum = GetLocalInt(oStore, "NumMiscEnchants");
		int nChosen = Random(nNum)+1;
		nIndex = GetLocalInt(oStore, "MiscEnchant_"+IntToString(nChosen));
	}
	nIndex--;
	if (nIndex > GetNum2DARows("store_item_enchants") || nIndex < 0){
		if (nTries < 5){
			nTries++;
			nIndex = GetStoreAppropriateEnchantmentIndex(sType, oStore, nTries);
		} else return -1;
	}
	return nIndex;
}

void CreateItemForStore(object oStore, object oPC = OBJECT_INVALID) {

	if (oPC == OBJECT_INVALID) oPC = OBJECT_SELF;

	int nLevel = GetChallengeRatingOfTarget(oStore);
	int nPoints = GetPointValueForCR(nLevel); //Just for determining material level
	
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "Points chosen: "+IntToString(nPoints));
	}
	
	//We want to make sure random items can have material levels
	int nMatLevel = nPoints-2;
	if (nMatLevel <= 0)
		nMatLevel = 0;
	else
		nMatLevel = Random(nMatLevel)+1;
		
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "Material Level chosen: "+IntToString(nMatLevel));
	}
	
	object oItem;
	int nType = Random(3)+1; //Add in more types later, like dedicated purple/orange slot
	string sType = "W";
	switch(nType) {
		case 1: sType = "W"; oItem = CreateRandomItemOfCategory(oStore, sType, nMatLevel); break;
		case 2: sType = "A"; oItem = CreateRandomItemOfCategory(oStore, sType, nMatLevel); break;
		case 3: sType = "M"; oItem = CreateRandomItemOfCategory(oStore, sType, nMatLevel); break;
	}
	
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "Type chosen: "+sType+", item generated: "+GetName(oItem));
	}
	
	if (GetTag(oItem) == "ps_crft_basemisc" || GetTag(oItem) == "ps_crft_basecontainer") {
		SendMessageToPC(oPC, "type not allowed! removing item");
		DestroyObject(oItem);
		return;
	}
	
	int nEnchant = GetStoreAppropriateEnchantmentIndex(sType, oStore);
	if (nEnchant < 0) { //Failure!
		SendMessageToPC(oPC, "enchantment not allowed! removing item");
		DestroyObject(oItem);
		return;
	}
	
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "About to enchant. . ");
	}

	struct enchantment e = LoadEnchantmentFrom2DA(nEnchant, oPC, TRUE);
	
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "Enchantment chosen: "+IntToString(e.id));
	}
	EnchantItem(oItem, e);
	
	if (GetTag(oStore) == "ps_store_armory") {
		itemproperty iDoom = ItemPropertySpecialMaterial(SPECIAL_MAT_DOOMFORGED);
	
		if (GetIsItemPropertyValid(iDoom)) {
			IPSafeAddItemProperty(oItem, iDoom);
		}
	}
	
	string sMat = GetLocalString(oItem, "material_name");
	if (sMat == "Leather" || sMat == "Iron" || sMat == "Wood")
		sMat = "";
	else
		sMat += " ";

	string sItemName = GetItemNamePart(e.id, "prefix")+" "+sMat+GetLocalString(oItem, "base_name");
	SetFirstName(oItem, sItemName);
	
	string sDescription = "This "+GetLocalString(oItem, "base_name")+" "+GetLocalString(oStore, "Item_Description");
	SetDescription(oItem, sDescription);
	
	int nBaseCost = GetGoldPieceValue(oItem);
	SetLocalInt(oItem, "PRICE_OLD", nBaseCost);
	PS_Timestamp_UNIX(oItem, "PRICE_TIMESTAMP");
	int nNewCost = GetCostOfItem(oItem);
	SetLocalInt(oItem, "PRICE", nNewCost);
	
}