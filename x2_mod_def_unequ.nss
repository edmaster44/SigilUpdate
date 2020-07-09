//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_unequ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnUnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////

#include "x2_inc_intweapon"
#include "ps_inc_functions"
#include "ps_inc_equipment"
#include "ps_inc_removeprops"

void main()
{
	//Modified by Clangeddin 30/12/2017
    object oItem = GetPCItemLastUnequipped();
    object oPC   = GetPCItemLastUnequippedBy();
	
	//This is the new subroutine that handles almost everything that happens in Sigil concerning equipment.
	//Found in the bottom of "ps_inc_equipment.nss"
	SigilEquipment(oPC, oItem, FALSE);
//Removes Elemental Weapon
	RemoveElementalWeapon(oPC, oItem);	
	
	//This Removes Meditative Strikes
		RemoveMeditativeStrikes(oPC,oItem);
	
	//Not everything was included in it, however. This is what I left out.
	PS_ManageItemImmunities(oItem, oPC, FALSE);
	
    // -------------------------------------------------------------------------
    //  Combat Mode Fix (so you can't enabled something like combat expertise from an item and swap)
    // -------------------------------------------------------------------------
	if (GetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE)) {
		SetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE, FALSE);
	} if (GetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)) {
		SetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE, FALSE);
	} if (GetActionMode(oPC, ACTION_MODE_IMPROVED_POWER_ATTACK)) {
		SetActionMode(oPC, ACTION_MODE_IMPROVED_POWER_ATTACK, FALSE);
	} if (GetActionMode(oPC, ACTION_MODE_POWER_ATTACK)) {
		SetActionMode(oPC, ACTION_MODE_POWER_ATTACK, FALSE);
	} if (GetActionMode(oPC, ACTION_MODE_RAPID_SHOT)) {
		SetActionMode(oPC, ACTION_MODE_RAPID_SHOT, FALSE);
	}
	 
    // -------------------------------------------------------------------------
    //  Intelligent Weapon System
    // -------------------------------------------------------------------------
    if (IPGetIsIntelligentWeapon(oItem))
    {
    	IWSetIntelligentWeaponEquipped(oPC, OBJECT_INVALID);
    	IWPlayRandomUnequipComment(oPC, oItem);
    }

    // -------------------------------------------------------------------------
    // Generic Item Script Execution Code
    // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // it will execute a script that has the same name as the item's tag
    // inside this script you can manage scripts for all events by checking against
    // GetUserDefinedItemEventNumber(). See x2_it_example.nss
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
    	SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNEQUIP);
    	int nRet = ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem), OBJECT_SELF);
    	//if (nRet == X2_EXECUTE_SCRIPT_END) return;
    }
}