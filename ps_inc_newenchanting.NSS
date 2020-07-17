const string xmlEnchantingFile = "scod_enchanting_window.xml";
const string sEnchantingScreen = "SCOD_ENCHANTING";
const float ENCHANTING_DISTANCE = 5.0f;

#include "x2_inc_itemprop"
#include "x0_i0_match"
#include "ps_inc_gemstones"
#include "nw_i0_plot"
#include "ps_inc_itemprops"
#include "nwnx_sql"
//#include "ps_inc_functions"
#include "ps_inc_casterlevel"

//Enchant the chosen item
void EnchantItem(object oItem, struct enchantment enchant);

//Must be called after GetHasRequiredEssence and/or GetHasRequiredGemstone
//If you want it to take the correct essence / gemstone 
//Ideally called after CanEnchantItem
void TakeEnchantmentRequirements(object oPC, struct enchantment enchant);

//Can you enchant this item? 
int CanEnchantItem(object oPC, object oItem, struct enchantment enchant, int feedback = TRUE);

//Converts between type/subtype/param/special and the actual property
itemproperty EnchantmentIndexToItemProp(struct enchantment enchant);

//Meets the minimum requirements for the most basic enchantment
int MeetsMinimumRequirements(object oPC);

//Checks gold + gives failure message
int GetHasRequiredCasterLevel(object oPC, int nCL, int giveFeedback = FALSE);

//Checks gold + gives failure message
int GetHasRequiredGold(object oPC, int nGold, int giveFeedback = FALSE);

//For use in the enchantment system. Will save the object
//found on the character if giveFeedback=TRUE
int GetHasRequiredEssence(object oPC, string sReq, int giveFeedback = FALSE);

//For use in the enchantment system. Will save the object
//found on the character if giveFeedback=TRUE
int GetHasRequiredGemstone(object oPC, string sReq, int giveFeedback = FALSE);

//takes the Custom_Requirement field, and checks whether the PC fulfils it
int GetFulfillsSpecialRequirement(object oPC, string sReq);

//Returns the descriptive text for the special requirement
//sReq should equal Custom_Requirement
string DisplaySpecialRequirement(string sReq);

//Do we have a similar item property on this item already?
//For warning the player before enchanting.
//0 = nothing similar
//1 = something lesser
//2 = exactly same enchantment
//3 = something greater
int HasSimilarProperty(object oPC, object oItem, struct enchantment enchant);

//Get is ammunition or ammunition quiver
int IPGetIsAmmunition(object oItem);

//Get is thrown weapon or thrown weapon quiver
int IPGetIsThrownWeapon(object oItem);

//Get the point value of this enchanted weapon
int GetItemTotalPoints(object oItem);

//Get whether this Made Of material is powerful enough to give an extra point
int IsPowerfulMaterial(itemproperty ip, int countSilver = FALSE);

//Max number of enchantment points
int GetItemTotalPointsAllowed(object oItem, object oPC = OBJECT_INVALID);

//Grabs all the enchantments for the given db column
//Valid columns are: Melee, Ranged, Ammo, Thrown, Armor, Glove
//Bracer, Helm, Amulet, Ring, Boots, Container, Instrument,
//Misc, Belt, Cloak
//used by the crafting manual script
string GenerateEnchantmentManualFor(object oTarget, string sColumn);

//Takes an enchantment and returns a string describing its recipe
string GenerateEnchantmentDescription(struct enchantment enchant);

//************************************************
//2da data fetch classes
//************************************************

//Get Index from 2da
int GetTypeIndex(int index);

//Get Subtype Index from 2da
int GetSubTypeIndex(int index);

//Get Numerical index from 2da
int GetParamIndex(int index);

//Get Gold cost from 2da
int GetGoldCost(int index);

//Get Point value from 2da
int GetPointValue(int index);

//Get Special index cost from 2da
int GetSpecialIndex(int index);

//Get essence requirement from 2da
string GetEssenceRequirement(int index);

//Get Gem requirement from 2da
string GetGemRequirement(int index);

//Writes out the item property in a pretty string
//fit for gui display
string GetItemPropertyString(itemproperty ip);

//estimate the point value from the 2da tables
//for this itemproperty
int EstimateItemPropertyPointValue(itemproperty ip);

//Check the database for the correct item point value
//for this item property; fallback on EstimateItemPropertyPointValue
//if entry not found
int GetItemPropertyPointValue(itemproperty ip, string itemType = "");

//Get the sql string to filter out inappropriate enchantments by item type
string GetEnchantmentItemRestriction(object oItem, int isEnchantWindow);

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
	string gemstone;
	string special_req;
};

//A structure to store the enchantment data
//Will get variables differently from sql, of course
// Variables of struct would stay the same though
struct enchantment LoadEnchantment(int index) {

	SQLExecDirect("SELECT Recipe_Id, Type, Subtype, Numerical, Special, Points, Gold, Essence, Gemstone, Custom_Requirement FROM recipes WHERE Recipe_Id='"+IntToString(index)+"'");
	
    struct enchantment enchant;
	while (SQLFetch() != SQL_ERROR) {
		enchant.id = StringToInt(SQLGetData(1));
		enchant.type = StringToInt(SQLGetData(2));
		enchant.subtype = StringToInt(SQLGetData(3));
		enchant.numerical = StringToInt(SQLGetData(4));
		enchant.special = StringToInt(SQLGetData(5));
		enchant.points = StringToInt(SQLGetData(6));
		enchant.gold =StringToInt(SQLGetData(7));
		enchant.essence = SQLGetData(8);
		enchant.gemstone = SQLGetData(9);
		enchant.special_req = SQLGetData(10);
	}
	return enchant;
	
}

//Get Index from 2da
int GetTypeIndex(int index) {
	int nIndex = StringToInt(Get2DAString("scodenchantments", "Type", index));  
	return nIndex;
}

