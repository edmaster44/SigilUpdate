const string xmlCraftingFile = "scod_crafting_window.xml";
const string sCraftingScreen = "SCOD_CRAFTING";

const string xmlCustomizationFile = "scod_icustom_window.xml";
const string sCustomizationScreen = "SCOD_ITEM_CUSTOMIZATION";

#include "ps_inc_newenchanting"
#include "ps_inc_gemstones"
#include "x2_inc_itemprop"
#include "nw_i0_plot"

//Important variables
//Craft_BaseItemType = index of scod_craft_baseitems picked
//Craft_Mat1 = index of material 2da picked (2da controlled by Craft_BaseItemType)
//Craft_Mat2 = index of material 2da picked (2da controlled by Craft_BaseItemType)
//Craft_Mat3 = index of material 2da picked (2da controlled by Craft_BaseItemType)

//Generates the list in the gui of possible
//base item types
//sType controls the list to be displayed
//W = weapons
//A = armor
//M = everything else (accessories, instruments, misc iems)
void GenerateBaseItemList(object oPC, string sType = "W");

//Generates the list in the gui of possible
//materials to craft with
//any given base item can have 1-3 material slots
//item_index = base item type index
void GenerateMaterial1List(object oPC, int item_index);

//Generates the list in the gui of possible
//materials to craft with
//any given base item can have 1-3 material slots
//item_index = base item type index
void GenerateMaterial2List(object oPC, int item_index);

//Generates the list in the gui of possible
//materials to craft with
//any given base item can have 1-3 material slots
//item_index = base item type index
void GenerateMaterial3List(object oPC, int item_index);

//Load the crafting information for a given base
//item type and put it in a struct
//n = 2da index
struct baseitem LoadBaseItem(int n);

//Get item field from scod_craft_baseitems
string GetItemLabel(int n);

//Get type field from scod_craft_baseitems
string GetItemType(int n);

//Get base_resref field from scod_craft_baseitems
string GetItemResref(int n);

//Get base_cost field from scod_craft_baseitems
int GetItemCost(int n);

//Get ID field from scod_craft_baseitems
int GetBaseID(int n);

//Get material fields from scod_craft_baseitems
// valid values for m are 1-3
//this will return the name of a 2da
string GetItemMatList(int n, int m);

//Gets the string to sort acceptable icons by
//returns ICON_KEYWORD from scod_craft_baseitems
string GetItemIconKeyword(int n);

//Gets the label field from the given 
//scod_craft_* materials 2da where n = 2da index
string GetMLabel(int n, string s2da);

//Gets the BASE_RESREF field from the given 
//scod_craft_* materials 2da where n = 2da index
string GetMResref(int n, string s2da);

//Gets the COST_TIER field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMCostTier(int n, string s2da);

//Gets the IP_DESCRIPTION_ID field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMForgedOf(int n, string s2da);

//Gets the IP_MELEE_TYPE field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMMeleeType(int n, string s2da);

//Gets the IP_MELEE_SUBTYPE field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMMeleeSubType(int n, string s2da);

//Gets the IP_MELEE_PARAM field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMMeleeParam(int n, string s2da);

//Gets the DR_PIERC_MAT field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMDRMaterial(int n, string s2da);

//Gets the IP_ARMOR_TYPE field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMArmorType(int n, string s2da);

//Gets the IP_ARMOR_SUBTYPE field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMArmorSubType(int n, string s2da);

//Gets the IP_ARMOR_PARAM field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMArmorParam(int n, string s2da);

//Gets the ARMOR_SUFFIX field from the given 
//scod_craft_* materials 2da where n = 2da index
string GetMArmorSuffix(int n, string s2da);

//Gets the IP_RANGED_TYPE field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMRangedType(int n, string s2da);

//Gets the IP_RANGED_SUBTYPE field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMRangedSubType(int n, string s2da);

//Gets the IP_RANGED_PARAM field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMRangedParam(int n, string s2da);

//Gets the CRAFT_DC field from the given 
//scod_craft_* materials 2da where n = 2da index
int GetMCraftDC(int n, string s2da);

//Set the material header text to something appropriately fluffy
// when generating the material lists
void SetMaterialListHeader(object oPC, struct baseitem i, int nList);

