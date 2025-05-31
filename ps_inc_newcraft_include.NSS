#include "x2_inc_itemprop"
#include "ps_inc_itemprops"
#include "ps_inc_gemstones"
#include "x2_inc_itemprop"
#include "nw_i0_plot"
#include "ps_inc_faction"
#include "ps_inc_functions"
#include "x0_i0_match"
#include "nwnx_sql"
#include "ps_inc_casterlevel"

const string xmlCraftingFile = "scod_crafting_window.xml";
const string sCraftingScreen = "SCOD_CRAFTING";
const string xmlCustomizationFile = "scod_icustom_window.xml";
const string sCustomizationScreen = "SCOD_ITEM_CUSTOMIZATION";
const float ENCHANTING_DISTANCE = 5.0f;

// readability constants
const int SYN_DEF_ATTACK = 1;
const int SYN_DEF_DAMAGE = 2;
const int SYN_DEF_EB = 3;

//************************************************
//Structure to hold enchantment values
//************************************************
struct enchantment {
	int id;
	int type;
	int subtype;
	int numerical;
	int special;
	int points;
	int gold;
	string essence;
	string add_essence; // characters enchanting through alchemy may need additional power essence 
	string gemstone;
	string special_req;
};

struct synergyBonus{
	int nPoints;
	itemproperty ip;
};
struct synergyBonus GetItemMaterialSynergyBonus(object oItem);


struct xbowMechanicals{
	itemproperty ipReload;
	itemproperty ipAim;
};
struct xbowMechanicals GetXbowMechanicals(object oItem);

struct dMatProp{
	itemproperty ip;
	int points;
};
struct dMatProp GetMatPowerFromItem(object oItem);

int GetIsPlayerMade(object oItem);
int GetBaseMaterialOfType(object oItem, string sMat2da);
string SearchValIn2da(string s2da, string sMatchColumn, string sMatchVal, string sFromColumn = "");
int GetWorkbenchInRange(object oPC, object oBench);
object GetNearestEnchantingWorkbench(object oPC);
object GetNearestSmithingWorkbench(object oPC);
itemproperty IpArgsToItemProperty(int nType, int nSub, int nParam, int nSpecial);


int GetArmorBaseMaterial(object oItem);

// WIP returns the iprp_specialmat index of the faction-craft itemproperty if the item
// is one associated with the faction of the player. Called in ps_inc_newcrafting to apply
// the itemproperty on item creation and in ps_inc_newenchanting to give a 10% discount
// to enchantments performed on the item. Returns 0 if either the player is not a member
// of a currently active faction of if the item is not associated with their faction.
// Edit this function to change item associations.
//int GetFactionItemAssociation(object oPC, object oItem);

// finds the bonus feat improved critical for launchers and thrown weapons to
// replace keen.
itemproperty GetImpCritItemPropertyForRanged(int nItem);

//Generates the list in the gui of possible
//materials to craft with
//any given base item can have 1-3 material slots
//item_index = base item type index, nList = the material slot
void GenerateMaterialList(object oPC, int item_index, int nList);

//Converts between type/subtype/param/special and the actual property
itemproperty EnchantmentIndexToItemProp(struct enchantment enchant);

//Get whether this Made Of material is powerful enough to give an extra point
// accepts the subtype of property type 100
int GetIsPowerfulMaterial(int nSubType);

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

//Gets the item property for this item + special material combination
itemproperty GetSpecialMaterialItemProperty(struct baseitem i, struct material m1);

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

//Get the cost of the material from the 2da by looking up the item prop
int GetCostTierOfMaterial(itemproperty iProp);

// get the column of scodenchantments for an item
string GetItemColumn(int nType);

// simple 2da val retrieval from scodenchantments
int GetTypeIndex(int index, int bUseLegacy = FALSE);
int GetSubTypeIndex(int index, int bUseLegacy = FALSE);
int GetParamIndex(int index, int bUseLegacy = FALSE);
int GetGoldCost(int index, int bUseLegacy = FALSE);
int GetPointValue(int index, int bUseLegacy = FALSE);
int GetSpecialIndex(int index, int bUseLegacy = FALSE);
string GetGemRequirement(int index, int bUseLegacy = FALSE);
string GetEssenceRequirement(int index, int bUseLegacy = FALSE);


//************************************************
//Structure to hold base item information
//from scod_craft_baseitems
//************************************************
struct baseitem {
	int index;
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
	int index;
	string label;
	string rResref;
	int costTier;
	int craftDC;
	int ipForgedOf;
	int ipMeleeType;
	int ipMeleeSubType;
	int ipMeleeParam;
	int ipMeleeSpecial;
	int drMaterial;
	int ipArmorType;
	int ipArmorSubType;
	int ipArmorParam;
	int ipArmorSpecial;
	string armorSuffix;
	int ipRangedType;
	int ipRangedSubType;
	int ipRangedParam;
	int ipRangedSpecial;
};
/*  WIP
// note: if we're going to include consumable might be better to move this to ps_inc_faction
int GetFactionItemAssociation(object oPC, object oItem){

	int nFaction = GetFaction(oPC);
	// first weed out non-faction members. Easiest way would be to return 0 if
	// nFaction is an old faction or non-faction, but for error catching purposes
	// we'll validate the 15 known factions and weed out any other return value
	switch (nFaction){
		case FACTION_FREE_LEAGUE: case FACTION_ATHAR: case FACTION_BELIEVERS_OF_THE_SOURCE:
		case FACTION_BLEAK_CABAL: case FACTION_DOOMGUARD: case FACTION_DUSTMEN:
		case FACTION_FATED: case FACTION_FRATERNITY_OF_ORDER: case FACTION_HARMONIUM:
		case FACTION_MERCYKILLERS: case FACTION_SIGN_OF_ONE: case FACTION_SOCIETY_OF_SENSATION:
		case FACTION_TRASCENDENT_ORDER: case FACTION_XAOSITECTS: case FACTION_RINGGIVERS:
		break;
		default: nFaction = 0;
	}
	if (nFaction == 0) return 0;
	
	
}
*/


