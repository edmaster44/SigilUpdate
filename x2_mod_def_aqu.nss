//::///////////////////////////////////////////////
//:: Example XP2 OnItemAcquireScript
//:: x2_mod_def_aqu
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*  Put into: OnItemAcquire Event */
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
// FlattedFifth - June 18, 2024: Re-ordered file to put main logic at top because IMO it's more readable that way,
//				Added a boolean style integer to control whether we bother logging muling or not (idk why we would
//				when it's allowed), though that might be better moved to x2_inc_switches at some point.
// 				Also makes wands and scrolls useable by those mage slayers who can use them.
//		ditto - June 30, added call to ff_update_legacy_items to fix any wrong items when the pc gets them.
#include "x2_inc_switches"
#include "nwnx_sql"
#include "ps_wandofsort_inc"
#include "ps_inc_advscript"
#include "ps_inc_functions"
#include "class_mageslayer_utils"
#include "ff_update_legacy_items"


// since muling is allowed there's no reason to make unnecessary writes to disk to log it.
// Just set to true if you want to turn this back on.
const int B_CHECK_FOR_MULING = FALSE;



// function declarations
int GetIsLooted(object oFROM);
void ReportMuling(object oBY, object oFROM, object oITEM);
int CheckMuling(object oBY, object oFROM, object oITEM);
void CheckAndPlaceItemInContainer(object oBY, object oFROM, object oITEM);
void BroadcastLoot(object oBY, object oFROM, object oITEM);
void HandleSigilAcquisition(object oBY, object oFROM, object oITEM);


void main()
{
	object oBY = GetModuleItemAcquiredBy();
	if (GetIsPC(oBY) == FALSE) return;
	object oFROM = GetModuleItemAcquiredFrom();
	object oITEM = GetModuleItemAcquired();
	HandleSigilAcquisition(oBY, oFROM, oITEM);
	
	// call to ff_update_legacy_items
	FF_UpdateSingleLegacyItem(oBY, oITEM);
	
	// call to ps_mage_slayer_utils
	if (GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oBY))
	{
		CheckMakeItemUseableForMageSlayer(oITEM, oBY);
	}
	
    // * Generic Item Script Execution Code
    // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // * it will execute a script that has the same name as the item's tag
    // * inside this script you can manage scripts for all events by checking against
    // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
    	SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACQUIRE);
        int nRet = ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oITEM), OBJECT_SELF);
        //if (nRet == X2_EXECUTE_SCRIPT_END) return;
    }

	//Old Script, Replaced by HandleSigilAcquisition subroutine up here. (Clangeddin 01/01/2018)
	//ExecuteScript("ps_item_onacquire", OBJECT_SELF);
}



//Simple wrapper to tell if the item is being looted from a bodybag or a treasure chest.
int GetIsLooted(object oFROM)
{
	if (oFROM == OBJECT_INVALID) return FALSE;
	string sFROM = GetTag(oFROM);
	if (sFROM == "BodyBag" || TestStringAgainstPattern("**chest**", sFROM)) return TRUE;
	return FALSE;
}

//Log the muling
void ReportMuling(object oBY, object oFROM, object oITEM)
{
	string sIT_NAME = GetName(oITEM);
	string sIT_TAG = GetTag(oITEM);
	string sBY_NAME = GetName(oBY);
	string sBY_PLAY = GetPCPlayerName(oBY);
	
	string sVAR_A1 = GetLocalString(oITEM, "A1");
	string sVAR_A2 = GetLocalString(oITEM, "A2");
	string sVAR_N1 = GetLocalString(oITEM, "N1");
	string sVAR_N2 = GetLocalString(oITEM, "N2");
	
	SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + SQLEncodeSpecialChars(sBY_PLAY) + 
	"','" + SQLEncodeSpecialChars(sBY_NAME) + "','" + SQLEncodeSpecialChars(sIT_NAME) + " (" + 
	SQLEncodeSpecialChars(sIT_TAG) + ") given from " + SQLEncodeSpecialChars(sVAR_A1) + "/" + SQLEncodeSpecialChars(sVAR_N1) + 
	" and original owner: " + SQLEncodeSpecialChars(sVAR_A2) + "/" + SQLEncodeSpecialChars(sVAR_N2) + " (" + 
	SQLEncodeSpecialChars(GetTag(oFROM)) + ")',105)");
	
	//SpeakString("<C=TOMATO>[POSSIBLE MULING] " + sVAR_A1 + "/" + sVAR_N1 + " just gave " +  sBY_PLAY + "/" + sBY_NAME + " following: " + sIT_NAME + "/" + sIT_TAG + ", which was last owned by: " + sVAR_A2 + "/" + sVAR_N2, TALKVOLUME_SILENT_SHOUT);
	
	SetLocalString(oITEM, "A2", "");
	SetLocalString(oITEM, "N2", "");
	SetLocalString(oITEM, "A1", sBY_PLAY);
	SetLocalString(oITEM, "N1", sBY_NAME);
	SetLocalString(oITEM, "M", "Muling logged");
}

