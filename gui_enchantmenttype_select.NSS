#include "ff_safevar"

#include "ps_inc_newenchanting"

void main (string sNum) {

	object oPC = OBJECT_SELF;
	
	//Clear Enchantment. Picking new type here
	PS_DeleteLocalInt(oPC, "EnchantmentToApply");
	//Clear Requirement List
	SetGUIObjectText(oPC, sEnchantingScreen, "ENCHANTING_ITEM_REQUIREMENTS", -1, "");
	
	int nIndex = StringToInt(sNum);
	
	struct enchantment enchant = LoadEnchantment(nIndex, oPC);
	GenerateParamTypeList(oPC, enchant);
	
}

