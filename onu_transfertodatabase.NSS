#include "nwnx_sql"
#include "ps_inc_gemstones"
#include "ps_inc_treasuregeneration"
#include "ps_inc_oldloottables"
#include "ps_inc_functions"

void LoadGemstonesIntoDatabase (object oPC);
void LoadEnchantmentsIntoDatabase(object oPC);
void LoadEnchantmentNamesIntoDatabase(object oPC);
void LoadJunkToDatabase(object oPC);
void LoadPotionsToDatabase(object oPC);
void LoadArmorToDatabase(object oPC);
void LoadBootsToDatabase(object oPC);
void LoadCloaksToDatabase(object oPC);
void LoadBracersToDatabase(object oPC);
void LoadBeltsToDatabase(object oPC);
void LoadHelmetsToDatabase(object oPC);
void LoadShieldsToDatabase(object oPC);
void LoadMagicalJewelryToDatabase(object oPC);
void LoadMiscellaneousToDatabase(object oPC);
void LoadWeaponsToDatabase(object oPC);

void main () {
	object oPC = GetLastUsedBy();
	int nType = PS_GetLocalInt(OBJECT_SELF, "load_type");
	if (nType == 1)
		LoadEnchantmentsIntoDatabase(oPC);
	else if (nType == 2)
		LoadGemstonesIntoDatabase(oPC);
	else if (nType == 3)
		LoadEnchantmentNamesIntoDatabase(oPC);
	else if (nType == 4)
		LoadPotionsToDatabase(oPC);
	else if (nType == 5)
		LoadJunkToDatabase(oPC);
	else if (nType == 6)
		LoadArmorToDatabase(oPC);
	else if (nType == 7)
		LoadBeltsToDatabase(oPC);
	else if (nType == 8)
		LoadBootsToDatabase(oPC);
	else if (nType == 9)
		LoadBracersToDatabase(oPC);
	else if (nType == 10)
		LoadCloaksToDatabase(oPC);
	else if (nType == 11)
		LoadHelmetsToDatabase(oPC);
	else if (nType == 12)
		LoadMagicalJewelryToDatabase(oPC);
	else if (nType == 13)
		LoadMiscellaneousToDatabase(oPC);
	else if (nType == 14)
		LoadShieldsToDatabase(oPC);
	else if (nType == 15)
		LoadWeaponsToDatabase(oPC);
}

//Gemstone transfer to database
void LoadGemstonesIntoDatabase (object oPC) {

	SQLExecDirect("TRUNCATE TABLE gemstones");

	object oChest = GetObjectByTag(gemstoneBox);
	object oItem = GetFirstItemInInventory(oChest);
	int n = 0;
    while (GetIsObjectValid(oItem)) {
	
		string sResref = "gemstone_value_low";
		if (!GetIsGemstone(oItem)) {
			sResref = "gemstone_value_vfx";
		} else if (GetGoldPieceValue(oItem) >= 299) {
			sResref = "gemstone_value_high";
		} else if (GetGoldPieceValue(oItem) >= 99) {
			sResref = "gemstone_value_medium";
		}
		
		string sName = SQLEncodeSpecialChars(GetName(oItem));
		string sTag = GetTag(oItem);
		int nIcon = GetItemIconSafe(oItem);
		string sColor = PS_GetLocalString(oItem, "Color");
		string sDescription = SQLEncodeSpecialChars(PS_GetLocalString(oItem, "GemDescription")+"\n\n"+PS_GetLocalString(oItem, "MineralDescription"));
		string sVFX = PS_GetLocalString(oItem, "VFX");
		float fDur = PS_GetLocalFloat(oItem, "Duration");
	
		string sQuery = "INSERT INTO gemstones SET gem_id='"+IntToString(n)+"', name='"+sName+"', tag='"+sTag+"', resref='"+sResref+"', icon='"+IntToString(nIcon)+"', color='"+sColor+"', description='"+sDescription+"', frequency='1', vfx='"+sVFX+"', duration='"+FloatToString(fDur)+"'";
		SendMessageToPC(oPC, sQuery);
		SQLExecDirect(sQuery);
		
		n++;
		
		oItem = GetNextItemInInventory(oChest);
	}

}

