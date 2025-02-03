#include "ps_inc_gemstones"
#include "ps_inc_time"
//Removes non-crafting items from the store so they don't torment players
//12-2-18 - added delay in case you change your mind about an item
void main () {

	int nWaitTime = 3600; //60 minute delay
	object oItem = GetFirstItemInInventory(OBJECT_SELF);
	while (GetIsObjectValid(oItem)) {
	
		int nCurrentTime = PS_GetTime();
		if (!GetIsGemstone(oItem) && GetBaseItemType(oItem) != BASE_ITEM_CRAFTMATERIALMED && GetBaseItemType(oItem) != BASE_ITEM_CRAFTMATERIALSML) {
			int nTimestamp = GetLocalInt(oItem,"MTS");	
			if (nTimestamp > 0 && nCurrentTime-nTimestamp > nWaitTime) {
				DestroyObject(oItem, 0.1f);
			} else {
				SetLocalInt(oItem, "MTS", nCurrentTime);
			}
		}
	
		oItem = GetNextItemInInventory(OBJECT_SELF);
	}

}