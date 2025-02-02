#include "ff_safevar"

#include "ps_inc_newenchanting"

void main (string sNum) {

	object oPC = OBJECT_SELF;
	int nIndex = StringToInt(sNum);
	object oItem = PS_GetLocalObject(oPC, "ObjectToEnchant");
	
	PS_SetLocalInt(oPC, "EnchantmentToApply", nIndex);
	
	struct enchantment enchant = LoadEnchantment(nIndex, oPC);
	
	if (!CanEnchantItem(oPC, oItem, enchant, FALSE)) {
		SetGUIObjectDisabled(oPC, sEnchantingScreen, "ENCHANT_ITEM", TRUE);
	} else {
		SetGUIObjectDisabled(oPC, sEnchantingScreen, "ENCHANT_ITEM", FALSE);
	}
	
	GenerateEnchantmentRequirementsList(oPC, enchant, oItem);

}