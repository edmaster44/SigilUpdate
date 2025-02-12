#include "ff_safevar"

#include "ps_inc_newcraft_include"

const string xmlEnchantingFile = "scod_enchanting_window.xml";
const string sEnchantingScreen = "SCOD_ENCHANTING";


struct enchantment LoadEnchantment(int index, object oPC = OBJECT_INVALID);
struct enchantment LoadEnchantmentFrom2DA(int index, object oPC = OBJECT_INVALID);
struct enchantment LoadEnchantmentFromSQL(int index, object oPC = OBJECT_INVALID);

//Enchant the chosen item
void EnchantItem(object oItem, struct enchantment enchant);

//Must be called after GetHasRequiredEssence and/or GetHasRequiredGemstone
//If you want it to take the correct essence / gemstone 
//Ideally called after CanEnchantItem
void TakeEnchantmentRequirements(object oPC, struct enchantment enchant);

//Can you enchant this item? 
int CanEnchantItem(object oPC, object oItem, struct enchantment enchant, int feedback = TRUE);

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
int GetFulfillsSpecialRequirement(object oPC, string sReq, object oItem = OBJECT_INVALID);

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

//Get the point value of this enchanted weapon
int GetItemTotalPoints(object oItem, object oPC = OBJECT_INVALID);

//Max number of enchantment points
int GetItemTotalPointsAllowed(object oItem);

//Grabs all the enchantments for the given db column
//Valid columns are: Melee, Ranged, Ammo, Thrown, Armor, Glove
//Bracer, Helm, Amulet, Ring, Boots, Container, Instrument,
//Misc, Belt, Cloak
//used by the crafting manual script
string GenerateEnchantmentManual(string sColumn);
string GenerateEnchantmentManualFrom2da(string sColumn);

//Takes an enchantment and returns a string describing its recipe
string GenerateEnchantmentDescription(struct enchantment enchant);

// characters using the Alchemical Infusion feat to enchant need an additional power essence
// to fuel the enchantment since they have insufficient magic of their own to fuel it, but 
// sometimes that will be the same essence they need for the base enchantment. This will 
// search their inv for a duplicate. 
int GetHasAddEssence(object oPC, string sAddEssence, string sMainEssence);

// special check for dragonhide boots, as player made dragonhide boots will be the only
// boots that can get an ac bonus. Don't want loot drop boots getting ac because it would stack with
// any that have an ac vs alignment. For example boots with ac 5 and ac vs evil 3 would be ac 8 vs evil.
// Restricting to have the Forged Of property for dragonhide should mitigate that risk
int GetIsAcEligibleBoots(object oItem);

// Further restricting boots to only "Masterwork", ie, having 3 special materials, should further
// mitigate the above described risk.
int GetIsPlayerMade(object oItem);

// Applies the "Masterwork" item property, which is used to denote items made with all 3 special mats.
// Will allow for additional points for player-crafted weapons and new enchant options for other items
void ApplyPlayerMade(object oItem);

string GetAdditionalEssenceReq(object oPC, int nPoints);

void GenerateEnchantmentTypeList(object oPC, object oItem = OBJECT_INVALID);
void GenerateEnchantmentTypeListFrom2DA(object oPC, object oItem);

void GenerateParamTypeList(object oPC, struct enchantment enchant);
void GenerateParamTypeListFrom2DA(object oPC, object oItem, struct enchantment enchant);


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

// exceedingly complicated but the sql version returns inconsistent results where tantulhor, beyshk, and blood glass are concerned,
// sometimes reporting as 2 points, sometimes 3.
int GetItemTotalPointsFrom2DA(object oItem, object oPC = OBJECT_INVALID);

//Get the sql string to filter out inappropriate enchantments by item type
string GetEnchantmentItemRestriction(object oItem, int isEnchantWindow = TRUE);


//Enchant the chosen item
void EnchantItem(object oItem, struct enchantment enchant) {

	itemproperty ip;
	int nItem = GetBaseItemType(oItem);
	// if the item property is "keen" and the item is a thrown weapon or bow, 
	// get item property bonus feat Improved Critical for that weapon instead.
	if (enchant.type == 43){
		if (IPGetIsLauncher(OBJECT_INVALID, nItem) || IPGetIsThrownWeapon(OBJECT_INVALID, nItem))
			ip = GetImpCritItemPropertyForRanged(nItem);
		else if (nItem == BASE_ITEM_GLOVES)
			ip = ItemPropertyBonusFeat(20); // bonus feat imp crit unarmed
		else ip = EnchantmentIndexToItemProp(enchant);
	} else ip = EnchantmentIndexToItemProp(enchant);
		
	IPSafeAddItemProperty(oItem, ip);
	
	//spell cast / per day
	if (enchant.type == 15) SetItemCharges(oItem, 50);
}

//A structure to store the enchantment data
//Will get variables differently from sql, of course
// Variables of struct would stay the same though
struct enchantment LoadEnchantment(int index, object oPC = OBJECT_INVALID){
	if (CRAFT_DIRECT_FROM_2DA) return LoadEnchantmentFrom2DA(index, oPC);
	return LoadEnchantmentFromSQL(index, oPC);
}


struct enchantment LoadEnchantmentFrom2DA(int index, object oPC = OBJECT_INVALID){

	if (oPC == OBJECT_INVALID) oPC = OBJECT_SELF;

    struct enchantment enchant;
	enchant.id = index;
	enchant.type = GetTypeIndex(index);
	enchant.subtype = GetSubTypeIndex(index);
	enchant.numerical = GetParamIndex(index);
	enchant.special = GetSpecialIndex(index);
	enchant.points = GetPointValue(index);
	enchant.gold = GetGoldCost(index);
	enchant.essence = GetEssenceRequirement(index);
	enchant.gemstone = GetGemRequirement(index);
	enchant.special_req = Get2DAString("scodenchantments", "Custom_Requirement", index); 
	if (GetIsObjectValid(oPC)) enchant.add_essence = GetAdditionalEssenceReq(oPC, enchant.points);
	else enchant.add_essence = "";
	return enchant;
}

struct enchantment LoadEnchantmentFromSQL(int index, object oPC = OBJECT_INVALID){

	if (oPC == OBJECT_INVALID) oPC = OBJECT_SELF;
	
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
	if (GetIsObjectValid(oPC)) enchant.add_essence = GetAdditionalEssenceReq(oPC, enchant.points);
	else enchant.add_essence = "";
	return enchant;
}



