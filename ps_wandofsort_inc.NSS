#include "ff_safevar"

// constants for variables for different types of objects
const string VAR_TYPE_GEMS = "ASTOREGEMSIN";
const string VAR_TYPE_BOOKS = "ASTOREBOOKSIN";
const string VAR_TYPE_SCROLLS = "ASTORESCROLLSIN";
const string VAR_TYPE_AMMO = "ASTOREAMMOIN";
const string VAR_TYPE_OTHER = "ASTOREOTHERIN"; // default for any types not specified, if this not set, then items don't get moved.
const string VAR_TYPE_WEAPONS = "ASTOREWEAPONSIN";
const string VAR_TYPE_ARMOUR = "ASTOREARMOURIN";

const string VAR_RESET = "AS_RESET"; // instruction to remove variable(s) from container.

// Not going to use this now, we will use the exact possible variants to cover multiple values on same container.
//const string VAR_TYPE_CONT = "AS_TYPE_CONT"; // stores which type of store it should be on the actual container for later removal

const string VAR_TEMP_OBJECT = "AS_TEMPOBJECT"; // holds the object id of the item clicked

const string VAR_CONT_ORIG_NAME = "AS_ORIGNAME";
const string VAR_CONT_ORIG_TAG = "AS_ORIGTAG";

const string VAR_NEWTAG = "autosort";

const string VAR_NEW_NAME = "Auto Sort: ";
const string STRING_SEPERATOR = "/";
const string STRING_GEMS = "Gems";
const string STRING_BOOKS = "Books";
const string STRING_SCROLLS = "Scrolls";
const string STRING_AMMO = "Ammo";
const string STRING_WEAPONS = "Weapons";
const string STRING_ARMOUR = "Armour";
const string STRING_OTHER = "Other";

void ResetSortValuesOnPC(object oPC, object oItem)
{
	int nMask = 0;
	if (PS_GetLocalInt(oItem, VAR_TYPE_GEMS) == 1) { PS_SetLocalObject(oPC, VAR_TYPE_GEMS, oItem); nMask |= 1; }
	if (PS_GetLocalInt(oItem, VAR_TYPE_BOOKS) == 1) { PS_SetLocalObject(oPC, VAR_TYPE_BOOKS, oItem); nMask |= 2; }
	if (PS_GetLocalInt(oItem, VAR_TYPE_SCROLLS) == 1) { PS_SetLocalObject(oPC, VAR_TYPE_SCROLLS, oItem); nMask |= 4; }
	if (PS_GetLocalInt(oItem, VAR_TYPE_AMMO) == 1) { PS_SetLocalObject(oPC, VAR_TYPE_AMMO, oItem); nMask |= 8; }
	if (PS_GetLocalInt(oItem, VAR_TYPE_WEAPONS) == 1) { PS_SetLocalObject(oPC, VAR_TYPE_WEAPONS, oItem); nMask |= 16; }
	if (PS_GetLocalInt(oItem, VAR_TYPE_ARMOUR) == 1) { PS_SetLocalObject(oPC, VAR_TYPE_ARMOUR, oItem); nMask |= 32; }
	if (PS_GetLocalInt(oItem, VAR_TYPE_OTHER) == 1) { PS_SetLocalObject(oPC, VAR_TYPE_OTHER, oItem); nMask |= 64; }

/*
	if (nMask != 0)
	{
		WriteTimestampedLogEntry("ResetSortValuesOnPC: oPC=" + GetName(oPC) + " (" + ObjectToString(oPC) + "), oItem=" + GetName(oItem) + " (" + ObjectToString(oItem) + "), nMask = " + IntToString(nMask));
	}
*/
}

void ResetSortObjectsOnPC(object oPC)
{
	object oItem;

	//
	// Sweep the inventory of the creature and reset the inventory objects that
	// receive items (e.g. to handle the case of a PC rehydrated when logging
	// back on without a reset).
	//

	oItem = GetFirstItemInInventory(oPC);
	while (oItem != OBJECT_INVALID)
	{
		if (GetTag(oItem) == VAR_NEWTAG)
		{
			ResetSortValuesOnPC(oPC, oItem);
		}

		oItem = GetNextItemInInventory(oPC);
	}
}