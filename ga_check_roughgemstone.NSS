#include "ff_safevar"

//Checks if you have a rough gemstone, and set a local int if so
//This can be kind of a heavy function, hence its inclusion as an action
//instead of a conditional

void main()
{
	object oPC = GetPCSpeaker();
	PS_DeleteLocalInt(oPC, "hasrough");
	
	object oItem = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(oItem)) {
	
		if (GetBaseItemType(oItem) == BASE_ITEM_GEM) {
			string sTag = GetTag(oItem);
			if (FindSubString(sTag, "gemstone_rough") >= 0) { //is a rough gemstone
				PS_SetLocalInt(oPC, "hasrough", 1);
				break;
			}
		}
	
		oItem = GetNextItemInInventory(oPC);
	}
	
}