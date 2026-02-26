

#include "ps_inc_newenchanting"

void main (string sNum) {

	object oPC = OBJECT_SELF;
	int nIndex = StringToInt(sNum);
	object oItem = GetLocalObject(oPC, "ObjectToEnchant");
	
	SetLocalInt(oPC, "EnchantmentToApply", nIndex);
	
	struct enchantment enchant = LoadEnchantment(nIndex, oPC);
	int bOkToEnchant = FALSE;
	// On test server crafting and enchanting is free and requires no skills or feats unless
	// player has turned on cost testing with the chat command #testcraftcost and ofc free for dms
	if ((GetLocalInt(GetModule(), "SIGIL_DEV_MODE") && !GetLocalInt(oPC, "TestCraftCost")) ||
		GetIsDM(oPC) || GetIsDMPossessed(oPC)){
		 bOkToEnchant = TRUE;
	} else if (CanEnchantItem(oPC, oItem, enchant, FALSE)){
		bOkToEnchant = TRUE;
	}
	
	if (bOkToEnchant){
		SetGUIObjectDisabled(oPC, sEnchantingScreen, "ENCHANT_ITEM", FALSE);
	} else {
		SetGUIObjectDisabled(oPC, sEnchantingScreen, "ENCHANT_ITEM", TRUE);
	}
	
	GenerateEnchantmentRequirementsList(oPC, enchant, oItem);

}