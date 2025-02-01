#include "ff_safevar"

#include "ginc_param_const"
#include "ginc_item"
#include "dethia_shop_sys"

object GetStoreFromStoreArea(string sTag)
{
	int iStoreArea = PS_GetGlobalInt("STORE_AREA");
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

void main(string sTag)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	DS_OpenShop(GetStoreFromStoreArea(sTag), oPC);
}