//Get Subtype Index from 2da
int GetSubTypeIndex(int index) {
	int nIndex = StringToInt(Get2DAString("scodenchantments", "Subtype", index));  
	return nIndex;
}

//Get Numerical index from 2da
int GetParamIndex(int index) {
	int nIndex = StringToInt(Get2DAString("scodenchantments", "Numerical", index));  
	return nIndex;
}

//Get Gold cost from 2da
int GetGoldCost(int index) {
	int nGold = StringToInt(Get2DAString("scodenchantments", "Gold", index));  
	return nGold;
}

//Get Point value from 2da
int GetPointValue(int index) {
	int nPoint = StringToInt(Get2DAString("scodenchantments", "Points", index));  
	return nPoint;
}

//Get Special index cost from 2da
int GetSpecialIndex(int index) {
	int nPoint = StringToInt(Get2DAString("scodenchantments", "Special", index));  
	return nPoint;
}

//Get Gem requirement from 2da
string GetGemRequirement(int index) {
	string sGem = Get2DAString("scodenchantments", "Gemstone", index);  
	return sGem;
}

//Get essence requirement from 2da
string GetEssenceRequirement(int index) {
	string sEssence = Get2DAString("scodenchantments", "Essence", index);  
	return sEssence;
}


//************************************************
//Bench classes - for fetching workbenches for 
//fancy effects
//************************************************

