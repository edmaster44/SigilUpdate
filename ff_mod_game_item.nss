
// FlattedFifth, June 9, 2024
// Script to check pc inventory for a specific item and either add or remove a designated
// item property, such as adding an ac penalty or removing an enchancement bonus.
// arguements oPC = the PC, sResRef = the string reference of the item, 
// itemproperty = the property to be added or removed, ex ItemPropertyACBonus(-2),
// Add = a boolean style integer. Set to TRUE if you want to add a property and FALSE
// if you want to remove it

// declaration of helper function
void ff_mod_it(object oItem, itemproperty ipProperty, int bAdd);

// main function
void ff_mod_game_item(object oPC, string sResRef, itemproperty ipProperty, int bAdd)
{
    object oItem = GetFirstItemInInventory(oPC);

    // Iterate through all items in the inventory
    while (GetIsObjectValid(oItem))
    {
        // Check if the item's ResRef matches
        if (GetResRef(oItem) == sResRef)
        {
            ff_mod_it(oItem, ipProperty, bAdd);
        }
        oItem = GetNextItemInInventory(oPC);
    }
}

void ff_mod_it(object oItem, itemproperty ipProperty, int bAdd)
{
	int hasIpProperty = FALSE;
	itemproperty ip = GetFirstItemProperty(oItem);
	
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == GetItemPropertyType(ipProperty) && GetItemPropertySubType(ip) == GetItemPropertySubType(ipProperty))
        {
            hasIpProperty = TRUE;
			break;
        }
        ip = GetNextItemProperty(oItem);
    }
	if (bAdd == TRUE && hasIpProperty == FALSE)
	{
		AddItemProperty(DURATION_TYPE_PERMANENT, ipProperty, oItem);
	}
	else if (bAdd == FALSE && hasIpProperty == TRUE)
	{
		RemoveItemProperty(oItem, ipProperty);
	}
}