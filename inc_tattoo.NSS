//::///////////////////////////////////////////////
//:: [inc_tattoo.nss]
//:: Copyright (c) 2010 SCoD
//:://////////////////////////////////////////////
//:: Include constants and functions for the tattoo system
//:://////////////////////////////////////////////
//:: Created by: Netrunner
//:: Created on: 19/10/2010
//:://////////////////////////////////////////////
// FlattedFifth, Aug 8, 2024. Replacing the creature skin tattoos with misc thin tattoos
// and applying effects to characters for them, so that all characters can use all tattoos
// even if they have a racial creature skin
#include "nw_i0_spells"

const int TATTOO_SPELL_ID = -8675309; // Jenny has all the tattoos
const string TATTOO_UPDATED_SUFFIX = "_updated";
const string ART_TATTOO = "ps_tattoo_42";
// the following are the only 2 tattoos at the time of this writing that do not 
// automatically apply their effects while in inventory.
const string DR_TATTOO = "ps_tattoo_54";
const string SR_TATTOO = "ps_tattoo_365";

const int maxTattooes = 1;
const string tattooTagPrefix ="ps_tattoo_";
const int duplicatesAllowed = TRUE;

void CheckTattoos(object oPC);
void UpdateTattoo(object oPC, object oTattoo);
void RemoveTattooFX(object oPC);
void ApplyTattooFX(object oPC, object oItem);
void createTattooOnCreature(string sTag, object oPC);
int getTattooCount(object oPC);
int canGetTattoo(object oPC);
void removeTattoo(object oPC, string sTattooTag);
string GetUpdatedTattooTag(string sTag);





void CheckTattoos(object oPC){
	RemoveTattooFX(oPC);
	object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
	if (oItem != OBJECT_INVALID){
		string sRes = GetStringLowerCase(GetResRef(oItem));
		if (sRes == DR_TATTOO || sRes == SR_TATTOO)
			UpdateTattoo(oPC, oItem);
	}
	int i = 0;
	oItem = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(oItem)){
		i++;
		// num of items a pc could have if inv full of full bags, including the bags
		if (i > 27072) break;
		string sRes = GetStringLowerCase(GetResRef(oItem));
		if (FindSubString(sRes, "ps_tattoo") != -1){
			if (sRes == ART_TATTOO) UpdateTattoo(oPC, oItem);
			ApplyTattooFX(oPC, oItem);
			break;
		}
		oItem = GetNextItemInInventory(oPC);
	}
}

string GetUpdatedTattooTag(string sTag)
{
	if (sTag == SR_TATTOO || sTag == DR_TATTOO || sTag == ART_TATTOO)
		return sTag + TATTOO_UPDATED_SUFFIX;
		else return sTag;

}

void createTattooOnCreature(string sTag, object oPC)
{
	//if oPC is not a PC, return
	if (!GetIsPC(oPC) || GetIsPossessedFamiliar(oPC))
		return;
	//SendMessageToPC(oPC, "Creating the tattoo " + sTag);
	//Change old creature skin tattoos to new non creature skin tattoos,
	// and artificer tattoo to new version.
	sTag = GetUpdatedTattooTag(sTag);
	//first of all, create the item in the PC's Inventory
	object oTattoo = CreateItemOnObject(sTag, oPC, 1, sTag, FALSE );
	//set plot and cursed status on item so that it cannot be bartered/dropped/sold
	SetItemCursedFlag(oTattoo, TRUE);
	SetPlotFlag(oTattoo, TRUE);
	ApplyTattooFX(oPC, oTattoo);
	
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
	string sAlt = GetUpdatedTattooTag(sTattooTag);
	object oItem = GetFirstItemInInventory(oPC);
	while (oItem != OBJECT_INVALID)
	{
		string sTag = GetTag(oItem);
		if (sTag == sTattooTag || sTag == sAlt)
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
		
	string sAlt = GetUpdatedTattooTag(sTattooTag);
	//first of all, look for the item in the PC's Inventory
	object oItem = GetFirstItemInInventory(oPC);
	
	while (oItem != OBJECT_INVALID)
	{
		string sTag = GetTag(oItem);
		if (sTag == sTattooTag || sTag == sAlt)
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
	RemoveTattooFX(oPC);
}


void UpdateTattoo(object oPC, object oTattoo){
	string sRes = GetStringLowerCase(GetResRef(oTattoo));
	if (sRes == GetUpdatedTattooTag(sRes)){
		return;
	}
	else {
		string sNewRes = GetUpdatedTattooTag(sRes);
		object oNewTat = CreateItemOnObject(sNewRes, oPC, 1, "", FALSE);
		if (oNewTat != OBJECT_INVALID){
			SetItemCursedFlag(oTattoo, FALSE);
			SetPlotFlag(oTattoo, FALSE);
			DestroyObject(oTattoo, 0.6f, FALSE);
			SetItemCursedFlag(oNewTat, TRUE);
			SetPlotFlag(oNewTat, TRUE);
			ApplyTattooFX(oPC, oNewTat);
		}
	}
}


void ApplyTattooFX(object oPC, object oItem){
	string sRes = GetStringLowerCase(GetResRef(oItem));
	string sManualTat1 = DR_TATTOO + TATTOO_UPDATED_SUFFIX;
	string sManualTat2 = SR_TATTOO + TATTOO_UPDATED_SUFFIX;
	if (sRes != sManualTat1 && sRes != sManualTat2){
		return;
	}
	else {
		effect eTat;
		if (sRes == sManualTat1){
			eTat = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
		}
		else if (sRes == sManualTat2){
			eTat = EffectSpellResistanceIncrease(26);
		}
	eTat = SupernaturalEffect(eTat);
    eTat = SetEffectSpellId(eTat, TATTOO_SPELL_ID);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTat, oPC);
	}
}


void RemoveTattooFX(object oPC){
	RemoveEffectsFromSpell(oPC, TATTOO_SPELL_ID);
}