//Check if muling is happening.
int CheckMuling(object oBY, object oFROM, object oITEM)
{
	//Cursed items cannot be transfered.
	if (GetItemCursedFlag(oITEM) == TRUE) return FALSE;
	
	string sBY_NAME = GetName(oBY);
	string sBY_PLAYER = GetPCPlayerName(oBY);
	
	//First case of Muling. A Player gives an item to another player with character X, and then gets it back with character Y.
	if (GetLocalString(oITEM, "A2") == sBY_PLAYER && GetLocalString(oITEM, "N2") != sBY_NAME) return TRUE;
	
	string sPREV_NAME = GetLocalString(oITEM, "N1");
	string sPREV_PLAYER = GetLocalString(oITEM, "A1");
	
	//Second case of Muling. A Player drops an item on the ground with Character X and picks it up with Character Y
	if (sPREV_PLAYER == sBY_PLAYER && sPREV_NAME != sBY_NAME) return TRUE;
	
	if (sPREV_NAME != sBY_NAME)
	{
		SetLocalString(oITEM, "A2", sPREV_PLAYER);
		SetLocalString(oITEM, "N2", sPREV_NAME);
		SetLocalString(oITEM, "A1", sBY_PLAYER);
		SetLocalString(oITEM, "N1", sBY_NAME);
	}
	return FALSE;
}

// Auto Sorting.
void CheckAndPlaceItemInContainer(object oBY, object oFROM, object oITEM)
{
	string sTo;

	// we can see if it should be stored somewhere.
	if (GetWeaponType(oITEM) != WEAPON_TYPE_NONE) sTo = VAR_TYPE_WEAPONS;
	else
	{
		int nTYPE = GetBaseItemType(oITEM);
		switch (nTYPE)
		{
			case BASE_ITEM_GEM: 				sTo = VAR_TYPE_GEMS; break;
			case BASE_ITEM_BOOK: 				sTo = VAR_TYPE_BOOKS; break;
			case BASE_ITEM_ENCHANTED_SCROLL: 
			case BASE_ITEM_SPELLSCROLL: 		sTo = VAR_TYPE_SCROLLS; break;
			case BASE_ITEM_ARROW:
			case BASE_ITEM_BOLT:
			case BASE_ITEM_BULLET: 				sTo = VAR_TYPE_AMMO; break;
			case BASE_ITEM_ARMOR: 				sTo = VAR_TYPE_ARMOUR; break;
			default: 							sTo = VAR_TYPE_OTHER;
		}
	}
	
	// extra check to make sure container belongs to PC and that it is a container
	// at least hopefully stop items disappearing to god knows where...
	object oTo = GetLocalObject(oBY, sTo);
	if (GetBaseItemType(oTo) != BASE_ITEM_LARGEBOX) return;
	if (GetItemPossessor(oTo) != oBY) return;
	AssignCommand(oBY, ActionGiveItem(oITEM, oTo, TRUE));
	AssignCommand(oBY, ActionDoCommand(PS_MergeContainerStacks(oTo)));
}

// Message sent to all party members when we loot something from a bodybag or from a chest.
void BroadcastLoot(object oBY, object oFROM, object oITEM)
{
	string sTXT = GetName(oBY) + " picked up ";
	int nTYPE = GetBaseItemType(oITEM);
	if (nTYPE == 255) sTXT = sTXT + "some gold"; //Gold. BASE_ITEM_GOLD being 76 is a lie, it's 255. Or is it?
	else
	{
		int nSTACK = GetItemStackSize(oITEM);
		if (nSTACK > 1) sTXT = sTXT + IntToString(nSTACK) + " ";
		else sTXT = sTXT + "a ";
		if (nTYPE == BASE_ITEM_SPELLSCROLL && GetIdentified(oITEM)) sTXT = sTXT + "Scroll of ";
		sTXT = sTXT + GetName(oITEM);
		if (nSTACK > 1) sTXT = sTXT + "s";
	}
	sTXT = sTXT + ".";
	
	object oAREA = GetArea(oBY);
	object oPARTY = GetFirstFactionMember(oBY);
	while (oPARTY != OBJECT_INVALID)
	{
		if ((oPARTY != oBY) && (GetArea(oPARTY) == oAREA)) SendMessageToPC(oPARTY, sTXT);
		oPARTY = GetNextFactionMember(oBY);
	}
}

void HandleSigilAcquisition(object oBY, object oFROM, object oITEM)
{
	string sITEM_TAG = GetTag(oITEM);
	if (B_CHECK_FOR_MULING)
	{
		if (CheckMuling(oBY, oFROM, oITEM) == TRUE) ReportMuling(oBY, oFROM, oITEM);
	}
	if (GetIsLooted(oFROM) == TRUE)
	{
		CheckAndPlaceItemInContainer(oBY, oFROM, oITEM);
		BroadcastLoot(oBY, oFROM, oITEM);
	}
	if (sITEM_TAG == VAR_NEWTAG) ResetSortValuesOnPC(oBY, oITEM);
	else if (sITEM_TAG == "ps_essence") PS_LoadEssenceState(oBY, oITEM);
}
 