int GetBenchIsValidForEnchanting(object oPC, object oBench) {
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
object GetNearestEnchantingWorkbench(object oPC) {
	object oBench = GetNearestObjectByTag("PLC_MR_MWBench", oPC);//PLC_MR_MWBench
	if (GetBenchIsValidForEnchanting(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("PLC_MC_CBENCH03", oPC);
	if (GetBenchIsValidForEnchanting(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("ps_usersign_magetable", oPC);
	if (GetBenchIsValidForEnchanting(oPC, oBench)) 
		return oBench;
	oBench = GetNearestObjectByTag("nx2_mage_bench", oPC);
	if (GetBenchIsValidForEnchanting(oPC, oBench)) 
		return oBench;
	return OBJECT_INVALID;
}

string GetItemPropertyString(itemproperty ip) {

	string sResult = "";
	int nProp = GetItemPropertyType(ip);
	int nPropType = StringToInt(Get2DAString("itempropdef", "Name", nProp));
	string sPropType = GetStringByStrRef(nPropType);
		
	string sSubTable = Get2DAString("itempropdef", "SubTypeResRef", nProp);
	int nPropSub = GetItemPropertySubType(ip);
	if (sSubTable != "" && sSubTable != "****") {
		int nPropSubType = StringToInt(Get2DAString(sSubTable, "Name", nPropSub));
		string sPropSubType = GetStringByStrRef(nPropSubType);
		sPropType += ": "+sPropSubType+"";
	}
	
	//Item Property Numeric Value String
	int nCostTable = GetItemPropertyCostTable(ip);
	int nCostTableValue = GetItemPropertyCostTableValue(ip);
	string sTable = Get2DAString("iprp_costtable", "Name", nCostTable);
	int nStreff = StringToInt(Get2DAString(sTable, "Name", nCostTableValue));
	string sName = GetStringByStrRef(nStreff);
	if (sName != "Bad Strref")
		sResult = sPropType+" "+sName;
	else
		sResult = sPropType;
		
	return sResult;
	
}

//Get item properties as text
string GetItemPropertyList(object oItem, object oPC = OBJECT_INVALID) {

	string sResult = "<i>";
	itemproperty ip = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(ip)) {
	
		sResult += "* "+GetItemPropertyString(ip)+"\n\n";
		
		ip = GetNextItemProperty(oItem);
		
	}

	return sResult+"</i>";
}

//Gets the name of the enchantment type from this 2da index
string GetTypeName(struct enchantment enchant) {
	//scodenchantments
	int nType = enchant.type; 
	int nSubType = enchant.subtype;
	
	string sResult = "";
	int nPropType = StringToInt(Get2DAString("itempropdef", "Name", nType));
	sResult += GetStringByStrRef(nPropType);
	if (nSubType > -1) {
		string sSubTable = Get2DAString("itempropdef", "SubTypeResRef", nType);
		if (sSubTable != "" && sSubTable != "****") {
			int nPropSubType = StringToInt(Get2DAString(sSubTable, "Name", nSubType));
			string sPropSubType = GetStringByStrRef(nPropSubType);
			sResult += ": "+sPropSubType;
		}
	}
	return sResult;
}

//Get text string for the parameter
string GetSecondaryParamName(struct enchantment enchant) {
	int nType = enchant.type;  
	
	int nCostTableIndex = StringToInt(Get2DAString("itempropdef", "CostTableResRef", nType));
	string sCostTable = Get2DAString("iprp_costtable", "Name", nCostTableIndex); 
	
	int nNumIndex = enchant.numerical;  
	int nParam = StringToInt(Get2DAString(sCostTable, "Name", nNumIndex)); 
	string sParam = GetStringByStrRef(nParam);
	if (GetStringLowerCase(sParam) == "bad strref" || GetStringLowerCase(sParam) == "bad_strref")
		return "";
	else
		return sParam;
}

//Is this a thrown weapon?
int IPGetIsThrown(object oItem)
{
  int nBT = GetBaseItemType(oItem);
  return (nBT == BASE_ITEM_DART || nBT == BASE_ITEM_SHURIKEN || nBT == BASE_ITEM_THROWINGAXE);
}

//Checks whether this enchantment type is valid on this item
//May need to be revisited - not everything is clearly marked in the 2da
//update 5/2/18 - may not be necessary anymore, so always returns true.
int CanAddEnchantmentToItem(object oItem, int nEnchant) {

	return TRUE;
	/*int nAllowed = FALSE;
	if (IPGetIsMeleeWeapon(oItem)) {
		nAllowed = StringToInt(Get2DAString("itemprops", "0_Melee", nEnchant));
	} else if (IPGetIsRangedWeapon(oItem)) {
		nAllowed = StringToInt(Get2DAString("itemprops", "1_Ranged", nEnchant));	
	} else if (IPGetIsThrownWeapon(oItem)) {
		nAllowed = StringToInt(Get2DAString("itemprops", "2_Thrown", nEnchant));	
	} else if (GetBaseItemType(oItem) == BASE_ITEM_QUARTERSTAFF || GetBaseItemType(oItem) == BASE_ITEM_MAGICSTAFF) {
		nAllowed = StringToInt(Get2DAString("itemprops", "3_Staves", nEnchant));	
	} else if (IPGetIsAmmunition(oItem)) {
		nAllowed = StringToInt(Get2DAString("itemprops", "5_Ammo", nEnchant));	
	} else if (MatchShield(oItem) || GetBaseItemType(oItem) == BASE_ITEM_BRACER 
		|| GetBaseItemType(oItem) == BASE_ITEM_BOOTS || GetArmorRank(oItem) > ARMOR_RANK_NONE) {
		nAllowed = StringToInt(Get2DAString("itemprops", "6_Arm_Shld", nEnchant));	
	} else if (GetBaseItemType(oItem) == BASE_ITEM_HELMET) {
		nAllowed = StringToInt(Get2DAString("itemprops", "7_Helm", nEnchant));	
	} else if (GetBaseItemType(oItem) == BASE_ITEM_AMULET || GetBaseItemType(oItem) == BASE_ITEM_RING) {
		nAllowed = StringToInt(Get2DAString("itemprops", "16_Misc", nEnchant));	
	} else if (GetBaseItemType(oItem) == BASE_ITEM_GLOVES) {
		nAllowed = StringToInt(Get2DAString("itemprops", "21_Glove", nEnchant));	
	}   
	return nAllowed;*/
}

//Get is ammunition or ammunition quiver
int IPGetIsAmmunition(object oItem) {
	if (GetBaseItemType(oItem) == BASE_ITEM_ARROW || GetBaseItemType(oItem) == BASE_ITEM_BOLT || GetBaseItemType(oItem) == BASE_ITEM_BULLET)
		return TRUE;
	if (GetBaseItemType(oItem) >= 93 && GetBaseItemType(oItem) <= 95)
		return TRUE;
	return FALSE;
}

//Get is thrown weapon or thrown weapon quiver
int IPGetIsThrownWeapon(object oItem) {
	if (GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE || GetBaseItemType(oItem) == BASE_ITEM_SHURIKEN || GetBaseItemType(oItem) == BASE_ITEM_DART)
		return TRUE;
	if (GetBaseItemType(oItem) >= 90 && GetBaseItemType(oItem) <= 92)
		return TRUE;
	return FALSE;
}

//Get is instrument
int IPGetIsInstrument(object oItem) {
	if (GetBaseItemType(oItem) == BASE_ITEM_DRUM || GetBaseItemType(oItem) == BASE_ITEM_FLUTE || GetBaseItemType(oItem) == BASE_ITEM_MANDOLIN)
		return TRUE;
	return FALSE;
}

//Get the sql string to filter out inappropriate enchantments by item type
string GetEnchantmentItemRestriction(object oItem, int isEnchantWindow = TRUE) {
	string sQuery = "";
	if (IPGetIsInstrument(oItem)) sQuery = "Instrument='1'";
	else if (IPGetIsMeleeWeapon(oItem)) sQuery = "Melee='1'";
	else if (IPGetIsThrownWeapon(oItem)) sQuery = "Thrown='1'";
	else if (IPGetIsAmmunition(oItem)) sQuery = "Ammo='1'";
	else if (IPGetIsRangedWeapon(oItem)) sQuery = "Ranged='1'";
	else if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR || 
	GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD || 
	GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD || 
	GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) sQuery = "Armor='1'";
	else if (GetBaseItemType(oItem) == BASE_ITEM_GLOVES) sQuery = "Glove='1'";
	else if (GetBaseItemType(oItem) == BASE_ITEM_BRACER) sQuery = "Bracer='1'";
	else if (GetBaseItemType(oItem) == BASE_ITEM_HELMET) sQuery = "Helm='1'";
	else if (GetBaseItemType(oItem) == BASE_ITEM_AMULET) sQuery = "Amulet='1'";
	else if (GetBaseItemType(oItem) == BASE_ITEM_RING) sQuery = "Ring='1'";
	else if (GetBaseItemType(oItem) == BASE_ITEM_BELT) sQuery = "Belt='1'";
	else if (GetBaseItemType(oItem) == BASE_ITEM_BOOTS) sQuery = "Boots='1'";
	else if (GetBaseItemType(oItem) == BASE_ITEM_CLOAK) sQuery = "Cloak='1'";
	else if (GetBaseItemType(oItem) == 66) sQuery = "Container='1'";
	else  sQuery = "Misc='1'";
	
	if (isEnchantWindow > 0)
		sQuery += " AND Can_Enchant='1'";
	
	return sQuery;
}

//Generate the main type list
void GenerateEnchantmentTypeList(object oPC) {
	
	ClearListBox(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTTYPE_LIST");
	
	object oItem = GetLocalObject(oPC, "ObjectToEnchant");
	string sRestrict = GetEnchantmentItemRestriction(oItem, TRUE);
	
	string sQuery = "SELECT Recipe_Id FROM recipes WHERE "+sRestrict;
	//SendMessageToPC(oPC, "Debug: "+sQuery);
	SQLExecDirect(sQuery);
	
	int index = 0;
	int max = SQLGetAffectedRows();
	//SendMessageToPC(oPC, "returned: "+IntToString(max));
	SetLocalInt(oPC, "enchant_types_num", max);
	while (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		int n = StringToInt(SQLGetData(1));
		SetLocalInt(oPC, "enchant_type_"+IntToString(index), n);
		index++;
	}
	
	//Doing two loops so that the sql counter doesn't
	//loose its place.
	int nDisplayed = 0;
	for (index = 0; index < max; index++) {
	
		int n = GetLocalInt(oPC, "enchant_type_"+IntToString(index));
		struct enchantment e = LoadEnchantment(n);
		string sName = GetTypeName(e);
		int nType = e.type;
		
		if (CanAddEnchantmentToItem(oItem, nType) && 
		GetLocalInt(oPC, sName) == 0) {
			SetLocalInt(oPC, sName, 1);
			SetLocalString(oPC, "enchantment_"+IntToString(nDisplayed), sName);
			nDisplayed++;
		
			AddListBoxRow(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTTYPE_LIST", "ENCHANTTROW_"+IntToString(n), "EnchantTypeName="+sName+";", "", "5="+IntToString(n), "");
			/*if (!MeetsMinimumRequirements(oPC)) {
				SetGUIObjectDisabled(oPC, sEnchantingScreen, "ENCHANTTROW_"+IntToString(index), TRUE);
			}*/
		}
		DeleteLocalInt(oPC, "enchant_type_"+IntToString(index)); //remove the evidence!
	}
	DeleteLocalInt(oPC, "enchant_types_num");
	
	//remove those markers set above
	index = 0;
	max = nDisplayed;
	while (index < max) {
		if (GetLocalString(oPC, "enchantment_"+IntToString(index)) != "") {
			DeleteLocalInt(oPC, GetLocalString(oPC, "enchantment_"+IntToString(index)));
			DeleteLocalString(oPC, "enchantment_"+IntToString(index));
		}
		index++;
	}
}

//Generate the main type list
//will need refactoring for sql
void GenerateParamTypeList(object oPC, struct enchantment enchant) {

	//Clear the box
	ClearListBox(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTPARAM_LIST");
	
	//fetching the parameters to match
	int nType = enchant.type;
	int nSubType = enchant.subtype;
	object oItem = GetLocalObject(oPC, "ObjectToEnchant");
	string sRestrict = GetEnchantmentItemRestriction(oItem, TRUE);
	
	string sQuery = "SELECT Recipe_Id FROM recipes WHERE Type='"+IntToString(nType)+"' AND Subtype='"+IntToString(nSubType)+"' AND "+sRestrict;
	//SendMessageToPC(oPC, "Debug: "+sQuery);
	SQLExecDirect(sQuery);
	
	int index = 0;
	int max = SQLGetAffectedRows();
	//SendMessageToPC(oPC, "returned: "+IntToString(max));
	SetLocalInt(oPC, "enchant_types_num", max);
	while (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		int n = StringToInt(SQLGetData(1));
		SetLocalInt(oPC, "enchant_type_"+IntToString(index), n);
		index++;
	}
	
	//Doing two loops so that the sql counter doesn't
	//loose its place.
	for (index = 0; index < max; index++) {
	
		int n = GetLocalInt(oPC, "enchant_type_"+IntToString(index));
		struct enchantment e = LoadEnchantment(n);
		
		int type = e.type;
		int sub = e.subtype;
		if (nType == type && nSubType == sub) {
			string sName = GetSecondaryParamName(e);
			if (sName == "") sName = "Click for Details";
			AddListBoxRow(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTPARAM_LIST", "ENCHANTPROW_"+IntToString(n), "ParamTypeName="+sName+";", "", "5="+IntToString(n), "");
			/*if (!CanEnchantItem(oPC, oItem, e, FALSE)) {
				SetGUIObjectDisabled(oPC, sEnchantingScreen, "ENCHANTPROW_"+IntToString(n), TRUE);
			}*/
		}
		DeleteLocalInt(oPC, "enchant_type_"+IntToString(index)); //remove the evidence!
	}
	DeleteLocalInt(oPC, "enchant_types_num");
	
}

//Gets the name of the object after creating it on the holder
//object. This is a clunky workaround but I don't want to 
//also have to record names. . .
string TranslateItemTagToName(string sString) {

	object oHolder = GetObjectByTag("pc_utility_ipchest");
	if (!GetIsObjectValid(oHolder))
		return "";
		
	object oItem = CreateItemOnObject(sString, oHolder);
	string sResult = GetName(oItem);
	DestroyObject(oItem);
	DelayCommand(0.1f, DestroyObject(oItem));
	return sResult;
	
}

//Same as TranslateItemTagToName but reads the tag
//to find out the desired quality of the gemstone
string TranslateGemstoneTagToName(string sString) {

	//SpeakString("Translating gemstone tag: "+sString, TALKVOLUME_SHOUT);
	string sBase = GetBaseGemTagFromString(sString);
	//SpeakString("Gemstone base: "+sBase, TALKVOLUME_SHOUT);
	string sResult = TranslateItemTagToName(sBase);
	//SpeakString("Gemstone name: "+sResult, TALKVOLUME_SHOUT);
	string sEnd = GetSubString(sString, GetStringLength(sString)-1, 1);
	int nQ = StringToInt(sEnd);
	string sQuality = GetQualityString(nQ-1);
	
	return sResult+" ("+sQuality+")";
}

//Helper function to deal with odd numbers in itemproperties
int IndiciesAreEquivalent(int x, int y, object oPC = OBJECT_INVALID) {
	/*if (GetIsObjectValid(oPC))
		SendMessageToPC(oPC, "pre change: "+IntToString(x)+", "+IntToString(y));*/
	if (x <= 0 || x >= 255)
		x = -1;
	if (y <= 0 || y >= 255)
		y = -1;
	/*if (GetIsObjectValid(oPC))
		SendMessageToPC(oPC, "post change: "+IntToString(x)+", "+IntToString(y));*/
	return (x == y);
}

//Do we have a similar item property on this item already?
//For warning the player before enchanting.
//0 = nothing similar
//1 = something lesser
//2 = exactly same enchantment
//3 = something greater
int HasSimilarProperty(object oPC, object oItem, struct enchantment enchant) {

	itemproperty iProp = EnchantmentIndexToItemProp(enchant);
	int nType = GetItemPropertyType(iProp);
	int nSub = GetItemPropertySubType(iProp);
	int nParam = GetItemPropertyCostTableValue(iProp);
	int nSpecial = GetItemPropertyParam1Value(iProp);
	
	itemproperty ip = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(ip)) {
	
		int iType = GetItemPropertyType(ip);
		int iSub = GetItemPropertySubType(ip);
		int iParam = GetItemPropertyCostTableValue(ip);
		int iSpecial = GetItemPropertyParam1Value(ip);
		
		//SendMessageToPC(oPC, "Checking type and subtype: "+IntToString(nType)+" vs. "+IntToString(iType)+", "+IntToString(nSub)+" vs. "+IntToString(iSub));
		if (nType == iType && IndiciesAreEquivalent(nSub, iSub, oPC)) {
			//SendMessageToPC(oPC, "Checking type and subtype: "+IntToString(nParam)+" vs. "+IntToString(iParam));
			if (IndiciesAreEquivalent(nParam, iParam, oPC)) {
				//SendMessageToPC(oPC, "Checking type and subtype: "+IntToString(nSpecial)+" vs. "+IntToString(iSpecial));
				if (IndiciesAreEquivalent(nSpecial, iSpecial, oPC))
					return 2;
				else if (nSpecial < iSpecial)
					return 3;
				else
					return 1;
			}
			else if (nParam < iParam)
				return 3;
			else 
				return 1;
		}
		
		ip = GetNextItemProperty(oItem);
	}
	return 0;
	
}

//Takes an enchantment and returns a string describing its recipe
string GenerateEnchantmentDescription(struct enchantment enchant) {

	string sResult = "<b>"+GetTypeName(enchant)+" "+GetSecondaryParamName(enchant)+"</b>\n";
	
	//Points
	int nPoints = enchant.points;
	sResult += "Point Value: "+IntToString(nPoints)+"\n";
	
	//Caster Level
	int nCasterLevel = nPoints*3; //need CL 3x that of point value, AT LEAST
	sResult += "Caster Level: "+IntToString(nCasterLevel)+"\n";
	
	//Gold Requirement
	int nGold = enchant.gold;
	sResult += "Gold: "+IntToString(nGold)+"gp \n";
	
	//Gemstone
	string sGem = enchant.gemstone;
	if (sGem != "") {
		sResult += "Gemstone: "+TranslateGemstoneTagToName(sGem)+"\n";
	}
	
	//Essence
	string sEssence = enchant.essence;
	if (sEssence != "") {
		sResult += "Essence: "+TranslateItemTagToName(sEssence)+"\n";
	}
	
	//Special requirements
	string sReq = enchant.special_req;
	if (sReq != "") {
		sResult += DisplaySpecialRequirement(sReq)+"\n";
	}
	
	return sResult;

}




//Grabs all the enchantments for the given db column
//Valid columns are: Melee, Ranged, Ammo, Thrown, Armor, Glove
//Bracer, Helm, Amulet, Ring, Boots, Container, Instrument,
//Misc, Belt, Cloak
//used by the crafting manual script
string GenerateEnchantmentManualFor(object oTarget, string sColumn) {

	//Book contents
	string sResult = "";

	int nIndex = 1;
	SQLExecDirect("SELECT Recipe_Id, Type, Subtype, Numerical, Special, Points, Gold, Essence, Gemstone, Custom_Requirement, Can_Enchant FROM recipes WHERE "+sColumn+" = 1 AND Can_Enchant = 1");
	while (SQLFetch() != SQL_ERROR) {
    	struct enchantment enchant;
		enchant.id = StringToInt(SQLGetData(1));
		enchant.type = StringToInt(SQLGetData(2));
		enchant.subtype = StringToInt(SQLGetData(3));
		enchant.numerical = StringToInt(SQLGetData(4));
		enchant.special = StringToInt(SQLGetData(5));
		enchant.points = StringToInt(SQLGetData(6));
		enchant.gold =StringToInt(SQLGetData(7));
		enchant.essence = SQLGetData(8);
		enchant.gemstone = SQLGetData(9);
		enchant.special_req = SQLGetData(10);
		
		int canEnchant = StringToInt(SQLGetData(11));
		if (canEnchant) {
			sResult += GenerateEnchantmentDescription(enchant);
			sResult += "\n";
		}
	}
	
	return sResult;
	
}

//Get the list of enchantment requirements for the GUI
void GenerateEnchantmentRequirementsList(object oPC, struct enchantment enchant, object oItem) {

	string sResult = "<b>"+GetTypeName(enchant)+" "+GetSecondaryParamName(enchant)+"</b>\n\n";
	
	int nPoints = enchant.points;
	int nCasterLevel = nPoints*3; //need CL 3x that of point value, AT LEAST
	if (nCasterLevel < 3)
		nCasterLevel = 3;
	if (GetHasRequiredCasterLevel(oPC, nCasterLevel, TRUE))
		sResult += "<i>Caster Level: "+IntToString(nCasterLevel)+"</i>\n";
	else
		sResult += "<Color=FireBrick><i>Caster Level: "+IntToString(nCasterLevel)+"</i></Color>\n";
	
	sResult += "Point Value: "+IntToString(nPoints)+"\n";
	
	int nGold = enchant.gold;
	if (GetHasRequiredGold(oPC, nGold, FALSE))
		sResult += "Gold: "+IntToString(nGold)+"gp \n";
	else
		sResult += "<Color=FireBrick>Gold: "+IntToString(nGold)+"gp </Color>\n";
	
	string sGem = enchant.gemstone;
	if (sGem != "") {
		if (GetHasRequiredGemstone(oPC, sGem, FALSE))
			sResult += "Gemstone: "+TranslateGemstoneTagToName(sGem)+"\n";
		else
			sResult += "<Color=FireBrick>Gemstone: "+TranslateGemstoneTagToName(sGem)+"</Color>\n";
	}
	
	string sEssence = enchant.essence;
	if (sEssence != "") {
		if (GetHasRequiredEssence(oPC, sEssence, FALSE))
			sResult += "Essence: "+TranslateItemTagToName(sEssence)+"\n";
		else
			sResult += "<Color=FireBrick>Essence: "+TranslateItemTagToName(sEssence)+"</Color>\n";
	}
	
	string sReq = enchant.special_req;
	if (sReq != "") {
		string sText = DisplaySpecialRequirement(sReq);
		if (GetFulfillsSpecialRequirement(oPC, sReq))
			sResult += sText+"\n";
		else
			sResult += "<Color=FireBrick>Essence: "+sText+"</Color>\n";
	}
	
	int nType = enchant.type;
	int nSubType = enchant.subtype;
	int nParam = enchant.numerical;
	int nSpecial = enchant.special;
	int nSimilar = HasSimilarProperty(oPC, oItem, enchant);
	if (nSimilar == 3)
		sResult += "\n\n<Color=FireBrick>Warning: This item already contains a better property of the same type. Proceeding may overwrite the existing property.</Color>";
	else if (nSimilar == 2) {
		sResult += "\n\n<Color=FireBrick>This item already contains this enchantment.</Color>";
		SetGUIObjectDisabled(oPC, sEnchantingScreen, "ENCHANT_ITEM", TRUE);
	} else if (nSimilar == 1)
		sResult += "\n\n<Color=Teal>This item contains a lesser version of this enchantment. Continuing will overwrite the old property.</Color>";
	SetGUIObjectText(oPC, sEnchantingScreen, "ENCHANTING_ITEM_REQUIREMENTS", -1, sResult);

}

//Display the item description in the gui
void DisplayItemDescription(object oPC, object oItem) {
	int iconIndex = GetItemIcon(oItem);
	string sIcon = Get2DAString("nwn2_icons", "ICON", iconIndex);
	SetGUITexture(oPC, sEnchantingScreen, "ENCHANTING_ITEM_ICON", sIcon+".tga");
	SetGUIObjectText(oPC, sEnchantingScreen, "ENCHANTING_ITEM_NAME", -1, GetName(oItem));
	string sDesc = GetItemPropertyList(oItem, oPC);
	SetGUIObjectText(oPC, sEnchantingScreen, "ENCHANTING_ITEM_DESCRIPTION", -1, sDesc);
	
	int nPointTotal = GetItemTotalPoints(oItem);
	int nPointAllowed = GetItemTotalPointsAllowed(oItem);
	string sPoint = "Points: "+IntToString(nPointTotal)+"/"+IntToString(nPointAllowed);
	SetGUIObjectText(oPC, sEnchantingScreen, "ENCHANTING_ITEM_POINTS", -1, sPoint);
}

//Converts between type/subtype/param/special and the actual property
itemproperty EnchantmentIndexToItemProp(struct enchantment enchant) {

	int nType = enchant.type;
	int nSub = enchant.subtype;
	int nParam = enchant.numerical;
	int nSpecial = enchant.special;

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
		case 26: return ItemPropertyDarkvision();
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

//Prints out the details of the requirement
string DisplaySpecialRequirement(string sReq) {

	string line = "";
	if (sReq == "CL_DIVINE") {
		line = "Must be Cleric, Paladin, or Favored Soul.";
	} else if (sReq == "CL_ARCANE") {
		line = "Must be Wizard, Sorcerer, or Bard.";
	} else if (sReq == "CL_NATURE") {
		line = "Must be Druid, Ranger, or Spirit Shaman.";
	} else if (sReq == "CL_BARD") {
		line = "Must be Bard.";
	}
	return line;
}

//Defines / Implements the custom requirements field
int GetFulfillsSpecialRequirement(object oPC, string sReq) {
	if (sReq == "CL_DIVINE") {
		if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_PALADIN, oPC) ||
		GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC)) {
			return TRUE;
		} else {
			return FALSE;
		}
	} else if (sReq == "CL_ARCANE") {
		if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_SORCERER, oPC) ||
		GetLevelByClass(CLASS_TYPE_BARD, oPC)) {
			return TRUE;
		} else {
			return FALSE;
		}
	} else if (sReq == "CL_NATURE") {
		if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_RANGER, oPC) ||
		GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC)) {
			return TRUE;
		} else {
			return FALSE;
		}
	} else if (sReq == "CL_BARD") {
		if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0)
			return TRUE;
		else
			return FALSE;
	}
	
	return TRUE; //no special req, return true
}

