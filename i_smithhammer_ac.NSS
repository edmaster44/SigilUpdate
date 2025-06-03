// i_smithhammer_ac
/*
	when the smith hammer is used on the workbench, an item may be created!
*/
// ChazM 1/31/06
// ChazM 3/28/06 Crafting call interface change
// ChazM 4/7/06 fix - assigned DoMundaneCrafting() to workbench
// ChazM 8/8/06 added ERROR_UNRECOGNIZED_HAMMER_USAGE,  added additional tags and local var setting for identifying blacksmith bench.
// ChazM 8/16/06 moved stuff to ginc_crafting
// ChazM 6/11/07 If campaign switch enabled, smith hammer can be used to rename any item.


#include "ginc_crafting"
#include "x2_inc_switches"
#include "ps_inc_functions"
#include "ps_inc_newcraft_include"

void DoGemReCut(object oPC, object oTarget);
void ReCutGem(object oPC, object oGem);
void DoMeltDownItem(object oPC, object oTarget);

void main(){
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
	string sRes = GetResRef(oTarget);
	if (FindSubString(sRes, "gemstone_") != -1)
		DoGemReCut(oPC, oTarget);
	else DoMeltDownItem(oPC, oTarget);
}

void DoGemReCut(object oPC, object oTarget){
	object oBench = GetNearestObjectByTag("PLC_MR_BSMITHG02", oPC);
	
	string sMessage = "<c=red>You must be near a gem cutting station and posses an";
	sMessage += "\nadamantine dagger to use as a chisel in order";
	sMessage += "\nto re-cut gems. (you do not have to have the dagger equipped)</c>";
	//are we near a gem bench?
	if (!GetWorkbenchInRange(oPC, oBench)){
		SendMessageToPC(oPC, sMessage);
		return;
	}
	// do we have an adamantine dagger to use as a chisel?
	int bFoundChisel = FALSE;
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oItemL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	if (GetBaseItemType(oItem) == BASE_ITEM_DAGGER &&
		GetItemBaseMaterialType(oItem) == GMATERIAL_METAL_ADAMANTINE){
			bFoundChisel = TRUE;
			ReCutGem(oPC, oTarget);
	} else if (GetBaseItemType(oItemL) == BASE_ITEM_DAGGER &&
		GetItemBaseMaterialType(oItemL) == GMATERIAL_METAL_ADAMANTINE){
			bFoundChisel = TRUE;
			ReCutGem(oPC, oTarget);
	} else {
		int i = 0;
		oItem = GetFirstItemInInventory(oPC);
		while (GetIsObjectValid(oItem)){
			i++;
			if (GetBaseItemType(oItem) == BASE_ITEM_DAGGER &&
				GetItemBaseMaterialType(oItem) == GMATERIAL_METAL_ADAMANTINE){
				bFoundChisel = TRUE;
				ReCutGem(oPC, oTarget);
				break;
			}
			oItem = GetNextItemInInventory(oPC);
			// num of items a pc could have if inv full of full bags, including the bags
			if (i > 27072) return;
		}
	}
	if (!bFoundChisel) SendMessageToPC(oPC, sMessage);
}

void ReCutGem(object oPC, object oGem){
	//has this gem been recut already? If so, exit with notification
	if (GetLocalInt(oGem, "recut")){
		SendMessageToPC(oPC, "</c>This gem has been recut once, it cannot be cut a third time.</c>");
		return;
	}
	SetLocalObject(oPC, "gem_to_be_recut", oGem);
	AssignCommand(oPC, ActionStartConversation(oPC, "conv_gem_recut", TRUE, FALSE));
}

