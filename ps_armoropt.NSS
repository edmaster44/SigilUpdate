#include "ps_inc_equipment"

void main() {

	object oPC				= OBJECT_SELF;
	object oItem			= GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	
	HeavyArmorOptimizations(oPC, oItem);
	
}