void GenerateEnchantmentTypeListFrom2DA(object oPC, object oItem){
	
	int nItem = GetBaseItemType(oItem);
	string sColumn = GetItemColumn(nItem);
	string s2da = "scodenchantments";
	int i = 0;
	int nMax = GetNum2DARows(s2da);
	int nNumTypes = 0;
	int bItemOk = FALSE; // give yourself a high 5 if you read this as "bite me, ok?"
	int bCanEnchant = FALSE;
	string sName;
	int nType;
	int nSubType;
	int nPropRes;
	int nSubRes;
	int nLastType = -1;
	int nLastSub = -1;
	int nLasti = -1;
	string sSubTable;
	for (i = 0; i < nMax; i++){
		bItemOk = (Get2DAString(s2da, sColumn, i) == "1");
		bCanEnchant = (Get2DAString(s2da, "Can_Enchant", i) == "1");
		if (bItemOk && bCanEnchant){
			nType = StringToInt(Get2DAString(s2da, "Type", i));
			nSubType = StringToInt(Get2DAString(s2da, "Subtype", i));

			nPropRes = StringToInt(Get2DAString("itempropdef", "Name", nType));
			sName = GetStringByStrRef(nPropRes);
			if (nSubType > -1) {
				sSubTable = Get2DAString("itempropdef", "SubTypeResRef", nType);
				if (sSubTable != "" && sSubTable != "****") {
					nSubRes = StringToInt(Get2DAString(sSubTable, "Name", nSubType));
					sName += ": "+ GetStringByStrRef(nSubRes);
				}
			}
			
			if (nType == nLastType && nSubType == nLastSub){
				RemoveListBoxRow(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTTYPE_LIST", "ENCHANTTROW_"+IntToString(nLasti));
			}
			AddListBoxRow(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTTYPE_LIST", "ENCHANTTROW_"+IntToString(i), "EnchantTypeName="+sName+";", "", "5="+IntToString(i), "");
			nLastType = nType;
			nLastSub = nSubType;
			nLasti = i;
			
		}
	}
}


//Generate the sub type list
void GenerateParamTypeListFrom2DA(object oPC, object oItem, struct enchantment enchant){

	int nItem = GetBaseItemType(oItem);
	string sColumn = GetItemColumn(nItem);
	
	string s2da = "scodenchantments";
	int i = 0;
	int nMax = GetNum2DARows(s2da);
	string sName;
	int nType;
	int nSub;
	int bCanEnchant;
	int bItemOk;
	int nCostTableIndex;
	string sCostTable; 
	int nNumIndex;
	int nParam; 
	string sParam;
	for (i = 0; i < nMax; i++){
		nType = StringToInt(Get2DAString(s2da, "Type", i));
		nSub = StringToInt(Get2DAString(s2da, "Subtype", i));
		bItemOk = (Get2DAString(s2da, sColumn, i) == "1");
		bCanEnchant = (Get2DAString(s2da, "Can_Enchant", i) == "1");
		if (nType == enchant.type && nSub == enchant.subtype && bItemOk && bCanEnchant){
			nNumIndex = StringToInt(Get2DAString(s2da, "Numerical", i));
			
			nCostTableIndex = StringToInt(Get2DAString("itempropdef", "CostTableResRef", nType));
			sCostTable = Get2DAString("iprp_costtable", "Name", nCostTableIndex); 
			nParam = StringToInt(Get2DAString(sCostTable, "Name", nNumIndex)); 
			sParam = GetStringByStrRef(nParam);
			sName = sParam;
			
			if (sName == "" || GetStringLowerCase(sParam) == "bad strref" || 
				GetStringLowerCase(sParam) == "bad_strref") sName = "Click for Details";
			AddListBoxRow(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTPARAM_LIST", "ENCHANTPROW_"+IntToString(i), "ParamTypeName="+sName+";", "", "5="+IntToString(i), "");
		}
	}
}



//************************************************
//Bench classes - for fetching workbenches for 
//fancy effects
//************************************************

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

//Get the sql string to filter out inappropriate enchantments by item type
string GetEnchantmentItemRestriction(object oItem, int isEnchantWindow = TRUE) {
	string sQuery = "";
	if (IPGetIsInstrument(oItem)) sQuery = "Instrument='1'";
	else if (IPGetIsMeleeWeapon(oItem)) sQuery = "Melee='1'";
	else if (IPGetIsThrownWeapon(oItem)) sQuery = "Thrown='1'";
	else if (IPGetIsProjectile(oItem)) sQuery = "Ammo='1'";
	else if (IPGetIsLauncher(oItem)) sQuery = "Ranged='1'";
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
void GenerateEnchantmentTypeList(object oPC, object oItem = OBJECT_INVALID){
	
	ClearListBox(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTTYPE_LIST");
	
	if (oItem == OBJECT_INVALID) oItem = PS_GetLocalObject(oPC, "ObjectToEnchant");
	
	if (CRAFT_DIRECT_FROM_2DA){
		GenerateEnchantmentTypeListFrom2DA(oPC, oItem);
		return;
	}
	
	string sRestrict = GetEnchantmentItemRestriction(oItem, TRUE);
	
	string sQuery = "SELECT Recipe_Id FROM recipes WHERE "+sRestrict;
	//SendMessageToPC(oPC, "Debug: "+sQuery);
	SQLExecDirect(sQuery);
	
	int index = 0;
	int max = SQLGetAffectedRows();
	//SendMessageToPC(oPC, "returned: "+IntToString(max));
	PS_SetLocalInt(oPC, "enchant_types_num", max);
	while (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		int n = StringToInt(SQLGetData(1));
		PS_SetLocalInt(oPC, "enchant_type_"+IntToString(index), n);
		index++;
	}
	
	//Doing two loops so that the sql counter doesn't
	//loose its place.
	int nDisplayed = 0;
	for (index = 0; index < max; index++) {
	
		int n = PS_GetLocalInt(oPC, "enchant_type_"+IntToString(index));
		struct enchantment e = LoadEnchantment(n, oPC);
		string sName = GetTypeName(e);
		int nType = e.type;
		
		if (PS_GetLocalInt(oPC, sName) == 0) {
			PS_SetLocalInt(oPC, sName, 1);
			PS_SetLocalString(oPC, "enchantment_"+IntToString(nDisplayed), sName);
			nDisplayed++;
		
			AddListBoxRow(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTTYPE_LIST", "ENCHANTTROW_"+IntToString(n), "EnchantTypeName="+sName+";", "", "5="+IntToString(n), "");
			/*if (!MeetsMinimumRequirements(oPC)) {
				SetGUIObjectDisabled(oPC, sEnchantingScreen, "ENCHANTTROW_"+IntToString(index), TRUE);
			}*/
		}
		PS_DeleteLocalInt(oPC, "enchant_type_"+IntToString(index)); //remove the evidence!
	}
	PS_DeleteLocalInt(oPC, "enchant_types_num");
	
	//remove those markers set above
	index = 0;
	max = nDisplayed;
	while (index < max) {
		if (PS_GetLocalString(oPC, "enchantment_"+IntToString(index)) != "") {
			PS_DeleteLocalInt(oPC, PS_GetLocalString(oPC, "enchantment_"+IntToString(index)));
			PS_DeleteLocalString(oPC, "enchantment_"+IntToString(index));
		}
		index++;
	}
}

//Generate the sub type list
//will need refactoring for sql
void GenerateParamTypeList(object oPC, struct enchantment enchant) {

		//Clear the box
	ClearListBox(oPC, sEnchantingScreen, "SCOD_ENCHANTMENTPARAM_LIST");
	object oItem = PS_GetLocalObject(oPC, "ObjectToEnchant");
	
	if (CRAFT_DIRECT_FROM_2DA){
		GenerateParamTypeListFrom2DA(oPC, oItem, enchant);
		return;
	}

	
	//fetching the parameters to match
	int nType = enchant.type;
	int nSubType = enchant.subtype;
	string sRestrict = GetEnchantmentItemRestriction(oItem, TRUE);
	
	string sQuery = "SELECT Recipe_Id FROM recipes WHERE Type='"+IntToString(nType)+"' AND Subtype='"+IntToString(nSubType)+"' AND "+sRestrict;
	//SendMessageToPC(oPC, "Debug: "+sQuery);
	SQLExecDirect(sQuery);
	
	int index = 0;
	int max = SQLGetAffectedRows();
	//SendMessageToPC(oPC, "returned: "+IntToString(max));
	PS_SetLocalInt(oPC, "enchant_types_num", max);
	while (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		int n = StringToInt(SQLGetData(1));
		PS_SetLocalInt(oPC, "enchant_type_"+IntToString(index), n);
		index++;
	}
	
	//Doing two loops so that the sql counter doesn't
	//loose its place.
	for (index = 0; index < max; index++) {
	
		int n = PS_GetLocalInt(oPC, "enchant_type_"+IntToString(index));
		struct enchantment e = LoadEnchantment(n, oPC);
		
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
		PS_DeleteLocalInt(oPC, "enchant_type_"+IntToString(index)); //remove the evidence!
	}
	PS_DeleteLocalInt(oPC, "enchant_types_num");
	
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
	// why the upper limit of 255? There's 1323 lines in iprp_feats
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
	
	string sAddEssence = enchant.add_essence;
	if (sAddEssence != "") {
		sResult += "Fuel Essence (Alchemical Infusion only): "+TranslateItemTagToName(sAddEssence)+"\n";
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
string GenerateEnchantmentManualFrom2da(string sColumn){
	sColumn = GetStringLowerCase(sColumn);
	if (sColumn == "melee") sColumn = "0_Melee";
	else if (sColumn == "ranged") sColumn = "1_Ranged";
	else if (sColumn == "ammo") sColumn = "2_Ammo";
	else if (sColumn == "thrown") sColumn = "3_Thrown"; 
	else if (sColumn == "armor") sColumn = "4_Armor";
	else if (sColumn == "glove") sColumn = "5_Glove";
	else if (sColumn == "bracer") sColumn = "6_Bracer";
	else if (sColumn == "helm") sColumn = "7_Helm";
	else if (sColumn == "amulet") sColumn = "8_Amulet";
	else if (sColumn == "ring") sColumn = "9_Ring";
	else if (sColumn == "boots") sColumn = "10_Boots";
	else if (sColumn == "belt") sColumn = "11_Belt";
	else if (sColumn == "cloak") sColumn = "12_Cloak";
	else if (sColumn == "container") sColumn = "13_Container";
	else if (sColumn == "instrument") sColumn = "14_Instrument";
	else sColumn = "15_Misc";
	
	
	string sResult = "";
	int nNumRows = GetNum2DARows("scodenchantments") - 1;
	int i;
	struct enchantment e;
	for (i = 0; i <= nNumRows; i++){
		if (Get2DAString("scodenchantments", sColumn, i) == "1"){
			if (Get2DAString("scodenchantments", "Can_Enchant", i) == "1"){
				e = LoadEnchantmentFrom2DA(i);
				sResult += GenerateEnchantmentDescription(e);
				sResult += "\n\n";
			}
		}
	}
	return sResult;
} 

string GenerateEnchantmentManual(string sColumn) {

	if (CRAFT_DIRECT_FROM_2DA) return GenerateEnchantmentManualFrom2da(sColumn);
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
	if (nCasterLevel < 3) nCasterLevel = 3;
	
	string sTemp = "<i>Caster Level: "+IntToString(nCasterLevel)+"</i>\n";
	if (GetHasRequiredCasterLevel(oPC, nCasterLevel, TRUE)) sResult += sTemp;
	else sResult += "<Color=FireBrick>" + sTemp + "</Color>";
	
	sResult += "Point Value: "+IntToString(nPoints)+"\n";
	
	
	int nGold = enchant.gold;
	 // currently all enchantments cost something afaik, but who knows what faction perks lay in wait?
	if (nGold > 0){
		// changing to copper, less confusion in game
		sTemp = "Cost: "+IntToString(nGold)+" copper \n";
		if (GetHasRequiredGold(oPC, nGold, FALSE)) sResult += sTemp;
		else sResult += "<Color=FireBrick>" + sTemp + "</Color>";
	}
	string sGem = enchant.gemstone;
	if (sGem != "") {
		sTemp = "Gemstone: "+TranslateGemstoneTagToName(sGem)+"\n";
		if (GetHasRequiredGemstone(oPC, sGem, FALSE)) sResult += sTemp;
		else sResult += "<Color=FireBrick>" + sTemp + "</Color>";
	}
	
	string sEssence = enchant.essence;
	if (sEssence != "") {
		sTemp = "Essence: "+TranslateItemTagToName(sEssence)+"\n";
		if (GetHasRequiredEssence(oPC, sEssence, FALSE)) sResult += sTemp;
		else sResult += "<Color=FireBrick>" + sTemp + "</Color>";
	}
	string sAddEssence = enchant.add_essence;
	if (sAddEssence != ""){
		sTemp = "Fuel Essence: "+TranslateItemTagToName(sAddEssence)+"\n";
		if (GetHasAddEssence(oPC, sAddEssence, sEssence)) sResult += sTemp;
		else sResult += "<Color=FireBrick>" + sTemp + "</Color>";
	}
	
	string sReq = enchant.special_req;
	if (sReq != "") {
		sTemp = DisplaySpecialRequirement(sReq) + "\n";
		if (GetFulfillsSpecialRequirement(oPC, sReq, oItem)) sResult += sTemp;
		else sResult += "<Color=FireBrick>" + sTemp + "</Color>";
	}
	
	int nType = enchant.type;
	int nSubType = enchant.subtype;
	int nParam = enchant.numerical;
	int nSpecial = enchant.special;
	int nSimilar = HasSimilarProperty(oPC, oItem, enchant);
	if (nSimilar == 3)
		sResult += "\n\n<Color=FireBrick>Warning: This item already contains a better property of the same type. Proceeding may overwrite the existing property.</Color>";
	else if (nSimilar == 2) {
		// Double check to make sure the item already has the ip because this has been
		// wrong on occasion
		itemproperty ipEnchant = EnchantmentIndexToItemProp(enchant);
		int bSame = FALSE;
		itemproperty ip = GetFirstItemProperty(oItem);
		while (GetIsItemPropertyValid(ip)){
			if (IPGetItemPropertiesIdentical(ip, ipEnchant)){
				bSame = TRUE;
				break;
			}
			ip = GetNextItemProperty(oItem);
		}
		if (bSame){
			sResult += "\n\n<Color=FireBrick>This item already contains this enchantment.</Color>";
			SetGUIObjectDisabled(oPC, sEnchantingScreen, "ENCHANT_ITEM", TRUE);
		}
	} else if (nSimilar == 1)
		sResult += "\n\n<Color=Teal>This item contains a lesser version of this enchantment. Continuing will overwrite the old property.</Color>";
	SetGUIObjectText(oPC, sEnchantingScreen, "ENCHANTING_ITEM_REQUIREMENTS", -1, sResult);

}
// ff add
//Display the item description in the gui
void DisplayItemDescription(object oPC, object oItem) {
	int iconIndex = GetItemIconSafe(oItem);
	string sIcon = Get2DAString("nwn2_icons", "ICON", iconIndex);
	SetGUITexture(oPC, sEnchantingScreen, "ENCHANTING_ITEM_ICON", sIcon+".tga");
	string sName = GetName(oItem);
	string sLastName = GetLastName(oItem);
	if (RemoveWhitespace(sName) == "") sName = GetFirstName(oItem);
	if (RemoveWhitespace(sLastName) != "") sName += " " + sLastName;
	if (RemoveWhitespace(sName) == ""){
		sName = GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(oItem))));
	}
	SetGUIObjectText(oPC, sEnchantingScreen, "ENCHANTING_ITEM_NAME", -1, sName);
	string sDesc = GetItemPropertyList(oItem, oPC);
	SetGUIObjectText(oPC, sEnchantingScreen, "ENCHANTING_ITEM_DESCRIPTION", -1, sDesc);
	//debug
	//SendMessageToPC(oPC, "Starting points");
	
	int nPointTotal = GetItemTotalPoints(oItem, oPC);
	int nPointAllowed = GetItemTotalPointsAllowed(oItem);
	if (nPointTotal < 0) nPointTotal = 0;
	if (nPointAllowed > 12) nPointAllowed = 12;
	string sPoint = "Points: "+IntToString(nPointTotal)+"/"+IntToString(nPointAllowed);
	SetGUIObjectText(oPC, sEnchantingScreen, "ENCHANTING_ITEM_POINTS", -1, sPoint);
}


//Prints out the details of the requirement
string DisplaySpecialRequirement(string sReq) {
	object oPC = OBJECT_SELF;
	object oItem = PS_GetLocalObject(oPC, "ObjectToEnchant");
	string line = "";
	if (sReq == "CL_DIVINE") {
		line = "Must be Cleric, Paladin, Favored Soul, or have Concentration 5 or Spellcraft 25.";
	} else if (sReq == "CL_ARCANE") {
		line = "Must be Wizard, Sorcerer, Bard, Warlock, or have the Magic domain, Lore 5, or Spellcraft 15.";
	} else if (sReq == "CL_NATURE") {
		line = "Must be Druid, Ranger, Spirit Shaman, or have either the Animal or Plant domain or Survival 5 or Spellcraft 15.";
	} else if (sReq == "CL_BARD") {
		line = "Must be Bard or have either the Knowledge, Travel, or Trickery domain or have Perform 5 or Spellcraft 15.";
	} else if (sReq == "CREATURE") {
		line = "On Creature weapons only.";
	} else if (sReq == "PLAYERMADE_STRONG_MATERIAL_BOOTS") {
		if (GetBaseItemType(oItem) == BASE_ITEM_BOOTS)
			line = "Only boots crafted within Sigil from Dragonhide, Flesh Golem, or Outsider can have armor enchantment added.";
	} else if (sReq == "PLAYER_MADE_ONLY_FOR_RINGS"){
		if (GetBaseItemType(oItem) == BASE_ITEM_RING)
			line = "Only rings crafted within Sigil can get this enchantment.";
	} else if (sReq == "PLAYER_MADE"){
		line = "Item must be crafted in Sigil.";
	} else if (sReq == "PLAYERMADE_XBOW_BRACER_GLOVE"){
		line = "Can only be enchanted on crossbows, bracers, and gloves made in Sigil";
	} else if (sReq == "NO_SLINGS"){
		if (GetBaseItemType(oItem) == BASE_ITEM_SLING)
			line = "This enchantment is redunant on slings.";
	}
	return line;
	
}

//Defines / Implements the custom requirements field
int GetFulfillsSpecialRequirement(object oPC, string sReq, object oItem = OBJECT_INVALID) {
	object oItem = PS_GetLocalObject(oPC, "ObjectToEnchant");
	if (sReq == "CL_DIVINE") {
		if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) > 0 ||
		GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE) >= 15 ||
		GetSkillRank(SKILL_CONCENTRATION, oPC, TRUE) >= 5){
			return TRUE;
		} else {
			return FALSE;
		}
	} else if (sReq == "CL_ARCANE") {
		if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 0 ||
		GetHasFeat(1844, oPC, TRUE) ||
		GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE) >= 15 ||
		GetSkillRank(SKILL_LORE, oPC, TRUE) >= 5){
			return TRUE;
		} else {
			return FALSE;
		}
	} else if (sReq == "CL_NATURE") {
		if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_RANGER, oPC) ||
		GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC) ||
		GetHasFeat(1835, oPC, TRUE) || GetHasFeat(1845, oPC, TRUE) ||
		GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE) >= 15 ||
		GetSkillRank(SKILL_SURVIVAL, oPC, TRUE) >= 5){
			return TRUE;
		} else {
			return FALSE;
		}
	} else if (sReq == "CL_BARD") {
		if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 ||
			GetHasFeat(1849, oPC, TRUE) || GetHasFeat(1850, oPC, TRUE) ||
			GetHasFeat(1843, oPC, TRUE) ||
			GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE) >= 15 ||
			GetSkillRank(SKILL_PERFORM, oPC, TRUE) >= 5){
			return TRUE;
		} else {
			return FALSE;
		}
	} else if (sReq == "CREATURE") {
		if (IPGetIsCreatureEquippedWeapon(oItem))
			return TRUE;
		else
			return FALSE;
	// added special condition in scodenchantments.2da for the ac enchant rows. 
	// This way we can enchant ac on player-made boots of golem, dragon, and outsider but not on others
	} else if (sReq == "PLAYERMADE_STRONG_MATERIAL_BOOTS") {
		if (GetBaseItemType(oItem) == BASE_ITEM_BOOTS){
			if (GetIsAcEligibleBoots(oItem) && GetIsPlayerMade(oItem)) return TRUE;
			else return FALSE;
		} else return TRUE;
	} else if (sReq == "PLAYER_MADE_ONLY_FOR_RINGS"){
		if (GetBaseItemType(oItem) == BASE_ITEM_RING){
			return GetIsPlayerMade(oItem);
		} else return TRUE;
	} else if (sReq == "PLAYER_MADE"){
		return GetIsPlayerMade(oItem);
	} else if (sReq == "PLAYERMADE_XBOW_BRACER_GLOVE"){
		if (!GetIsPlayerMade(oItem)) return FALSE;
		if (IPGetIsLauncher(oItem)){
			int nItem = GetBaseItemType(oItem);
			if (nItem != BASE_ITEM_HEAVYCROSSBOW && nItem != BASE_ITEM_LIGHTCROSSBOW)
				return FALSE;
		}
	} else if (sReq == "NO_SLINGS"){
		if (GetBaseItemType(oItem) == BASE_ITEM_SLING) return FALSE;
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
					PS_SetLocalObject(oPC, "GemstoneToTake", oItem);
					return TRUE;
				}
			} 
			//backwards compatibility with old quartz
			else if (sGemReq == "gemstone_kuartz_green" && !IsGemRough(oItem)) {
				if (FindSubString(sTag, "gemstone_quartz_green") >= 0) {
					int nQuality = GetGemQuality(oItem);
					if (nQReq == nQuality) {
						//SpeakString("This item has base: "+sTag, TALKVOLUME_SHOUT);
						PS_SetLocalObject(oPC, "GemstoneToTake", oItem);
						return TRUE;
					}
				}
			}
			else if (sGemReq == "gemstone_kuartz_purple" && !IsGemRough(oItem)) {
				if (FindSubString(sTag, "gemstone_quartz_purple") >= 0) {
					int nQuality = GetGemQuality(oItem);
					if (nQReq == nQuality) {
						//SpeakString("This item has base: "+sTag, TALKVOLUME_SHOUT);
						PS_SetLocalObject(oPC, "GemstoneToTake", oItem);
						return TRUE;
					}
				}
			}
			else if (sGemReq == "gemstone_kuartz_white" && !IsGemRough(oItem)) {
				if (FindSubString(sTag, "gemstone_quartz_white") >= 0) {
					int nQuality = GetGemQuality(oItem);
					if (nQReq == nQuality) {
						//SpeakString("This item has base: "+sTag, TALKVOLUME_SHOUT);
						PS_SetLocalObject(oPC, "GemstoneToTake", oItem);
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
		PS_SetLocalObject(oPC, "EssenceToTake", oItem);
		return TRUE;
	}
	
	if (giveFeedback)
		SendMessageToPC(oPC, "You need a "+TranslateItemTagToName(sReq)+" in order to enchant this item.");
	return FALSE;
}

//This MUST be called AFTER getting the regular essence requirement
int GetHasAddEssence(object oPC, string sAddEssence, string sMainEssence){
	if (sAddEssence == "") return TRUE;
	object oMainEssence = PS_GetLocalObject(oPC, "EssenceToTake");
	if (sAddEssence == sMainEssence && GetIsObjectValid(oMainEssence)){
		if (GetItemStackSize(oMainEssence) > 1){
			PS_SetLocalObject(oPC, "AddEssenceToTake", oMainEssence);
			return TRUE;
		}	
	}
	int i = 0;
	object oItem = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(oItem)){
		i++;
		// num of items a pc could have if inv full of full bags, including the bags
		if (i > 27072) break;
		if (GetResRef(oItem) == sAddEssence && oItem != oMainEssence){
			PS_SetLocalObject(oPC, "AddEssenceToTake", oItem);
			return TRUE;
		}
		oItem = GetNextItemInInventory(oPC);
	}
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
	
	int nRCL = GetRealCasterLevel(oPC, TRUE);
	if (nRCL >= nCL)
		return TRUE;
		
	if (giveFeedback)
		SendMessageToPC(oPC, "You need caster level "+IntToString(nCL)+" in order to enchant this item. Your caster level is "+IntToString(nRCL));	
	return FALSE;
}

