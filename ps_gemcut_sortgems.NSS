#include "ff_safevar"

#include "ps_inc_gemstones"

void main () {

	object oChest = OBJECT_SELF;
	if (PS_GetLocalInt(oChest, "Initialized") > 0)
		return;
	
	object oGem = GetFirstItemInInventory(oChest);
	while (GetIsObjectValid(oGem)) {
	
		string sColor = GetGemstoneColor(oGem);
		int nNum = PS_GetLocalInt(oChest, sColor+"_Num");
		PS_SetLocalString(oChest, sColor+"_"+IntToString(nNum), GetTag(oGem));
		PS_SetLocalInt(oChest, sColor+"_Num", nNum+1);
		oGem = GetNextItemInInventory(oChest);
	}
	PS_SetLocalInt(oChest, "Initialized", 1);

}