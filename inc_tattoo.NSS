//::///////////////////////////////////////////////
//:: [inc_tattoo.nss]
//:: Copyright (c) 2010 SCoD
//:://////////////////////////////////////////////
//:: Include constants and functions for the tattoo system
//:://////////////////////////////////////////////
//:: Created by: Netrunner
//:: Created on: 19/10/2010
//:://////////////////////////////////////////////

const int maxTattooes = 1;
const string tattooTagPrefix ="ps_tattoo_";
const int duplicatesAllowed = TRUE;

void createTattooOnCreature(string sTag, object oPC)
{
	//if oPC is not a PC, return
	if (!GetIsPC(oPC) || GetIsPossessedFamiliar(oPC))
		return;
	//SendMessageToPC(oPC, "Creating the tattoo " + sTag);
	//first of all, create the item in the PC's Inventory
	object oTattoo = CreateItemOnObject(sTag, oPC, 1, sTag, FALSE );
	//set plot and cursed status on item so that it cannot be bartered/dropped/sold
	SetItemCursedFlag(oTattoo, TRUE);
	SetPlotFlag(oTattoo, TRUE);
}
int getTattooCount(object oPC)
{
	//cycle through the items in th target PC's inventory
	
	object oItem = GetFirstItemInInventory(oPC);
	int iCount=0;
	while (oItem != OBJECT_INVALID)
	{
		//if the current item tag begins with the configured prefix, increase the counter
		if (FindSubString(GetTag(oItem), tattooTagPrefix, 0) == 0)
			iCount++;
		oItem=GetNextItemInInventory(oPC);
	}
	if(FindSubString(GetTag(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)), tattooTagPrefix, 0) == 0)
		iCount++;
	
	oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
	if(FindSubString(GetTag(oItem), tattooTagPrefix, 0) == 0)
		iCount++;
		
	return iCount;
}
int canGetTattoo(object oPC)
{
	//if oPC is not a PC, return FALSE
	if (!GetIsPC(oPC) || GetIsPossessedFamiliar(oPC))
		return FALSE;
		//if oPC has the max number of allowed tattooes, return false, else true
	if (getTattooCount(oPC) >= maxTattooes)
		return FALSE;
	else
		return TRUE;
}
object findTattoo(object oPC, string sTattooTag)
{
	object oItem = GetFirstItemInInventory(oPC);
	while (oItem != OBJECT_INVALID)
	{
		if (GetTag(oItem) == sTattooTag)
		{
			//Tattoo found, return it
			return oItem;
		}
		else
		{
			//Tattoo not found, get next item
			oItem=GetNextItemInInventory(oPC);
		}
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
	if(FindSubString(GetTag(oItem), tattooTagPrefix, 0) == 0)
		return oItem;
	
	return OBJECT_INVALID;
}
void removeTattoo(object oPC, string sTattooTag)
{
		//if oPC is not a PC, return
	if (!GetIsPC(oPC) || GetIsPossessedFamiliar(oPC))
		return;
	//first of all, look for the item in the PC's Inventory
	object oItem = GetFirstItemInInventory(oPC);
	
	while (oItem != OBJECT_INVALID)
	{
		if (GetTag(oItem) == sTattooTag)
		{
			//Tattoo found, remove it and set oItem=OBJECT_INVALID so to exit the while loop
				SetItemCursedFlag(oItem, FALSE);
				SetPlotFlag(oItem, FALSE);
				DestroyObject(oItem, 0.0f, FALSE);
				break;
		}
		else
		{
			//Tattoo not found, get next item
			oItem=GetNextItemInInventory(oPC);
		}
	}
	// And just a quick and dirty check to see if it is the tattoo is on the hide...
	oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
	if(FindSubString(GetTag(oItem), tattooTagPrefix, 0) == 0)
	{
		SetItemCursedFlag(oItem, FALSE);
		SetPlotFlag(oItem, FALSE);
		DestroyObject(oItem, 0.0f, FALSE);		
	}

}