//Meets the minimum requirements for the most basic enchantment
int MeetsMinimumRequirements(object oPC) {

	if (GetIsDM(oPC))
		return TRUE;

	object oItem = PS_GetLocalObject(oPC, "ObjectToEnchant");

	int nGold = 300; //minimum amount of gold for 1 point ability
	int nCL = 3; //minimum CL for 1 point ability
	
	int nPoints = GetItemTotalPoints(oItem, oPC);
	int nAllowed = GetItemTotalPointsAllowed(oItem);
	
	if (nPoints < nAllowed &&
	GetGold(oPC) > nGold &&
	GetRealCasterLevel(oPC, TRUE) >= nCL)
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
	int nPoints = GetItemTotalPoints(oItem, oPC);
	int nAllowed = GetItemTotalPointsAllowed(oItem);
	int bHasBaseReq = ((nPoints+enchant.points) <= nAllowed &&
	GetHasRequiredCasterLevel(oPC, nCL, feedback) &&
	GetHasRequiredGold(oPC, nGold, feedback) &&
	GetHasRequiredEssence(oPC, sEssence, feedback) && 
	GetHasRequiredGemstone(oPC, sGem, feedback) && 
	GetFulfillsSpecialRequirement(oPC, sReq, oItem));
	if (bHasBaseReq && enchant.add_essence != ""){
		if (!GetHasAddEssence(oPC, enchant.add_essence, enchant.essence))
			bHasBaseReq = FALSE;
	}
	return bHasBaseReq;
}