//For use in the enchantment system. Will save the object
//found on the character if giveFeedback=TRUE
int GetHasRequiredGemstone(object oPC, string sReq, int giveFeedback = FALSE) {
	if (sReq == "")
		return TRUE;

	object oItem = GetFirstItemInInventory(oPC);
	string sGemReq = GetBaseGemTagFromString(sReq);
	//SpeakString("Required Gemstone Base: "+sGemReq, TALKVOLUME_SHOUT);
	int nQReq = StringToInt(GetSubString(sReq, GetStringLength(sReq)-1, 1));
	nQReq = nQReq-1;
	
	while (GetIsObjectValid(oItem)) {
		if (GetBaseItemType(oItem) == BASE_ITEM_GEM) {
			string sTag = GetTag(oItem);
			if (FindSubString(sTag, sGemReq) >= 0 && !IsGemRough(oItem)) {
				int nQuality = GetGemQuality(oItem);
				if (nQReq == nQuality) {
					//SpeakString("This item has base: "+sTag, TALKVOLUME_SHOUT);
					SetLocalObject(oPC, "GemstoneToTake", oItem);
					return TRUE;
				}
			} 
			//backwards compatibility with old quartz
			else if (sGemReq == "gemstone_kuartz_green" && !IsGemRough(oItem)) {
				if (FindSubString(sTag, "gemstone_quartz_green") >= 0) {
					int nQuality = GetGemQuality(oItem);
					if (nQReq == nQuality) {
						//SpeakString("This item has base: "+sTag, TALKVOLUME_SHOUT);
						SetLocalObject(oPC, "GemstoneToTake", oItem);
						return TRUE;
					}
				}
			}
			else if (sGemReq == "gemstone_kuartz_purple" && !IsGemRough(oItem)) {
				if (FindSubString(sTag, "gemstone_quartz_purple") >= 0) {
					int nQuality = GetGemQuality(oItem);
					if (nQReq == nQuality) {
						//SpeakString("This item has base: "+sTag, TALKVOLUME_SHOUT);
						SetLocalObject(oPC, "GemstoneToTake", oItem);
						return TRUE;
					}
				}
			}
			else if (sGemReq == "gemstone_kuartz_white" && !IsGemRough(oItem)) {
				if (FindSubString(sTag, "gemstone_quartz_white") >= 0) {
					int nQuality = GetGemQuality(oItem);
					if (nQReq == nQuality) {
						//SpeakString("This item has base: "+sTag, TALKVOLUME_SHOUT);
						SetLocalObject(oPC, "GemstoneToTake", oItem);
						return TRUE;
					}
				}
			}
		}
		oItem = GetNextItemInInventory(oPC);
	}
	
	if (giveFeedback)
		SendMessageToPC(oPC, "You need a "+TranslateGemstoneTagToName(sReq)+" in order to enchant this item.");
	return FALSE;
}

