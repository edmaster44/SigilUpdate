void main () {
	
	//chest_crafting_materials
	object oPC = GetLastUsedBy();
	object oChest = GetNearestObjectByTag("chest_crafting_materials");
	
	object oItem = GetFirstItemInInventory(oChest);
	while(GetIsObjectValid(oItem)) {
	
		CopyItem(oItem, oPC, TRUE);
		oItem = GetNextItemInInventory(oChest);
		
	}

}