

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_placeable_signs"
#include "ps_inc_faction"

const int MAX_ITEMS = 100;

int MerchWandSourceValid(object oSource, object oPC)
{
	if (GetIsObjectValid(oSource))
	{
		if (GetObjectType(oSource) == OBJECT_TYPE_ITEM && GetItemPossessor(oSource) == oPC
			&& GetHasInventory(oSource))
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	else
	{
		return FALSE;
	}
}

int MerchWandDestinationValid(object oDestination, object oPC)
{
	if (GetIsObjectValid(oDestination))
	{
		if (GetObjectType(oDestination) == OBJECT_TYPE_PLACEABLE && GetHasInventory(oDestination) == TRUE && GetTag(oDestination) == "ps_usersign_display")
		{
			if (GetLocalString(oDestination,"OWNER_NAME") == GetName(oPC))
				return TRUE;
			if (GetLocalString(oDestination, "OWNER_NAME") == "DOOMGUARD" && GetFaction(oPC) == FACTION_DOOMGUARD)
				return TRUE;
			return FALSE;
		}
		else
		{
			return FALSE;
		}
	}
	else
	{
		return FALSE;
	}
}

void MerchDoCloneItems(object oSource, object oDestination, object oPC)
{
	object oItem = GetFirstItemInInventory(oSource);
	int iCount;
	object oTemp;
	location lDest = GetLocation(oDestination);
	
	while (oItem != OBJECT_INVALID && iCount < MAX_ITEMS)
	{
		oTemp = CopyObject(oItem, lDest, oDestination, "itemondisplay");
		SetLocalObject(oTemp, "CONTAINER", oDestination);
		iCount += 1;
		SendMessageToPC(oPC, "Item on display: " + GetName(oItem));
		oItem = GetNextItemInInventory(oSource);
	}
	if (iCount == MAX_ITEMS && GetIsObjectValid(oItem) == TRUE)
		SendMessageToPC(oPC, "You have displayed the maximum number of items possible (" + IntToString(iCount) + "). Do not have more than this in the container if you wish to ensure all are displayed.");
}

void main()
{
	object oPC = GetItemActivator();
    object oItem = GetItemActivated();
    object oTarget = GetItemActivatedTarget();
	object oSource = GetLocalObject(oItem, "SOURCE");
	//object oDestination = GetLocalObject(oItem, "DESTINATION"); // not needed i think
	
	
	// some checks first
	if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
	{
		if (MerchWandDestinationValid(oTarget, oPC) == TRUE)
		{
			if (MerchWandSourceValid(oSource, oPC) == TRUE)
			{
				// do the cloning (and clean any existing contents!)
				UserPlaceableCleanContainter(oTarget);
				MerchDoCloneItems(oSource, oTarget, oPC);
				SendMessageToPC(oPC, "Items are now available for viewing in your container");
			}
			else
			{
				SendMessageToPC(oPC, "You have not yet specified a valid source container, ie: a bag in your inventory, or else that bag no longer exists");
			}
		}
		else
		{
			SendMessageToPC(oPC, "Destination container must be a placeable owned by you and have an inventory");
		}
	}
	else if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
	{
		// check to see if own inventory container
		if (MerchWandSourceValid(oTarget, oPC) == TRUE)
		{
			SetLocalObject(oItem, "SOURCE", oTarget);
			SendMessageToPC(oPC, "Targetted container (" + GetName(oTarget) + ") is now stored. Now target an owned placeable container.");
		}
		else
		{
			SendMessageToPC(oPC, "Target is not a container within your inventory");
		}
	}
	else
	{
		SendMessageToPC(oPC, "Target must be own placeable container or inventory container!");
	}
	
}