//Load Enchantment table from 2da to database
void LoadEnchantmentsIntoDatabase(object oPC) {

	SQLExecDirect("TRUNCATE TABLE recipes");
	
	int n;
	int max = GetNum2DARows("store_item_enchants");
	for (n = 0; n < max; n++) {
		//string recipe_id 	= IntToString(n);
		string label		= SQLEncodeSpecialChars(Get2DAString("store_item_enchants", "Label", n));
		
		string type	 		= Get2DAString("store_item_enchants", "Type", n);
		if (type == "")		type = "0";
		
		string subtype 		= Get2DAString("store_item_enchants", "Subtype", n);
		if (subtype == "")	subtype = "0";
		
		string numerical 	= Get2DAString("store_item_enchants", "Numerical", n);
		if (numerical == "")numerical = "0";
		
		string special 		= Get2DAString("store_item_enchants", "Special", n);
		if (special == "")	special = "0";
		
		string points 		= Get2DAString("store_item_enchants", "Points", n);
		if (points == "")	points = "0";
		
		string gold 		= Get2DAString("store_item_enchants", "Gold", n);
		if (gold == "")		gold = "0";
		
		string essence 		= SQLEncodeSpecialChars(Get2DAString("store_item_enchants", "Essence", n));
		string gemstone 	= SQLEncodeSpecialChars(Get2DAString("store_item_enchants", "Gemstone", n));
		
		string melee 		= Get2DAString("store_item_enchants", "0_Melee", n);
		if (melee == "")	melee = "0";
		
		string ranged 		= Get2DAString("store_item_enchants", "1_Ranged", n);
		if (ranged == "")	ranged = "0";
		
		string ammo			= Get2DAString("store_item_enchants", "2_Ammo", n);
		if (ammo == "")		ammo = "0";
		
		string thrown 		= Get2DAString("store_item_enchants", "3_Thrown", n);
		if (thrown == "")	thrown = "0";
		
		string armor 		= Get2DAString("store_item_enchants", "4_Armor", n);
		if (armor == "")	armor = "0";
		
		string glove 		= Get2DAString("store_item_enchants", "5_Glove", n);
		if (glove == "")	glove = "0";
		
		string bracer 		= Get2DAString("store_item_enchants", "6_Bracer", n);
		if (bracer == "")	bracer = "0";
		
		string helm 		= Get2DAString("store_item_enchants", "7_Helm", n);
		if (helm == "")		helm = "0";
		
		string amulet 		= Get2DAString("store_item_enchants", "8_Amulet", n);
		if (amulet == "")	amulet = "0";
		
		string ring 		= Get2DAString("store_item_enchants", "9_Ring", n);
		if (ring == "")		ring = "0";
		
		string boots 		= Get2DAString("store_item_enchants", "10_Boots", n);
		if (boots == "")	boots = "0";
		
		string belt 		= Get2DAString("store_item_enchants", "11_Belt", n);
		if (belt == "") 	belt = "0";
		
		string cloak 	= Get2DAString("store_item_enchants", "12_Cloak", n);
		if (cloak == "") cloak = "0";
		
		string container 	= Get2DAString("store_item_enchants", "13_Container", n);
		if (container == "") container = "0";
		
		string instrument 	= Get2DAString("store_item_enchants", "14_Instrument", n);
		if (instrument == "") instrument = "0";
		
		string misc 		= Get2DAString("store_item_enchants", "15_Misc", n);
		if (misc == "")		misc = "0";
		
		string custom 		= Get2DAString("store_item_enchants", "Custom_Requirement", n);
		if (custom == "")		custom = "0";
		
		string can_enchant 	= Get2DAString("store_item_enchants", "Can_Enchant", n);
		if (can_enchant == "")		can_enchant = "0";
		
		string sQuery = "INSERT INTO recipes SET Label='"+label+"', Type='"+type+"', Subtype='"+subtype+"'";
		sQuery += ", Numerical='"+numerical+"', Special='"+special+"', Points='"+points+"', Gold='"+gold+"', Gemstone='"+gemstone+"', Essence='"+essence+"', Melee='"+melee+"'";
		sQuery += ", Ranged='"+ranged+"', Ammo='"+ammo+"', Thrown='"+thrown+"', Armor='"+armor+"', Glove='"+glove+"', Bracer='"+bracer+"'";
		sQuery += ", Helm='"+helm+"', Amulet='"+amulet+"', Ring='"+ring+"', Boots='"+boots+"', Belt='"+belt+"', Cloak='"+cloak+"', Container='"+container+"', Instrument='"+instrument+"'";
		sQuery += ", Misc='"+misc+"', Custom_Requirement='"+custom+"', Can_Enchant='"+can_enchant+"', Cursed=0, Can_Generate=1";
		
		SendMessageToPC(oPC, sQuery);
		
		SQLExecDirect(sQuery);
	}
}