//Must be called after GetHasRequiredEssence and/or GetHasRequiredGemstone
//If you want it to take the correct essence / gemstone 
//Ideally called after CanEnchantItem
void TakeEnchantmentRequirements(object oPC, struct enchantment enchant) {

	int nGold = enchant.gold;
	TakeGoldFromCreature(nGold, oPC, TRUE, TRUE);
	object oGem = PS_GetLocalObject(oPC, "GemstoneToTake");
	if (GetIsObjectValid(oGem)) {
		string sTag = GetTag(oGem);
		TakeNumCraftingMaterials(oPC, sTag, 1);
	} else {
		SendMessageToPC(oPC, "no gem required");
	}
	object oEssence = PS_GetLocalObject(oPC, "EssenceToTake");
	if (GetIsObjectValid(oEssence)) {
		string sTag = GetTag(oEssence);
		TakeNumCraftingMaterials(oPC, sTag, 1);
	} 
	if (enchant.add_essence != ""){
		object oAddEssence = PS_GetLocalObject(oPC, "AddEssenceToTake");
		if (GetIsObjectValid(oAddEssence)) {
			string sAddTag = GetTag(oAddEssence);
			TakeNumCraftingMaterials(oPC, sAddTag, 1);
		} 
	}
	if (enchant.essence == "" && enchant.add_essence == "")
		SendMessageToPC(oPC, "no essence required");
		
}

