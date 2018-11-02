#include "nwnx_sql"
#include "ps_inc_gemstones"
#include "ps_inc_treasuregeneration"

void LoadGemstonesIntoDatabase (object oPC) {

	SQLExecDirect("TRUNCATE TABLE gemstones");

	object oChest = GetObjectByTag("plc_chest_gemstonegeneration_2");
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
		
		string sName = GetName(oItem);
		string sTag = GetTag(oItem);
		int nIcon = GetItemIcon(oItem);
		string sColor = GetLocalString(oItem, "Color");
		string sDescription = GetLocalString(oItem, "GemDescription")+"\n\n"+GetLocalString(oItem, "MineralDescription");
		string sVFX = GetLocalString(oItem, "VFX");
		float fDur = GetLocalFloat(oItem, "Duration");
	
		string sQuery = "INSERT INTO gemstones SET gem_id='"+IntToString(n)+"', name='"+sName+"', tag='"+sTag+"', resref='"+sResref+"', icon='"+IntToString(nIcon)+"', color='"+sColor+"', description='"+sDescription+"', frequency='1', vfx='"+sVFX+"', duration='"+FloatToString(fDur)+"'";
		SendMessageToPC(oPC, sQuery);
		SQLExecDirect(sQuery);
		
		n++;
		
		oItem = GetNextItemInInventory(oChest);
	}

}

void LoadEnchantmentsIntoDatabase(object oPC) {

	SQLExecDirect("TRUNCATE TABLE recipes");
	
	int n;
	int max = GetNum2DARows("scodenchantments");
	for (n = 0; n < max; n++) {
		string recipe_id 	= IntToString(n);
		string label		= SQLEncodeSpecialChars(Get2DAString("scodenchantments", "Label", n));
		
		string type	 		= Get2DAString("scodenchantments", "Type", n);
		if (type == "")		type = "0";
		
		string subtype 		= Get2DAString("scodenchantments", "Subtype", n);
		if (subtype == "")	subtype = "0";
		
		string numerical 	= Get2DAString("scodenchantments", "Numerical", n);
		if (numerical == "")numerical = "0";
		
		string special 		= Get2DAString("scodenchantments", "Special", n);
		if (special == "")	special = "0";
		
		string points 		= Get2DAString("scodenchantments", "Points", n);
		if (points == "")	points = "0";
		
		string gold 		= Get2DAString("scodenchantments", "Gold", n);
		if (gold == "")		gold = "0";
		
		string essence 		= SQLEncodeSpecialChars(Get2DAString("scodenchantments", "Essence", n));
		string gemstone 	= SQLEncodeSpecialChars(Get2DAString("scodenchantments", "Gemstone", n));
		
		string melee 		= Get2DAString("scodenchantments", "0_Melee", n);
		if (melee == "")	melee = "0";
		
		string ranged 		= Get2DAString("scodenchantments", "1_Ranged", n);
		if (ranged == "")	ranged = "0";
		
		string ammo			= Get2DAString("scodenchantments", "2_Ammo", n);
		if (ammo == "")		ammo = "0";
		
		string thrown 		= Get2DAString("scodenchantments", "3_Thrown", n);
		if (thrown == "")	thrown = "0";
		
		string armor 		= Get2DAString("scodenchantments", "4_Armor", n);
		if (armor == "")	armor = "0";
		
		string glove 		= Get2DAString("scodenchantments", "5_Glove", n);
		if (glove == "")	glove = "0";
		
		string bracer 		= Get2DAString("scodenchantments", "6_Bracer", n);
		if (bracer == "")	bracer = "0";
		
		string helm 		= Get2DAString("scodenchantments", "7_Helm", n);
		if (helm == "")		helm = "0";
		
		string amulet 		= Get2DAString("scodenchantments", "8_Amulet", n);
		if (amulet == "")	amulet = "0";
		
		string ring 		= Get2DAString("scodenchantments", "9_Ring", n);
		if (ring == "")		ring = "0";
		
		string boots 		= Get2DAString("scodenchantments", "10_Boots", n);
		if (boots == "")	boots = "0";
		
		string belt 		= Get2DAString("scodenchantments", "11_Belt", n);
		if (belt == "") 	belt = "0";
		
		string cloak 	= Get2DAString("scodenchantments", "12_Cloak", n);
		if (cloak == "") cloak = "0";
		
		string container 	= Get2DAString("scodenchantments", "13_Container", n);
		if (container == "") container = "0";
		
		string instrument 	= Get2DAString("scodenchantments", "14_Instrument", n);
		if (instrument == "") instrument = "0";
		
		string misc 		= Get2DAString("scodenchantments", "15_Misc", n);
		if (misc == "")		misc = "0";
		
		string custom 		= Get2DAString("scodenchantments", "Custom_Requirement", n);
		if (custom == "")		custom = "0";
		
		string can_enchant 	= Get2DAString("scodenchantments", "Can_Enchant", n);
		if (can_enchant == "")		can_enchant = "0";
		
		string sQuery = "INSERT INTO recipes SET Recipe_Id='"+recipe_id+"', Label='"+label+"', Type='"+type+"', Subtype='"+subtype+"'";
		sQuery += ", Numerical='"+numerical+"', Special='"+special+"', Points='"+points+"', Gold='"+gold+"', Gemstone='"+gemstone+"', Essence='"+essence+"', Melee='"+melee+"'";
		sQuery += ", Ranged='"+ranged+"', Ammo='"+ammo+"', Thrown='"+thrown+"', Armor='"+armor+"', Glove='"+glove+"', Bracer='"+bracer+"'";
		sQuery += ", Helm='"+helm+"', Amulet='"+amulet+"', Ring='"+ring+"', Boots='"+boots+"', Belt='"+belt+"', Cloak='"+cloak+"', Container='"+container+"', Instrument='"+instrument+"'";
		sQuery += ", Misc='"+misc+"', Custom_Requirement='"+custom+"', Can_Enchant='"+can_enchant+"'";
		
		SendMessageToPC(oPC, sQuery);
		
		SQLExecDirect(sQuery);
	}
}

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
		
		string enchantment_id	 		= Get2DAString("enchantments_names", "enchantment_id", n);
		if (enchantment_id == "")		enchantment_id = "0";
		string prefix	 				= SQLEncodeSpecialChars(Get2DAString("enchantments_names", "prefix", n));
		if (prefix == "")				prefix = "";
		string suffix	 				= SQLEncodeSpecialChars(Get2DAString("enchantments_names", "suffix", n));
		if (suffix == "")				suffix = "";
		string arcane	 				= SQLEncodeSpecialChars(Get2DAString("enchantments_names", "arcane", n));
		if (arcane == "")				arcane = "";
		
		string sQuery = "INSERT INTO recipes_names SET enchantment_id='"+enchantment_id+"', prefix='"+prefix+"', suffix='"+suffix+"', arcane='"+arcane+"'";
		
		SendMessageToPC(oPC, sQuery);
		
		SQLExecDirect(sQuery);
	}
}

