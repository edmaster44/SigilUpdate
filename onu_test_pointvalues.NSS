#include "ps_inc_treasuregeneration"

void TestPointValue(object oPC, object oItem) {

	SendMessageToPC(oPC, "********************************");
	SendMessageToPC(oPC, "Item: "+GetName(oItem));
	itemproperty ip = GetFirstItemProperty(oItem);
	int nPoints = 0;
	while (GetIsItemPropertyValid(ip)) {
		//Debugging sql info
		string sProp = GetItemPropertyString(ip);
		int nOfficialValue = GetItemPropertyPointValue(ip);
		
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
	CreateEnchantmentManualOnTarget(oPC);
	CreateEnchantmentManualOnTarget(oPC);
	CreateEnchantmentManualOnTarget(oPC);
	CreateEnchantmentManualOnTarget(oPC);
	
	SendMessageToPC(oPC, "Creating gemstones: ");
	CreateGemOnTarget(oPC, TREASURE_LOW);
	CreateGemOnTarget(oPC, TREASURE_LOW);
	CreateGemOnTarget(oPC, TREASURE_LOW);
	CreateGemOnTarget(oPC, TREASURE_LOW);
	CreateGemOnTarget(oPC, TREASURE_LOW);
	CreateGemOnTarget(oPC, TREASURE_LOW);
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