//Sets the icon list in the item customization gui
//Should be called at the end of gui_craft_item
void GenerateItemIconList(object oPC, struct baseitem i);

//Set the crafting details field to let the player
//know what they are getting
void GenerateCraftDetails(object oPC);

//create the item which has been specified by the crafting system
//requires the indicies for the base item type
//and any applicable materials
//defaults to basic wood/leather/metal/misc
object CreateCraftedItem(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3);

//get the item cost so far
//based on base item type and material cost tiers
int GetCraftedItemCost(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3); 

//Takes the required special material items for this crafting project
void TakeRequiredCraftingItems(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3);

//Generates new item name
string GetCraftingItemName(struct baseitem i, struct material m1, struct material m2, struct material m3);

//Generated new item description
string GetCraftingNameDescription(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3);

//Gets whether this 2da row id belongs to a ranged weapon (not thrown)
int GetIDRanged(int nId);

//Gets the item property for this item + special material combination
itemproperty GetSpecialMaterialItemProperty(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3);

//Does the lookup for the name in iprp_materials
//for pretty display of DR piercing item material
string GetDRMaterialString(int nDR);

//returns the crafting skill rank requirement
// m1.craftDC + m2.costTier + m3.costTier
int GetCraftingRankRequirement(struct baseitem i, struct material m1, struct material m2, struct material m3);

//Get the skill id required for crafting this particular item
//Use in conjunction with GetCraftingRankRequirement
int GetRequiredCraftSkill(struct baseitem i);

//Gets any important warnings for the crafting system. Called in GenerateCraftDetails.
string GetCautionString(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3);

//Checks if nType is a quiver. Range is 90-95
int GetIsQuiver(int nTYPE);

//Get the cost of the material from the 2da by looking up the item prop
int GetCostTierOfMaterial(itemproperty iProp);

//Get the base cost of the item by looking it up in the crafting table
int GetBaseCostOfItem(int nBaseID);

//************************************************
//Structure to hold base item information
//from scod_craft_baseitems
//************************************************
struct baseitem {
	string label;
	int id;
	string type;
	string resref;
	int cost;
	string matlist_1;
	string matlist_2;
	string matlist_3;
	string icon;
};

//************************************************
//Structure to hold material information
//from scod_craft_metal, scod_craft_leather
//scod_craft_wood, or scod_craft_misc
//************************************************
struct material {
	string label;
	string rResref;
	int costTier;
	int craftDC;
	int ipForgedOf;
	int ipMeleeType;
	int ipMeleeSubType;
	int ipMeleeParam;
	int drMaterial;
	int ipArmorType;
	int ipArmorSubType;
	int ipArmorParam;
	string armorSuffix;
	int ipRangedType;
	int ipRangedSubType;
	int ipRangedParam;
};

string GetMLabel(int n, string s2da) {
	string sIndex = Get2DAString(s2da, "LABEL", n);  
	return sIndex;
}

string GetMResref(int n, string s2da) {
	string sIndex = Get2DAString(s2da, "BASE_RESREF", n);  
	return sIndex;
}

int GetMCostTier(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "COST_TIER", n));  
	return nIndex;
}

int GetMForgedOf(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_DESCRIPTION_ID", n));  
	return nIndex;
}

int GetMMeleeType(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_MELEE_TYPE", n));  
	return nIndex;
}

int GetMMeleeSubType(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_MELEE_SUBTYPE", n));  
	return nIndex;
}

int GetMMeleeParam(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_MELEE_PARAM", n));  
	return nIndex;
}

int GetMDRMaterial(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "DR_PIERC_MAT", n));  
	return nIndex;
}

int GetMArmorType(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_ARMOR_TYPE", n));  
	return nIndex;
}

int GetMArmorSubType(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_ARMOR_SUBTYPE", n));  
	return nIndex;
}

int GetMArmorParam(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_ARMOR_PARAM", n));  
	return nIndex;
}

string GetMArmorSuffix(int n, string s2da) {
	string sIndex = Get2DAString(s2da, "ARMOR_SUFFIX", n);  
	return sIndex;
}