//For use in the enchantment system. Will save the object
//found on the character if giveFeedback=TRUE
int GetHasRequiredEssence(object oPC, string sReq, int giveFeedback = FALSE) {
	if (sReq == "")
		return TRUE;
		
	object oItem = GetItemPossessedBy(oPC, sReq);
	if (GetIsObjectValid(oItem)) {
		SetLocalObject(oPC, "EssenceToTake", oItem);
		return TRUE;
	}
	
	if (giveFeedback)
		SendMessageToPC(oPC, "You need a "+TranslateItemTagToName(sReq)+" in order to enchant this item.");
	return FALSE;
}

//Checks gold + gives failure message
int GetHasRequiredGold(object oPC, int nGold, int giveFeedback = FALSE) {
	
	if (GetGold(oPC) > nGold)
		return TRUE;
		
	if (giveFeedback)
		SendMessageToPC(oPC, "You need "+IntToString(nGold)+"gp in order to enchant this item.");	
	return FALSE;
}

//Checks CL + gives failure message
int GetHasRequiredCasterLevel(object oPC, int nCL, int giveFeedback = FALSE) {
	
	if (GetRealCasterLevel(oPC) >= nCL)
		return TRUE;
		
	if (giveFeedback)
		SendMessageToPC(oPC, "You need caster level "+IntToString(nCL)+" in order to enchant this item. Your caster level is "+IntToString(GetRealCasterLevel(oPC)));	
	return FALSE;
}

