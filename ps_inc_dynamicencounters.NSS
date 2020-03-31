//*******************************************
//ps_inc_dynamicencounters
//Mimi Fearthegn
//Started 3-5-20
//*******************************************
//Include script for creating creatures
//suitable for encounters (fighting or flavor)
//of any level
//*******************************************
#include "ps_inc_advscript"
#include "ps_inc_randomitems"

//creates a creature/npc at the given waypoint
//of decent challenge to nLevel
//and of the given class type
//can be set to a standard faction with faction = STANDARD_FACTION_*
//(if there is no blueprint of the given class type, defaults to fighter)
//Supported class types:
//CLASS_TYPE_BARBARIAN
//CLASS_TYPE_BARD
//CLASS_TYPE_CLERIC
//CLASS_TYPE_DRUID
//CLASS_TYPE_SPIRIT_SHAMAN (defaults to druid for now)
//CLASS_TYPE_FIGHTER
//CLASS_TYPE_MONK
//CLASS_TYPE_PALADIN
//CLASS_TYPE_RANGER
//CLASS_TYPE_ARCANE_ARCHER (actually just gives ranger archer)
//CLASS_TYPE_ROGUE
//CLASS_TYPE_WARLOCK
//CLASS_TYPE_WIZARD
object CreateScaledCreatureofClass(object oWP, int nLevel, int classType, int isHostile = TRUE);

//Gets the blueprint string from the class INT
//(if there is no blueprint of the given class type, defaults to fighter)
string GetBlueprintStringFromClass(int classType);

//Gets the nearest blueprint available
//classType currently does nothing; putting it in for later
int GetNearestCreatureLevelAvailable(int nLevel, int classType);

//Sets the creature's conversation
void SetConversation(object oCreature, string sConversation);

//Gets the resref of a suitable set of clothing
string GetClothing(object oCreature);

//Gets the resref of a suitable set of armor
string GetArmor(object oCreature);

//Makes sure all the items given to this creature will be undroppable
//ALWAYS CALL AFTER EQUIPPING A RANDOM CREATURE
//This does mean that the creature won't drop loot (or won't drop it in the same way)
//This is a small price to pay for not having the economy implode
void makeInventoryUndroppable(object oCreature);

//Selects and equips protective gear
//set shouldHaveArmor to true for armor
//otherwise, will just do clothing and wearables (albeit enchanted at high levels)
//***********************************
//AC metrics
//***********************************
//Levels 1-5 standard armor
//Levels 5-10 armor +1-5
//Levels 10-15 amulet of nat armor +1-5
//Levels 15-20 boots of dodge +1-5
//Levels 20-25 ring +1-5
//Levels 25-30 armor +6-10
void assignProtectiveItems(object oCreature, int shouldHaveArmor = FALSE);

//creates a weapon on the creature
//if no BASE_ITEM_* is assigned as preference, defaults to longsword
//later add a way to specify special weapon properties; for the moment, we'll randomly
//magically enchant it
//Note: does not currently give ammo with ranged weapons; fix this later
//***********************************
//Weapon metrics
//***********************************
//Levels 1-5 standard weapons (sometimes silver or cold iron)
//Levels 5-10 weapons 2-4 points
//Levels 10-15 weapons 3-6 points
//Levels 15-20 weapons 6-9 points
//Levels 20-25 weapons 9-10 points
//Levels 25+ weapons 10-13 points
void assignWeaponToCreature(object oCreature, int shouldEquip = FALSE, int typePreference = -1);

//*******************************************
//ACTUAL CODE
//*******************************************
object CreateScaledCreatureofClass(object oWP, int nLevel, int classType, int faction = STANDARD_FACTION_HOSTILE) {

	int blueprintID = GetNearestCreatureLevelAvailable(nLevel, classType);
	string sBlueprint = GetBlueprintStringFromClass(classType)+IntToString(blueprintID);
	SpeakString("Going to generate: "+sBlueprint, TALKVOLUME_SHOUT);
	
	//make sure we have a waypoint
	if (!GetIsObjectValid(oWP)) {
		SpeakString("No waypoint found!!!", TALKVOLUME_SHOUT);
		return oWP;
	}
		
	object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sBlueprint, GetLocation(oWP));
	SpeakString("Created creature: "+GetName(oCreature), TALKVOLUME_SHOUT);
	ChangeToStandardFaction(oCreature, faction);
	
	return oCreature;
}

string GetBlueprintStringFromClass(int classType) {

	switch (classType) {
		case CLASS_TYPE_BARBARIAN: return "de_barbarian_";
		case CLASS_TYPE_BARD: return "de_bard_";
		case CLASS_TYPE_CLERIC: return "de_cleric_";
		case CLASS_TYPE_DRUID: return "de_druid_";
		case CLASS_TYPE_SPIRIT_SHAMAN: return "de_druid_";
		case CLASS_TYPE_FIGHTER: return "de_fighter_";
		case CLASS_TYPE_MONK: return "de_monk_";
		case CLASS_TYPE_PALADIN: return "de_paladin_";
		case CLASS_TYPE_RANGER: return "de_ranger_";
		case CLASS_TYPE_ARCANE_ARCHER: return "de_archer_";
		case CLASS_TYPE_ROGUE: return "de_rogue_";
		case CLASS_TYPE_WARLOCK: return "de_warlock_";
		case CLASS_TYPE_WIZARD: return "de_wizard_";
		default: return "de_fighter_";
	}
	
	return "de_fighter_";

}