void LoadPotionsToDatabase(object oPC) {
	SQLExecDirect("SELECT * FROM information_schema.tables WHERE table_name = 'treasure_potions' LIMIT 1");
	if (SQLFetch() == SQL_ERROR || SQLGetData(1) == "") { 
		SendMessageToPC(oPC, "Creating new table");
		SQLExecDirect("CREATE TABLE treasure_potions (item_id INT NOT NULL AUTO_INCREMENT, name VARCHAR(255), resref VARCHAR(255), treasure_level INT");
		
	} else {
		SendMessageToPC(oPC, "Table already exists");
	}
	SQLExecDirect("TRUNCATE TABLE treasure_potions");
	
	int n = 1;
	while (n < 33) {
		string sPot = RandomPotion(oPC, n, 1);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_potions", oPC, 1);
		n++;
	}
	n = 1;
	while (n < 19) {
		string sPot = RandomPotion(oPC, n, 2);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_potions", oPC, 2);
		n++;
	}
	n = 1;
	while (n < 4) {
		string sPot = RandomPotion(oPC, n, 3);
		if (sPot == "") {
			n++; continue;
		}
		UploadItemToDatabase(sPot, "treasure_potions", oPC, 3);
		n++;
	}
}

void main () {
	object oPC = GetLastUsedBy();
	int nType = GetLocalInt(OBJECT_SELF, "load_type");
	if (nType == 1)
		LoadEnchantmentsIntoDatabase(oPC);
	else if (nType == 2)
		LoadGemstonesIntoDatabase(oPC);
	else if (nType == 3)
		LoadEnchantmentNamesIntoDatabase(oPC);
	else if (nType == 4)
		LoadPotionsToDatabase(oPC);
}