// Returns the iprp_specialmat line that matches the basic material type defined
// by the material 2da. sMat2da must be "scod_craft_metal", "scod_craft_leather", 
// "scod_craft_wood", or "scod_craft_misc"
int GetBaseMaterialOfType(object oItem, string sMat2da){
	itemproperty ip = GetFirstItemProperty(oItem);
	int nSub;
	while (GetIsItemPropertyValid(ip)){
		if (GetItemPropertyType(ip) == 100){
			nSub = GetItemPropertySubType(ip);
			if (Get2DAString("iprp_specialmat", "Mat_2da", nSub) == sMat2da)
				return nSub;
		}
		ip = GetNextItemProperty(oItem);
	}
	return NULL;
}


string SearchValIn2da(string s2da, string sMatchColumn, string sMatchVal, string sFromColumn = ""){
	int nRows = GetNum2DARows(s2da);
	int i;
	string sFoundVal;
	for (i = 0; i <= nRows; i++){
		sFoundVal = Get2DAString(s2da, sMatchColumn, i);
		if (sFoundVal == sMatchVal){
			if (sFromColumn == "") return IntToString(i);
			else return Get2DAString(s2da, sFromColumn, i);
		}
	}
	return "****";
}

struct dMatProp GetMatPowerFromItem(object oItem){
	int nItem = GetBaseItemType(oItem);

	// We'll set an intial item property of 50% weight reduction because in our system that 
	// property costs 0 points.
	struct dMatProp data;
	data.ip = ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_50_PERCENT);
	data.points = 0;
	
	// non=player-made items don't have material powers, so return default values
	if (!GetIsPlayerMade(oItem)) return data;
	
	string sLookupColumn = "ID";
	int nLookupValue = nItem;
	
	// if it's an armor then we look it up by armorstat rule
	if (nItem == 16){
		sLookupColumn = "ARMORSTAT_ID";
		nLookupValue = GetArmorRulesType(oItem);
		if (nLookupValue >= 42) sLookupColumn = "MITH_ARMORSTAT_ID"; // crafted mithral
	} else {
		switch(nItem){
			case 90: nLookupValue = 31; break; // dart quiver to dart
			case 91: nLookupValue = 63; break; // throwing axe quiver to taxe
			case 92: nLookupValue = 59; break; // shuriken quiver to shuriken
			case 93: nLookupValue = 20; break; // arrow quiver to arrow
			case 94: nLookupValue = 25; break; // bolt quiver to bolt
			case 95: nLookupValue = 27; break; // bullet quiver to bullet
			case 111: nLookupValue = 202; break; // there are 2 whip ids, this 2da uses 202
			default: nLookupValue = nItem; break;
		}
	}
	
	string sBaseItemsRow = SearchValIn2da("scod_craft_baseitems", sLookupColumn, IntToString(nLookupValue));
	if (sBaseItemsRow == "****") return data;
	
	int nBaseItemsRow = StringToInt(sBaseItemsRow);
	
	string sType = Get2DAString("scod_craft_baseitems", "TYPE", nBaseItemsRow);
	int bIsMeleeGlove = (nItem == BASE_ITEM_GLOVES && CRAFTED_GLOVES_GET_MAT_POWER);
	if (sType == "M" && !bIsMeleeGlove) return data; // misc items don't have material powers unless they're gloves
	
	string sCat = "";
	if (sType == "A") sCat = "armor";
	else if (sType == "W"){
		if (nItem == BASE_ITEM_SLING || nItem == BASE_ITEM_SHORTBOW || 
				nItem == BASE_ITEM_LONGBOW || nItem == BASE_ITEM_LIGHTCROSSBOW ||
				nItem == BASE_ITEM_HEAVYCROSSBOW) sCat = "ranged";
		else sCat = "melee"; // thrown weapons get same material powers as melee
	}
	
	if (sCat == "") return data;
	
	// get the 2da that corresponds to the base material from which the item is crafted
	// so that we can look up the material power from that 2da
	string sMat2da = Get2DAString("scod_craft_baseitems", "MATERIAL_1", nBaseItemsRow);
	sMat2da = GetStringLowerCase(sMat2da);
	
	int nMat = NULL;
	// check for non-metal melee weapons that have metalline as their metal component
	// if they do, then they get metalline's property instead
	if (sCat == "melee" && sMat2da != "scod_craft_metal"){
		if (GetBaseMaterialOfType(oItem, "scod_craft_metal") == SPECIAL_MAT_METALLINE){
			data.ip = IpArgsToItemProperty(15, 335, 13, 0);
			data.points = 1;
			return data;
		}
	}
	
	nMat = GetBaseMaterialOfType(oItem, sMat2da);
	
	if (nMat == NULL) return data;
	
	string sMatRow = SearchValIn2da(sMat2da, "IP_DESCRIPTION_ID", IntToString(nMat));
	if (sMatRow == "****") return data;
	
	int nMatRow = StringToInt(sMatRow);
	
	string sTypeColumn = "IP_MELEE_TYPE";
	string sSubColumn = "IP_MELEE_SUBTYPE";
	string sParamColumn = "IP_MELEE_PARAM";
	string sSpecColumn = "IP_M_SPECIAL";
	string sPointsColumn = "M_POINTS";
	
	if (sCat == "armor"){
		sTypeColumn = "IP_ARMOR_TYPE";
		sSubColumn = "IP_ARMOR_SUBTYPE";
		sParamColumn = "IP_ARMOR_PARAM";
		sSpecColumn = "IP_A_SPECIAL";
		sPointsColumn = "A_POINTS";
	} else if (sCat == "ranged"){
		sTypeColumn = "IP_RANGED_TYPE";
		sSubColumn = "IP_RANGED_SUBTYPE";
		sParamColumn = "IP_RANGED_PARAM";
		sSpecColumn = "IP_R_SPECIAL";
		sPointsColumn = "R_POINTS";	
	}
	int nType = StringToInt(Get2DAString(sMat2da, sTypeColumn, nMatRow));
	
	// if it's a ranged weapon or glove whose mat power is keen, it gets bonus feature
	// improved crit instead. If it's ammo whose mat power is keen, it gets nothing.
	if (nType == 43){
		// ammo cannot get keen so we return
		if (IPGetIsProjectile(OBJECT_INVALID, nItem)) return data;
		
		if (IPGetIsThrownWeapon(OBJECT_INVALID, nItem) ||
			IPGetIsLauncher(OBJECT_INVALID, nItem)){
				data.ip = GetImpCritItemPropertyForRanged(nItem);
		} else if (nItem == BASE_ITEM_GLOVES){
			if (!CRAFTED_GLOVES_GET_MAT_POWER) return data;
			else data.ip = ItemPropertyBonusFeat(20); // imp crit unarmed
		} else data.ip = ItemPropertyKeen();

		data.points = 1;
		return data;
	}
	
	int nSub = StringToInt(Get2DAString(sMat2da, sSubColumn, nMatRow));
	int nParam = StringToInt(Get2DAString(sMat2da, sParamColumn, nMatRow));
	int nSpecial = StringToInt(Get2DAString(sMat2da, sSpecColumn, nMatRow));
	
	data.points = StringToInt(Get2DAString(sMat2da, sPointsColumn, nMatRow));
	data.ip = IpArgsToItemProperty(nType, nSub, nParam, nSpecial);
	
	return data;
}

