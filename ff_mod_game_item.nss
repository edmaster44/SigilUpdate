
// FlattedFifth, June 9, 2024
// Script to check pc inventory for a specific item and either add or remove a designated
// item property, such as adding an ac penalty or removing an enchancement bonus.
// arguements oPC = the PC, sResRef = the string reference of the item, 
// itemproperty = the property to be added or removed, ex ItemPropertyACBonus(-2),
// Add = a boolean style integer. Set to TRUE if you want to add a property and FALSE
// if you want to remove it

#include "x2_inc_itemprop"

// declaration of helper function
void FF_ModifyItem(object oItem, itemproperty ipProperty, int bAdd);


// main function
void FF_ModifyGameItem(object oPC, string sResRef, itemproperty ipProperty, int bAdd)
{
	object oItem;

    oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
	if (GetResRef(oItem) == sResRef) 
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
	if (GetResRef(oItem) == sResRef) 
	{
		
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC);
	if (GetResRef(oItem) == sResRef)
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	if (GetResRef(oItem) == sResRef) 
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
	if (GetResRef(oItem) == sResRef) 
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
	if (GetResRef(oItem) == sResRef) 
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	if (GetResRef(oItem) == sResRef)
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC);
	if (GetResRef(oItem) == sResRef) 
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_NECK, oPC);
	if (GetResRef(oItem) == sResRef) 
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (GetResRef(oItem) == sResRef) 
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
	if (GetResRef(oItem) == sResRef)
	{
		DelayCommand(0.3f, AssignCommand(oPC,FF_ModifyItem(oItem, ipProperty, bAdd)));
	}

    oItem = GetFirstItemInInventory(oPC);

    // Iterate through all items in the inventory
    while (GetIsObjectValid(oItem))
    {
        // Check if the item's ResRef matches
        if (GetResRef(oItem) == sResRef)
        {
            FF_ModifyItem(oItem, ipProperty, bAdd);
        }
        oItem = GetNextItemInInventory(oPC);
    }
}

void FF_ModifyItem(object oItem, itemproperty ipProperty, int bAdd)
{
	if (bAdd == TRUE)
	{
		IPSafeAddItemProperty(oItem, ipProperty, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	else
	{
		int ipType = GetItemPropertyType(ipProperty);
		int ipSubType = GetItemPropertySubType(ipProperty);
		IPRemoveMatchingItemProperties(oItem, ipType, DURATION_TYPE_PERMANENT, ipSubType);
	}
	
}