int GetItemTotalPointsFrom2DA(object oItem, object oPC = OBJECT_INVALID){

	if (oPC == OBJECT_INVALID) oPC = OBJECT_SELF;
	
	int nPoints = 0; // this will be our ultimate return value. May as well set it up first thing.
	int nItem = GetBaseItemType(oItem);
	if (nItem == 111) nItem = 202; // there are 2 whip ids. The scod_craft_baseitems uses 202
	
	itemproperty ipMatPower;
	itemproperty ip;
	int nIpType;
	int nIpSub;
	string sTypeColumn = "IP_MELEE_TYPE";
	string sSubColumn =  "IP_MELEE_SUBTYPE";
	string sParamColumn = "IP_MELEE_PARAM";
	string sSpecColumn = "IP_M_SPECIAL";
	string sPointsColumn = "M_POINTS";
	int nIpMatType;
	int nIpMatSub;
	int nIpMatParam;
	int nIpMatSpec;
	string sMat2da = "";
	int nNumRows;
	int i;
	if (GetTag(oItem) == "nw_metalline") {
		sMat2da = "scod_craft_metal";
		nNumRows = GetNum2DARows(sMat2da);
		for (i = 0; i < nNumRows; i++){
			if (StringToInt(Get2DAString(sMat2da, "IP_DESCRIPTION_ID", i)) == SPECIAL_MAT_METALLINE){
				nIpMatType = StringToInt(Get2DAString(sMat2da, sTypeColumn, i));
				nIpMatSub = StringToInt(Get2DAString(sMat2da, sSubColumn, i));
				nIpMatParam = StringToInt(Get2DAString(sMat2da, sParamColumn, i));
				nIpMatSpec = StringToInt(Get2DAString(sMat2da, sSpecColumn, i));
				nPoints += StringToInt(Get2DAString(sMat2da, sPointsColumn, i));
				ipMatPower = IpArgsToItemProperty(nIpMatType, nIpMatSub, nIpMatParam,nIpMatSpec);
				break;
			}
		}
	} else {
		string sCat = "other"; // is this an armor, a ranged launcher, meleee/ammo/thrown, or other?
		string sLookupColumn = ""; // this and the one below will be used to find our item in scod_craft_baseitems
		int nLookupValue = NULL;
		if (nItem == 16){
			sCat = "armor";
			sLookupColumn = "ARMORSTAT_ID";
			nLookupValue = GetArmorRulesType(oItem);
			if (nLookupValue >= 42) sLookupColumn = "MITH_ARMORSTAT_ID"; // crafted mithral
		} else {
			sLookupColumn = "ID";
			// the 2da lists the quivers by the items they produce, not the quivers themselves
			switch(nItem){
				case 90: nLookupValue = 31; break; // dart quiver to dart
				case 91: nLookupValue = 63; break; // throwing axe quiver to taxe
				case 92: nLookupValue = 59; break; // shuriken quiver to shuriken
				case 93: nLookupValue = 20; break; // arrow quiver to arrow
				case 94: nLookupValue = 25; break; // bolt quiver to bolt
				case 95: nLookupValue = 27; break; // bullet quiver to bullet
				default: nLookupValue = nItem; break;
			}
			if (nItem == BASE_ITEM_SMALLSHIELD || nItem == BASE_ITEM_LARGESHIELD ||
				nItem == BASE_ITEM_TOWERSHIELD)
					sCat = "armor";
			else if (nItem == BASE_ITEM_SLING || nItem == BASE_ITEM_SHORTBOW || 
				nItem == BASE_ITEM_LONGBOW || nItem == BASE_ITEM_LIGHTCROSSBOW ||
				nItem == BASE_ITEM_HEAVYCROSSBOW)
					sCat = "launcher";
			else if (IPGetIsWeapon(OBJECT_INVALID, nItem) || IPGetIsProjectile(OBJECT_INVALID, nItem))
				sCat = "melee"; // ammo and thrown weapons also use the melee base mat powers
		}

		if (sCat != "other"){ // misc items do not have a material power, so don't try to find it 

			if (sCat == "armor"){
				sTypeColumn = "IP_ARMOR_TYPE";
				sSubColumn =  "IP_ARMOR_SUBTYPE";
				sParamColumn = "IP_ARMOR_PARAM";
				sSpecColumn = "IP_A_SPECIAL";
				sPointsColumn = "A_POINTS";
			} else if (sCat == "launcher"){
				sTypeColumn = "IP_RANGED_TYPE";
				sSubColumn =  "IP_RANGED_SUBTYPE";
				sParamColumn = "IP_RANGED_PARAM";
				sSpecColumn = "IP_R_SPECIAL";
				sPointsColumn = "R_POINTS";
			}
			
			if (sLookupColumn != "" && nLookupValue != NULL){
				nNumRows = GetNum2DARows("scod_craft_baseitems");
				for (i = 0; i < nNumRows; i++){
					if (StringToInt(Get2DAString("scod_craft_baseitems", sLookupColumn, i)) == nLookupValue){
						sMat2da = Get2DAString("scod_craft_baseitems", "MATERIAL_1", i);
						break;
					}
				}
			}
			if (sMat2da != ""){
				nNumRows = GetNum2DARows(sMat2da);
				ip = GetFirstItemProperty(oItem);
				int bFoundIp = FALSE;
				while (GetIsItemPropertyValid(ip) && !bFoundIp){
					nIpType = GetItemPropertyType(ip);
					if (nIpType == 100){
						nIpSub = GetItemPropertySubType(ip);
						for (i = 0; i < nNumRows; i++){
							if (StringToInt(Get2DAString(sMat2da, "IP_DESCRIPTION_ID", i)) == nIpSub){
								nPoints += StringToInt(Get2DAString(sMat2da, sPointsColumn, i));
								if (Get2DAString(sMat2da, sTypeColumn, i) != "****"){
									nIpMatType = StringToInt(Get2DAString(sMat2da, sTypeColumn, i));
									nIpMatSub = StringToInt(Get2DAString(sMat2da, sSubColumn, i));
									nIpMatParam = StringToInt(Get2DAString(sMat2da, sParamColumn, i));
									nIpMatSpec = StringToInt(Get2DAString(sMat2da, sSpecColumn, i));
									ipMatPower = IpArgsToItemProperty(nIpMatType, nIpMatSub, nIpMatParam, nIpMatSpec);
								}
								bFoundIp = TRUE;
								break;
							}
						}	
					}
					ip = GetNextItemProperty(oItem);
				}
			}
		}
	}

	struct synergyBonus dSynergy = GetItemMaterialSynergyBonus(oItem);
	itemproperty ipSynergy = dSynergy.ip;
	int nSynergyPoints = dSynergy.nPoints;
	struct xbowMechanicals dXbow = GetXbowMechanicals(oItem);
	itemproperty ipMechAim = dXbow.ipAim;
	itemproperty ipMechReload = dXbow.ipReload;
	itemproperty ipCrit = ItemPropertyKeen();
	if (nItem == BASE_ITEM_GLOVES) ipCrit = ItemPropertyBonusFeat(20);
	else if (IPGetIsLauncher(OBJECT_INVALID, nItem) || IPGetIsThrownWeapon(OBJECT_INVALID, nItem))
		ipCrit = GetImpCritItemPropertyForRanged(nItem);
	itemproperty ipWeight = ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_50_PERCENT);
	
	sTypeColumn = GetItemColumn(nItem); // the column in scodenchantments for a valid enchantment for this item, 0_Melee, etc
	struct enchantment eFrom2da; // the enchantment in scodenchantments that might be the one on our item
	itemproperty ipFrom2da; // the item property from above, we'll compare it to the one on the item
	int bFoundMatch; // boolean, did we find a matching enchantment?
	nNumRows = GetNum2DARows("scodenchantments");
	int nAddPoints;
	int bSkipIp; // boolean to skip an ip that we know is 0 points or specific points already added.
	ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip)){
		bSkipIp = FALSE;
		bFoundMatch = FALSE;
		nAddPoints = 0;
		nIpType = GetItemPropertyType(ip);
		nIpSub = GetItemPropertySubType(ip);
			
		//debug 
		/*
		string sDebug = "\nComparison\n";
		sDebug += "Item type: " + IntToString(nIpType);
		sDebug += ", 2da type: " +IntToString(GetItemPropertyType(ipFrom2da)) + "\n";
		sDebug += "Item sub: " +IntToString(GetItemPropertySubType(ip));
		sDebug += ", 2da sub: " +IntToString(GetItemPropertySubType(ipFrom2da)) + "\n";
		sDebug += "Item table: " +IntToString(GetItemPropertyCostTable(ip));
		sDebug += ", 2da table: " +IntToString(GetItemPropertyCostTable(ipFrom2da)) + "\n";
		sDebug += "Item num: " +IntToString(GetItemPropertyCostTableValue(ip));
		sDebug += ", 2da num: " +IntToString(GetItemPropertyCostTableValue(ipFrom2da)) + "\n";
		sDebug += "Item spec: " +IntToString(GetItemPropertyParam1Value(ip));
		sDebug += ", 2da spec: " +IntToString(GetItemPropertyParam1Value(ipFrom2da)) + "\n\n";					
		SendMessageToPC(oPC, sDebug);
		*/

		// skip temp enchantments like from light spell or magic vestment spell
		if (GetItemPropertyDurationType(ip) !=  DURATION_TYPE_PERMANENT)
			bSkipIp = TRUE;
		
		// "Forged Of" and Player-Made ips
		if (!bSkipIp && (nIpType == 100 || nIpType == 101))
			bSkipIp = TRUE; 
		
		// the special material power
		if (!bSkipIp && GetIsItemPropertyValid(ipMatPower)){
			if (IPGetItemPropertiesIdentical(ipMatPower, ip))
				bSkipIp = TRUE; // we've already added the points for the mat power
		}
		
		// skip the unique power self only on ammo and thrown quivers
		if (!bSkipIp && IPGetIsQuiver(OBJECT_INVALID, nItem) && nIpType == 15)
			bSkipIp = TRUE;
			
		// mighty property is redundant on slings because they get infinite mighty,
		// so add no points if a sling has mighty
		if (!bSkipIp && nIpType == 45 && nItem == BASE_ITEM_SLING)
			bSkipIp = TRUE;
		

		// reload and aim features granted by materials a crossbow is made with do not cost points
		// (because they don't grant any either)
		if (!bSkipIp && GetIsItemPropertyValid(ipMechReload)){
			if (IPGetItemPropertiesIdentical(ipMechReload, ip)) bSkipIp = TRUE;	
		}
		if (!bSkipIp && GetIsItemPropertyValid(ipMechAim)){
			if (IPGetItemPropertiesIdentical(ipMechAim, ip)) bSkipIp = TRUE;	
		}
		
		// synergy bonus
		if (!bSkipIp && GetIsItemPropertyValid(ipSynergy)){
			if (IPGetItemPropertiesIdentical(ipSynergy, ip)){
				nAddPoints += nSynergyPoints;
				bSkipIp = TRUE;
			}
		}
		
		// 50% weight reduction costs no points
		if (!bSkipIp){
			if (IPGetItemPropertiesIdentical(ipWeight, ip)) bSkipIp = TRUE;
		}
		
		// checking for keen/imp crit last in case it was already the matpower
		if (!bSkipIp && IPGetItemPropertiesIdentical(ipCrit, ip)){
				bSkipIp = TRUE;
		}
		
			// for reasons I don't understand there are 2 entries in iprp_feats
			// for each imp crit for ranged weapons, so we'll check for them all
		if (!bSkipIp && nIpType == 12){ // type 12 = bonus feat
			if ((nItem == BASE_ITEM_LONGBOW && (nIpSub == 59 || nIpSub == 1318)) ||
				(nItem == BASE_ITEM_SHORTBOW && (nIpSub == 60 || nIpSub == 1317)) ||
				(nItem == BASE_ITEM_HEAVYCROSSBOW && (nIpSub == 50 || nIpSub == 1320)) ||
				(nItem == BASE_ITEM_LIGHTCROSSBOW && (nIpSub == 51 || nIpSub == 1319)) ||
				(nItem == BASE_ITEM_SLING && (nIpSub == 57 || nIpSub == 1316)) ||
				((nItem == BASE_ITEM_DART || nItem == 90) && (nIpSub == 49 || nIpSub == 1321)) ||
				((nItem == BASE_ITEM_SHURIKEN || nItem == 92)&& (nIpSub == 77 || nIpSub == 1322)) ||
				((nItem == BASE_ITEM_THROWINGAXE || nItem == 91) && (nIpSub == 67 || nIpSub == 1323))){
				nAddPoints = 1;
				bSkipIp = TRUE;
			}
		}
		if (bSkipIp) bFoundMatch = TRUE;
		else {
			for (i = 0; i < nNumRows; i++){
				if (Get2DAString("scodenchantments", sTypeColumn, i) == "1" &&
					StringToInt(Get2DAString("scodenchantments", "Type", i)) == nIpType){
					
					eFrom2da = LoadEnchantment(i, oPC);
					ipFrom2da = EnchantmentIndexToItemProp(eFrom2da);
					
					//debug 
					/*
					string sDebug = "\nComparison\n";
					sDebug += "Item type: " + IntToString(nIpType);
					sDebug += ", 2da type: " +IntToString(GetItemPropertyType(ipFrom2da)) + "\n";
					sDebug += "Item sub: " +IntToString(GetItemPropertySubType(ip));
					sDebug += ", 2da sub: " +IntToString(GetItemPropertySubType(ipFrom2da)) + "\n";
					sDebug += "Item table: " +IntToString(GetItemPropertyCostTable(ip));
					sDebug += ", 2da table: " +IntToString(GetItemPropertyCostTable(ipFrom2da)) + "\n";
					sDebug += "Item num: " +IntToString(GetItemPropertyCostTableValue(ip));
					sDebug += ", 2da num: " +IntToString(GetItemPropertyCostTableValue(ipFrom2da)) + "\n";
					sDebug += "Item spec: " +IntToString(GetItemPropertyParam1Value(ip));
					sDebug += ", 2da spec: " +IntToString(GetItemPropertyParam1Value(ipFrom2da)) + "\n\n";					
					SendMessageToPC(oPC, sDebug);
					*/
					if (IPGetItemPropertiesIdentical(ip, ipFrom2da)){
						//debug
						//SendMessageToPC(oPC, "FOUND MATCH");
						bFoundMatch = TRUE;
						nAddPoints = StringToInt(Get2DAString("scodenchantments", "Points", i));
						break;
					}
				}
			}
			if (!bFoundMatch) nAddPoints = EstimateItemPropertyPointValue(ip);
		}
		if (nAddPoints > 6) nAddPoints = 6;
		else if (nAddPoints < 0) nAddPoints = 0;
		nPoints += nAddPoints;
		ip = GetNextItemProperty(oItem);
	}	
	return nPoints;
}


