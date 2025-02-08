#include "ff_safevar"

// Script for the thrown weapon sets
// Destroys the created weapons if the set is lost.
// By Electrohydra
// michel.remillard1@gmail.com

// Created 02/12/2018
// Last Edit 02/12/2018
void main()
{
    // * This code runs when the item is unacquired
    object oPC      = GetModuleItemLostBy();
    object oItem    = GetModuleItemLost();

 	// First, destroy any thrown weapons previously created by this.
	int id = PS_GetLocalInt(oItem, "id");
	if (id == 0) { id = -1; }
	
	object iEquipped = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (PS_GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
	iEquipped = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
	if (PS_GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
	iEquipped = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
	if (PS_GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
	iEquipped = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
	if (PS_GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
		
	object iInventory = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(iInventory))
	{
		if (PS_GetLocalInt(iInventory, "returningthrownid") == id) {
			DestroyObject(iInventory, 0.0f, FALSE); }
		iInventory = GetNextItemInInventory(oPC);
	}	
}