void DoMeltDownItem(object oPC, object oTarget){	
	object oBench = GetNearestSmithingWorkbench(oPC);
	
	
	if (!GetIsObjectValid(oBench)){
		SendMessageToPC(oPC, "You must be near a crafting workstation to melt down items.");
		return;
	} else if (GetItemCursedFlag(oTarget) || !IPGetIsForgedItem(oTarget)){
		SendMessageToPC(oPC, "This item cannot be melted down.");
		return;
	} else {
		int nItem = GetBaseItemType(oTarget);
		if ((IPGetIsProjectile(OBJECT_INVALID, nItem) || IPGetIsThrownWeapon(OBJECT_INVALID, nItem)) && 
			!IPGetIsQuiver(OBJECT_INVALID, nItem)){
			SendMessageToPC(oPC, "Cannot melt down individual ammunition, must melt down entire quiver");
			return;
		}
		int bIsJewelry = (nItem == BASE_ITEM_RING || nItem == BASE_ITEM_AMULET);
		int nNumRows = GetNum2DARows("scod_craft_metal");
		int nMetalMatID = -1;
		string sMetalName = "Iron";
		string sIngot = "n2_crft_ingiron";
		int nSub = -1;
		int i;
		int bBaseMetal;
		itemproperty ip = GetFirstItemProperty(oTarget);
		while (GetIsItemPropertyValid(ip)){
			if (GetItemPropertyType(ip) == 100){
				nSub = GetItemPropertySubType(ip);
				if (Get2DAString("iprp_specialmat", "Mat_2da", nSub) == "scod_craft_metal"){
					nMetalMatID = nSub;
					for (i = 0; i < nNumRows; i++){
						if (Get2DAString("scod_craft_metal", "IP_DESCRIPTION_ID", i) == IntToString(nSub)){
							bBaseMetal = TRUE;
						// if this is a decorative metal then it's not the one we're looking for unless this is jewelry.
							if (Get2DAString("scod_craft_metal", "DECORATIVE_METAL", i) == "1") bBaseMetal = bIsJewelry;
							if (bBaseMetal){
								sMetalName = Get2DAString("scod_craft_metal", "LABEL", i);
								if (sMetalName == "Copper") sIngot = "ps_crft_pm_copper";
								else if (sMetalName == "Iron") sIngot = "n2_crft_ingiron";
								else sIngot = Get2DAString("scod_craft_metal", "BASE_RESREF", i);
								break;
							}
						}
					}
				}
			}
			ip = GetNextItemProperty(oTarget);
		}
		// if we didn't find a specific material tied to a "Forged Of" property we give the most
		// common material of the base material type.
		if (nMetalMatID == -1){
			nMetalMatID = GetItemBaseMaterialType(oTarget);
			switch (nMetalMatID){
				case 1: {
					sMetalName = "Meteoric Iron";
					sIngot = "ps_cfrt_ing_mi";
					break;
				}
				case 2:{
					sMetalName = "Cold Iron";
					sIngot = "n2_crft_ingcldiron";
					break;
				}
				case 3:{
					sMetalName = "Darksteel";
					sIngot = "n2_crft_ingdrksteel";
					break;
				}
				case 5:{
					sMetalName = "Mithral";
					sIngot = "ps_golem_mithral";
					break;
				}
				case 6:{
					sMetalName = "Alchemical Silver";
					sIngot = "n2_crft_ingsilver";
					break;
				}
				default:{
					sMetalName = "Iron";
					sIngot = "n2_crft_ingiron";
					break;
				}
			}
		}
		string sItemName = GetName(oTarget);
		if (RemoveWhitespace(sItemName) == "")
			sItemName = GetFirstName(oTarget) + " " + GetLastName(oTarget);
		if (RemoveWhitespace(sItemName) == ""){
			int nNameRes = StringToInt(Get2DAString("baseitems", "Name", nItem));
			sItemName = GetStringByStrRef(nNameRes);	
		}
		if (RemoveWhitespace(sItemName) == "") sItemName = "item";
		
		SetCustomToken(4001, sItemName);
		SetCustomToken(4002, sMetalName);
		SetLocalString(oPC, "melt_ingotRes", sIngot);
		SetLocalObject(oPC, "melt_itemObject", oTarget);
		AssignCommand(oPC, ActionStartConversation(oPC, "confirm_meltdown_dialog", TRUE, FALSE, TRUE, TRUE));
	}

/*
	PrettyDebug("i_smithhammer_ac : started");
    // * This code runs when the Unique Power property of the item is used
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
    object oTarget  = GetItemActivatedTarget();
    location lTarget = GetItemActivatedTargetLocation();
    string sTargetTag  = GetTag(oItem);
	int bSmithHammerRenameItem = GetGlobalInt(CAMPAIGN_SWITCH_SMITH_HAMMER_RENAME_ITEM);
	
	PrettyDebug("oPC = " + GetName(oPC));
	PrettyDebug("oItem = " + GetName(oItem));
	PrettyDebug("oTarget = " + GetName(oTarget));
	
	if (IsSmithWorkbench(oTarget))
	{
    	AssignCommand(oTarget, DoMundaneCrafting(oPC));
	}
	else if (bSmithHammerRenameItem && (GetObjectType(oTarget) == OBJECT_TYPE_ITEM))
	{
		SetEnchantedItemName(oPC, oTarget);
	}
	else
	{
		ErrorNotify(oPC, ERROR_UNRECOGNIZED_HAMMER_USAGE);
	}		
	PrettyDebug("i_smithhammer_ac : completed");*/
}		