#include "ps_inc_treasuregeneration"

void TestPointValue(object oPC, object oItem) {

	string itemType = "";
	if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR || 
	GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD || 
	GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD || 
	GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) 
		itemType = "Armor";

	SendMessageToPC(oPC, "********************************");
	SendMessageToPC(oPC, "Item: "+GetName(oItem));
	itemproperty ip = GetFirstItemProperty(oItem);
	int nPoints = 0;
	while (GetIsItemPropertyValid(ip)) {
		//Debugging sql info
		string sProp = GetItemPropertyString(ip);
		int nOfficialValue = GetItemPropertyPointValue(ip, itemType);
		
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
			sQuery += "AND Special='"+IntToString(nSpecial)+"'"; 
			
		//Is this armor? Because if so, enchanting AC is supposed to be cheaper, so check for armor recipe!
		if (itemType == "Armor" && nType == 1) {
			sQuery += " AND Armor='1'";
		}	
			
		SQLExecDirect(sQuery);	
		SendMessageToPC(oPC, "SQL Debug: "+sQuery);
		while (SQLFetch() != SQL_ERROR) {
			int Point = StringToInt(SQLGetData(1));
			SendMessageToPC(oPC, "Points found: "+IntToString(Point));
			break;
		}
	
		nPoints += nOfficialValue;
		SendMessageToPC(oPC, sProp+": "+IntToString(nOfficialValue));
		ip = GetNextItemProperty(oItem);
	}
	SendMessageToPC(oPC, "Total Points: "+IntToString(nPoints));
	SendMessageToPC(oPC, "********************************");

}

void main () {

	object oPC = GetLastUsedBy();
	
	SendMessageToPC(oPC, "Creating manuals: ");
	CreateEnchantmentManualOnTarget(oPC);
	
	SendMessageToPC(oPC, "Creating gemstones: ");
	CreateGemOnTarget(oPC, TREASURE_LOW);
	CreateGemOnTarget(oPC, TREASURE_LOW);
	CreateGemOnTarget(oPC, TREASURE_LOW);
	
	int n = 0;
	for (n = 0; n < NUM_INVENTORY_SLOTS; n++) {
		object oItem = GetItemInSlot(n, oPC);
		if (GetIsObjectValid(oItem)) {
			int nMax = GetItemTotalPointsAllowed(oItem, oPC);
			SendMessageToPC(oPC, "max points allowed: "+IntToString(nMax));
			TestPointValue(oPC, oItem);
		}
	}

}