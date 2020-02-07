//Checks if you have a rough gemstone, and set a local int if so
//This can be kind of a heavy function, hence its inclusion as an action
//instead of a conditional

#include "ps_inc_gemstones"
void main()
{
	object oPC = GetPCSpeaker();
	DeleteLocalInt(oPC, "hasrough");
	
	object oItem = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(oItem)) {
	
		if (GetBaseItemType(oItem) != BASE_ITEM_GEM)
			continue;
		string sTag = GetTag(oItem);
		SendMessageToPC(oPC, "checking: "+sTag);
		if (FindSubString(sTag, "gemstone_rough") >= 0) { //is a rough gemstone
			SendMessageToPC(oPC, sTag+" is a rough gemstone.");
			SetLocalInt(oPC, "hasrough", 1);
			break;
		} else {
			SendMessageToPC(oPC, sTag+" is not a rough gemstone.");
		}
	
		oItem = GetNextItemInInventory(oPC);
	}
	
	SendMessageToPC(oPC, "Has a rough gemstone? "+IntToString(GetLocalInt(oPC, "hasrough")));
	
}