int GetMRangedType(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_RANGED_TYPE", n));  
	return nIndex;
}

int GetMRangedSubType(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_RANGED_SUBTYPE", n));  
	return nIndex;
}

int GetMRangedParam(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "IP_RANGED_PARAM", n));  
	return nIndex;
}

int GetMCraftDC(int n, string s2da) {
	int nIndex = StringToInt(Get2DAString(s2da, "CRAFT_DC", n));  
	return nIndex;
}

struct material LoadMaterial(int n, string s2da) {

	struct material mat;
	mat.label = GetMLabel(n, s2da);
	mat.rResref = GetMResref(n, s2da);
	mat.costTier = GetMCostTier(n, s2da);
	mat.craftDC = GetMCraftDC(n, s2da);
	mat.ipForgedOf = GetMForgedOf(n, s2da);
	mat.ipMeleeType = GetMMeleeType(n, s2da);
	mat.ipMeleeSubType = GetMMeleeSubType(n, s2da);
	mat.ipMeleeParam = GetMMeleeParam(n, s2da);
	mat.drMaterial = GetMDRMaterial(n, s2da);
	mat.ipArmorType = GetMArmorType(n, s2da);
	mat.ipArmorSubType = GetMArmorSubType(n, s2da);
	mat.ipArmorParam = GetMArmorParam(n, s2da);
	mat.armorSuffix = GetMArmorSuffix(n, s2da);
	mat.ipRangedType = GetMRangedType(n, s2da);
	mat.ipRangedSubType = GetMRangedSubType(n, s2da);
	mat.ipRangedParam = GetMRangedParam(n, s2da);
	return mat;
	
}

string GetItemLabel(int n) {
 	string sIndex = Get2DAString("scod_craft_baseitems", "ITEM", n);  
	return sIndex;
}

string GetItemType(int n) {
 	string sIndex = Get2DAString("scod_craft_baseitems", "TYPE", n);  
	return sIndex;
}

string GetItemResref(int n) {
 	string sIndex = Get2DAString("scod_craft_baseitems", "BASE_RESREF", n);  
	return sIndex;
}

int GetItemCost(int n) {
	int nIndex = StringToInt(Get2DAString("scod_craft_baseitems", "BASE_COST", n));  
	return nIndex;
}

int GetBaseID(int n) {
	int nIndex = StringToInt(Get2DAString("scod_craft_baseitems", "ID", n));  
	return nIndex;
}

string GetItemMatList(int n, int m) {
	string sColumn = "MATERIAL_"+IntToString(m);
 	string sIndex = Get2DAString("scod_craft_baseitems", sColumn, n);  
	return sIndex;
}

string GetItemIconKeyword(int n) {
 	string sIndex = Get2DAString("scod_craft_baseitems", "ICON_KEYWORD", n);  
	return sIndex;
}

struct baseitem LoadBaseItem(int n) {

	struct baseitem item;
	item.label = GetItemLabel(n);
	item.id = GetBaseID(n);
	item.type = GetItemType(n);
	item.resref = GetItemResref(n);
	item.cost = GetItemCost(n);
	item.matlist_1 = GetItemMatList(n, 1);
	item.matlist_2 = GetItemMatList(n, 2);
	item.matlist_3 = GetItemMatList(n, 3);
	item.icon = GetItemIconKeyword(n);
	return item;
	
}

int GetIsQuiver(int nTYPE) {
	if (nTYPE < 90) return FALSE;
	if (nTYPE > 95) return FALSE;
	return TRUE;
}

void GenerateItemIconList(object oPC, struct baseitem i) {

	ClearListBox(oPC, sCustomizationScreen, "SCOD_ICON_LIST");

	string sSubstring = i.icon;
	
	int index = 0;
	int max = GetNum2DARows("nwn2_icons");
	while (index < max) {
	
		string sLabel = Get2DAString("nwn2_icons", "ICON", index);
		if (FindSubString(sLabel, sSubstring) >= 0) {
			//ItemIcon
			AddListBoxRow(oPC, sCustomizationScreen, "SCOD_ICON_LIST", "ICUSTOMROW_"+IntToString(index), "", "ItemIcon="+sLabel+".tga;", "5=" + IntToString(index), "");
				
		}
		
		index++;	
		
	}
}