int GetNearestCreatureLevelAvailable(int nLevel, int classType = CLASS_TYPE_FIGHTER) {

	if (nLevel <= 2)
		return 1;
	else if (nLevel <= 5) 
		return 2;
	else if (nLevel <= 8) 
		return 3;
	else if (nLevel <= 11) 
		return 4;
	else if (nLevel <= 14) 
		return 5;
	else if (nLevel <= 17) 
		return 6;
	else if (nLevel <= 20) 
		return 7;
	else if (nLevel <= 23) 
		return 8;
	else if (nLevel <= 27) 
		return 9;
	else
		return 10;

}

void SetConversation(object oCreature, string sConversation) {

	SetLocalString(oCreature, "DEFAULT_CONVERSATION", sConversation);

}

string GetArmor(object oCreature) {

	int nClass = GetClassByPosition(1, oCreature);
	int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oCreature); 
	
	if (GetLocalInt(oCreature, "CAMPAIGN_HARMONIUM") > 0)
		return "ps_darkharmonium_plate";
	
	string sArmorType = "heavy";
	if (nClass == CLASS_TYPE_ROGUE || nClass == CLASS_TYPE_RANGER || nClass == CLASS_TYPE_DRUID || nDexMod >= 4) {
		sArmorType == "light";
	} else if (nDexMod >= 2) {
		sArmorType == "medium";
	} 
	
	if (sArmorType == "light") {
		int nRand = Random(4)+1;
		switch(nRand) {
			case 1: return "de_lightarmor_1";
			case 2: return "de_lightarmor_2";
			case 3: return "de_lightarmor_3";
			case 4: return "de_lightarmor_4";
		}
	} else if (sArmorType == "medium") {
		int nRand = Random(4)+1;
		switch(nRand) {
			case 1: return "de_mediumarmor_1";
			case 2: return "de_mediumarmor_2";
			case 3: return "de_mediumarmor_3";
			case 4: return "de_mediumarmor_4";
		}
	} else if (sArmorType == "medium") {
		int nRand = Random(3)+1;
		switch(nRand) {
			case 1: return "de_heavyarmor_1";
			case 2: return "de_heavyarmor_2";
			case 3: return "de_heavyarmor_3";
		}
	}
	
	return "de_basicclothing_01";
}

string GetClothing(object oCreature) {

	int nRand = Random(12)+1;
	switch(nRand) {
		case 1: return "de_basicclothing_01";
		case 2: return "de_basicclothing_02";
		case 3: return "de_basicclothing_03";
		case 4: return "de_basicclothing_04";
		case 5: return "de_basicclothing_05";
		case 6: return "de_basicclothing_06";
		case 7: return "de_basicclothing_07";
		case 8: return "de_basicclothing_08";
		case 9: return "de_basicclothing_09";
		case 10: return "de_basicclothing_10";
		case 11: return "de_basicclothing_11";
		case 12: return "de_basicclothing_12";
	}
	return "de_basicclothing_01";
	
}

void makeInventoryUndroppable(object oCreature) {

	object oItem = GetFirstItemInInventory(oCreature);
	while (GetIsObjectValid(oItem)) {
	
		SetDroppableFlag(oItem, FALSE);
		
		oItem = GetNextItemInInventory(oCreature);
		
	}

}

void assignWeaponToCreature(object oCreature, int shouldEquip = FALSE, int typePreference = -1) {
	
	int nLevel = GetChallengeRatingOfTarget(oCreature);
	
	object oWeapon;
	if (GetLocalInt(oCreature, "CAMPAIGN_HARMONIUM") > 0) {
		int nRand = Random(3)+1;
		switch(nRand) {
			case 1: oWeapon = CreateItemOnObject("ps_darkharmonium_spic", oCreature); break;
			case 2: oWeapon = CreateItemOnObject("ps_darkharmonium_kop", oCreature); break;
			case 3: oWeapon = CreateItemOnObject("ps_darkharmonium_glad", oCreature); break;
		}
	} else if (typePreference < 0) {
		oWeapon = CreateRandomItemOfCategory(oCreature, "W");
	} else {
		int nCraftingIndex = GetCraftingItemIndexByBaseItemType(typePreference);
		oWeapon = CreateRandomItemOfType(oCreature, nCraftingIndex);
	}
	
	if (!GetIsObjectValid(oWeapon))
		return;

	SetDroppableFlag(oWeapon, FALSE);
	SetIdentified(oWeapon, TRUE);
	
	int nPoints = 1;
	if (nLevel > 25)
		nPoints = 9+d4();
	else if (nLevel > 20)
		nPoints = 8+d2();
	else if (nLevel > 15)
		nPoints = 5+d3();
	else if (nLevel > 10)
		nPoints = 2+d3();
	else if (nLevel > 5)
		nPoints = 1+d3();
	
	GiveItemRandomEnchantments(oWeapon, nPoints);
	GenerateRandomNameAndDescriptionForItem(oWeapon);
	
}

