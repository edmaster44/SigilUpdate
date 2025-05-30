

// ga_open_store
/*
	Opens store with tag sTag for the PC Speaker.  
	nMarkUp/nMarkDown are a percentage value that modifies the base price for an item.
	Function also adds or subtracts numbers to the markup and markdown values depending on the result of the appraise skill check.
*/
// ChazM 5/9/06 - changed to gplotAppraiseOpenStore
// ChazM 8/30/06 - new appraise open store function used.
// Replaced appraise function - Agony_Aunt/Loki_999 for SCoD.

//#include "ginc_misc"
//#include "nw_i0_plot"
#include "ginc_param_const"
#include "ginc_item"
#include "dethia_shop_sys"

object GetStoreFromStoreArea(string sTag)
{
	int iStoreArea = GetGlobalInt("STORE_AREA");
	object oStoreArea = IntToObject(iStoreArea);
	
	object oStore = GetFirstObjectInArea(oStoreArea);
	
	while (GetTag(oStore) != sTag && oStore != OBJECT_INVALID)
	{
		oStore = GetNextObjectInArea(oStoreArea);
	}
	
	// just in case someone drops a store outside the store area, it will still work.
	if (oStore == OBJECT_INVALID) {	oStore = GetTarget(sTag); }
	
	return oStore;
}

void main(string sTag, int nMarkUp, int nMarkDown)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	object oStore = GetStoreFromStoreArea(sTag);
	//AddAllItemsInStoreToDatabase(oStore, oPC);
	
	DS_OpenShop(oStore, oPC, 0, 0);
}