void GenerateBaseItemList(object oPC, string sType = "W") {

	int max = GetNum2DARows("scod_craft_baseitems");
	int index = 0;
	ClearListBox(oPC, sCraftingScreen, "SCOD_BASEITEM_LIST");
	while (index < max) {
	
		struct baseitem i = LoadBaseItem(index);
		if (i.type == sType) {
			string sName = i.label;
			AddListBoxRow(oPC, sCraftingScreen, "SCOD_BASEITEM_LIST", "CITEMROW_"+IntToString(index), "BaseItemName="+sName+";", "", "5="+IntToString(index), "");
		}
		
		index++;	
		
	}
}

void SetMaterialListHeader(object oPC, struct baseitem i, int nList) {

	string sTitle = "";
	string sMatList = "";
	if (nList == 1) {
		sMatList = i.matlist_1;
		if (sMatList == "SCOD_CRAFT_METAL") {
			sTitle = "Forged of:";
		} else if (sMatList == "SCOD_CRAFT_WOOD") {
			sTitle = "Carved of:";
		} else {
			sTitle = "Made of:";
		} 
	} else {
		if (nList == 2) {
			sMatList = i.matlist_2;
		} else {
			sMatList = i.matlist_3;
		}
		
		if (sMatList == "SCOD_CRAFT_METAL" && i.type == "A") {
			sTitle = "Studded with:";
		} else if (sMatList == "SCOD_CRAFT_METAL" && i.type == "W") {
			sTitle = "Shod with:";
		} else if (sMatList == "SCOD_CRAFT_METAL") {
			sTitle = "Plated with:";
		} else if (sMatList == "SCOD_CRAFT_WOOD" && i.type == "W") {
			sTitle = "With Shaft of:";
		} else if (sMatList == "SCOD_CRAFT_LEATHER" && i.type == "A") {
			sTitle = "With Shirt of:";
		}else {
			sTitle = "Inlayed with:";
		}
	}

	SetGUIObjectText(oPC, sCraftingScreen, "MATERIAL"+IntToString(nList)+"_HEADER", -1, sTitle);
}

void GenerateMaterial1List(object oPC, int item_index) {

	struct baseitem i = LoadBaseItem(item_index);
	string sMatList = i.matlist_1;
	
	//SetGUIObjectText
	
	//SendMessageToPC(oPC, "material list #1: "+sMatList);
	
	if (sMatList == "") {
		SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL1_HEADER", TRUE);
		SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL1_LIST", TRUE);
		return;
	} else {
		SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL1_HEADER", FALSE);
		SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL1_LIST", FALSE);
	}

	int max = GetNum2DARows(sMatList);
	int index = 0;
	ClearListBox(oPC, sCraftingScreen, "SCOD_MATERIAL1_LIST");
	while (index < max) {
	
		struct material m = LoadMaterial(index, sMatList);
		
		string sName = m.label;
		AddListBoxRow(oPC, sCraftingScreen, "SCOD_MATERIAL1_LIST", "CMAT1ROW_"+IntToString(index), "Material1Name="+sName+";", "", "5="+IntToString(index), "");

		index++;	
		
	}
	
	SetMaterialListHeader(oPC, i, 1);
}

void GenerateMaterial2List(object oPC, int item_index) {

	struct baseitem i = LoadBaseItem(item_index);
	string sMatList = i.matlist_2;
	
	//SendMessageToPC(oPC, "material list #2: "+sMatList);
	
	if (sMatList == "") {
		SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL2_HEADER", TRUE);
		SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL2_LIST", TRUE);
		return;
	} else {
		SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL2_HEADER", FALSE);
		SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL2_LIST", FALSE);
	}

	int max = GetNum2DARows(sMatList);
	int index = 0;
	ClearListBox(oPC, sCraftingScreen, "SCOD_MATERIAL2_LIST");
	while (index < max) {
	
		struct material m = LoadMaterial(index, sMatList);
		
		string sName = m.label;
		AddListBoxRow(oPC, sCraftingScreen, "SCOD_MATERIAL2_LIST", "CMAT2ROW_"+IntToString(index), "Material2Name="+sName+";", "", "5="+IntToString(index), "");

		index++;	
		
	}
	
	SetMaterialListHeader(oPC, i, 2);
}