int GetItemTotalPoints(object oItem, object oPC = OBJECT_INVALID) {

	if (oPC == OBJECT_INVALID) oPC = OBJECT_SELF;
	if (CRAFT_DIRECT_FROM_2DA) return GetItemTotalPointsFrom2DA(oItem, oPC);

	string itemType = "";
	int nItem = GetBaseItemType(oItem);
	if (nItem == BASE_ITEM_ARMOR || 
	nItem == BASE_ITEM_SMALLSHIELD || 
	nItem == BASE_ITEM_LARGESHIELD || 
	nItem == BASE_ITEM_TOWERSHIELD) 
		itemType = "Armor";

	int nTotal = 0;
	itemproperty ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip)) {
		nTotal += GetItemPropertyPointValue(ip, itemType);
		ip = GetNextItemProperty(oItem);
	}
	return nTotal;
}


//Max number of enchantment points
int GetItemTotalPointsAllowed(object oItem) {
	// New Points:
	// All player-made items start with 10 points except launchers and ammo, which start at 8. loot
	// drop weapons have base 8. If a weapon has the player-made property "Cage-Forged", or if it is 
	// made with 3 special materials, then we know it's player-made and gets 10.
	/*
	int countSilver = FALSE;
	int nBase = 10; //later we can add higher point base for suboptimal items
	if (GetWeaponType(oItem) != WEAPON_TYPE_NONE || (GetBaseItemType(oItem) >= 93 && GetBaseItemType(oItem) <= 95)) 
	{ //Weapons/Quivers start at 8 points
		nBase = 8;
		countSilver = TRUE;
	}
	*/
	// there's no reason why we shouldn't always count cold iron and silver as special
	// even if it's not adding any properties of use, like in an amulet. It still cost more
	// than iron or brass so it's worth a point. We can just use conditionals at the end
	// to keep points in the allowed range, so idk why this is even here.
	int countSilver = TRUE; 
	int nBase = 10;
	int bIsThrownOrMelee = (IPGetIsMeleeWeapon(oItem) || IPGetIsThrownWeapon(oItem));
	// set all weapons to base 8, but player-made melee and thrown will get 2 added back at the end
	if (bIsThrownOrMelee || IPGetIsLauncher(oItem) || IPGetIsProjectile(oItem)) nBase = 8;
	int nNumMaterials = 0;
	itemproperty ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip)) {
		if (GetItemPropertyType(ip) == 100){
			if (GetIsPowerfulMaterial(GetItemPropertySubType(ip))) nNumMaterials++;
		}
		ip = GetNextItemProperty(oItem);
	}

	if (bIsThrownOrMelee){
		if (GetIsPlayerMade(oItem)) nBase += 2;
		else if (nNumMaterials >= 3){ // if it's made with 3 special materials we will assume it's a player-made from before this change
			nBase += 2;
			ApplyPlayerMade(oItem);
		}
	}

	if (nNumMaterials > 0) nNumMaterials -= 1;
	int nTotal = nBase + nNumMaterials;
	if (nTotal > nBase + 2) nTotal = nBase + 2;
	else if (nTotal < nBase) nTotal = nBase;
	return nTotal;
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
	if (nType == 101) return 0; // player-made
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