//Load enchantment names table to database
void LoadEnchantmentNamesIntoDatabase(object oPC) {

	/*SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'recipes_names' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE recipes_names (enchantment_id INT, prefix VARCHAR(255), suffix VARCHAR(255), arcane VARCHAR(255)");
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}*/

	SQLExecDirect("TRUNCATE TABLE recipes_names");
	
	int n;
	int max = GetNum2DARows("enchantments_names");
	for (n = 0; n < max; n++) {
		
		//string enchantment_id	 		= Get2DAString("enchantments_names", "enchantment_id", n);
		//if (enchantment_id == "")		enchantment_id = "0";
		string prefix	 				= SQLEncodeSpecialChars(Get2DAString("enchantments_names", "prefix", n));
		if (prefix == "")				prefix = "";
		string suffix	 				= SQLEncodeSpecialChars(Get2DAString("enchantments_names", "suffix", n));
		if (suffix == "")				suffix = "";
		string arcane	 				= SQLEncodeSpecialChars(Get2DAString("enchantments_names", "arcane", n));
		if (arcane == "")				arcane = "";
		
		string sQuery = "INSERT INTO recipes_names SET prefix='"+prefix+"', suffix='"+suffix+"', arcane='"+arcane+"'";
		
		SendMessageToPC(oPC, sQuery);
		
		SQLExecDirect(sQuery);
	}
}

//Old Junk tables
void LoadJunkToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_junk' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_junk (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT, special = VARCHAR(255)");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_junk");
	int n = 1;
	while (n < 27) {
		string sPot = GetFromJunkList(n);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 9) {
		string sPot = GetFromCoinList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 1, "coin");
		n++;
	}
	n = 1;
	while (n < 4) {
		string sPot = GetFromCoinList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 2, "coin");
		n++;
	}
	n = 1;
	while (n < 4) {
		string sPot = GetFromCoinList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 3, "coin");
		n++;
	}
	UploadItemToDatabase(GetFromCoinList(1, 4), "treasure_junk", oPC, 4, "coin");
	n = 1;
	while (n < 14) {
		string sPot = GetFromGrenadeList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 1, "grenade");
		n++;
	}
	n = 1;
	while (n < 15) {
		string sPot = GetFromGrenadeList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 2, "grenade");
		n++;
	}
	n = 1;
	while (n < 6) {
		string sPot = GetFromPaintingList(n);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 1, "painting");
		n++;
	}
	n = 1;
	while (n < 97) {
		string sPot = GetFromRuneList(n);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 1, "rune");
		n++;
	}
	n = 1;
	while (n < 11) {
		string sPot = GetFromDrugList(n);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 1, "drug");
		n++;
	}
	n = 1;
	while (n < 8) {
		string sPot = GetOrdinaryJewelryFromList(n);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 18) {
		string sPot = GetKitsFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 27) {
		string sPot = GetKitsFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 2);
		n++;
	}
	string sQuery = "UPDATE treasure_junk SET special='healingkit' WHERE resref LIKE '%medkit%'";
	SQLExecDirect(sQuery);
	sQuery = "UPDATE treasure_junk SET special='thieveskit' WHERE resref LIKE '%picks%'";
	SQLExecDirect(sQuery);
	sQuery = "UPDATE treasure_junk SET special='trapkit' WHERE resref LIKE '%trap%'";
	SQLExecDirect(sQuery);
	n = 1;
	while (n < 97) {
		string sPot = GetAmmoFromList(n);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_junk", oPC, 1, "ammo");
		n++;
	}
}