void GenerateMaterial3List(object oPC, int item_index) {

	struct baseitem i = LoadBaseItem(item_index);
	string sMatList = i.matlist_3;
	
	//SendMessageToPC(oPC, "material list #3: "+sMatList);
	
	if (sMatList == "") {
		SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL3_HEADER", TRUE);
		SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL3_LIST", TRUE);
		return;
	} else {
		SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL3_HEADER", FALSE);
		SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL3_LIST", FALSE);
	}

	int max = GetNum2DARows(sMatList);
	int index = 0;
	ClearListBox(oPC, sCraftingScreen, "SCOD_MATERIAL3_LIST");
	while (index < max) {
	
		struct material m = LoadMaterial(index, sMatList);
		
		string sName = m.label;
		AddListBoxRow(oPC, sCraftingScreen, "SCOD_MATERIAL3_LIST", "CMAT3ROW_"+IntToString(index), "Material3Name="+sName+";", "", "5="+IntToString(index), "");

		index++;	
		
	}
	
	SetMaterialListHeader(oPC, i, 3);
}

string GetDRMaterialString(int nDR) {
	
	int nIndex = StringToInt(Get2DAString("iprp_materials", "NAME", nDR));  
	return GetStringByStrRef(nIndex);
	
}

int GetCraftingRankRequirement(struct baseitem i, struct material m1, struct material m2, struct material m3) {

	int nRank = m1.craftDC;
	
	if (m2.craftDC != 0)
		nRank += m2.costTier;
		
	if (m3.craftDC != 0)
		nRank += m3.costTier;
		
	if (nRank == 0)
		return 4;
	return nRank;
	
}

int GetRequiredCraftSkill(struct baseitem i) {
	if (i.type == "A" || i.type == "M") {
		return SKILL_CRAFT_ARMOR;
	} else {
		return SKILL_CRAFT_WEAPON;
	}
}