int GetIsAcEligibleBoots(object oItem){
	int nSub = 0;
	if (GetBaseItemType(oItem) == BASE_ITEM_BOOTS){
		int nMat = GetItemBaseMaterialType(oItem);
		if (nMat == 20 || nMat == 9 || nMat == 1) return TRUE;
		itemproperty ip = GetFirstItemProperty(oItem);
		while (GetIsItemPropertyValid(ip)){
			if (GetItemPropertyType(ip) == 100){
				nSub = GetItemPropertySubType(ip);
				// special mats for dragonhide are 22 - 26, Celestial, demon, 
				// and devil are 27 - 29, flesh golem is 57
				if ((nSub >= 22 && nSub <= 29) || nSub == 57) return TRUE; 	
			}
			ip = GetNextItemProperty(oItem);
		}
	}
	return FALSE;
}

int GetIsPlayerMade(object oItem){
	int ipType;
	int bRet = FALSE;
	itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip)){
		ipType = GetItemPropertyType(ip);
        if (ipType == 101){ // "Cage-Forged" property to denote a player-made item
			bRet = TRUE;
			break;
		} 
		ip = GetNextItemProperty(oItem);
    }
    return bRet;
}

void ApplyPlayerMade(object oItem){
	object oChest = GetObjectFromDMArea("pc_utility_ipchest");
	object oSpoon = CreateItemOnObject("ps_crft_utility_playermade", oChest);
	itemproperty ip = GetFirstItemProperty(oSpoon);
	DestroyObject(oSpoon, 1.0f);
	IPSafeAddItemProperty(oItem, ip);
}

