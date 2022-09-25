#include "dethia_shop_sys"
#include "ps_inc_newenchanting"
#include "ps_inc_newcrafting"

//Get the cost of an item property
int GetCostOfProperty(itemproperty iProp, object oPC = OBJECT_INVALID);

int GetCostOfItem(object oItem, object oPC = OBJECT_INVALID);

int GetCostOfItemByString(string sItem, object oPC = OBJECT_INVALID);

void main() {

	object oPC = GetLastUsedBy();

	object oChest = GetNearestObjectByTag("item_addition_chest");
	
	object oItem = GetFirstItemInInventory(oChest);
	while (GetIsObjectValid(oItem)) {
	
		string sName = GetName(oItem);
		string sTag = GetResRef(oItem);
		int nPrice = GetCostOfItem(oItem, oPC);
		int nOldPrice = GetGoldPieceValue(oItem);
		
		if (!GetItemInDB(oItem)) {
			string sQuery = "INSERT INTO item_prices SET item_name='"+sName+"', item_tag='"+sTag+"', item_price='"+IntToString(nPrice)+"', item_oldvalue='"+IntToString(nOldPrice)+"'";
			SQLExecDirect(sQuery);
		}
		
		//DestroyObject(oItem, 0.5f);
	
		oItem = GetNextItemInInventory(oChest);
	}

}

int GetCostOfItemByString(string sItem, object oPC = OBJECT_INVALID) {

	string sQuery = "SELECT item_price FROM item_prices WHERE item_tag = '"+sItem+"'";
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) {
		int nCost = StringToInt(SQLGetData(1));
		return nCost;
	}
	return FALSE;

}

int GetCostOfItem(object oItem, object oPC = OBJECT_INVALID) {

	int nCost = 0;
	itemproperty iProp = GetFirstItemProperty(oItem);
	
	if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Get cost for: "+GetName(oItem));
	
	while(GetIsItemPropertyValid(iProp)) {
	
		nCost += GetCostOfProperty(iProp, oPC);
	
		iProp = GetNextItemProperty(oItem);
	}
	if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Final cost for "+GetName(oItem)+": "+IntToString(nCost));
	
	if (nCost <= 10)
		return GetGoldPieceValue(oItem);
	
	return nCost;

}

int GetCostOfProperty(itemproperty iProp, object oPC = OBJECT_INVALID) {

	int iType = GetItemPropertyType(iProp);
	int iSub = GetItemPropertySubType(iProp);
	int iParam = GetItemPropertyCostTableValue(iProp);
	int iSpecial = GetItemPropertyParam1Value(iProp);
	
	//Special Material
	if (iType == 100) {
		int costTier = GetCostTierOfMaterial(iProp);
		if (costTier > 0)
			return costTier*1000;
		return 1000;
	}
	
	string sQuery = "SELECT Recipe_Id, Points, Gold, Essence, Gemstone FROM recipes WHERE Type='"+IntToString(iType)+"' AND Subtype='"+IntToString(iType)+"' AND Numerical='"+IntToString(iParam)+"' AND Special='"+IntToString(iSpecial)+"'";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() != SQL_ERROR) {
		int enchant_id = StringToInt(SQLGetData(1));
		int points = StringToInt(SQLGetData(2));
		int gold =StringToInt(SQLGetData(3));
		string sEssence = SQLGetData(4);
		string sGem = SQLGetData(5);
		
		int nQReq = StringToInt(GetSubString(sGem, GetStringLength(sGem)-1, 1));
		nQReq = nQReq-1;
		
		int nGemCost = 100;
		if (nQReq >= 2)
			nGemCost = 3000;
		else if (nQReq >= 1)
			nGemCost = 1000;
		
		if (enchant_id > 0) {
			int nCost = gold*2;
			nCost += GetCostOfItemByString(sEssence);
			nCost += nGemCost;
			
			if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetItemPropertyString(iProp)+" - Success / generated price: "+IntToString(nCost));
			return nCost;
		} else {
			if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetItemPropertyString(iProp)+" - Failed / Not found: "+sQuery);
		}
	} else {
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetItemPropertyString(iProp)+" - Failed: "+sQuery);
	}
		
	return FALSE;
}