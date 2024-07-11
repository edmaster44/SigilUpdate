
// FlattedFifth, June 30, 2024
// Script to check pc inventory for a specific items and either add or remove item properties.
// Edit FF_UpdateSingleLegacyItem() to add or remove any procedures.

#include "x2_inc_itemprop"

// function declarations
void FF_UpdateLegacyItems(object oPC);
void FF_ModifyItemProperty(object oItem, itemproperty ipProperty, int bAdd);


// Edit this function to perform whatever operations need to be done to correct erroneous items.
// This function is called from the function below it and should also be called from the on acquire 
// item event script x2_mod_def_aqu.nss
void FF_UpdateSingleLegacyItem(object oItem)
{
	// since multiple checks require knowing the res ref, we'll just get it here.
	string nRef = GetResRef(oItem);
	
	// nerf the sword saint armor
	if (nRef == "ps_itemset_swordsaint3")
	{
		FF_ModifyItemProperty(oItem, ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_SHIELD, 2), TRUE);
	}
	
	// change blackguard use limitation properties to knight blackguard path
	if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_BLACKGUARD), DURATION_TYPE_PERMANENT)) 
	{
		int idClassKnight = 6;
		FF_ModifyItemProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_BLACKGUARD), FALSE);
		FF_ModifyItemProperty(oItem, ItemPropertyLimitUseByClass(idClassKnight), TRUE);
		FF_ModifyItemProperty(oItem, ItemPropertyLimitUseByAlign(IP_CONST_ALIGNMENTGROUP_EVIL), TRUE);
	}
	
	//replace Red Dragon Disciple use limitation property with half dragon RPrC
	if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_DRAGONDISCIPLE), DURATION_TYPE_PERMANENT)) 
	{
		int idClassHalfDragon = 49;
		FF_ModifyItemProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_DRAGONDISCIPLE), FALSE);
		FF_ModifyItemProperty(oItem, ItemPropertyLimitUseByClass(idClassHalfDragon), TRUE);
	}
	
	// replace Dwarven Defender use limit with Stalwart Defender
	if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_DWARVENDEFENDER), DURATION_TYPE_PERMANENT))
	{
		int idClassStalwart = 180;
		FF_ModifyItemProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_DWARVENDEFENDER), FALSE);
		FF_ModifyItemProperty(oItem, ItemPropertyLimitUseByClass(idClassStalwart), TRUE);
	}
	
	// Fix darkvision helmets. Note that this requires my updated iprp_feats.2da to work properly because 
	// darkvision wasn't available as a bonus feat until I added it, so we'll do a little check and default to low 
	// light vision instead if darkvision isn't found. IPGetItemHasProperty() will not recognize ItempropertyDarkvision()
	// for some reason so we have to check for individual helms. -FlattedFifth
	if (nRef == "ps_luca_safetygoggles" || nRef == "ps_helmet_helmofdarkness" ) 
	{
		itemproperty ipdv = ItemPropertyDarkvision();
		// go ahead and remove item property darkvision since it doesn't work anyway. Its'a biobug
		FF_ModifyItemProperty(oItem, ipdv, FALSE);
		int nFeatId = 801;
		if (Get2DAString("iprp_feats", "FeatIndex", 438) == "228") nFeatId = 438; 
		FF_ModifyItemProperty(oItem, ItemPropertyBonusFeat(nFeatId), TRUE);
	}
}


// MAIN, cycles through all of PC's items and sends them to FF_UpdateSingleLegacyItem function.
// This should be called from the login script ps_onpcloaded.nss
void FF_UpdateLegacyItems(object oPC)
{
	int i = 0;
	object oItem;
	for (i = 0; i <= NUM_INVENTORY_SLOTS; i++)
	{
		oItem = GetItemInSlot(i, oPC);
		DelayCommand(0.3f, AssignCommand(oPC, FF_UpdateSingleLegacyItem(oItem)));
	}
    // Iterate through all items in the inventory
	i = 0;
	oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
		i++;
        FF_UpdateSingleLegacyItem(oItem);
        oItem = GetNextItemInInventory(oPC);
		// num of items a pc could have if inv full of full bags, including the bags
		if (i > 27072) return;
    }
}




// set bAdd to TRUE to add the item property, FALSE to remove it.
void FF_ModifyItemProperty(object oItem, itemproperty ipProperty, int bAdd)
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