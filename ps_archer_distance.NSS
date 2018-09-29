#include "nwnx_craft"

int GetIsArcaneArcherUpgraded(object oItem) {
	if (GetBaseItemType(oItem) >= 190 && GetBaseItemType(oItem) <= 194)
		return TRUE;
	return FALSE;
}

void UpgradeArcaneArcherBow(object oItem, object oPC) {
	int nNewValue = 0;
	if (GetBaseItemType(oItem) == BASE_ITEM_LONGBOW)
		nNewValue = 192;
	else if (GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW)
		nNewValue = 193;
	else if (GetBaseItemType(oItem) == BASE_ITEM_HEAVYCROSSBOW)
		nNewValue = 190;
	else if (GetBaseItemType(oItem) == BASE_ITEM_LIGHTCROSSBOW)
		nNewValue = 191;
	else if (GetBaseItemType(oItem) == BASE_ITEM_SLING)
		nNewValue = 194;
	XPCraft_SetItemProperty(oPC, oItem, "BaseItem", nNewValue);
	DelayCommand(0.2f, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
	
}

void DegradeArcaneArcherBow(object oItem, object oPC) {
	int nNewValue = 0;
	if (GetBaseItemType(oItem) == 192)
		nNewValue = BASE_ITEM_LONGBOW;
	else if (GetBaseItemType(oItem) == 193)
		nNewValue = BASE_ITEM_SHORTBOW;
	else if (GetBaseItemType(oItem) == 190)
		nNewValue = BASE_ITEM_HEAVYCROSSBOW;
	else if (GetBaseItemType(oItem) == 191)
		nNewValue = BASE_ITEM_LIGHTCROSSBOW;
	else if (GetBaseItemType(oItem) == 194)
		nNewValue = BASE_ITEM_SLING;
	XPCraft_SetItemProperty(oPC, oItem, "BaseItem", nNewValue);
	DelayCommand(0.2f, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
}

void main() {

	object oPC = OBJECT_SELF;
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
	if (!GetIsObjectValid(oItem))
		return;
	
	if (!GetWeaponRanged(oItem)) {
		return;
	}
	
	SendMessageToPC(oPC, "This ability has been temporarily disabled due to bugs! When the bugs are fixed, it will become an on-equip ability, as stated in its description.");
	
	/*if (!GetHasFeat(2764, oPC) && GetIsArcaneArcherUpgraded(oItem)) {
		DegradeArcaneArcherBow(oItem, oPC);
		return;
	}
	if (GetHasFeat(2764, oPC) && !GetIsArcaneArcherUpgraded(oItem)) {
		UpgradeArcaneArcherBow(oItem, oPC);
		return;
	}*/
}