void assignProtectiveItems(object oCreature, int shouldHaveArmor = FALSE) {
	
	int nLevel = GetChallengeRatingOfTarget(oCreature);
	
	string armorResref = "";
	if (shouldHaveArmor)
		armorResref = GetArmor(oCreature);
	else
		armorResref = GetClothing(oCreature);
		
	object oArmor = CreateItemOnObject(armorResref, oCreature);
	
	if (nLevel >= 30)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(10), oArmor);
	else if (nLevel >= 29)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(9), oArmor);
	else if (nLevel >= 28)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(8), oArmor);
	else if (nLevel >= 27)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(7), oArmor);
	else if (nLevel >= 26)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(6), oArmor);
	else if (nLevel >= 9)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(5), oArmor);
	else if (nLevel >= 8)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(4), oArmor);
	else if (nLevel >= 7)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(3), oArmor);
	else if (nLevel >= 6)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(2), oArmor);
	else if (nLevel >= 5)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(1), oArmor);
		
	SetDroppableFlag(oArmor, FALSE);
	SetIdentified(oArmor, TRUE);
	DelayCommand(0.1f, AssignCommand(oCreature, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST)));
	
	object oProf = CreateItemOnObject("de_ringofproficiency", oCreature);
	SetDroppableFlag(oProf, FALSE);
	SetIdentified(oProf, TRUE);
	DelayCommand(0.1f, AssignCommand(oCreature, ActionEquipItem(oProf, INVENTORY_SLOT_LEFTRING)));
	
	if (nLevel >= 10) {
		object oAmulet;
		
		if (nLevel >= 14)
			oAmulet = CreateItemOnObject("nw_it_mneck015", oCreature);
		else if (nLevel >= 13)
			oAmulet = CreateItemOnObject("nw_it_mneck014", oCreature);
		else if (nLevel >= 12)
			oAmulet = CreateItemOnObject("nw_it_mneck013", oCreature);
		else if (nLevel >= 11)
			oAmulet = CreateItemOnObject("nw_it_mneck012", oCreature);
		else if (nLevel >= 10)
			oAmulet = CreateItemOnObject("nw_it_mneck001", oCreature);
			
		
		SetDroppableFlag(oAmulet, FALSE);
		SetIdentified(oAmulet, TRUE);
		DelayCommand(0.1f, AssignCommand(oCreature, ActionEquipItem(oAmulet, INVENTORY_SLOT_NECK)));
	}
	
	if (nLevel >= 15) {
		object oBoots;
		
		if (nLevel >= 19)
			oBoots = CreateItemOnObject("nx2_boots_hardy_05", oCreature);
		else if (nLevel >= 18)
			oBoots = CreateItemOnObject("nx2_boots_hardy_04", oCreature);
		else if (nLevel >= 17)
			oBoots = CreateItemOnObject("nx2_boots_hardy_03", oCreature);
		else if (nLevel >= 16)
			oBoots = CreateItemOnObject("nx2_boots_hardy_02", oCreature);
		else if (nLevel >= 15)
			oBoots = CreateItemOnObject("nx2_boots_hardy_01", oCreature);
			
		
		SetDroppableFlag(oBoots, FALSE);
		SetIdentified(oBoots, TRUE);
		DelayCommand(0.1f, AssignCommand(oCreature, ActionEquipItem(oBoots, INVENTORY_SLOT_BOOTS)));
	}
	
	if (nLevel >= 20) {
		object oRing;
		
		if (nLevel >= 24)
			oRing = CreateItemOnObject("nw_it_mring020", oCreature);
		else if (nLevel >= 23)
			oRing = CreateItemOnObject("nw_it_mring019", oCreature);
		else if (nLevel >= 22)
			oRing = CreateItemOnObject("nw_it_mring018", oCreature);
		else if (nLevel >= 21)
			oRing = CreateItemOnObject("nw_it_mring008", oCreature);
		else if (nLevel >= 20)
			oRing = CreateItemOnObject("nw_it_mring001", oCreature);
			
		
		SetDroppableFlag(oRing, FALSE);
		SetIdentified(oRing, TRUE);
		DelayCommand(0.1f, AssignCommand(oCreature, ActionEquipItem(oRing, INVENTORY_SLOT_RIGHTRING)));
	}
	
	//Give harmonium their shields
	if (GetLocalInt(oCreature, "CAMPAIGN_HARMONIUM") > 0) {
		object oShield = CreateItemOnObject("ps_darkharmonium_shield", oCreature);
		DelayCommand(0.1f, AssignCommand(oCreature, ActionEquipItem(oShield, INVENTORY_SLOT_LEFTHAND)));
	}

}