//Meets the minimum requirements for the most basic enchantment
int MeetsMinimumRequirements(object oPC) {

	if (GetIsDM(oPC))
		return TRUE;

	object oItem = GetLocalObject(oPC, "ObjectToEnchant");

	int nGold = 300; //minimum amount of gold for 1 point ability
	int nCL = 3; //minimum CL for 1 point ability
	
	int nPoints = GetItemTotalPoints(oItem);
	int nAllowed = GetItemTotalPointsAllowed(oItem);
	
	if (nPoints < nAllowed &&
	GetGold(oPC) > nGold &&
	GetRealCasterLevel(oPC) > nCL)
		return TRUE;
	return FALSE;
}

//Can you enchant this item with this enchantment 
int CanEnchantItem(object oPC, object oItem, struct enchantment enchant, int feedback = TRUE) {

	if (GetIsDM(oPC))
		return TRUE;
	
	string sEssence = enchant.essence;
	string sGem = enchant.gemstone;
	int nGold = enchant.gold;
	string sReq = enchant.special_req;
	int nCL = enchant.points*3;
	if (nCL < 3)
		nCL = 3;
	int nPoints = GetItemTotalPoints(oItem);
	int nAllowed = GetItemTotalPointsAllowed(oItem);
	
	if ((nPoints+enchant.points) <= nAllowed &&
	GetHasRequiredCasterLevel(oPC, nCL, feedback) &&
	GetHasRequiredGold(oPC, nGold, feedback) &&
	GetHasRequiredEssence(oPC, sEssence, feedback) && 
	GetHasRequiredGemstone(oPC, sGem, feedback) && 
	GetFulfillsSpecialRequirement(oPC, sReq))
		return TRUE;
	
	return FALSE;
}

