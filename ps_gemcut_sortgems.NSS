#include "ps_inc_gemstones"

void main () {

	object oChest = OBJECT_SELF;
	if (GetLocalInt(oChest, "Initialized") > 0)
		return;
	
	object oGem = GetFirstItemInInventory(oChest);
	while (GetIsObjectValid(oGem)) {
	
		string sColor = GetGemstoneColor(oGem);
		int nNum = GetLocalInt(oChest, sColor+"_Num");
		SetLocalString(oChest, sColor+"_"+IntToString(nNum), GetTag(oGem));
		SetLocalInt(oChest, sColor+"_Num", nNum+1);
		oGem = GetNextItemInInventory(oChest);
	}
	SetLocalInt(oChest, "Initialized", 1);

}