int GetWorkbenchInRange(object oPC, object oBench){
	if(GetIsObjectValid(oBench)) 
	{
		//if(LineOfSightObject(oPC, oBench)) {
			if(GetDistanceBetween(oPC, oBench) <= ENCHANTING_DISTANCE)
			{
				return TRUE;
			}
		/*} else {
			SendMessageToPC(oPC, "There must be no obstructions between you and the workbench.");
		}*/
	}
	return FALSE;
}

//Get the nearest enchanting Workbench
object GetNearestEnchantingWorkbench(object oPC){
	object oBench = GetNearestObjectByTag("PLC_MR_MWBench", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("PLC_MC_CBENCH03", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("ps_usersign_magetable", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("nx2_mage_bench", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;
	return OBJECT_INVALID;
}

// get nearest smithing Workbench
object GetNearestSmithingWorkbench(object oPC){
	object oBench = GetNearestObjectByTag("ps_usersign_smithtable", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("ps_sigil_forge", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;	
	oBench = GetNearestObjectByTag("ps_usersign_faction_godswbench", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;	
	oBench = GetNearestObjectByTag("ps_usersign_faction_doomgwbench", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("PLC_MC_WBENCH01", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("PLC_MR_WWBench", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("PLC_MC_CBENCH02", oPC);
	if (GetWorkbenchInRange(oPC, oBench)) 
		return oBench;
	return OBJECT_INVALID;
}

struct xbowMechanicals GetXbowMechanicals(object oItem){
	struct xbowMechanicals dXbow;
	int nItem = GetBaseItemType(oItem);
	if (nItem != BASE_ITEM_HEAVYCROSSBOW && nItem != BASE_ITEM_LIGHTCROSSBOW)
		return dXbow;
	int bFoundLever = FALSE;
	int bFoundSight = FALSE;
	int nSubType;
	itemproperty ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip)){
		if (GetItemPropertyType(ip) == 100){
			nSubType = GetItemPropertySubType(ip);
			if (nSubType == SPECIAL_MAT_XBOW_LEVER) bFoundLever = TRUE;
			else if (nSubType == SPECIAL_MAT_XBOW_SIGHT) bFoundSight = TRUE;
		}
		if (bFoundLever && bFoundSight) break;
		ip = GetNextItemProperty(oItem);
	}
	if (!bFoundLever && !bFoundSight) return dXbow;
	
	if (bFoundLever) dXbow.ipReload = ItemPropertyBonusFeat(89);
	if (bFoundSight){
		int nFeat = StringToInt(Get2DAString("baseitems", "FEATWpnFocus", nItem));
		int nIprp = PS_GetIpBonusFeat(nFeat);
		dXbow.ipAim = ItemPropertyBonusFeat(nIprp);
	}
	return dXbow;	
}

struct synergyBonus GetItemMaterialSynergyBonus(object oItem){
	
	struct synergyBonus dSynergy;
	dSynergy.nPoints = 0;
	
	int nItem = GetBaseItemType(oItem);
	int bCheckForAC = FALSE;
	int nSynergyType = -1;
	// get the type of item we're applying a bonus to, or return an empty itemproperty if
	// not the type of item that gets a bonus.
	if (IPGetIsLauncher(OBJECT_INVALID, nItem)){
		if (SYN_TYPE_FOR_BOWS == SYN_DEF_ATTACK || SYN_TYPE_FOR_BOWS == SYN_DEF_DAMAGE || 
			SYN_TYPE_FOR_BOWS == SYN_DEF_EB) nSynergyType = SYN_TYPE_FOR_BOWS;
	} else if (IPGetIsMeleeWeapon(OBJECT_INVALID, nItem) || IPGetIsThrownWeapon(OBJECT_INVALID, nItem) ||
		(nItem == BASE_ITEM_GLOVES && CRAFTED_GLOVES_GET_MAT_POWER)){
		if (SYN_TYPE_FOR_MELEE_AND_THROWN == SYN_DEF_ATTACK || SYN_TYPE_FOR_MELEE_AND_THROWN == SYN_DEF_DAMAGE ||
			SYN_TYPE_FOR_MELEE_AND_THROWN == SYN_DEF_EB) nSynergyType = SYN_TYPE_FOR_MELEE_AND_THROWN;
	} else if (IPGetIsProjectile(OBJECT_INVALID, nItem)){
		if (SYN_FOR_PROJECTILES) nSynergyType = SYN_DEF_DAMAGE;
	} else if (SYN_AC_FOR_ARMOR && nItem == BASE_ITEM_ARMOR){
		bCheckForAC = TRUE;
	} else if (SYN_AC_FOR_SHIELDS){
		if (nItem == BASE_ITEM_SMALLSHIELD || nItem == BASE_ITEM_LARGESHIELD || nItem == BASE_ITEM_TOWERSHIELD)
			bCheckForAC = TRUE;
	} else return dSynergy;
	
	if (!bCheckForAC && nSynergyType == -1) return dSynergy;

	int nIpSub;
	int vsDragon = 0;
	int vsElemental = 0;
	int vsFey = 0; 
	int vsGoblin = 0; 
	int vsOutsider = 0; 
	int vsUndead = 0; 
	int vsShapeshifter = 0;
	itemproperty ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip)){
		if (GetItemPropertyType(ip) == 100){
			nIpSub = GetItemPropertySubType(ip);
			switch (nIpSub){ 
				case SPECIAL_MAT_DEMON_SCALE: case SPECIAL_MAT_DEVIL_SCALE: 
				case SPECIAL_MAT_FIENDISH_IVORY: case SPECIAL_MAT_DEMON_HORN: 
				case SPECIAL_MAT_DEVIL_HORN:{
					vsOutsider += 1;
					break;
				}
				case SPECIAL_MAT_DRAGON_BONE: case SPECIAL_MAT_DHIDE_BLACK:
				case SPECIAL_MAT_DHIDE_BLUE: case SPECIAL_MAT_DHIDE_GREEN:
				case SPECIAL_MAT_DHIDE_RED: case SPECIAL_MAT_DHIDE_WHITE:
				case SPECIAL_MAT_DRAGON_SINEW:{
					vsDragon += 1;
					break;
				}
				case SPECIAL_MAT_CHIMERA_HIDE: case SPECIAL_MAT_ROWANWOOD:
				case SPECIAL_MAT_MOON_PEARL:{
					vsGoblin += 1;
					break;
				}
				case SPECIAL_MAT_IRONWOOD: case SPECIAL_MAT_MANTICORE_HIDE:
				case SPECIAL_MAT_PYRITE:{
					vsFey += 1;
					break;
				}
				case SPECIAL_MAT_CELESTIAL_PLUMES: case SPECIAL_MAT_ARBOREAL_OAK:
				case SPECIAL_MAT_MERCURIAN_ROSE:{
					vsUndead += 1;
					break;
				}
				case SPECIAL_MAT_FORMIC_AMBER: case SPECIAL_MAT_REGULAN_GEARSPRING:
				case SPECIAL_MAT_NEUMANNIC_FLYWHEEL: case SPECIAL_MAT_FLESH_GOLEM_HIDE:{
					vsElemental += 1;
					break;
				}
				case SPECIAL_MAT_OPHIDIAN: case SPECIAL_MAT_DUSKWOOD:
				case SPECIAL_MAT_SILVER_REG:{
					vsShapeshifter += 1;
					break;
				}
			}	
		}
		ip = GetNextItemProperty(oItem);
	}
	
	int nRace = -1;
	if (vsDragon >= 2) nRace = IP_CONST_RACIALTYPE_DRAGON;
	else if (vsElemental >= 2) nRace = IP_CONST_RACIALTYPE_ELEMENTAL;
	else if (vsFey >= 2) nRace = IP_CONST_RACIALTYPE_FEY;
	else if (vsGoblin >= 2) nRace = IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID;
	else if (vsOutsider >= 2) nRace = IP_CONST_RACIALTYPE_OUTSIDER;
	else if (vsUndead >= 2) nRace = IP_CONST_RACIALTYPE_UNDEAD;
	else if (vsShapeshifter >= 2) nRace = IP_CONST_RACIALTYPE_SHAPECHANGER;
	
	if (nRace == -1) return dSynergy;
	else {
		int nPoints = 0;
		if (bCheckForAC){
			nPoints = SYN_AC_POINTS;
			int nAC = SYN_AC_NUMERICAL;
			if (nAC < 1) nAC = 1;
			else if (nAC > 20) nAC = 20;
			dSynergy.ip = ItemPropertyACBonusVsRace(nRace, nAC);
		}else if (nSynergyType == SYN_DEF_ATTACK){
			nPoints = SYN_ATTACK_POINTS;
			int nAT = SYN_ATTACK_NUMERICAL;
			if (nAT < 1) nAT = 1;
			else if (nAT > 20) nAT = 20;
			dSynergy.ip = ItemPropertyAttackBonusVsRace(nRace, nAT);
		} else if (nSynergyType == SYN_DEF_DAMAGE){
			nPoints = SYN_DAM_POINTS;
			int nDam = SYN_DAM_NUMERICAL;
			if (nDam < 1) nDam = 1;
			else if (nDam > 20 && nDam < 51) nDam = 20;
			else if (nDam > 61) nDam = 61;
			dSynergy.ip = ItemPropertyDamageBonusVsRace(nRace, 5, nDam);
		} else if (nSynergyType == SYN_DEF_EB){
			nPoints = SYN_EB_POINTS;
			int nEB = SYN_EB_NUMERICAL;
			if (nEB < 1) nEB = 1;
			else if (nEB > 20) nEB = 20;
			dSynergy.ip = ItemPropertyEnhancementBonusVsRace(nRace, nEB);
		}
		if (nPoints < 0) nPoints = 0;
		else if (nPoints > 6) nPoints = 6;
		dSynergy.nPoints = nPoints;
	}
	return dSynergy;
}

//Get whether this subtype is powerful enough to give an extra point
int GetIsPowerfulMaterial(int nSubType){
	// There used to be a special boolean for whether or not to grant a point
	// for silver and cold-iron, but if someone is going to spend the extra $ 
	// they ought to get a point. So now everything but copper, iron, basic leather, 
	// and basic wood gives a point. Also we're fetching from 2da instead of using
	// using code
	if (Get2DAString("iprp_specialmat", "Powerful_Mat", nSubType) == "1") return TRUE;
	
	return FALSE;
}

string GetItemColumn(int nType){
	string sColumn = "";
	if (IPGetIsMeleeWeapon(OBJECT_INVALID, nType)) sColumn = "0_Melee";
	else if (IPGetIsLauncher(OBJECT_INVALID, nType)) sColumn = "1_Ranged";
	else if (IPGetIsProjectile(OBJECT_INVALID, nType)) sColumn = "2_Ammo";
	else if (IPGetIsThrownWeapon(OBJECT_INVALID, nType)) sColumn = "3_Thrown";
	else if (IPGetIsInstrument(OBJECT_INVALID, nType)) sColumn = "14_Instrument";
	else switch (nType){
		case BASE_ITEM_SMALLSHIELD: case BASE_ITEM_LARGESHIELD:
		case BASE_ITEM_TOWERSHIELD: case BASE_ITEM_ARMOR: sColumn = "4_Armor"; break;
		case BASE_ITEM_GLOVES: sColumn = "5_Glove"; break;
		case BASE_ITEM_BRACER: sColumn = "6_Bracer"; break;
		case BASE_ITEM_HELMET: sColumn = "7_Helm"; break;
		case BASE_ITEM_AMULET: sColumn = "8_Amulet"; break;
		case BASE_ITEM_RING: sColumn = "9_Ring"; break;
		case BASE_ITEM_BOOTS: sColumn = "10_Boots"; break;
		case BASE_ITEM_BELT: sColumn = "11_Belt"; break;
		case BASE_ITEM_CLOAK: sColumn = "12_Cloak"; break;
		case BASE_ITEM_LARGEBOX: sColumn = "13_Container"; break;
		default: sColumn = "15_Misc"; break;
	}
	return sColumn;
}

//Get Index from 2da
int GetTypeIndex(int index, int bUseLegacy = FALSE){
	string s2da = "scodenchantments";
	if (bUseLegacy) s2da = "store_item_enchants";
	int nIndex = StringToInt(Get2DAString(s2da, "Type", index));  
	return nIndex;
}

//Get Subtype Index from 2da
int GetSubTypeIndex(int index, int bUseLegacy = FALSE){
	string s2da = "scodenchantments";
	if (bUseLegacy) s2da = "store_item_enchants";
	int nIndex = StringToInt(Get2DAString(s2da, "Subtype", index));  
	return nIndex;
}

//Get Numerical index from 2da
int GetParamIndex(int index, int bUseLegacy = FALSE){
	string s2da = "scodenchantments";
	if (bUseLegacy) s2da = "store_item_enchants";
	int nIndex = StringToInt(Get2DAString(s2da, "Numerical", index));  
	return nIndex;
}

//Get Gold cost from 2da
int GetGoldCost(int index, int bUseLegacy = FALSE){
	object oPC = OBJECT_SELF;
	if (GetIsCraftingFree(oPC)) return 0;
	string s2da = "scodenchantments";
	if (bUseLegacy) s2da = "store_item_enchants";
	int nGold = StringToInt(Get2DAString(s2da, "Gold", index));
		// 10% discount for craft magic arms and armor, since psi and lock get imbue for free
	if (GetHasFeat(FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR, oPC, TRUE)){
		if (nGold >= 10){
			float fGold = IntToFloat(nGold);
			fGold = fGold * 0.9f;
			nGold = FloatToInt(fGold);
		}
	}
	return nGold;
}

//Get Point value from 2da
int GetPointValue(int index, int bUseLegacy = FALSE){
	string s2da = "scodenchantments";
	if (bUseLegacy) s2da = "store_item_enchants";
	return StringToInt(Get2DAString(s2da, "Points", index));  
}

//Get Special index cost from 2da
int GetSpecialIndex(int index, int bUseLegacy = FALSE){
	string s2da = "scodenchantments";
	if (bUseLegacy) s2da = "store_item_enchants";
	return StringToInt(Get2DAString(s2da, "Special", index));  
}

//Get Gem requirement from 2da
string GetGemRequirement(int index, int bUseLegacy = FALSE){
	object oPC = OBJECT_SELF;
	if (GetIsCraftingFree(oPC)) return "";
	string s2da = "scodenchantments";
	if (bUseLegacy) s2da = "store_item_enchants";
	return Get2DAString(s2da, "Gemstone", index);  

}

//Get essence requirement from 2da
string GetEssenceRequirement(int index, int bUseLegacy = FALSE){
	object oPC = OBJECT_SELF;
	if (GetIsCraftingFree(oPC)) return "";
	string s2da = "scodenchantments";
	if (bUseLegacy) s2da = "store_item_enchants";
	return Get2DAString(s2da, "Essence", index);  

}

int GetArmorBaseMaterial(object oItem){
	if (GetBaseItemType(oItem) != 16) return NULL;
	int nRuleType = GetArmorRulesType(oItem);
	string s2da;
	if (nRuleType <= 3 || nRuleType == 12) s2da = "scod_craft_leather";
	else s2da = "scod_craft_metal";
	
	int nSub;
	int i;
	int nNumRows = GetNum2DARows(s2da);
	itemproperty ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip)){
		if (GetItemPropertyType(ip) == 100){
			nSub = GetItemPropertySubType(ip);
			for (i = 0; i < nNumRows; i++){
				if (StringToInt(Get2DAString(s2da, "IP_DESCRIPTION_ID", i)) == nSub)
					return nSub;
			}
		}
		ip = GetNextItemProperty(oItem);
	}
	return NULL;
}

itemproperty IpArgsToItemProperty(int nType, int nSub, int nParam, int nSpecial){
	switch(nType) {
		case 0: return ItemPropertyAbilityBonus(nSub, nParam);
		case 1: return ItemPropertyACBonus(nParam);
		case 2: return ItemPropertyACBonusVsAlign(nSub, nParam);
		case 3: return ItemPropertyACBonusVsDmgType(nSub, nParam);
		case 4: return ItemPropertyACBonusVsRace(nSub, nParam);
		case 5: return ItemPropertyACBonusVsAlign(nSub, nParam);
	 	case 6: return ItemPropertyEnhancementBonus(nParam);
		case 7: return ItemPropertyEnhancementBonusVsAlign(nSub, nParam);
		case 8: return ItemPropertyEnhancementBonusVsRace(nSub, nParam);
		case 9: return ItemPropertyEnhancementBonusVsSAlign(nSub, nParam);
	 	case 10: return ItemPropertyAttackPenalty(nParam);
	 	case 11: return ItemPropertyWeightReduction(nParam);
		case 12: return ItemPropertyBonusFeat(nSub);
		case 13: return ItemPropertyBonusLevelSpell(nSub, nParam);
		case 15: return ItemPropertyCastSpell(nSub, nParam);
		case 16: return ItemPropertyDamageBonus(nSub, nParam);
		case 17: return ItemPropertyDamageBonusVsAlign(nSub, IP_CONST_DAMAGETYPE_MAGICAL, nParam);
		case 18: return ItemPropertyDamageBonusVsRace(nSub, IP_CONST_DAMAGETYPE_MAGICAL, nParam);
		case 19: return ItemPropertyDamageBonusVsSAlign(nSub, IP_CONST_DAMAGETYPE_MAGICAL, nParam);
		case 20: return ItemPropertyDamageImmunity(nSub, nParam);
		case 21: return ItemPropertyDamagePenalty(nParam);
		case 22: return ItemPropertyDamageReduction(nParam, nSub);
		case 23: return ItemPropertyDamageResistance(nSub, nParam);
		case 24: return ItemPropertyDamageVulnerability(nSub, nParam);
		case 26: return ItemPropertyBonusFeat(438); // IpDarkvision bugged, use bonus feat
		case 27: return ItemPropertyDecreaseAbility(nSub, nParam);
		case 28: return ItemPropertyDecreaseAC(nSub, nParam);
		case 29: return ItemPropertyDecreaseSkill(nSub, nParam);
		case 32: return ItemPropertyContainerReducedWeight(nParam);
		case 35: return ItemPropertyHaste();
		case 36: return ItemPropertyHolyAvenger();
		case 37: return ItemPropertyImmunityMisc(nSub);
		case 38: return ItemPropertyImprovedEvasion();
		case 39: return ItemPropertyBonusSpellResistance(nParam);
		case 40: return ItemPropertyBonusSavingThrowVsX(nSub, nParam);
		case 41: return ItemPropertyBonusSavingThrow(nSub, nParam);
		case 43: return ItemPropertyKeen();
		case 44: return ItemPropertyLight(nSub, nParam);
		case 45: return ItemPropertyMaxRangeStrengthMod(nParam);
		case 47: return ItemPropertyNoDamage();
		case 48: return ItemPropertyOnHitProps(nSub, nParam, nSpecial);
		case 49: return ItemPropertyReducedSavingThrow(nSub, nParam);
		case 50: return ItemPropertyReducedSavingThrowVsX(nSub, nParam);
		case 51: return ItemPropertyRegeneration(nParam);
		case 52: return ItemPropertySkillBonus(nSub, nParam);
		case 53: return ItemPropertySpellImmunitySpecific(nParam);
		case 54: return ItemPropertySpellImmunitySchool(nSub);
		case 55: return ItemPropertyThievesTools(nParam);
		case 56: return ItemPropertyAttackBonus(nParam);
		case 57: return ItemPropertyAttackBonusVsAlign(nSub, nParam);
		case 58: return ItemPropertyAttackBonusVsRace(nSub, nParam);
		case 59: return ItemPropertyAttackBonusVsSAlign(nSub, nParam);
		case 60: return ItemPropertyAttackPenalty(nParam);
		case 61: return ItemPropertyUnlimitedAmmo(nParam);
		case 62: return ItemPropertyLimitUseByAlign(nSub);
		case 63: return ItemPropertyLimitUseByClass(nSub);
		case 64: return ItemPropertyLimitUseByRace(nSub);
		case 65: return ItemPropertyLimitUseBySAlign(nSub);
		case 66: return ItemPropertyBonusHitpoints(nParam);
		case 67: return ItemPropertyVampiricRegeneration(nParam);
		case 70: return ItemPropertyTrap(nSub, nParam);
		case 71: return ItemPropertyTrueSeeing();
		case 72: return ItemPropertyOnMonsterHitProperties(nSub, nSpecial);
		case 73: return ItemPropertyTurnResistance(nParam);
		case 74: return ItemPropertyMassiveCritical(nParam);
		case 75: return ItemPropertyFreeAction();
		case 78: return ItemPropertyImmunityToSpellLevel(nParam);
		case 79: return ItemPropertySpecialWalk(nSub);
		case 80: return ItemPropertyHealersKit(nParam);
		case 81: return ItemPropertyWeightIncrease(nSpecial);
		case 82: return ItemPropertyOnHitCastSpell(nSub, nParam);
		case 83: return ItemPropertyVisualEffect(nSub);
		case 84: return ItemPropertyArcaneSpellFailure(nParam);
		case 100: return ItemPropertySpecialMaterial(nSub);
		default: return ItemPropertyEnhancementBonus(nParam);
	}
	return ItemPropertyEnhancementBonus(nParam);
}

//Converts between type/subtype/param/special and the actual property
itemproperty EnchantmentIndexToItemProp(struct enchantment enchant) {
	
	/*
	int nType = enchant.type;
	int nSub = enchant.subtype;
	int nParam = enchant.numerical;
	int nSpecial = enchant.special;*/

	return IpArgsToItemProperty(enchant.type, enchant.subtype, enchant.numerical, enchant.special);
}

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
	mat.index = n;
	mat.label = GetMLabel(n, s2da);
	mat.rResref = GetMResref(n, s2da);
	mat.costTier = GetMCostTier(n, s2da);
	mat.craftDC = GetMCraftDC(n, s2da);
	mat.ipForgedOf = GetMForgedOf(n, s2da);
	mat.ipMeleeType = GetMMeleeType(n, s2da);
	mat.ipMeleeSubType = GetMMeleeSubType(n, s2da);
	mat.ipMeleeParam = GetMMeleeParam(n, s2da);
	mat.ipMeleeSpecial = StringToInt(Get2DAString(s2da, "IP_M_SPECIAL", n));
	mat.drMaterial = GetMDRMaterial(n, s2da);
	mat.ipArmorType = GetMArmorType(n, s2da);
	mat.ipArmorSubType = GetMArmorSubType(n, s2da);
	mat.ipArmorParam = GetMArmorParam(n, s2da);
	mat.ipArmorSpecial = StringToInt(Get2DAString(s2da, "IP_A_SPECIAL", n));
	mat.armorSuffix = GetMArmorSuffix(n, s2da);
	mat.ipRangedType = GetMRangedType(n, s2da);
	mat.ipRangedSubType = GetMRangedSubType(n, s2da);
	mat.ipRangedParam = GetMRangedParam(n, s2da);
	mat.ipRangedSpecial = StringToInt(Get2DAString(s2da, "IP_R_SPECIAL", n));
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
	item.index = n;
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

void GenerateMaterialList(object oPC, int item_index, int nList){
	struct baseitem dItem = LoadBaseItem(item_index);
	string sMatList;
	switch (nList){
		case 1: sMatList = dItem.matlist_1; break;
		case 2: sMatList = dItem.matlist_2; break;
		default: sMatList = dItem.matlist_3; break;
	}
	string sList = IntToString(nList);
	if (sMatList == "") {
		SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL"+sList+"_HEADER", TRUE);
		SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL"+sList+"_LIST", TRUE);
		return;
	} else {
		SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL"+sList+"_HEADER", FALSE);
		SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL"+sList+"_LIST", FALSE);
	}
	// metals such gold, platinum, non-alchemical-silver, etc make useless weapons and armor so what I've
	// done is put them on both metal 2da and the misc 2da but made a column in both to denote them.  
	// We'll allow them to be the base item for jewelry or the misc item for weapons, armor, bracers, and helms
	// but won't be used in anything else. Due to their value they will grant an enchanting point but have no
	// special properties like a matpower or synergy bonus.
	int bCheckForDecorativeMetals = (sMatList == "SCOD_CRAFT_METAL" || sMatList == "SCOD_CRAFT_MISC");
	int bUseDecorativeMetal = FALSE;
	int bIsWeaponOrArmor = (dItem.id == BASE_ITEM_BRACER || dItem.id == BASE_ITEM_HELMET || 
		dItem.type == "A" || dItem.type == "W");
		
	int bIsJewelry = (dItem.id == BASE_ITEM_AMULET || dItem.id == BASE_ITEM_RING);
	if ((bIsWeaponOrArmor && nList == 3) ||	(bIsJewelry && nList == 1))
		bUseDecorativeMetal = TRUE;
		
	int bIsXbow = (dItem.id == BASE_ITEM_HEAVYCROSSBOW || dItem.id == BASE_ITEM_LIGHTCROSSBOW);

	int bIncludeMat;
	int nNum2daRows = GetNum2DARows(sMatList);
	int i;
	string sName;
	int nIpRpId;
	string sSpecificMatOnly = "";
	if (dItem.label == "Crossbow Cocking Lever") sSpecificMatOnly = "ps_crft_reggear";
	else if (dItem.label == "Crossbow Sight") sSpecificMatOnly = "ps_crft_neufly";
	
	ClearListBox(oPC, sCraftingScreen, "SCOD_MATERIAL"+sList+"_LIST");
	for (i = 0; i < nNum2daRows; i++){
		bIncludeMat = TRUE;
		if (bCheckForDecorativeMetals){
			if (Get2DAString(sMatList, "DECORATIVE_METAL", i) == "1") bIncludeMat = bUseDecorativeMetal;
		}
		if (sSpecificMatOnly != ""){
			if (Get2DAString(sMatList, "BASE_RESREF", i) != sSpecificMatOnly) bIncludeMat = FALSE;
		}
		if (Get2DAString(sMatList, "XBOW_ONLY", i) == "1"){
			if (!bIsXbow) bIncludeMat = FALSE;
		}
		if (bIncludeMat){
			sName = GetMLabel(i, sMatList);
			nIpRpId = StringToInt(Get2DAString(sMatList, "IP_DESCRIPTION_ID", i));
			if (!GetIsPowerfulMaterial(nIpRpId)) sName += " (no points)";
			AddListBoxRow(oPC, sCraftingScreen, "SCOD_MATERIAL"+sList+"_LIST", "CMAT"+sList+"ROW_"+IntToString(i), "Material"+sList+"Name="+sName+";", "", "5="+IntToString(i), "");
		}
		
	}
	SetMaterialListHeader(oPC, dItem, nList);
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
	itemproperty matPower = GetSpecialMaterialItemProperty(i, m1);
	// Changes to tantulhor, beyshk, and blood glass make the warning for them unnecessary
	/*
	if (GetItemPropertyType(matPower) == ITEM_PROPERTY_DAMAGE_BONUS) 
	{
		sResult = "If you are making a ";
		if (GetItemPropertySubType(matPower) == IP_CONST_DAMAGETYPE_BLUDGEONING) {
			sResult += "bludgeoning weapon we will use slashing ";
		} else if (GetItemPropertySubType(matPower) == IP_CONST_DAMAGETYPE_SLASHING) {
			sResult = "slashing weapon we will use piercing ";
		} else if (GetItemPropertySubType(matPower) == IP_CONST_DAMAGETYPE_PIERCING) {
			sResult = "piercing weapon we will use slashing ";
		}
		sResult += "bonus instead to avoid overwritten properties.";
	} else 
	*/
	if (GetItemPropertyType(matPower) == 43 && IPGetIsProjectile(OBJECT_INVALID, i.id)){
		sResult = "Please note: Keen property cannot be applied to ammunition.";
	} else if (GetItemPropertyType(matPower) == ITEM_PROPERTY_MASSIVE_CRITICALS && 
		IPGetIsProjectile(OBJECT_INVALID, i.id)){
		sResult = "Please note: Massive Criticals cannot be applied to ammunition.";
	} else if (m1.label == "Metalline" && (IPGetIsProjectile(OBJECT_INVALID, i.id) ||
		IPGetIsThrownWeapon(OBJECT_INVALID, i.id))){
		sResult = "Please note: Ammunition and thrown weapons cannot change material type. Metalline special property is useless on ammunition and thrown weapons.";
	}
	return sResult;
}

itemproperty GetImpCritItemPropertyForRanged(int nItem){
	int nFeat = StringToInt(Get2DAString("baseitems", "FEATImprCrit", nItem));
	int nIprp = PS_GetIpBonusFeat(nFeat);
	return ItemPropertyBonusFeat(nIprp);
}

itemproperty GetSpecialMaterialItemProperty(struct baseitem i, struct material m1){

	struct enchantment enchant;
	// This refers to launchers so it doesn't apply to ammo or thrown weapons
	if (IPGetIsLauncher(OBJECT_INVALID, i.id)) {
		if (m1.ipRangedType == 43) return GetImpCritItemPropertyForRanged(i.id);
		enchant.type = m1.ipRangedType;
		enchant.subtype = m1.ipRangedSubType;
		enchant.numerical = m1.ipRangedParam;
		enchant.special = m1.ipRangedSpecial;
	} else if (i.type == "W" || (i.id == BASE_ITEM_GLOVES && CRAFTED_GLOVES_GET_MAT_POWER)) {
		enchant.type = m1.ipMeleeType;
		
		ItemPropertyBonusFeat(20); // bonus feat imp crit unarmed
		
		// "Keen" property doesn't work on thrown weapons, so lets get bonus feat improved crit instead
		// and get imp crit unarmed for gloves
		if (m1.ipMeleeType == 43){
			if (i.id == BASE_ITEM_GLOVES) return ItemPropertyBonusFeat(20);
			if (IPGetIsThrownWeapon(OBJECT_INVALID, i.id))
				return GetImpCritItemPropertyForRanged(i.id);
		}
		
		// If we're adding a damage bonus, make sure the damage bonus doesn't override the base damage of the weapon
		// ipMeleeSubType 0 = bludgeoning, 1 = piercing, 2 = slashing
		// nBaseType 1 = piercing, 2 = bludgeoning, 3 = slashing, 4 = piercing-slashing, 5 = bludgeoning-piercing
		if (enchant.type == 16){
			int nBaseType; // the base damage type of the weapon.
			// if bullets set base dmg type to bludgeoning (2da doesn't show type for ammo, just launcher)
			if (i.id == 27 || i.id == BASE_ITEM_GLOVES) nBaseType = 2; 
			else if (i.id == BASE_ITEM_GLOVES) nBaseType = 2;// set gloves to bludgeoning
			else if (i.id == 20 || i.id == 25) nBaseType = 1; // if arrows or bolts set base dmg type to piercing
			else nBaseType = StringToInt(Get2DAString("baseitems", "WeaponType", i.id)); // get thrown and melee dmg type from 2da
			
			// Change tantulhor to slashing if the base dmg type is blunt or blunt + piercing.
			if (m1.ipMeleeSubType == 0 && (nBaseType == 2 || nBaseType == 5)) enchant.subtype = 2;
			
			// Change beyshk to slashing if the weapon's damage type is piercing or bludgeoning + piercing
			else if (m1.ipMeleeSubType == 1 && (nBaseType == 1 || nBaseType == 5)) enchant.subtype = 2;
			
			// change beyshk to blunt if the weapon's damage type is piercing + slashing
			else if (m1.ipMeleeSubType == 1 && nBaseType == 4) enchant.subtype = 0;
			
			// change blood glass to piercing if the weapon's damage type is slashing
			else if (m1.ipMeleeSubType == 2 && nBaseType == 3) enchant.subtype = 1;
			
			// change blood glass to bludgeoning if the weapon's damage type is piercing + slashing
			else if (m1.ipMeleeSubType == 2 && nBaseType == 4) enchant.subtype = 0;
			
			// otherwise use normal material damage type
			else enchant.subtype = m1.ipMeleeSubType;
		} else enchant.subtype = m1.ipMeleeSubType;
		enchant.numerical = m1.ipMeleeParam;	
		enchant.special = m1.ipMeleeSpecial;
	} else if (i.type == "A") {
		enchant.type = m1.ipArmorType;
		enchant.subtype = m1.ipArmorSubType;
		enchant.numerical = m1.ipArmorParam;
		enchant.special = m1.ipArmorSpecial;
	}
	//SendMessageToPC(oPC, "setting item ability: "+IntToString(enchant.type)+", "+IntToString(enchant.subtype)+", "+IntToString(enchant.numerical));
	itemproperty matPower = EnchantmentIndexToItemProp(enchant);
	return matPower;
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

string RemoveWhitespace(string sInput){
    int nLength = GetStringLength(sInput);
	if (nLength == 0) return "";
    string sResult = "";
	int i;
	string sChar;
    for (i = 0; i < nLength; i++){
        sChar = GetSubString(sInput, i, 1);
        if (sChar != " " && sChar != "\t" && sChar != "\n" && sChar != "\r"){
            sResult += sChar;
        }
    }
    return sResult;
}

int GetIsPlayerMade(object oItem){
	int ipType;
	itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip)){
		ipType = GetItemPropertyType(ip);
        if (ipType == 101){ // "Cage-Forged" property to denote a player-made item
			return TRUE;
		} 
		ip = GetNextItemProperty(oItem);
    }
    return FALSE;
}