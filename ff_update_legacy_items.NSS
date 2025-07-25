
// FlattedFifth, June 30, 2024
// Script to check pc inventory for a specific items and either add or remove item properties.
// Edit FF_UpdateSingleLegacyItem() to add or remove any procedures.

#include "x2_inc_itemprop"
#include "x2_inc_craft"
#include "dmfi_inc_const"

// function declarations
void FF_UpdateLegacyItems(object oPC);
void FF_ModifyItemProperty(object oItem, itemproperty ipProperty, int bAdd = FALSE);


// Edit this function to perform whatever operations need to be done to correct erroneous items.
// This function is called from the function below it and should also be called from the on acquire 
// item event script x2_mod_def_aqu.nss
void FF_UpdateSingleLegacyItem(object oPC, object oItem){
	// since multiple checks require knowing the res ref, we'll just get it here.
	string sRef = GetResRef(oItem);
	
	//ditto base item type
	int nType = GetBaseItemType(oItem);
	
	object oNewItem;
	
	// replace banned items with their counterparts
	string sNewRes = "";
	if (sRef == "ps_gad_dreadaxe") sNewRes = "ps_gad_dreadaxe2";
	else if (sRef == "ps_xbow_chokuno") sNewRes = "ps_xbow_chokuno2";
	else if (sRef == "ps_gad_serene") sNewRes = "ps_gad_serene2";
	else if (sRef == "ps_longsword_wideblade") sNewRes = "ps_longsword_wideblade2";
	else if (sRef == "ps_katana_momentum") sNewRes = "ps_katana_momentum2";
	else if (sRef == "ps_qstaff_philosophysolidified") sNewRes = "ps_qstaff_philosophysolidified2";
	else if (sRef == "ps_ed_bloodcleaver") sNewRes = "ps_ed_bloodcleaver2";
	else if (sRef == "ps_wmace_cripplinghammer") sNewRes = "ps_wmace_cripplinghammer2";
	else if (sRef == "ps_luca_rukus") sNewRes = "ps_luca_rukus2";
	else if (sRef == "ps_luca_sunlightseeker") sNewRes = "ps_luca_sunlightseeker2";
	else if (sRef == "ps_boots_avoidance") sNewRes = "ps_boots_avoidance1";
	if (sNewRes != ""){
		oNewItem = CreateItemOnObject(sNewRes, oPC);
		DelayCommand(0.5f, SendMessageToPC(oPC, "Replacing banned item '" + sRef + "' with " + sNewRes));
		if (GetIsObjectValid(oNewItem)) DestroyObject(oItem);
		else {
			SendMessageToPC(oPC, "Error replacing banned item. Please contact a DM");
			return;
		}
	}
	
	// New version of alertness works when chosen via lvl or granted by 2da, 
	// but not as an item property so just remove both versions from
	// items until Dae can fix the alerness constitution AC bug
	itemproperty ipOldAlert = ItemPropertyBonusFeat(0);
	itemproperty ipNewAlert = ItemPropertyBonusFeat(1324);
	if (IPGetItemHasProperty(oItem, ipOldAlert, DURATION_TYPE_PERMANENT)){
		FF_ModifyItemProperty(oItem, ipOldAlert);
	}
	if (IPGetItemHasProperty(oItem, ipNewAlert, DURATION_TYPE_PERMANENT)){
		FF_ModifyItemProperty(oItem, ipNewAlert);
	}


	// make sure scrolls and wands are usuable by all classes that have the same spellbook or 
	// are supposed to be allowed to use scrolls and wands of another spellbook
	if (nType == 102 || nType == 105 || nType == 103 || nType == 106){
		// make sure fs can use cleric and vice versa, also make knight able if boolean set
		if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_CLERIC), DURATION_TYPE_PERMANENT) ||
		IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_FAVORED_SOUL), DURATION_TYPE_PERMANENT)){
			MakeItemUseableByClass(CLASS_TYPE_FAVORED_SOUL, oItem); // checks for existing before adding
			MakeItemUseableByClass(CLASS_TYPE_CLERIC, oItem);
			if (B_KNIGHT_USE_CLERIC_WANDSCROLL) MakeItemUseableByClass(CLASS_TYPE_PALADIN, oItem);
		}
		// if boolean set make cleric and fs able to use knight wands and scrolls
		if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_PALADIN), DURATION_TYPE_PERMANENT) &&
			B_CLERIC_USE_KNIGHT_WANDSCROLL){
			MakeItemUseableByClass(CLASS_TYPE_FAVORED_SOUL, oItem);
			MakeItemUseableByClass(CLASS_TYPE_CLERIC, oItem);
		}
		// make sure shaman can use druid and vice versa, also make ranger able if boolean set
		if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_DRUID), DURATION_TYPE_PERMANENT) ||
		IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_SPIRIT_SHAMAN), DURATION_TYPE_PERMANENT)){
			MakeItemUseableByClass(CLASS_TYPE_DRUID, oItem);
			MakeItemUseableByClass(CLASS_TYPE_SPIRIT_SHAMAN, oItem);
			if (B_RANGER_USE_DRUID_WANDSCROLL) MakeItemUseableByClass(CLASS_TYPE_RANGER, oItem);
		}
		// if boolean set make shaman and druid able to use ranger wands and scrolls
		if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_RANGER), DURATION_TYPE_PERMANENT) &&
			B_DRUID_USE_RANGER_WANDSCROLL){
			MakeItemUseableByClass(CLASS_TYPE_DRUID, oItem);
			MakeItemUseableByClass(CLASS_TYPE_SPIRIT_SHAMAN, oItem);
		}
		// make sure sorc can use wiz and vice versa, also make bard able if boolean set
		if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_WIZARD), DURATION_TYPE_PERMANENT) ||
		IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_SORCERER), DURATION_TYPE_PERMANENT)){
			MakeItemUseableByClass(CLASS_TYPE_WIZARD, oItem);
			MakeItemUseableByClass(CLASS_TYPE_SORCERER, oItem);
			if (B_BARD_USE_WIZ_WANDSCROLL) MakeItemUseableByClass(CLASS_TYPE_BARD, oItem);
		}
		// if boolean set make sorc and wiz able to use bard wands and scrolls
		if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_BARD), DURATION_TYPE_PERMANENT) &&
			B_WIZ_USE_BARD_ARCANE_WANDSCROLL){
			itemproperty ipSpell = GetFirstItemProperty(oItem);
			int nId = NULL;
			int nSub = NULL;
			while (GetIsItemPropertyValid(ipSpell)){
				if (GetItemPropertyType(ipSpell) == ITEM_PROPERTY_CAST_SPELL){
					nSub = GetItemPropertySubType(ipSpell);
					nId = StringToInt(Get2DAString("iprp_spells", "SpellIndex", nSub));
					break;
				}
				ipSpell = GetNextItemProperty(oItem);
			}
			if (nId != NULL && !IsOnSpellList(nId, CLASS_TYPE_CLERIC)){
				MakeItemUseableByClass(CLASS_TYPE_WIZARD, oItem);
				MakeItemUseableByClass(CLASS_TYPE_SORCERER, oItem);
			}
		}
	}
	
	if (sRef == "ps_flail_chainshatred"){
		if (IPGetItemHasProperty(oItem, ItemPropertyEnhancementBonus(6), DURATION_TYPE_PERMANENT)){
			FF_ModifyItemProperty(oItem, ItemPropertyEnhancementBonus(6));
			FF_ModifyItemProperty(oItem, ItemPropertyEnhancementBonus(5), TRUE);
		}
		itemproperty ipDrain = ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, 24, IP_CONST_ABILITY_CON);
		if (IPGetItemHasProperty(oItem, ipDrain, DURATION_TYPE_PERMANENT))
			FF_ModifyItemProperty(oItem, ipDrain);
		return;
	}
	
	// make sure that people get the mithral and adamantine ingots used in crafting here instead of
	// the default ones that might be lingering in treasure tables
	if (sRef == "n2_crft_ingadamant" || sRef == "n2_crft_ingmithral"){
		int nStack = GetNumStackedItems(oItem);
		if (sRef == "n2_crft_ingadamant") oNewItem = CreateItemOnObject("ps_crft_ing_ada", oPC, nStack, "ps_crft_ing_ada", 0);
		else oNewItem = CreateItemOnObject("ps_golem_mithral", oPC, nStack, "ps_golem_mithral", 0);
		
		// this does nothing but delay things by half a sec to make sure the new item is created
		DelayCommand(0.5f, SetLocalInt(oPC, "GotACraftIngot", TRUE));
		
		if (GetIsObjectValid(oNewItem)) DestroyObject(oItem, 0.3f, FALSE);
	}
	
	// nerf the sword saint armor
	if (sRef == "ps_itemset_swordsaint3")
	{
		FF_ModifyItemProperty(oItem, ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_SHIELD, 2), TRUE);
	}
	
	// update Bit o' Larry
	if (sRef == "ps_amor_bitolarry"){
		oNewItem = CreateItemOnObject("ps_amor_bitolarry_new", oPC);
		// this does nothing but delay things by half a sec to make sure the new item is created
		DelayCommand(0.5f, SetLocalInt(oPC, "GotABitOLarry", TRUE));
		if (GetIsObjectValid(oNewItem)) DestroyObject(oItem, 0.3f, FALSE);
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
	
	// replace harper agent use limitation with bard, if it doesn't have bard already 
	if (IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_HARPER), DURATION_TYPE_PERMANENT))
	{
		FF_ModifyItemProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_HARPER), FALSE);
		if (!IPGetItemHasProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_BARD), DURATION_TYPE_PERMANENT))
		{
			FF_ModifyItemProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_BARD), TRUE);
		}
	}
	
	// Fix darkvision items, because ItemPropertyDarkvision() is Biobugged. 
	// Note that this requires my updated iprp_feats.2da to work properly because 
	// darkvision wasn't available as a bonus feat until I added it, so we'll do a little check and default to low 
	// light vision instead if darkvision isn't found. -FlattedFifth
	
    itemproperty ip = GetFirstItemProperty(oItem);
	int bHasDV = FALSE;
    while (GetIsItemPropertyValid(ip)){
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_DARKVISION){
            bHasDV = TRUE;
			break;
        }
        ip = GetNextItemProperty(oItem);
    }
	if (bHasDV){
		FF_ModifyItemProperty(oItem, ip, FALSE);
		int nFeatId = 801; // low light vision
		
		// if the currently used iprp_feats.2da has darkvision at line 438 change nFeatId to darkvision.
		if (Get2DAString("iprp_feats", "FeatIndex", 438) == "228") nFeatId = 438; 
		
		FF_ModifyItemProperty(oItem, ItemPropertyDarkvision());
		// add either bonus feat darkvision of bonus feat low light vision		
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
		if (i != INVENTORY_SLOT_CARMOUR)
		{
			oItem = GetItemInSlot(i, oPC);
			DelayCommand(0.3f, AssignCommand(oPC, FF_UpdateSingleLegacyItem(oPC, oItem)));
		}
	}
	int nNumDMFI = 0;
    // Iterate through all items in the inventory
	i = 0;
	oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem)){
		i++;
		// destroy extra dmfi tools
		if (GetResRef(oItem) == DMFI_PCTOOL_RESREF){
			nNumDMFI++;
			if (nNumDMFI > 1) DestroyObject(oItem, 0.3f, FALSE);
		} else {
			FF_UpdateSingleLegacyItem(oPC, oItem);
		}
        oItem = GetNextItemInInventory(oPC);
		// num of items a pc could have if inv full of full bags, including the bags
		if (i > 27072) return;
    }
}




// set bAdd to TRUE to add the item property, FALSE to remove it.
void FF_ModifyItemProperty(object oItem, itemproperty ipProperty, int bAdd = FALSE)
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