string GetCautionString(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {

	string sResult = "";
	itemproperty matPower = GetSpecialMaterialItemProperty(oPC, i, m1, m2, m3);
	if (GetItemPropertyType(matPower) == ITEM_PROPERTY_DAMAGE_BONUS) {
		if (GetItemPropertySubType(matPower) == IP_CONST_DAMAGETYPE_BLUDGEONING) {
			sResult = "Please note: Applying bludgeoning damage to a bludgeoning weapon will replace the base damage with the new damage.";
		} else if (GetItemPropertySubType(matPower) == IP_CONST_DAMAGETYPE_SLASHING) {
			sResult = "Please note: Applying slashing damage to a slashing weapon will replace the base damage with the new damage.";
		} else if (GetItemPropertySubType(matPower) == IP_CONST_DAMAGETYPE_PIERCING) {
			sResult = "Please note: Applying piercing damage to a piercing weapon will replace the base damage with the new damage.";
		}	
	} else if (GetItemPropertyType(matPower) == ITEM_PROPERTY_MASSIVE_CRITICALS && (GetIsQuiver(i.id) || i.id == BASE_ITEM_ARROW || i.id == BASE_ITEM_BOLT || i.id == BASE_ITEM_BULLET)) {
		sResult = "Please note: Massive Criticals can not be applied to ammunition.";
	} else if (m1.label == "Metalline"&& (GetIsQuiver(i.id) || i.id == BASE_ITEM_ARROW || i.id == BASE_ITEM_BOLT || i.id == BASE_ITEM_BULLET)) {
		sResult = "Please note: Ammunition cannot change material type. Metalline special property is useless on ammunition.";
	}
	
	return sResult;

} 

void GenerateCraftDetails(object oPC) {

	int nBase = GetLocalInt(oPC, "Craft_BaseItemType");
	int nMat1 = GetLocalInt(oPC, "Craft_Mat1");
	int nMat2 = GetLocalInt(oPC, "Craft_Mat2");
	int nMat3 = GetLocalInt(oPC, "Craft_Mat3");
	
	struct baseitem i = LoadBaseItem(nBase);
	struct material m1 = LoadMaterial(nMat1, i.matlist_1);
	struct material m2 = LoadMaterial(nMat2, i.matlist_2);
	struct material m3 = LoadMaterial(nMat3, i.matlist_3);
	
	string sCaution = GetCautionString(oPC, i, m1, m2, m3);
	
	string sText = "Base Item: "+i.label+"\n";
	if (nMat1 != 0)
		sText += "Made of "+m1.label;
	if (nMat2 != 0)
		sText += ", "+m2.label;
	if (nMat3 != 0)
		sText += ", and "+m3.label+"\n";
	sText += "\n";
	
	sText += "Cost: "+IntToString(GetCraftedItemCost(oPC, i, m1, m2, m3))+"gp\n";
	
	sText += "Skill Rank requirement: ";
	if (i.type == "A" || i.type == "M") {
		sText += "Craft Armor "+IntToString(GetCraftingRankRequirement(i, m1, m2, m3));
	} else {
		sText += "Craft Weapon "+IntToString(GetCraftingRankRequirement(i, m1, m2, m3));
	}
	
	sText += "\nRequired items: ";
	
	if (nMat1 != 0 && m1.rResref != "")
		sText += m1.label;
	if (nMat1 != 0 && m2.rResref != "")
		sText += ", "+m2.label;
	if (nMat1 != 0 && m2.rResref != "")
		sText += ", "+m3.label;
		
	sText += "\n\n";
	
	itemproperty matPower = GetSpecialMaterialItemProperty(oPC, i, m1, m2, m3);
	if (GetIsItemPropertyValid(matPower)) {
		sText += "<i>"+GetItemPropertyString(matPower)+"</i>\n";
		if (sCaution != "")
			sText += "<i><color=Red>"+sCaution+"</color></i>";
	}
	
	//Manually adding DR notes since they're on the items, not itemproperties
	if (i.type == "A") {
		if (m1.label == "Demonscale") {
			sText += "<i>Damage Reduction 5/Cold Iron or Good</i>";
		} else if (m1.label == "Devilscale") {
			sText += "<i>Damage Reduction 5/Silver or Good</i>";
		} else if (m1.label == "Celestial Plumes") {
			sText += "<i>Damage Reduction 5/Mithral or Evil</i>";
		} else if (m1.label == "Glassteel") {
			sText += "<i>Damage Reduction 5/Slashing or Bludgeoning</i>";
		} else if (m1.label == "Alchemic Platinum") {
			sText += "<i>Damage Reduction 5/Piercing or Slashing</i>";
		} else if (m1.label == "Riverine") {
			sText += "<i>Damage Reduction 5/Piercing or Bludgeoning</i>";
		} else if (m1.label == "Oerthblood") {
			sText += "<i>+3 to all Saves</i>";
		}
	}
	
	if (i.type == "W" && nMat1 != 0 && m1.drMaterial > 0) {
		sText += "Pierces DR as "+GetDRMaterialString(m1.drMaterial)+"\n";
	}
		
	SetGUIObjectText(oPC, sCraftingScreen, "CRAFTING_DETAILS_TEXT", -1, sText);
}

itemproperty GetSpecialMaterialItemProperty(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {
	struct enchantment enchant;
	if (GetIDRanged(i.id)) {
		enchant.type = m1.ipRangedType;
		enchant.subtype = m1.ipRangedSubType;
		enchant.numerical = m1.ipRangedParam;
	} else if (i.type == "W") {
		enchant.type = m1.ipMeleeType;
		enchant.subtype = m1.ipMeleeSubType;
		enchant.numerical = m1.ipMeleeParam;	
	} else if (i.type == "A") {
		enchant.type = m1.ipArmorType;
		enchant.subtype = m1.ipArmorSubType;
		enchant.numerical = m1.ipArmorParam;
	}
	//SendMessageToPC(oPC, "setting item ability: "+IntToString(enchant.type)+", "+IntToString(enchant.subtype)+", "+IntToString(enchant.numerical));
	itemproperty matPower = EnchantmentIndexToItemProp(enchant);
	return matPower;
}

object CreateCraftedItem(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {
	
	string toCreate = i.resref;
	if (i.type == "A" && m1.armorSuffix != "")
		toCreate += m1.armorSuffix;
		
	object oItem = CreateItemOnObject(toCreate, oPC);
	itemproperty ipMat1 = ItemPropertySpecialMaterial(m1.ipForgedOf);
	itemproperty ipMat2 = ItemPropertySpecialMaterial(m2.ipForgedOf);
	itemproperty ipMat3 = ItemPropertySpecialMaterial(m3.ipForgedOf);
	
	if (GetIsItemPropertyValid(ipMat1)) {
		IPSafeAddItemProperty(oItem, ipMat1);
		//SendMessageToPC(oPC, "material 1 added");
	} if (GetIsItemPropertyValid(ipMat2)) {
		IPSafeAddItemProperty(oItem, ipMat2);
		//SendMessageToPC(oPC, "material 2 added");
	} if (m3.ipForgedOf > 0 && GetIsItemPropertyValid(ipMat3)) {
		IPSafeAddItemProperty(oItem, ipMat3);
	}
		
	itemproperty matPower = GetSpecialMaterialItemProperty(oPC, i, m1, m2, m3);
	if (GetIsItemPropertyValid(matPower)) {
		//SendMessageToPC(oPC, "item property valid; adding");
		IPSafeAddItemProperty(oItem, matPower);
	}
	
	//Handle the metalline special script; does not apply to quivers
	if (m1.label == "Metalline" && GetIsQuiver(i.id) == FALSE)
		SetTag(oItem, "nw_metalline");
		
	if (m1.drMaterial > 0)
		SetItemBaseMaterialType(oItem, m1.drMaterial);
	else if (m2.drMaterial > 0 && i.type == "W" && i.matlist_1 == "SCOD_CRAFT_WOOD")
		SetItemBaseMaterialType(oItem, m2.drMaterial);
		
	return oItem;
}

int GetCraftedItemCost(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {
	
	int nGold = i.cost;
	int nMatCost1 = m1.costTier*1000;
	int nMatCost2 = (m2.costTier*1000)/2;
	int nMatCost3 = (m3.costTier*1000)/3;
	
	//Handles cost of Cold Iron and Alchemical Silver
	//Flat x2 base cost of item
	if (m1.costTier == 0 && m1.rResref != "") {
		nGold = nGold*2;
	} else {
		nGold = nGold+nMatCost1+nMatCost2+nMatCost3;
	}
	
	return nGold;
}

int GetHasRequiredCraftingItems(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {

	string sRequired1 = m1.rResref;
	string sRequired2 = m2.rResref;
	string sRequired3 = m3.rResref;
	
	object oItem; 
	
	if (sRequired1 != "" && GetItemPossessedBy(oPC, sRequired1) == OBJECT_INVALID) 
		return FALSE;
	if (sRequired2 != "" && GetItemPossessedBy(oPC, sRequired2) == OBJECT_INVALID) 
		return FALSE;
	if (sRequired3 != "" && GetItemPossessedBy(oPC, sRequired3) == OBJECT_INVALID) 
		return FALSE;
	
	return TRUE;

}

void TakeRequiredCraftingItems(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {

	string sTag;
	object oItem;
	
	sTag = m1.rResref;
	//SendMessageToPC(oPC, "required item: "+sTag);
	if (sTag != "") {
		oItem = GetItemPossessedBy(oPC, sTag);
		if (GetIsObjectValid(oItem))
			TakeNumCraftingMaterials(oPC, GetTag(oItem), 1);
	}
	
	sTag = m2.rResref;
	//SendMessageToPC(oPC, "required item: "+sTag);
	if (sTag != "") {
		oItem = GetItemPossessedBy(oPC, sTag);
		if (GetIsObjectValid(oItem))
			TakeNumCraftingMaterials(oPC, GetTag(oItem), 1);
	}
	
	sTag = m3.rResref;
	//SendMessageToPC(oPC, "required item: "+sTag);
	if (sTag != "") {
		oItem = GetItemPossessedBy(oPC, sTag);
		if (GetIsObjectValid(oItem))
			TakeNumCraftingMaterials(oPC, GetTag(oItem), 1);
	}

}

string GetCraftingItemName(struct baseitem i, struct material m1, struct material m2, struct material m3) {

	string sBase = i.label;
	string sMat1 = m1.label;
	if (sMat1 != "")
		sBase = sMat1+" "+sBase;
		
	return sBase;
}

string GetCraftingNameDescription(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {

	string sBase = i.label;
	string sMat1 = m1.label;
	if (sMat1 != "")
		sBase = "A "+sMat1+" "+sBase;

	if (m2.label != "") {
		if (i.matlist_2 == "SCOD_CRAFT_METAL" && i.type == "A")
			sBase += ", Studded with "+m2.label;
		else if (i.matlist_2 == "SCOD_CRAFT_METAL" && i.type == "W")
			sBase += ", Shod with "+m2.label;
		else if (i.matlist_2 == "SCOD_CRAFT_METAL")
			sBase += ", Plated with "+m2.label;
		else if (i.matlist_2 == "SCOD_CRAFT_WOOD" && i.type == "W")
			sBase += ", with Shaft of "+m2.label;
		else if (i.matlist_2 == "SCOD_CRAFT_LEATHER" && i.type == "A")
			sBase += ", with Shirt of "+m2.label;
		else if (m2.label != "None")
			sBase += ", Inlayed with "+m2.label;
	}
	
	if (m3.label != "" && m3.label != "None")
		sBase += " and "+m3.label;
		
	sBase += ".\n\n";
	sBase += "Crafted by "+GetFirstName(oPC)+" "+GetLastName(oPC);
	
	return sBase;
		
}

int GetIDRanged(int nId) {
	
	if((nId == BASE_ITEM_LONGBOW) ||
      (nId == BASE_ITEM_HEAVYCROSSBOW) ||
      (nId == BASE_ITEM_LIGHTCROSSBOW) ||
      (nId == BASE_ITEM_SHORTBOW) ||
      (nId == BASE_ITEM_SLING))
	  	return TRUE;
		
	return FALSE;
}

int GetCostTierOfMaterial(itemproperty iProp) {

	int iType = GetItemPropertyType(iProp);
	int iSub = GetItemPropertySubType(iProp);
	int iParam = GetItemPropertyCostTableValue(iProp);
	int iSpecial = GetItemPropertyParam1Value(iProp);
	
	if (iType != 100)
		return 0;
		
	string sMatName = Get2DAString("iprp_specialmat", "Label", iSub);  
	
	string s2da = "scod_craft_metal";
	int nMax = GetNum2DARows(s2da);
	int n = 0;
	for (n = 0; n < nMax; n++) {
		string sName =  Get2DAString(s2da, "LABEL", n);
		if (sName == sMatName) 
			return GetMCostTier(n, s2da);
	}
	
	s2da = "scod_craft_leather";
	nMax = GetNum2DARows(s2da);
	for (n = 0; n < nMax; n++) {
		string sName =  Get2DAString(s2da, "LABEL", n);
		if (sName == sMatName) 
			return GetMCostTier(n, s2da);
	}
	
	s2da = "scod_craft_wood";
	nMax = GetNum2DARows(s2da);
	for (n = 0; n < nMax; n++) {
		string sName =  Get2DAString(s2da, "LABEL", n);
		if (sName == sMatName) 
			return GetMCostTier(n, s2da);
	}
	
	s2da = "scod_craft_misc";
	nMax = GetNum2DARows(s2da);
	for (n = 0; n < nMax; n++) {
		string sName =  Get2DAString(s2da, "LABEL", n);
		if (sName == sMatName) 
			return GetMCostTier(n, s2da);
	}
	
	return 0;

}

int GetBaseCostOfItem(int nBaseID) {
	
	int n;
	int	nMax = GetNum2DARows("scod_craft_baseitems");
	for (n = 0; n < nMax; n++) {
		string sID =  Get2DAString("scod_craft_baseitems", "ID", n);
		if (StringToInt(sID) == nBaseID) {
			string sCost = Get2DAString("scod_craft_baseitems", "BASE_COST", n);
			return StringToInt(sCost);
		}
	}
	
	return 0;

}