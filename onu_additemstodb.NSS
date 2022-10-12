#include "dethia_shop_sys"

void UpdateItem(object oItem, object oPC);

void main() {

	object oPC = GetLastUsedBy();
	
	string sTarget = GetLocalString(OBJECT_SELF, "TARGET");
	if (sTarget == "")
		sTarget = "item_addition_chest";

	object oChest = GetNearestObjectByTag(sTarget);
	float fDelay = 0.01f;
	
	object oItem = GetFirstItemInInventory(oChest);
	while (GetIsObjectValid(oItem)) {
	
		DelayCommand(fDelay, UpdateItem(oItem, oPC));
		fDelay += 0.1f;
		
		//DestroyObject(oItem, 0.5f);
	
		oItem = GetNextItemInInventory(oChest);
	}

}

void UpdateItem(object oItem, object oPC) {
	string sName = GetName(oItem);
	string sTag = GetResRef(oItem);
	int nPrice = GetCostOfItem(oItem, oPC);
	int nOldPrice = GetGoldPieceValue(oItem);
	
	if (!GetItemInDB(oItem)) {
		string sQuery = "INSERT INTO item_prices SET item_name='"+sName+"', item_tag='"+sTag+"', item_price='"+IntToString(nPrice)+"', item_oldvalue='"+IntToString(nOldPrice)+"'";
		SQLExecDirect(sQuery);
	} else {
		string sQuery = "UPDATE item_prices SET item_name='"+sName+"', item_price='"+IntToString(nPrice)+"', item_oldvalue='"+IntToString(nOldPrice)+"' WHERE item_tag='"+sTag+"'";
		SQLExecDirect(sQuery);
	}
}