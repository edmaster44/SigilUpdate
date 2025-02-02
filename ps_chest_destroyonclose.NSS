#include "ff_safevar"

void main()
{
	object oChest = OBJECT_SELF;
	object oItem = GetFirstItemInInventory(oChest);
	
	//If the looting was denied, don't destroy!
	if (PS_GetLocalInt(OBJECT_SELF, "LOOT_CANCELED") > 0) {
		PS_SetLocalInt(OBJECT_SELF, "LOOT_CANCELED", 0);
		return;
	}
	
	if(!GetIsObjectValid(oItem))
    {
        SetPlotFlag(oChest, FALSE);
        DestroyObject(oChest);
    }
}