//Must be called after GetHasRequiredEssence and/or GetHasRequiredGemstone
//If you want it to take the correct essence / gemstone 
//Ideally called after CanEnchantItem
void TakeEnchantmentRequirements(object oPC, struct enchantment enchant) {

	int nGold = enchant.gold;
	TakeGoldFromCreature(nGold, oPC, TRUE, TRUE);
	object oGem = GetLocalObject(oPC, "GemstoneToTake");
	if (GetIsObjectValid(oGem)) {
		string sTag = GetTag(oGem);
		TakeNumCraftingMaterials(oPC, sTag, 1);
	} else {
		SendMessageToPC(oPC, "no gem required");
	}
	object oEssence = GetLocalObject(oPC, "EssenceToTake");
	if (GetIsObjectValid(oEssence)) {
		string sTag = GetTag(oEssence);
		TakeNumCraftingMaterials(oPC, sTag, 1);
	} else {
		SendMessageToPC(oPC, "no essence required");
	}
		
}

//Enchant the chosen item
void EnchantItem(object oItem, struct enchantment enchant) {

	itemproperty ip = EnchantmentIndexToItemProp(enchant);
	IPSafeAddItemProperty(oItem, ip);
	
	if (enchant.type == 15) {//spell cast / per day
		SetItemCharges(oItem, 50);
	}
}