string GetAdditionalEssenceReq(object oPC, int nPoints){
	//if (GetIsCraftingFree(oPC)) return "";
	if (nPoints < 0) nPoints = 0;
	else if (nPoints > 5) nPoints = 5;
	// in case they have some real caster levels, check to see if they would
	// be able to do the enchantment with those. If they can, then they don't
	// need the additional power essence
	int nReqCasterLevel = nPoints * 3;
	if (nReqCasterLevel < 3) nReqCasterLevel = 3;
	// Check caster level excluding calculation for Alchemical Infusion.
	// If they have suffient magical power of their own, bail without
	// setting an additional power essence requirement.
	if (GetRealCasterLevel(oPC, FALSE) >= nReqCasterLevel) return "";
	// else assign a power essence based on points of enchantment.
	// 1 point is free and sets no power essence.
	switch (nPoints){
		case 2: return "cft_ess_power1";
		case 3: return "cft_ess_power2";
		case 4: return "cft_ess_power3";
		case 5: return "cft_ess_power4";
		default: return "";
	}
	return "";
}


/* Moved to x2_inc_itemprops where they can be accessable to other scripts as well

//Is this a thrown weapon?
int IPGetIsThrownWeapon(object oItem)
{
  int nBT = GetBaseItemType(oItem);
  return (nBT == BASE_ITEM_DART || nBT == BASE_ITEM_SHURIKEN || nBT == BASE_ITEM_THROWINGAXE);
}

//Get is ammunition or ammunition quiver
int IPGetIsProjectile(object oItem) {
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

*/