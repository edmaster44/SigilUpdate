

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
	int id = GetLocalInt(oItem, "id");
	if (id == 0) { id = -1; }
	
	object iEquipped = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
	iEquipped = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
	if (GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
	iEquipped = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
	if (GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
	iEquipped = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
	if (GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
		
	object iInventory = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(iInventory))
	{
		if (GetLocalInt(iInventory, "returningthrownid") == id) {
			DestroyObject(iInventory, 0.0f, FALSE); }
		iInventory = GetNextItemInInventory(oPC);
	}	
}