//Old Potions table
void LoadPotionsToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_potions' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_potions (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_potions");
	
	int n = 1;
	while (n < 33) {
		string sPot = GetPotionFromList(oPC, n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_potions", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 19) {
		string sPot = GetPotionFromList(oPC, n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_potions", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 4) {
		string sPot = GetPotionFromList(oPC, n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_potions", oPC, 3);
		n++;
	}
}

//Old armor table
void LoadArmorToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_armor' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_armor (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_armor");
	
	int n = 1;
	while (n < 91) {
		string sPot = GetArmorFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_armor", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 85) {
		string sPot = GetArmorFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_armor", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 54) {
		string sPot = GetArmorFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_armor", oPC, 3);
		n++;
	}
}

//Old boots table
void LoadBootsToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_boots' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_boots (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_boots");
	
	int n = 1;
	while (n < 21) {
		string sPot = GetBootsFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_boots", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 15) {
		string sPot = GetBootsFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_boots", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 12) {
		string sPot = GetBootsFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_boots", oPC, 3);
		n++;
	}
}

//Load cloaks
void LoadCloaksToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_cloaks' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_cloaks (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_cloaks");
	
	int n = 1;
	while (n < 19) {
		string sPot = GetCloaksFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_cloaks", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 18) {
		string sPot = GetCloaksFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_cloaks", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 21) {
		string sPot = GetCloaksFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_cloaks", oPC, 3);
		n++;
	}
}

//Load bracers to table
void LoadBracersToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_bracers' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_bracers (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_bracers");
	
	int n = 1;
	while (n < 34) {
		string sPot = GetBracersFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_bracers", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 28) {
		string sPot = GetBracersFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_bracers", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 30) {
		string sPot = GetBracersFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_bracers", oPC, 3);
		n++;
	}
}

//Old belts table
void LoadBeltsToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_belts' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_belts (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_belts");
	
	int n = 1;
	while (n < 13) {
		string sPot = GetBeltsFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_belts", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 11) {
		string sPot = GetBeltsFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_belts", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 16) {
		string sPot = GetBeltsFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_belts", oPC, 3);
		n++;
	}
}

//Old helmets table
void LoadHelmetsToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_helmets' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_helmets (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_helmets");
	
	int n = 1;
	while (n < 17) {
		string sPot = GetHelmetsFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_helmets", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 17) {
		string sPot = GetHelmetsFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_helmets", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 16) {
		string sPot = GetHelmetsFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_helmets", oPC, 3);
		n++;
	}
}

//Load shields to database
void LoadShieldsToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_shields' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_shields (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_shields");
	
	int n = 1;
	while (n < 38) {
		string sPot = GetShieldsFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_shields", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 24) {
		string sPot = GetShieldsFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_shields", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 21) {
		string sPot = GetShieldsFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_shields", oPC, 3);
		n++;
	}
}

//Old jewelry table
void LoadMagicalJewelryToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_jewelry' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_jewelry (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_jewelry");
	
	int n = 1;
	while (n < 71) {
		string sPot = GetMagicJewelryFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_jewelry", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 57) {
		string sPot = GetMagicJewelryFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_jewelry", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 47) {
		string sPot = GetMagicJewelryFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_jewelry", oPC, 3);
		n++;
	}
}

//Miscellaneous Table - used to be under wearables
void LoadMiscellaneousToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_miscellaneous' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_miscellaneous (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_miscellaneous");
	
	int n = 1;
	while (n < 37) {
		string sPot = GetMiscFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_miscellaneous", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 14) {
		string sPot = GetMiscFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_miscellaneous", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 9) {
		string sPot = GetMiscFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_miscellaneous", oPC, 3);
		n++;
	}
}

//Old weapons table
void LoadWeaponsToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_weapons' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_weapons (item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_weapons");
	
	int n = 1;
	while (n < 465) {
		string sPot = GetWeaponFromList(n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_weapons", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 228) {
		string sPot = GetWeaponFromList(n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_weapons", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 257) {
		string sPot = GetWeaponFromList(n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_weapons", oPC, 3);
		n++;
	}
}