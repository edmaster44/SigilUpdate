#include "ps_inc_newenchanting"
#include "dethia_shop_sys"

void PlayEnchantAnimation(object oPC) {

	PlayCustomAnimation(oPC, "def_cast", FALSE, 1.0f);
	
}

void PlayIdleAnimation(object oPC) {

	PlayCustomAnimation(oPC, "idle", TRUE, 1.0f);
	
}


void main () {

	object oPC = OBJECT_SELF;
	object oItem = GetLocalObject(oPC, "ObjectToEnchant");
	int nIndex = GetLocalInt(oPC, "EnchantmentToApply");
	
	object oBench = GetNearestEnchantingWorkbench(oPC);
	if (!GetIsObjectValid(oBench)) {
		effect eEffect = EffectNWN2SpecialEffectFile("fx_craft_magic");
		ApplyEffectAtLocation(0, eEffect, GetLocation(oBench));
	}
	
	//Clearing any saved objects so it doesn't get confused
	DeleteLocalObject(oPC, "GemstoneToTake");
	DeleteLocalObject(oPC, "EssenceToTake");
	
	struct enchantment enchant = LoadEnchantment(nIndex, oPC);
	
	if (CanEnchantItem(oPC, oItem, enchant)) {
		TakeEnchantmentRequirements(oPC, enchant);
		EnchantItem(oItem, enchant);
		SetLocalInt(oItem, "PRICE_DIRTY", 1);
		if (!CRAFT_DIRECT_FROM_2DA) SetItemCostVariables(oItem);
	}
	
	DisplayItemDescription(oPC, oItem);
	
	PlayEnchantAnimation(oPC);
	DelayCommand(1.0f, PlayIdleAnimation(oPC));
}