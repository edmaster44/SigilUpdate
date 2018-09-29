#include "nwnx_sql"

//Gets the enchanting recipes from the override 2da and updates the database with it
void main () {

	object oPC = GetLastUsedBy();
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