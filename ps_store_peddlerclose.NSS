#include "ps_inc_gemstones"
//Removes non-crafting items from the store so they don't torment players
void main () {

	object oItem = GetFirstItemInInventory(OBJECT_SELF);
	while (GetIsObjectValid(oItem)) {
	
		if (!GetIsGemstone(oItem) && GetBaseItemType(oItem) != BASE_ITEM_CRAFTMATERIALMED && GetBaseItemType(oItem) != BASE_ITEM_CRAFTMATERIALSML)
			DestroyObject(oItem, 0.1f);
	
		oItem = GetNextItemInInventory(OBJECT_SELF);
	}

}