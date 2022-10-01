#include "dethia_shop_sys"

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
		} else {
			string sQuery = "UPDATE item_prices SET item_name='"+sName+"', item_price='"+IntToString(nPrice)+"', item_oldvalue='"+IntToString(nOldPrice)+"' WHERE item_tag='"+sTag+"'";
			SQLExecDirect(sQuery);
		}
		
		//DestroyObject(oItem, 0.5f);
	
		oItem = GetNextItemInInventory(oChest);
	}

}