int GetItemTotalPoints(object oItem) {

	string itemType = "";
	if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR || 
	GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD || 
	GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD || 
	GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) 
		itemType = "Armor";
	
	int nTotal = 0;
	itemproperty ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip)) {
		nTotal += GetItemPropertyPointValue(ip, itemType);
		ip = GetNextItemProperty(oItem);
	}
	return nTotal;
	
}

//Get whether this subtype is powerful enough to give an extra point
int IsPowerfulMaterial(itemproperty ip, int countSilver = FALSE) {

	int nSubType = GetItemPropertySubType(ip);
	if (nSubType >= 0 && nSubType <= 15) {
		return TRUE;
	} else if (nSubType >= 22 && nSubType <= 37) {
		return TRUE;
	} else if (countSilver && (nSubType == 41 || nSubType == 20)) { //Allowing Cold Iron / Silver to add to points, because sometimes you want a weapon with full points and no existing property!
		return TRUE;
	}
	return FALSE;
}

//Max number of enchantment points
int GetItemTotalPointsAllowed(object oItem, object oPC = OBJECT_INVALID) {

	int countSilver = FALSE;
	int nBase = 10; //later we can add higher point base for suboptimal items
	if (GetWeaponType(oItem) != WEAPON_TYPE_NONE || (GetBaseItemType(oItem) >= 93 && GetBaseItemType(oItem) <= 95)) { //Weapons/Quivers start at 8 points
		nBase = 8;
		countSilver = TRUE;
	}
	
	int nNumMaterials = 0;
	itemproperty ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip)) {
	
		if (GetIsObjectValid(oPC)) 
			SendMessageToPC(oPC, "Property type: "+IntToString(GetItemPropertyType(ip))+", sub type: "+IntToString(GetItemPropertySubType(ip)));
		
		if (GetItemPropertyType(ip) == 100 && IsPowerfulMaterial(ip, countSilver))  //find Made Of property and check value
			nNumMaterials++;
		
		ip = GetNextItemProperty(oItem);
	}
	
	if (GetIsObjectValid(oPC)) 
		SendMessageToPC(oPC, "number of materials: "+IntToString(nNumMaterials));

	if (nNumMaterials > 0)
		nNumMaterials -= 1;
	return nBase+nNumMaterials;
}

//get the point value for item property
int GetItemPropertyPointValue(itemproperty ip, string itemType = "") {

	int nType = GetItemPropertyType(ip);
	int nSubType = GetItemPropertySubType(ip);
	int nNumerical = GetItemPropertyCostTableValue(ip);
	int nSpecial = GetItemPropertyParam1(ip);

	string sQuery = "SELECT Points FROM recipes";
	if (nType >= 0 && nType < 255)
		sQuery += " WHERE Type='"+IntToString(nType)+"'";
	if (nSubType >= 0 && nSubType < 255)
		sQuery += " AND Subtype='"+IntToString(nSubType)+"'";
	if (nNumerical >= 0 && nNumerical < 255)
		sQuery += " AND Numerical='"+IntToString(nNumerical)+"'";
	if (nSpecial >= 0 && nSpecial < 255)
		sQuery += " AND Special='"+IntToString(nSpecial)+"'"; 
			
	//Is this armor? Because if so, enchanting AC is supposed to be cheaper, so check for armor recipe!
	if (itemType == "Armor" && nType == 1) {
		sQuery += " AND Armor='1'";
	}
	
	SQLExecDirect(sQuery);
	while (SQLFetch() != SQL_ERROR) {
		int Point = StringToInt(SQLGetData(1));
		return Point;
	}
	return EstimateItemPropertyPointValue(ip);
}

//get the point estimate from cost tables
int EstimateItemPropertyPointValue(itemproperty ip) {
	int nType = GetItemPropertyType(ip);
	//Exception types
	if (nType >= 62 && nType <= 65) //Use Limitation Properties
		return 0;
	if (nType >= 27 && nType <= 29) //Decrease Properties
		return 0;
	if (nType >= 49 && nType <= 50) //Reduced Properties
		return 0;
	if (nType == 24 || nType == 44 || nType == 10 || nType == 21 || nType == 83) //Damage Vulnerability, Light, Attack Penalty, Damage Penalty, Visual Effect
		return 0;
	if (nType == 100) //Made of Properties
		return 0;
	//Locked off / Power properties
	if (nType == 20 || nType == 35 || nType == 36 
	|| nType == 37 || nType == 54 || nType == 78 || nType == 75) //Damage Immunity, Haste, Holy Avenger, Immunity Misc, Immunity to Spell Level / School, Freedom of Movement
		return 10;
	//Specific Spell Immunity, Bonus Feat, Bonus Spell Slot, Cast Spell
	if (nType == 53 || nType == 12 || nType == 13 || nType == 15)
		return 3;
		
	float baseCost = StringToFloat(Get2DAString("itempropdef", "Cost", nType));
	int nCostTable = GetItemPropertyCostTable(ip);
	string sCostTable = Get2DAString("iprp_costtable", "Name", nCostTable);
	int nCostTableValue = GetItemPropertyCostTableValue(ip);
	float extraCost = StringToFloat(Get2DAString(sCostTable, "Cost", nCostTableValue));
	
	string costString = Get2DAString(sCostTable, "Cost", nCostTableValue);
	string baseString = Get2DAString("itempropdef", "Cost", nType);
	
	float estimate = baseCost*extraCost;
	if (estimate < 1.0f)
		estimate = 1.0f;
		
	return FloatToInt(estimate);
}