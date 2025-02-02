/*************************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666    *
* Edited in August 2022 by MimiFearthegn for standardization *
*************************************************************/
#include "ps_inc_functions"
#include "nwnx_sql"
#include "nwnx_srvadmin"
#include "ps_inc_placeable_signs"
#include "ps_inc_time"

/*************************************************************/
/* Constants and Definitions */
/*************************************************************/
const int FACTION_PRIME = 1;
const int FACTION_FREE_LEAGUE = 2;
const int FACTION_ATHAR = 3;
const int FACTION_BELIEVERS_OF_THE_SOURCE = 4;
const int FACTION_BLEAK_CABAL = 5;
const int FACTION_DOOMGUARD = 6;
const int FACTION_DUSTMEN = 7;
const int FACTION_FATED = 8;
const int FACTION_FRATERNITY_OF_ORDER = 9;
const int FACTION_HARMONIUM = 10;
const int FACTION_MERCYKILLERS = 11;
const int FACTION_REVOLUTIONARY_LEAGUE = 12;
const int FACTION_SIGN_OF_ONE = 13;
const int FACTION_SOCIETY_OF_SENSATION = 14;
const int FACTION_TRASCENDENT_ORDER = 15;
const int FACTION_XAOSITECTS = 16;
const int FACTION_NONE = 17;
const int FACTION_UNDECIDED = 18;
const int FACTION_RINGGIVERS = 19;
const int FACTION_QUIT = 255;

const int FACTION_RANKS_MAX = 5; //we are standardizing this
const string FACTION_RANKS = "Namer|Factioneer|Factotum|Factoral|Factor"; //default names, will be overwritten by actual faction names

const int FACTION_RANK_NAMER = 1;
const int FACTION_RANK_FACTIONEER = 2;
const int FACTION_RANK_FACTOTUM = 3;
const int FACTION_RANK_FACTORAL = 4;
const int FACTION_RANK_FACTOR = 5;

// RANKS_<FACTION>_MAX used for quick evaluation of promotion by DM rather than enumerating the named ranks
// must keep in sync if making changes to ranks

const int HENCH_MAX_DURATION = 43200;

const string FACTION_MESSAGE_TEXT_COLOUR = "<COLOR=green>";

const string FACTION_NPC_LEFT_HAND = "LeftHandWep";
const string FACTION_NPC_RIGHT_HAND = "RightHandWep";

const string FACTION_VERSION_OLD = "Old_Factions";
const string FACTION_VERSION_NEW = "New_Factions";

/* No longer costs points to summon
const int SUMMON_NPC_COST_RP = 1;
const int SUMMON_NPC_COST_COMBAT = 5;
*/

const string RANKS_FREE_LEAGUE = "berk of little reputation|cutter of some reputation|cutter of good reputation|blood of high reputation|";
const int RANKS_FREE_LEAGUE_MAX = 4;

const string RANKS_ATHAR = "Namer|Athaon Low|Athaon Middle|Athaon High|Factor|";
const int RANKS_ATHAR_MAX = 5;

const string RANKS_BELIEVERS_OF_THE_SOURCE = "Namer|Factotum|Factor|";
const int RANKS_BELIEVERS_OF_THE_SOURCE_MAX = 3;

const string RANKS_BLEAK_CABAL = "Namer|Factotum|Factor|";
const int RANKS_BLEAK_CABAL_MAX = 3;

const string RANKS_DOOMGUARD = "Lesser Doomguard|Doomguard|Lesser Doomlord|Greater Doomlord|";
const int RANKS_DOOMGUARD_MAX = 4;

const string RANKS_DUSTMEN = "Namer|Initiate Five|Initiate Four|Initiate One|";
const int RANKS_DUSTMEN_MAX = 4;

const string RANKS_FATED = "Namer|Factotum|Factor|";
const int RANKS_FATED_MAX = 3;

const string RANKS_FRATERNITY_OF_ORDER = "Aide|Administrator A10|Administrator A9|Administrator A8|Administrator A7|Administrator A6|Administrator A5|Administrator A4|Administrator A3|Administrator A2|Administrator A1|Bureau Chief B5|Bureau Chief B4|Bureau Chief B3|Bureau Chief B2|Bureau Chief B1|";
const int RANKS_FRATERNITY_OF_ORDER_MAX = 16;

const string RANKS_HARMONIUM = "Namer|Notary 1|Notary 2|Notary 3|Notary 4|Notary 5|Measure 1|Measure 2|Measure 3|Measure 4|Measure 5|Mover 1|Mover 2|Mover 3|Mover 4|Mover 5|";
const int RANKS_HARMONIUM_MAX = 16;

const string RANKS_MERCYKILLERS = "Namer|Factotum|Justicar|Factor|";
const int RANKS_MERCYKILLERS_MAX = 4;

const string RANKS_REVOLUTIONARY_LEAGUE = "Namer|Cell Member|Trusted Cell Member|Cell Leader|";
const int RANKS_REVOLUTIONARY_LEAGUE_MAX = 4;

const string RANKS_SIGN_OF_ONE = "Namer|Factotum|Factor|";
const int RANKS_SIGN_OF_ONE_MAX = 3;

const string RANKS_SOCIETY_OF_SENSATION = "Namer|Factotum|Factor|";
const int RANKS_SOCIETY_OF_SENSATION_MAX = 3;

const string RANKS_TRANSCENDENT_ORDER = "Namer|Master of the Heart|Master of the Mind|Master of the Spirit|";
const int RANKS_TRANSCENDENT_ORDER_MAX = 4;

const string RANKS_XAOSITECTS = "irregular berk|Boss|Big Boss|";
const int RANKS_XAOSITECTS_MAX = 3;

//Faction actions - for logging purposes
const int FACTION_ACTION_JOIN = 1;
const int FACTION_ACTION_PROMOTE = 2;
const int FACTION_ACTION_DEMOTE = 3;
const int FACTION_ACTION_LEAVE = 4;
const int FACTION_ACTION_RECOMMEND = 5;
const int FACTION_ACTION_CLEAR = 6;
const int FACTION_ACTION_TRANSFER = 7;

//*************************************************************/
//Function definitions
//*************************************************************/
//returns the faction name from the faction ID
string FactionIdToName(int nFactionID);

//Get the maximum ranks possible for PCs in the faction
int GetFactionMaxRanks(int iFaction);

//Gets the pretty name for this combination of faction + rank
string GetFactionRankName(int iFaction, int iFactionRank);

//Get the faction ID of the PC
int GetFaction(object oPC);

//check if we have a badge
int HasFactionBadge(object oPC);

//Get whether this is one of the official playable factions
int GetIsFaction(int nFaction);

//Get current rank in faction
int GetFactionRank(object oPC);

//To check if we're on the new faction system yet
int GetOnNewFactionSystem(object oPC = OBJECT_INVALID);

//Function for toggling system in game
void ToggleFactionSystem(object oPC = OBJECT_INVALID);

//Function to call to promote someone in the faction
void PromoteInFaction(object oDM, object oPC);

//old faction promotion code for backwards compatibility
void PromoteInFactionOld(object oBadge, object oDM, object oTarget, string sTargetName);

//Demote in faction - new code
void DemoteInFaction(object oDM, object oPC);

//Demote in the faction - old code for backwards compatibility
void DemoteInFactionOld(object oBadge, object oDM, object oTarget, string sTargetName);

//Returns the faction badge
//Still used for certain functions
//Maybe replace with UI someday?
object GetFactionBadgeObject(object oPC);

//Set the badge's faction + info
void SetBadgeFaction(object oBadge, int iFaction);

//Log the faction action for this PC.
//for keeping records / displaying in game to DMs
void LogFactionAction(object oPC, int factionAction, string actionString);

//Remove PC (including yourself) from faction
//calls RemoveFactionBadge
void RemoveFaction(object oPC, object oDM = OBJECT_INVALID);

//Remove the faction badge object
void RemoveFactionBadge(object oBadge, object oSource, object oTarget);

//Remove all faction data - clean slate
//(does log, though)
void RemoveAllFactionData(object oDM, object oTarget);

//Show badge function (discrete)
//Put this in UI someday!
void DiscreteShowBadge(object oPC, object oTarget);

//Publicly show badge
//Put this in UI someday!
void PublicShowBadge(object oBadge, object oPC);

// used to get the faction from a different factioneer
// if pass in anything other than zero for checking faction then it will compare with that specifically
// mainly useful for double check on Anarchist infiltration.
int GetOtherFactioneerFaction(object oOtherPC, int iSeekingFaction);

//Factioneer call
//Please note that the anarchist badge reference has been removed
void SendGenericFactionMessage(object oPC);

//wrapper function for the actual object creation to pass the correct placeable 
// through specific for their faction then calls CreateSignItem
void CreateFactionSignItem(object oPC);

//Get whether we're the namer rank in chosen faction
//returns false if you're not in a playable faction
//only works on new system
int GetIsNamer(object oPC);

//Get whether we're the factioneer rank in chosen faction
//returns false if you're not in a playable faction
//only works on new system
int GetIsFactioneer(object oPC);

//Get if you are a factotum in your chosen faction
int GetIsFactotum(object oPC);

//Get whether we're the factoral rank in chosen faction
//returns false if you're not in a playable faction
//only works on new system
int GetIsFactoral(object oPC);

//Get if you are a factotum or higher in your chosen faction
int GetIsFactor(object oPC);

//port the PC into the new faction system
void PortIntoNewFactionSystem(object oPC);

//Translate ranks to standardized system
int TranslateOldRankToNewRank(int iFaction, int iCurrentRank);

//give harmonium items
void GiveHarmoniumKit(object oPC);

//give mercykiller items
void GiveMercykillerKit(object oPC);

//Faction henchman equip weapons
void FactionCohortEquipWeapons(object oHench);

//Faction henchman unequip weapons
void FactionCohortUnequipWeapons(object oHench);

//Level up the faction henchman items for your rank
void BoostFactionNPCItems(object oHench, int iBonus);

//Level up faction henchman appropriately for your rank
void BoostFactionHenchman(object oBadge, object oPC);

//Get the spawn point for the henchman
//really a more generic function
location FindHenchSpawnPoint(object oPC);

// For the next few routines, oHenchObject is probably going to be either a faction badge
// or a summoner feather (for Cere's cohort summoner script).
// looks like 1 second = 1 in the returned INT.
int AllowRespawnHench(object oHenchObject);

//Henchman variables
void ClearHenchInfo(object oHenchObject);

//Henchman variables
void StoreHenchInfo(object oHenchObject, object oHench);

//Dismess the henchman
void DismissFactionCohort(object oHench);

// just to make sure all items are usable and weapons are equippable.
void IdentifyHenchObjects(object oHench);

//Set up faction henchman
void SetUpHenchman(object oHench, object oPC);

//Find/replace faction henchman
void FindOrReplaceHenchman(object oHenchObject);

//summon faction henchman
void SummonFactionCohort(object oBadge, object oPC, int iHenchNumber);

// Basically my astral converter, but adding days as well to the return due to longer possible durations
// the astral version of this function should never need to report days, hours are even unlikely for that one.
string PS_TimeToString(int iTime);

//utility function
string FindStringInArray(int iPosition, string sArray);

//*************************************************************/
//Function code
//*************************************************************/
//returns the faction name from the faction ID
string FactionIdToName(int nFactionID) {

	switch (nFactionID) {
		case 2: return "Free League";
		case 3: return "Athar";
		case 4: return "Believers of the Source";
		case 5: return "Bleak Cabal";
		case 6: return "Doomguard";
		case 7: return "Dustmen";
		case 8: return "Fated";
		case 9: return "Fraternity of Order";
		case 10: return "Harmonium";
		case 11: return "Mercykillers";
		case 12: return "Revolutionary League";
		case 13: return "Sign of One";
		case 14: return "Society of Sensation";
		case 15: return "Transcendent Order";
		case 16: return "Xaositects";
		case 19: return "Ring-Givers";
	}
	
	return "None";

}

//Get the maximum ranks possible for PCs in the faction
int GetFactionMaxRanks(int iFaction) {

	int iMaxRanks = 0;
	
	if (GetOnNewFactionSystem()) {
		iMaxRanks = FACTION_RANKS_MAX;
	} else {
		switch (iFaction)
		{
			case 2:
				iMaxRanks = RANKS_FREE_LEAGUE_MAX;
				break;
			case 3:
				iMaxRanks = RANKS_ATHAR_MAX;
				break;
			case 4:
				iMaxRanks = RANKS_BELIEVERS_OF_THE_SOURCE_MAX;
				break;
			case 5:
				iMaxRanks = RANKS_BLEAK_CABAL_MAX;
				break;
			case 6:
				iMaxRanks = RANKS_DOOMGUARD_MAX;
				break;
			case 7:
				iMaxRanks = RANKS_DUSTMEN_MAX;
				break;
			case 8:
				iMaxRanks = RANKS_FATED_MAX;
				break;
			case 9:
				iMaxRanks = RANKS_FRATERNITY_OF_ORDER_MAX;
				break;
			case 10:
				iMaxRanks = RANKS_HARMONIUM_MAX;
				break;
			case 11:
				iMaxRanks = RANKS_MERCYKILLERS_MAX;
				break;
			case 12:
				iMaxRanks = RANKS_REVOLUTIONARY_LEAGUE_MAX;
				break;
			case 13:
				iMaxRanks = RANKS_SIGN_OF_ONE_MAX;
				break;
			case 14:
				iMaxRanks = RANKS_SOCIETY_OF_SENSATION_MAX;
				break;
			case 15:
				iMaxRanks = RANKS_TRANSCENDENT_ORDER_MAX;
				break;
			case 16:
				iMaxRanks = RANKS_XAOSITECTS_MAX;
				break;
		}
	}
	return iMaxRanks;
}

//Gets the pretty name for this combination of faction + rank
string GetFactionRankName(int iFaction, int iFactionRank) {

	string sFactionRankNames; 
	
	if (GetOnNewFactionSystem()) {
		sFactionRankNames = FACTION_RANKS;
	} else {
		switch (iFaction) {
			case 2:
				sFactionRankNames = RANKS_FREE_LEAGUE;
				break;
			case 3:
				sFactionRankNames = RANKS_ATHAR;
				break;
			case 4:
				sFactionRankNames = RANKS_BELIEVERS_OF_THE_SOURCE;
				break;
			case 5:
				sFactionRankNames = RANKS_BLEAK_CABAL;
				break;
			case 6:
				sFactionRankNames = RANKS_DOOMGUARD;
				break;
			case 7:
				sFactionRankNames = RANKS_DUSTMEN;
				break;
			case 8:
				sFactionRankNames = RANKS_FATED;
				break;
			case 9:
				sFactionRankNames = RANKS_FRATERNITY_OF_ORDER;
				break;
			case 10:
				sFactionRankNames = RANKS_HARMONIUM;
				break;
			case 11:
				sFactionRankNames = RANKS_MERCYKILLERS;
				break;
			case 12:
				sFactionRankNames = RANKS_REVOLUTIONARY_LEAGUE;
				break;
			case 13:
				sFactionRankNames = RANKS_SIGN_OF_ONE;
				break;
			case 14:
				sFactionRankNames = RANKS_SOCIETY_OF_SENSATION;
				break;
			case 15:
				sFactionRankNames = RANKS_TRANSCENDENT_ORDER;
				break;
			case 16:
				sFactionRankNames = RANKS_XAOSITECTS;
				break;
			}
	}

	string sNameToReturn = FindStringInArray(iFactionRank, sFactionRankNames);
	
	if (sNameToReturn == "")
		sNameToReturn = "ERROR: Faction name not found!!!";
	return sNameToReturn;
}

//Get the faction ID of the PC
int GetFaction(object oPC) {

	if (!GetOnNewFactionSystem()) {
		object oItem = GetFactionBadgeObject(oPC);
	    if(GetIsObjectValid(oItem))
	    {
		 	int nFaction = PS_GetLocalInt(oItem,"Faction");
			return nFaction;
	    }
	}
	
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	if(GetIsObjectValid(oItem)) {
		int oldFaction = PS_GetLocalInt(oItem, "Faction");
		if (oldFaction == FACTION_QUIT)
			return FACTION_QUIT;
	}
	
	string sID = PS_GetCharID(oPC);
	string sQuery = "SELECT faction_id FROM characterfactions WHERE character_id = "+sID;
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		int faction_id = StringToInt(SQLGetData(1));
		return faction_id;
	}
	
	return 0;
}

//Get the faction rank of the PC
int GetFactionRank(object oPC) {

	object oBadge = GetFactionBadgeObject(oPC);
	if (!GetOnNewFactionSystem()) {
	    if(GetIsObjectValid(oBadge))
	    {
		 	int nFactionRank = PS_GetLocalInt(oBadge,"FactionRank");
			return nFactionRank;
	    }
	}
	
	string sID = PS_GetCharID(oPC);
	string sQuery = "SELECT faction_id, faction_rank FROM characterfactions WHERE character_id = "+sID;
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		int iFaction = StringToInt(SQLGetData(1));
		int faction_rank = StringToInt(SQLGetData(2));
		PS_SetLocalInt(oBadge, "FactionRank", faction_rank);
		PS_SetLocalString(oBadge, "FactionRankName", GetFactionRankName(iFaction, faction_rank));
		return faction_rank;
	}
	
	return 0;
}

// Just a small routine to determine if a character has a badge.
int HasFactionBadge(object oPC) {

	object oItem = GetItemPossessedBy(oPC,"ps_faction_badge");
    
	if(GetIsObjectValid(oItem))
    	return TRUE;
	else
		return FALSE;

}

//Get the Faction Badge itself
object GetFactionBadgeObject(object oPC) {

	object oBadge = PS_GetLocalObject(oPC, "FactionBadgeUsed");
	if (!GetIsObjectValid(oBadge)) {
		oBadge = GetItemPossessedBy(oPC, "ps_faction_badge");
	}
	return oBadge;
}

//Get whether this faction ID belongs to one of 
//the official playable factions
int GetIsFaction(int nFaction) {
	
	if (((nFaction > 1) && (nFaction < 17)) || nFaction == 19)
		return TRUE;
		
	return FALSE;

}

//To check if we're on the new faction system yet
int GetOnNewFactionSystem(object oPC = OBJECT_INVALID) {

	object oModule = GetModule();
	string sSystem = PS_GetLocalString(oModule, "FACTION_SYSTEM");
	
	if (sSystem == "") {
	
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Fetching faction version");
		string sQuery = "SELECT version FROM server_version WHERE row_id="+IntToString(FACTION_VERSION_ROW);
		SQLExecDirect(sQuery);
		if (SQLFetch() != SQL_ERROR) { 
			string version = SQLGetData(1);
			if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Found faction version: "+version);
			PS_SetLocalString(oModule, "FACTION_SYSTEM", version);
		}
		sSystem = PS_GetLocalString(oModule, "FACTION_SYSTEM");
		
	}
	
	if (sSystem == FACTION_VERSION_NEW) {
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "We are on the new version");
		return TRUE;
	}
	else {
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "We are on the old version");
		return FALSE;
	}

}

void ToggleFactionSystem(object oPC = OBJECT_INVALID) {

	object oModule = GetModule();
	
	string sQuery = "";
	if (GetOnNewFactionSystem()) {
		sQuery = "UPDATE server_version SET version='"+FACTION_VERSION_OLD+"' WHERE row_id = "+IntToString(FACTION_VERSION_ROW);
		PS_SetLocalString(oModule, "FACTION_SYSTEM", FACTION_VERSION_OLD);
		SendMessageToPC(oPC, "Server is now using the old faction system");
	} else {
		sQuery = "UPDATE server_version SET version='"+FACTION_VERSION_NEW+"' WHERE row_id = "+IntToString(FACTION_VERSION_ROW);
		PS_SetLocalString(oModule, "FACTION_SYSTEM", FACTION_VERSION_NEW);
		SendMessageToPC(oPC, "Server is now using the new faction system");
	}
	
	SQLExecDirect(sQuery);
	
	//GetOnNewFactionSystem(oPC);

}

//Promte in the faction - new code
void PromoteInFaction(object oDM, object oPC) {
	
	object oBadge = GetFactionBadgeObject(oPC);
	//For backwards compatibility 
	if (!GetOnNewFactionSystem()) {
		string sTargetName = GetName(oPC);
		PromoteInFactionOld(oBadge, oDM, oPC, sTargetName);
		return;
	}
	
	string sID = PS_GetCharID(oPC);
	string sQuery = "SELECT faction_id, faction_rank FROM characterfactions WHERE character_id = "+sID;
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		int faction_id = StringToInt(SQLGetData(1));
		int faction_rank = StringToInt(SQLGetData(2));
		int iMaxRanks = GetFactionMaxRanks(faction_id);
		string sFactionName = FactionIdToName(faction_id);
		
		if (faction_rank < iMaxRanks)
		{
			int newRank = faction_rank+1;
			sQuery = "UPDATE characterfactions SET faction_rank="+IntToString(newRank)+" WHERE character_id = "+sID;
			SQLExecDirect(sQuery);
			PS_SetLocalInt(oBadge, "FactionRank", newRank);
			PS_SetLocalString(oBadge, "FactionRankName", GetFactionRankName(faction_id, newRank));
			
			SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + GetName(oPC) + " has been promoted in the " 
				+ sFactionName 
				+ " from " + GetFactionRankName(faction_id, faction_rank) + " to "
				+ GetFactionRankName(faction_id, newRank) + ".");
				
			SendMessageToPC(oPC, FACTION_MESSAGE_TEXT_COLOUR + "You have been promoted in the " 
				+ sFactionName 
				+ " from " + GetFactionRankName(faction_id, faction_rank) + " to "
				+ GetFactionRankName(faction_id, newRank) + ".");
				
			//Log faction action - promotion
			LogFactionAction(oPC, FACTION_ACTION_PROMOTE, GetName(oPC) + " has been promoted in the " 
				+ sFactionName 
				+ " from " + GetFactionRankName(faction_id, faction_rank) + " to "
				+ GetFactionRankName(faction_id, newRank) + " by " + GetName(oDM));
			
		} else {
			SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + GetName(oPC) + " is already maximum rank in the " + sFactionName + ".");
		}
	}
	
}

//Promte in the faction - old code for backwards compatibility
void PromoteInFactionOld(object oBadge, object oDM, object oTarget, string sTargetName) {

	int iCurrentRank = PS_GetLocalInt(oBadge, "FactionRank");
	int iFaction = PS_GetLocalInt(oBadge, "Faction");
	int iMaxRanks = GetFactionMaxRanks(iFaction);
	
	
	if (iCurrentRank < iMaxRanks)
	{			
		PS_SetLocalInt(oBadge, "FactionRank", iCurrentRank + 1);
		PS_SetLocalString(oBadge, "FactionRankName", GetFactionRankName(iFaction, iCurrentRank + 1));
				
		SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " has been promoted in the " 
			+ PS_GetLocalString(oBadge, "FactionName") 
			+ " from " + GetFactionRankName(iFaction, iCurrentRank) + " to "
			+ GetFactionRankName(iFaction, iCurrentRank + 1) + ".");
				
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "You have been promoted in the " 
			+ PS_GetLocalString(oBadge, "FactionName") 
			+ " from " + GetFactionRankName(iFaction, iCurrentRank) + " to "
			+ GetFactionRankName(iFaction, iCurrentRank + 1) + ".");
	}
	else
	{
		SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " is already maximum rank in the " + PS_GetLocalString(oBadge, "FactionName") + ".");
	}
		
}

//Demote in faction - new code
void DemoteInFaction(object oDM, object oPC) {

	object oBadge = GetFactionBadgeObject(oPC);
	//For backwards compatibility 
	if (!GetOnNewFactionSystem()) {
		string sTargetName = GetName(oPC);
		DemoteInFactionOld(oBadge, oDM, oPC, sTargetName);
		return;
	}
	
	string sID = PS_GetCharID(oPC);
	string sQuery = "SELECT faction_id, faction_rank FROM characterfactions WHERE character_id = "+sID;
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		int faction_id = StringToInt(SQLGetData(1));
		int faction_rank = StringToInt(SQLGetData(2));
		int iMaxRanks = GetFactionMaxRanks(faction_id);
		string sFactionName = FactionIdToName(faction_id);
		
		if (faction_rank > 1) {
		
			int newRank = faction_rank-1;
			sQuery = "UPDATE characterfactions SET faction_rank="+IntToString(newRank)+" WHERE character_id = "+sID;
			SQLExecDirect(sQuery);
			PS_SetLocalInt(oBadge, "FactionRank", newRank);
			PS_SetLocalString(oBadge, "FactionRankName", GetFactionRankName(faction_id, newRank));
			
			SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + GetName(oPC) + " has been demoted in the " 
				+ sFactionName 
				+ " from " + GetFactionRankName(faction_id, faction_rank) + " to "
				+ GetFactionRankName(faction_id, newRank) + ".");
				
			SendMessageToPC(oPC, FACTION_MESSAGE_TEXT_COLOUR + "You have been demoted in the " 
				+ sFactionName 
				+ " from " + GetFactionRankName(faction_id, faction_rank) + " to "
				+ GetFactionRankName(faction_id, newRank) + ".");
				
			//Log faction action - demotion
			LogFactionAction(oPC, FACTION_ACTION_DEMOTE, GetName(oPC) + " has been demoted in the " 
				+ sFactionName 
				+ " from " + GetFactionRankName(faction_id, faction_rank) + " to "
				+ GetFactionRankName(faction_id, newRank) + " by " + GetName(oDM));
			
		} else {
			SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + GetName(oPC) + " is already minimum rank in the " + sFactionName + ".");
		}
	}
}

//Demote in the faction - old code for backwards compatibility
void DemoteInFactionOld(object oBadge, object oDM, object oTarget, string sTargetName) {

	int iCurrentRank = PS_GetLocalInt(oBadge, "FactionRank");
	int iFaction = PS_GetLocalInt(oBadge, "Faction");
	
	if (iCurrentRank > 1) //because if 1 then can't go lower!
	{
		PS_SetLocalInt(oBadge, "FactionRank", iCurrentRank - 1);
		PS_SetLocalString(oBadge, "FactionRankName", GetFactionRankName(iFaction, iCurrentRank - 1));
				
		SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " has been demoted in the " 
			+ PS_GetLocalString(oBadge, "FactionName") 
			+ " from " + GetFactionRankName(iFaction, iCurrentRank) + " to "
			+ GetFactionRankName(iFaction, iCurrentRank - 1) + ".");
				
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "You have been demoted in the " 
			+ PS_GetLocalString(oBadge, "FactionName") 
			+ " from " + GetFactionRankName(iFaction, iCurrentRank) + " to "
			+ GetFactionRankName(iFaction, iCurrentRank - 1) + ".");
	}
	else
	{
		SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " is already minimum rank in the " + PS_GetLocalString(oBadge, "FactionName") + ".");
	}
}

//Join a new faction!
//If we already had a faction, make sure to call the leave faction function first
//Though this will remove faction db entry just in case
void JoinFaction(object oPC, int iFaction) {

	//Make a note on the essence for quick finding later
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	if(GetIsObjectValid(oItem)) {
		PS_SetLocalInt(oItem, "Faction", iFaction);
	}

	//Now on to the real stuff:
	object oBadge; 
	if (HasFactionBadge(oPC) == FALSE) {
		oBadge = CreateItemOnObject("ps_faction_badge", oPC);
	} else {
		oBadge = GetFactionBadgeObject(oPC);
	}
	
	SetBadgeFaction(oBadge, iFaction);
	
	string sID = PS_GetCharID(oPC);
	string sFactionName = FactionIdToName(iFaction);
	
	//Removing data just in case, but really, we should always call leave faction first
	string sQuery = "DELETE FROM characterfactions WHERE character_id = "+sID;
	SQLExecDirect(sQuery);
	
	sQuery = "INSERT INTO characterfactions SET character_id = "+sID+", faction_id = "+IntToString(iFaction)+", faction_rank=1";
	SQLExecDirect(sQuery);
				
	//Log faction action - join faction
	LogFactionAction(oPC, FACTION_ACTION_JOIN, GetName(oPC) + " has joined the " + sFactionName);
}

//Log the faction action for this PC.
//for keeping records / displaying in game to DMs
void LogFactionAction(object oPC, int factionAction, string actionString) {

	string sID = PS_GetCharID(oPC);
	
	actionString = SQLEncodeSpecialChars(actionString);
	string sQuery = "INSERT INTO factionlogging SET event_id="+IntToString(factionAction)+", event_description='"+actionString+"', character_id="+sID+", event_created = CURRENT_TIMESTAMP";
	SQLExecDirect(sQuery);

}

//Set the badge's faction + info
void SetBadgeFaction(object oBadge, int iFaction)
{
	int iIconRow;
	object oPC = GetItemPossessor(oBadge);
	PS_SetLocalInt(oBadge, "Faction", iFaction);
	
	// rank 1 is Namer equivalent. 0 we may use for left/kicked out or something.
	PS_SetLocalInt(oBadge, "FactionRank", 1);
	PS_SetLocalString(oBadge, "FactionRankName", GetFactionRankName(iFaction, 1));
	switch (iFaction)
		{
			case 2:
				//sFaction = "Free League";
				iIconRow = 2203;
				PS_SetLocalString(oBadge, "FactionName", "Free League");
				break;
			case 3:
				//sFaction = "Athar";
				iIconRow = 2196;
				PS_SetLocalString(oBadge, "FactionName", "Athar");
				break;
			case 4:
				//sFaction = "Believers of the Source";
				iIconRow = 2204;
				PS_SetLocalString(oBadge, "FactionName", "Believers of the Source");
				break;
			case 5:
				//sFaction = "Bleak Cabal";
				iIconRow = 2197;
				PS_SetLocalString(oBadge, "FactionName", "Bleak Cabal");
				break;
			case 6:
				//sFaction = "Doomguard";
				iIconRow = 2199;
				PS_SetLocalString(oBadge, "FactionName", "Doomguard");
				break;
			case 7:
				//sFaction = "Dustmen";
				iIconRow = 2200;
				PS_SetLocalString(oBadge, "FactionName", "Dustmen");
				break;
			case 8:
				//sFaction = "Fated";
				iIconRow = 2201;
				PS_SetLocalString(oBadge, "FactionName", "Fated");
				break;
			case 9:
				//sFaction = "Fraternity of Order";
				iIconRow = 2202;
				PS_SetLocalString(oBadge, "FactionName", "Fraternity of Order");
				break;
			case 10:
				//sFaction = "Harmonium"; 
				iIconRow = 2205;
				PS_SetLocalString(oBadge, "FactionName", "Harmonium");
				GiveHarmoniumKit(oPC);
				break;
			case 11:
				//sFaction = "Mercykillers";
				iIconRow = 2206;
				PS_SetLocalString(oBadge, "FactionName", "Mercykillers");
				GiveMercykillerKit(oPC);
				break;
			case 12:
				//sFaction = "Revolutionary League";
				iIconRow = 2195;
				PS_SetLocalString(oBadge, "FactionName", "Revolutionary League");
				PS_SetLocalInt(oBadge, "Infiltrated", FALSE);
				PS_SetLocalInt(oBadge, "InfiltratedFaction", 0);
				break;
			case 13:
				//sFaction = "Sign of One";
				iIconRow = 2208;
				PS_SetLocalString(oBadge, "FactionName", "Sign of One");
				break;
			case 14:
				//sFaction = "Society of Sensation";
				iIconRow = 2207;
				PS_SetLocalString(oBadge, "FactionName", "Society of Sensation");
				break;
			case 15:
				//sFaction = "Transcendent Order";
				iIconRow = 2198;
				PS_SetLocalString(oBadge, "FactionName", "Transcendent Order");
				break;
			case 16:
				//sFaction = "Xaositects";
				iIconRow = 2209;
				PS_SetLocalString(oBadge, "FactionName", "Xaositects");
				break;
			case 19:
				//sFaction = "Ring-Givers";
				iIconRow = 2212;
				PS_SetLocalString(oBadge, "FactionName", "Ring-Givers");
				break;
		}
		
	SetItemIcon(oBadge, iIconRow);
	SetFirstName(oBadge, PS_GetLocalString(oBadge, "FactionName") + " Faction Badge");
}

//Remove faction - new system
void RemoveFaction(object oPC, object oDM = OBJECT_INVALID) {

	int iFaction = GetFaction(oPC);
	string sFactionName = FactionIdToName(iFaction);
	
	object oBadge; 
	if (HasFactionBadge(oPC)) {
		oBadge = GetFactionBadgeObject(oPC);
		if (GetIsObjectValid(oDM))
			RemoveFactionBadge(oBadge, oDM, oPC);
		else
			RemoveFactionBadge(oBadge, oPC, oPC);
	}
	
	string sID = PS_GetCharID(oPC);
	
	//Removing data just in case, but really, we should always call leave faction first
	string sQuery = "DELETE FROM characterfactions WHERE character_id = "+sID;
	SQLExecDirect(sQuery);
				
	//Log faction action - join faction
	if (GetIsObjectValid(oDM))
		LogFactionAction(oPC, FACTION_ACTION_LEAVE, GetName(oPC) + " has been kicked out of the " + sFactionName + " by "+GetName(oDM));
	else
		LogFactionAction(oPC, FACTION_ACTION_LEAVE, GetName(oPC) + " has left the " + sFactionName + " voluntarily.");
}

//Remove the faction badge object
void RemoveFactionBadge(object oBadge, object oSource, object oTarget) {
	// if anarch check then it means we are removing the anarch badge, 
	// then check for infiltrate info on the badge before deleting so we can
	// set their other faction as primary.  Of course, they may have already left that one as well
	// so we need to confirm that badge exists.
	// when no badges at all, set ps_essence faction to 255.
	
	// first just check for and remove any faction henchmen
	
	object oHench = GetHenchman(oTarget, 1);
	
	if (oHench != OBJECT_INVALID)
	{
		if (GetStringLeft(GetTag(oHench), 15) == "ps_faction_npc_")
		{
			DismissFactionCohort(oHench);
		}
	}
	
	int nOldRank = PS_GetLocalInt(oBadge,"FactionRank");
	
	int iInfiltrated = 0;
	string sFactionName = PS_GetLocalString(oBadge, "FactionName");
	object oEssence = GetItemPossessedBy(oTarget, "ps_essence");
	
	if (PS_GetLocalInt(oBadge, "Faction") == 12)
	{
		iInfiltrated = PS_GetLocalInt(oBadge, "Infiltrated");
		int iInfiltrationConfirmed = FALSE;
		
		// if this is anything but 0 then we need to check a badge exists of that faction
		// if it does, then we set the essence to use that as the new primary faction.
		object oItem = GetFirstItemInInventory(oTarget);
	
		while (oItem != OBJECT_INVALID)
		{
			if (GetTag(oItem) == "ps_faction_badge")
				if (PS_GetLocalInt(oItem, "Faction") == iInfiltrated)
					iInfiltrationConfirmed = TRUE;
			
			oItem = GetNextItemInInventory(oTarget);
		}
		
		
		if (iInfiltrationConfirmed == TRUE)
			PS_SetLocalInt(oEssence, "Faction", iInfiltrated);
		else if (nOldRank > 1)
			PS_SetLocalInt(oEssence, "Faction", FACTION_QUIT);
		else
			PS_DeleteLocalInt(oEssence, "Faction");
	}
	else
	{
		if (nOldRank > 1)
			PS_SetLocalInt(oEssence, "Faction", FACTION_QUIT);
		else
			PS_DeleteLocalInt(oEssence, "Faction");
	}
	
	DestroyObject(oBadge, 0.0, TRUE);
	
	if (oSource == oTarget)
	{
		// Player has self booted
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "You have left the " + sFactionName 
			+ " and now are an outcast from that faction. Please RP this appropriately");
	}
	else
	{
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "You have been kicked out of the " 
			+ sFactionName + " and now are an outcast from that faction. Please RP this appropriately");
		SendMessageToPC(oSource, FACTION_MESSAGE_TEXT_COLOUR + "You have kicked " + GetName(oTarget)
			+ " out of the " + sFactionName + ".");
	}
	
}

//Remove all faction data from the badge
void RemoveAllFactionData(object oDM, object oTarget) {

	object oItem = GetFirstItemInInventory(oTarget);
	
	while (oItem != OBJECT_INVALID)
	{
		if (GetTag(oItem) == "ps_essence")
		{
			PS_SetLocalInt(oItem, "Faction", 0);
		}
		else if (GetTag(oItem) == "ps_faction_badge")
			DestroyObject(oItem, 0.0, TRUE);
			
		oItem = GetNextItemInInventory(oTarget);
	}
	
	string sID = PS_GetCharID(oTarget);
	//Removing data just in case, but really, we should always call leave faction first
	string sQuery = "DELETE FROM characterfactions WHERE character_id = "+sID;
	SQLExecDirect(sQuery);
	
	LogFactionAction(oTarget, FACTION_ACTION_CLEAR, GetName(oTarget) + " has had all faction data cleared by "+GetName(oDM));
	
}

//Show badge function
//Put this in UI someday!
void DiscreteShowBadge(object oPC, object oTarget) {

	int nFactionID = GetFaction(oPC);
	int nFactionRank = GetFactionRank(oPC);
	//SendMessageToPC(oPC, "found faction: "+IntToString(nFactionID)+", rank: "+IntToString(nFactionRank));
	
	string sFactionName = FactionIdToName(nFactionID);
	string sFactionRankName = GetFactionRankName(nFactionID, nFactionRank);

	SendMessageToPC(oPC,FACTION_MESSAGE_TEXT_COLOUR + "Discretely showing badge");
	if (oPC == oTarget)
	{
			SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "*You discreetly look at your badge which identifies you as a " +
			sFactionRankName + " in the " + sFactionName + ".*");
	}
	else if (GetIsDM(oTarget))
	{
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "*" + GetName(oPC) + " is a " +
			sFactionRankName + " in the " + sFactionName + ".*");
	}
	else
	{
		SendMessageToPC(oPC, FACTION_MESSAGE_TEXT_COLOUR + "*You discreetly show your badge to " + GetName(oTarget) + ".");
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "*" + GetName(oPC) + " discretely shows you their faction badge which identifies them as a " +
			sFactionRankName + " in the " + sFactionName + ".*");
	}
}

//Publicly show badge
//Put this in UI someday!
void PublicShowBadge(object oBadge, object oPC) {	

	int nFactionID = GetFaction(oPC);
	int nFactionRank = GetFactionRank(oPC);
	string sFactionName = FactionIdToName(nFactionID);
	string sFactionRankName = GetFactionRankName(nFactionID, nFactionRank);
	
	SendMessageToPC(oPC, "Publically showing badge");
	AssignCommand(oPC, SpeakString(FACTION_MESSAGE_TEXT_COLOUR + "*" + GetName(oPC) + " displays their faction badge openly showing them to be a " + 
		sFactionRankName + " in the " + sFactionName + ".*", TALKVOLUME_TALK));
}

// used to get the faction from a different factioneer
// if pass in anything other than zero for checking faction then it will compare with that specifically
// mainly useful for double check on Anarchist infiltration.
int GetOtherFactioneerFaction(object oOtherPC, int iSeekingFaction) {

	int iFaction = 0;
	object oEssence = GetItemPossessedBy(oOtherPC,"ps_essence");
   	if(GetIsObjectValid(oEssence))
   	{
		// use essence because quick to find and no checking of badge statuses required
		iFaction = PS_GetLocalInt(oEssence, "Faction");
   	}
   	
   	if (((iFaction > 1) && (iFaction < 17)) || iFaction == 19)
	{
		if (iFaction == 12 && iSeekingFaction != 12)
		// ok, we got an anarch, need to check for infiltration and then check against iSeekingFaction
		{
			if (iSeekingFaction == 12)
			{
				return iFaction;
			}
			else
			{
				// let's check for infiltration
				object oBadge = GetItemPossessedBy(oOtherPC,"ps_faction_badge");
				// doesn't matter if it finds the Anarch badge or another, it should find one
				int iCoverFaction = PS_GetLocalInt(oBadge, "Faction");
				if (iCoverFaction == 12)
				// we found the anarch badge
				{
					if (PS_GetLocalInt(oBadge, "Infiltrated") == TRUE)
						return PS_GetLocalInt(oBadge, "InfiltratedFaction");
					else
						return iFaction;
				}
				else
				{
					return PS_GetLocalInt(oBadge, "Faction");
				}
			}
		}
		else
		{
			// if not seeking a particular faction, then can return anarch badge if first found
			// could be some issue here need to think about.
			return iFaction;
		}
	}
	else
		return 0;
}

//Factioneer call
//Please note that the anarchist badge reference has been removed
void SendGenericFactionMessage(object oPC) {
	
	int iFaction = GetFaction(oPC);
	int nFactionRank = GetFactionRank(oPC);
	string sFactionName = FactionIdToName(iFaction);
	string sFactionRankName = GetFactionRankName(iFaction, nFactionRank);
	
	int iOtherFaction;
	int iCount = 0;
	object oOtherPC;
	string sMessage = FACTION_MESSAGE_TEXT_COLOUR + "Chant on the street is that " + GetName(oPC) + ", a " + sFactionRankName + " in the " + sFactionName + " is looking for assistance in the " + GetName(GetArea(oPC)) + ".";
	
	oOtherPC = GetFirstPC();
	
	while (oOtherPC != OBJECT_INVALID)
	{
		if (oOtherPC != oPC)
		{
			iOtherFaction = GetOtherFactioneerFaction(oOtherPC, iFaction);
			if (iOtherFaction == iFaction)
			{
				iCount += 1;
				SendMessageToPC(oOtherPC, sMessage);
			}
		}
		oOtherPC = GetNextPC();
	}
	
	if (iCount == 0)
		sMessage = FACTION_MESSAGE_TEXT_COLOUR + "Your call went out, but doesn't seem likely anyone heard.";
	else if (iCount == 1 || iCount == 2)
		sMessage = FACTION_MESSAGE_TEXT_COLOUR + "Your call went out, and a fellow factioneer or two may have heard.";
	else
		sMessage = FACTION_MESSAGE_TEXT_COLOUR + "Your call went out, and its likly that a factioneer will respond.";
		
	SendMessageToPC(oPC, sMessage);	
}

//wrapper function for the actual object creation to pass the correct placeable 
// through specific for their faction then calls CreateSignItem
void CreateFactionSignItem(object oPC) {

	int iFaction = GetFaction(oPC);
	string sTemplate;
	string sItemName;
	
	switch(iFaction)
	{
		// just temp use the same template.
		case 2: sTemplate = "ps_usersign_faction_fl"; sItemName = "Free League Sign Creator"; break;
		case 3: sTemplate = "ps_usersign_faction_at"; sItemName = "Athar Banner Creator"; break;
		case 4: sTemplate = "ps_usersign_faction_bs"; sItemName = "Believers of the Source Sign Creator"; break;
		case 5: sTemplate = "ps_usersign_faction_bc"; sItemName = "Bleak Cabal Sign Creator"; break;
		case 6: sTemplate = "ps_usersign_faction_dg"; sItemName = "Doomguard Standard Creator"; break;
		case 7: sTemplate = "ps_usersign_faction_du"; sItemName = "Dustmen Bone Pole Creator"; break;
		case 8: sTemplate = "ps_usersign_faction_fa"; sItemName = "Fated Banner Creator"; break;
		case 9: sTemplate = "ps_usersign_faction_fo"; sItemName = "Fraternity of Order Banner Creator"; break;
		case 10: sTemplate = "ps_usersign_faction_ha"; sItemName = "Harmonium Standard Creator"; break;
		case 11: sTemplate = "ps_usersign_faction_mk"; sItemName = "Mercykillers Standard Creator"; break;
		case 12: sTemplate = "ps_usersign_faction_rl"; sItemName = "Revolutionary League Proclamation Creator"; break;
		case 13: sTemplate = "ps_usersign_faction_so"; sItemName = "Sign of the Sign of One Creator"; break;
		case 14: sTemplate = "ps_usersign_faction_ss"; sItemName = "Soceity of Sensation Announcement Creator"; break;
		case 15: sTemplate = "ps_usersign_faction_to"; sItemName = "Transcendent Order Notice Creator"; break;
		case 16: sTemplate = "ps_usersign_faction_xa"; sItemName = "Xaositects Crazy Pole Creator"; break;
		case 19: sTemplate = "ps_usersign_faction_ring"; sItemName = "Ring-Giver Standard Creator"; break;
	}
	
	object oItem = CreateItemOnObject("ps_factionsign", oPC);
	
	if (oItem != OBJECT_INVALID)
	{
		SendMessageToPC(oPC, sTemplate);
		SetFirstName(oItem, sItemName);
		PS_SetLocalString(oItem, "TEMPLATE_RESREF", sTemplate);
	}
	else
	{
		SendMessageToPC(oPC, "Failed to create faction sign creator.  Please report a bug via the forums");
	}
}

//Port PC into the new faction system
void PortIntoNewFactionSystem(object oPC) {

	object oBadge = GetFactionBadgeObject(oPC);
		
	//We aren't in a faction; so we don't need to go farther
	if (!GetIsObjectValid(oBadge)) {
		return;
	}
	
	//Check if we've already done this
	string sID = PS_GetCharID(oPC);
	string sQuery = "SELECT faction_id FROM characterfactions WHERE character_id = "+sID;
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		int faction_id = StringToInt(SQLGetData(1));
		if (GetIsFaction(faction_id))
			return;
	}
	
	if (GetOnNewFactionSystem()) {
		SendMessageToPC(oPC, "You are still on the old faction system! Transferring your badge now.");
	}
	
	//Ok, we are in a faction but not transferred yet. Proceed.
	int iCurrentRank = PS_GetLocalInt(oBadge, "FactionRank");
	int iFaction = PS_GetLocalInt(oBadge, "Faction");
	
	int newRank = TranslateOldRankToNewRank(iFaction, iCurrentRank);
	
	sQuery = "INSERT INTO characterfactions SET faction_id="+IntToString(iFaction)+", faction_rank="+IntToString(newRank)+", character_id="+sID;
	SQLExecDirect(sQuery);
	
	LogFactionAction(oPC, FACTION_ACTION_TRANSFER, GetName(oPC) + " has been transferred into the new system. Old rank: " + IntToString(iCurrentRank) + ", New rank: "+IntToString(newRank)); 
	
}

//Translate ranks to standardized system
int TranslateOldRankToNewRank(int iFaction, int iCurrentRank) {

	//ATHAR
	if (iFaction == FACTION_ATHAR) {
		return iCurrentRank;
	}
	
	//GODSMEN
	if (iFaction == FACTION_BELIEVERS_OF_THE_SOURCE) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTOR;
		else
			return FACTION_RANK_NAMER;
	}
	
	//BLEAKERS
	if (iFaction == FACTION_BLEAK_CABAL) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTOR;
		else
			return FACTION_RANK_NAMER;
	}
	
	//DOOMGUARD
	if (iFaction == FACTION_DOOMGUARD) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTORAL;
		else if (iCurrentRank == 4)
			return FACTION_RANK_FACTOR;
		else 
			return FACTION_RANK_NAMER;
	}
	
	//DUSTIES
	if (iFaction == FACTION_DUSTMEN) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTORAL;
		else if (iCurrentRank == 4)
			return FACTION_RANK_FACTOR;
		else 
			return FACTION_RANK_NAMER;
	}
	
	//FATED
	if (iFaction == FACTION_FATED) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTOR;
		else
			return FACTION_RANK_NAMER;
	}
	
	//GUVNERS
	if (iFaction == FACTION_FRATERNITY_OF_ORDER) {
		if (iCurrentRank == 1)
			return FACTION_RANK_NAMER;
		else if (iCurrentRank < 7)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank < 10)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank < 12)
			return FACTION_RANK_FACTORAL;
		else
			return FACTION_RANK_FACTOR;
	}
	
	//HARMONIUM
	if (iFaction == FACTION_HARMONIUM) {
		if (iCurrentRank == 1)
			return FACTION_RANK_NAMER;
		else if (iCurrentRank < 7)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank < 10)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank < 12)
			return FACTION_RANK_FACTORAL;
		else
			return FACTION_RANK_FACTOR;
	}
	
	//MERCYKILLERS
	if (iFaction == FACTION_MERCYKILLERS) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTORAL;
		else if (iCurrentRank == 4)
			return FACTION_RANK_FACTOR;
		else 
			return FACTION_RANK_NAMER;
	}
	
	//REVS - we don't support this, but no reason not to keep records-
	if (iFaction == FACTION_REVOLUTIONARY_LEAGUE) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTORAL;
		else if (iCurrentRank == 4)
			return FACTION_RANK_FACTOR;
		else 
			return FACTION_RANK_NAMER;
	}
	
	//Indeps
	if (iFaction == FACTION_FREE_LEAGUE) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTORAL;
		else if (iCurrentRank == 4)
			return FACTION_RANK_FACTOR;
		else 
			return FACTION_RANK_NAMER;
	}
	
	//Signers
	if (iFaction == FACTION_SIGN_OF_ONE) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTOR;
		else 
			return FACTION_RANK_NAMER;
	}
	
	//Sensates
	if (iFaction == FACTION_SOCIETY_OF_SENSATION) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTOR;
		else 
			return FACTION_RANK_NAMER;
	}
	
	//Ciphers
	if (iFaction == FACTION_TRASCENDENT_ORDER) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTORAL;
		else if (iCurrentRank == 4)
			return FACTION_RANK_FACTOR;
		else 
			return FACTION_RANK_NAMER;
	}
	
	//Xaos
	if (iFaction == FACTION_XAOSITECTS) {
		if (iCurrentRank == 1)
			return FACTION_RANK_FACTIONEER;
		else if (iCurrentRank == 2)
			return FACTION_RANK_FACTOTUM;
		else if (iCurrentRank == 3)
			return FACTION_RANK_FACTOR;
		else 
			return FACTION_RANK_NAMER;
	}
	
	return FALSE;

}

//Get whether we're the namer rank in chosen faction
//returns false if you're not in a playable faction
//only works on new system
int GetIsNamer(object oPC) {
	int nFaction = GetFaction(oPC);
	int iRank = GetFactionRank(oPC);
	
	if (GetOnNewFactionSystem()) {
		if (GetIsFaction(nFaction)) {
			return (iRank == FACTION_RANK_NAMER);
		}
	}
	
	return FALSE;
}

//Get whether we're the factioneer rank in chosen faction
//returns false if you're not in a playable faction
//only works on new system
int GetIsFactioneer(object oPC) {
	int nFaction = GetFaction(oPC);
	int iRank = GetFactionRank(oPC);
	
	if (GetOnNewFactionSystem()) {
		if (GetIsFaction(nFaction)) {
			return (iRank == FACTION_RANK_FACTIONEER);
		}
	}
	
	return FALSE;
}


//Get if you are a factotum in your chosen faction
int GetIsFactotum(object oPC) {

	int nFaction = GetFaction(oPC);
	int iRank = GetFactionRank(oPC);
	
	if (GetOnNewFactionSystem()) {
		if (GetIsFaction(nFaction)) {
			return (iRank == FACTION_RANK_FACTOTUM);
		}
	} else {
		if ((nFaction == 2 || nFaction == 6 || nFaction == 7 || nFaction == 11 || nFaction == 12 || nFaction == 15) && 
		(iRank >= 2 && iRank <= 3)) //Free League / Doomguard / Dustmen / Mercykillers / Anarchists / Transcendent Order
			return TRUE;
		else if (nFaction == 3 && (iRank >= 2 && iRank <= 4)) //Athar 
			return TRUE;
		else if ((nFaction == 4 || nFaction == 5 || nFaction == 8 || nFaction == 13 || nFaction == 14 || nFaction == 16) 
		&& iRank == 2) //Believers of the Source / Bleak Cabal / Fated
			return TRUE;
		else if (nFaction == 9 && (iRank >= 2 && iRank <= 11))
			return TRUE;
		else if (nFaction == 10 && (iRank >= 7 && iRank <= 11))
			return TRUE;
	}
		
	return FALSE;
}

//Get whether we're the factoral rank in chosen faction
//returns false if you're not in a playable faction
//only works on new system
int GetIsFactoral(object oPC) {
	int nFaction = GetFaction(oPC);
	int iRank = GetFactionRank(oPC);
	
	if (GetOnNewFactionSystem()) {
		if (GetIsFaction(nFaction)) {
			return (iRank == FACTION_RANK_FACTORAL);
		}
	}
	
	return FALSE;
}

//Get if you are a factotum or higher in your chosen faction
int GetIsFactor(object oPC) {

	int nFaction = GetFaction(oPC);
	int iRank = GetFactionRank(oPC);
	
	if (GetOnNewFactionSystem()) {
		if (GetIsFaction(nFaction)) {
			return (iRank == FACTION_RANK_FACTOR);
		}
	} else {

		if (nFaction == FACTION_ATHAR && iRank >= 5) //Athar
			return TRUE;
		else if (nFaction == FACTION_DOOMGUARD && iRank >= 6) //Doomguard
			return TRUE;
		else if (nFaction == FACTION_DUSTMEN && iRank >= 7) //Dustmen
			return TRUE;
		else if (nFaction == FACTION_FRATERNITY_OF_ORDER && iRank >= 12) //Guvner
			return TRUE;
		else if (nFaction == FACTION_HARMONIUM && iRank >= 12) //Harmonium
			return TRUE;
		else if (nFaction == FACTION_MERCYKILLERS && iRank >= 4) //Mercykillers
			return TRUE;
		else if (nFaction == FACTION_REVOLUTIONARY_LEAGUE && iRank >= 4) //Revs
			return TRUE;
		else if (nFaction == FACTION_TRASCENDENT_ORDER && iRank >= 4) //Cipher
			return TRUE;
		else if (nFaction == 1 || nFaction == 2 || nFaction == 4 || nFaction == 5 ||
				nFaction == 8  || nFaction == 13 || nFaction == 14) {
			if (iRank >= 3)
				return TRUE;
			else
				return FALSE;
		}	
	}
	
	return FALSE;
}

//*************************************************************
//Give faction kit items
//*************************************************************
//give harmonium items
void GiveHarmoniumKit(object oPC)
{
	CreateItemOnObject("ps_faction_harmonium_armour", oPC);
	CreateItemOnObject("ps_faction_harmonium_helmet", oPC);
	CreateItemOnObject("ps_faction_harmonium_boots", oPC);
}

//give mercykiller items
void GiveMercykillerKit(object oPC)
{
	if (GetGender(oPC) == GENDER_FEMALE)
		CreateItemOnObject("ps_faction_mercy_plate_f", oPC);
	else
		CreateItemOnObject("ps_faction_mercy_plate_m", oPC);	
}

//*************************************************************
//Henchman functions
//*************************************************************
void FactionCohortEquipWeapons(object oHench)
{
	object oItem;
	
	oItem = PS_GetLocalObject(oHench, FACTION_NPC_RIGHT_HAND);
	if (GetIsObjectValid(oItem) == TRUE)
		AssignCommand(oHench, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
		
	oItem = PS_GetLocalObject(oHench, FACTION_NPC_LEFT_HAND);
	if (GetIsObjectValid(oItem) == TRUE)
		AssignCommand(oHench, ActionEquipItem(oItem, INVENTORY_SLOT_LEFTHAND));
		
}

void FactionCohortUnequipWeapons(object oHench)
{
	object oItemLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oHench);
	if (GetIsObjectValid(oItemLeft) == TRUE)
		{
			SetIdentified(oItemLeft, TRUE);
			PS_SetLocalObject(oHench, FACTION_NPC_LEFT_HAND, oItemLeft);
			AssignCommand(oHench, ActionUnequipItem(oItemLeft));
		}
	
	object oItemRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench);
	if (GetIsObjectValid(oItemRight) == TRUE)
		{
			SetIdentified(oItemRight, TRUE);
			PS_SetLocalObject(oHench, FACTION_NPC_RIGHT_HAND, oItemRight);
			AssignCommand(oHench, ActionUnequipItem(oItemRight));
		}
}

void BoostFactionNPCItems(object oHench, int iBonus)
{
	// being lazy here and assuming non-enchanted items will be used on henchmen.
	// if giving a bow, make sure infinite ammo.
	// For sake of sanity, all Faction NPCs have their items equipped in the template.
	// When spawned, tag their items so easier for equip routine
	// This way we can also dual wield.
	// Not using safe add, just doing and ignoring errors, lets see what happens.
	itemproperty ipACBonus = ItemPropertyACBonus(iBonus);
	itemproperty ipAttackBonus = ItemPropertyAttackBonus(iBonus);
	itemproperty ipEnhanceBonus = ItemPropertyEnhancementBonus(iBonus);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipEnhanceBonus, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench), 0.0);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipAttackBonus, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench), 0.0);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipACBonus, GetItemInSlot(INVENTORY_SLOT_NECK, oHench), 0.0);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipACBonus, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oHench), 0.0);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipEnhanceBonus, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oHench), 0.0);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipACBonus, GetItemInSlot(INVENTORY_SLOT_BOOTS, oHench), 0.0);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipACBonus, GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oHench), 0.0);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipACBonus, GetItemInSlot(INVENTORY_SLOT_CHEST, oHench), 0.0);	
}

void BoostFactionHenchman(object oBadge, object oPC)
{
	PS_SetLocalInt(oBadge, "LastFactionHenchBoosted", TRUE);
	int iFaction = GetFaction(oPC);
	int iCurrentFactionRank = GetFactionRank(oPC);
	int iFactionMaxRank = GetFactionMaxRanks(iFaction);
	int iCombatNPCLevel = FloatToInt(IntToFloat(iCurrentFactionRank)/IntToFloat(iFactionMaxRank) * 20);
	object oHench = GetHenchman(oPC);
	
	FactionCohortEquipWeapons(oHench);
	// delay, just to make sure that weapons are equipped
	DelayCommand(3.0, BoostFactionNPCItems(oHench, FloatToInt(IntToFloat(iCombatNPCLevel) / 3) + 1));

	int iLoop;
	int iPackage = GetLevelUpPackage(oHench);
	int iClass = GetClassByPosition(1, oHench);
	
	for (iLoop = 1; iLoop <= iCombatNPCLevel; iLoop++)
	{
		LevelUpHenchman(oHench, iClass, TRUE, iPackage);
	}		
}

location FindHenchSpawnPoint(object oPC)
{
	// has a little problem at times finding a good location and tends to spawn near the PC
	// so lets make 3 and choose the furthest.
	location lLoc1 = CalcSafeLocation(oPC, GetRandomLocation(GetArea(oPC),oPC, 30.0), 20.0, FALSE, FALSE);
	location lLoc2 = CalcSafeLocation(oPC, GetRandomLocation(GetArea(oPC),oPC, 30.0), 20.0, FALSE, FALSE);
	location lLoc3 = CalcSafeLocation(oPC, GetRandomLocation(GetArea(oPC),oPC, 30.0), 20.0, FALSE, FALSE);
	location lPC = GetLocation(oPC);
	
	if (GetDistanceBetweenLocations(lPC, lLoc1) > GetDistanceBetweenLocations(lPC, lLoc2))
		if (GetDistanceBetweenLocations(lPC, lLoc1) > GetDistanceBetweenLocations(lPC, lLoc3))
			return lLoc1;
		else
			return lLoc3;
	else if (GetDistanceBetweenLocations(lPC, lLoc2) > GetDistanceBetweenLocations(lPC, lLoc3))
		return lLoc2;
	else
		return lLoc3;
}

// For the next few routines, oHenchObject is probably going to be either a faction badge
// or a summoner feather (for Cere's cohort summoner script).
// looks like 1 second = 1 in the returned INT.
int AllowRespawnHench(object oHenchObject)
{
	int iCurrentTime = GetRealTime();
	int iSpawnTime = PS_GetLocalInt(oHenchObject, "HenchSpawnTime");
	object oPC = GetItemPossessor(oHenchObject);
	int iAllow;
	
	if (GetHenchman(oPC, 1) != OBJECT_INVALID)
		iAllow = FALSE;
	else if (iSpawnTime == 0)
		// because 0 is the result of a failed GetRealTime or the local int has been cleared/does not exist.
		iAllow = FALSE;
	else if ((iCurrentTime - iSpawnTime) > HENCH_MAX_DURATION)
		iAllow = FALSE;
	else
		iAllow = TRUE;
	
	//For testing, we are setting it to TRUE now, then will test with FALSE.
	//iAllow = TRUE;
	
	//SendMessageToPC(oPC, "DEBUG: iAllow set to " + IntToString(iAllow));
	return iAllow;
	
}

void ClearHenchInfo(object oHenchObject)
{
	// only needs to be used on badges not feathers, as feathers destroy themselves.
	PS_SetLocalInt(oHenchObject, "LastFactionHenchBoosted", FALSE);
	PS_SetLocalObject(oHenchObject, "HenchObject", OBJECT_INVALID);
	PS_SetLocalInt(oHenchObject, "HenchSpawnTime", 0);
	PS_SetLocalString(oHenchObject, "HenchResRef", "");
}

void StoreHenchInfo(object oHenchObject, object oHench)
{
	//SendMessageToPC(GetItemPossessor(oHenchObject), "DEBUG:Hench stored as " + GetResRef(oHench));
	PS_SetLocalObject(oHenchObject, "HenchObject", oHench);
	PS_SetLocalInt(oHenchObject, "HenchSpawnTime", GetRealTime());
	PS_SetLocalString(oHenchObject, "HenchResRef", GetResRef(oHench));
}

void DismissFactionCohort(object oHench)
{
	RemoveHenchman(GetMaster(oHench), oHench);
	// make them dumb
	SetCreatureScriptsToSet(oHench, 0);
	AssignCommand(oHench, ActionSpeakString(PS_GetLocalString(oHench, "Goodbye"), TALKVOLUME_TALK));
	AssignCommand(oHench, ActionMoveToLocation(FindHenchSpawnPoint(oHench), FALSE));
	AssignCommand(oHench, DestroyObject(oHench, 5.0));
}

// just to make sure all items are usable and weapons are equippable.
void IdentifyHenchObjects(object oHench)
{
	// loop through inventory items then check all items in slots
	object oItem = GetFirstItemInInventory(oHench);
	
	while (oItem != OBJECT_INVALID)
	{
		SetIdentified(oItem, TRUE);
		oItem = GetNextItemInInventory(oHench);
	}
	
	int iCount;
	for (iCount = 0; iCount <= NUM_INVENTORY_SLOTS; iCount++)
	{
		oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oHench);
		if (oItem != OBJECT_INVALID) SetIdentified(oItem, TRUE);
	}
}

//Set up henchman
void SetUpHenchman(object oHench, object oPC)
{
	IdentifyHenchObjects(oHench);
	FactionCohortUnequipWeapons(oHench);
	AssignCommand(oHench, ActionMoveToObject(oPC, FALSE, 2.0));
	AssignCommand(oHench, ActionSpeakString(PS_GetLocalString(oHench, "WelcomeStart") 
		+ GetFirstName(oPC) + PS_GetLocalString(oHench, "WelcomeEnd"), TALKVOLUME_TALK));		
}

//Find or replace henchman
void FindOrReplaceHenchman(object oHenchObject)
{
	// Look for existing before spawning new
	object oPC = GetItemPossessor(oHenchObject);
	object oHench = PS_GetLocalObject(oHenchObject, "HenchObject");
	string oHenchType = PS_GetLocalString(oHenchObject, "HenchResRef");
	int iRecreate = FALSE;
	
	if (oHenchType != "")
	{
		// apparently object values are not perfect, so an extra check to ensure its a creature
		// and not some randomly spawned item just happens to have the same ID.... unlikely
		// but better safe than sorry.
		// would prefer it if we could actually identify it as being the original object
		// possible, if a problem arises we will have to tag the existing NPCs on spawn
		// and double check, otherwise we may find NPCs being stolen.
		if ((GetIsObjectValid(oHench) == TRUE) & (GetObjectType(oHench) == OBJECT_TYPE_CREATURE))
		{
			AddHenchman(GetItemPossessor(oHenchObject), oHench);
			SendMessageToPC(oPC, "Your cohort has returned to your side.");
		}
		else
		{
			iRecreate = TRUE;
		}
	}
	else
		iRecreate = TRUE;
	
	if (iRecreate == TRUE)
	{
		if (GetTag(oHenchObject) == "ps_faction_badge")
		{
			//SendMessageToPC(oPC, "DEBUG: oHenchType = " + oHenchType);
			//its a faction NPC so use faction summon
			oHench = CreateObject(OBJECT_TYPE_CREATURE, oHenchType, FindHenchSpawnPoint(oPC));
	
			//if (oHench == OBJECT_INVALID)
			//SendMessageToPC(oPC, "DEBUG: Failed to create henchman");
			
			int iIsCombat;
			
			if (PS_GetLocalInt(oHenchObject, "LastFactionHenchBoosted") == TRUE)
				iIsCombat = TRUE;
			else
				iIsCombat = FALSE;
				
			DelayCommand(0.2, AddHenchman(oPC, oHench));
			DelayCommand(0.25, SetCreatureScriptsToSet(oHench, 0));
			DelayCommand(0.5, SetUpHenchman(oHench, oPC));
			if (iIsCombat == TRUE)
			{
				DelayCommand(1.0, BoostFactionHenchman(oHenchObject, oPC));
			}
			DelayCommand(5.0, SetCreatureScriptsToSet(oHench, 10));
		}
		else
		{
			// must be one of Cere's from the summoner script
			object oHench = CreateObject(OBJECT_TYPE_CREATURE, oHenchType, FindHenchSpawnPoint(oPC));
			DelayCommand(0.2, AddHenchman(oPC, oHench));
			DelayCommand(0.25, SetCreatureScriptsToSet(oHench, 10));
			SendMessageToPC(oPC,FACTION_MESSAGE_TEXT_COLOUR + "Your cohort has returned to your side.");
	
		}
	}
}

//Summon faction cohort
void SummonFactionCohort(object oBadge, object oPC, int iHenchNumber)
{
	//int iCooldown = CanSummonFactionCohort(oBadge, iCurrentFactionRank, iFactionMaxRank, iHenchNumber);
	
	//SetLastCohortSummonTime(oBadge, iHenchNumber);
	int iFaction = GetFaction(oPC);
	string sCritter = "ps_faction_npc_" + IntToString(iFaction) + "_";
	if (iHenchNumber == 4)
		sCritter = sCritter + "c";
	else
		sCritter = sCritter + "rp" + IntToString(iHenchNumber);
		
	object oHench = CreateObject(OBJECT_TYPE_CREATURE, sCritter, FindHenchSpawnPoint(oPC));
	
	//if (oHench == OBJECT_INVALID)
		//SendMessageToPC(oPC, "DEBUG: Failed to create henchman");
	PS_SetLocalInt(oBadge, "LastFactionHenchBoosted", FALSE);
	DelayCommand(0.2, SetCollision(oHench, FALSE));
	DelayCommand(0.25, AddHenchman(oPC, oHench));
	DelayCommand(0.3, StoreHenchInfo(oBadge, oHench));
	DelayCommand(0.35, SetCreatureScriptsToSet(oHench, 0));
	DelayCommand(0.5, SetUpHenchman(oHench, oPC));
	DelayCommand(1.0, SetCreatureScriptsToSet(oHench, 10));
	DelayCommand(6.0, SetCollision(oHench, TRUE));
}


//*************************************************************
//Utility functions
//*************************************************************
//For fetching strings from an array of options
//i.e. faction names
string FindStringInArray(int iPosition, string sArray)
{
	int iCurrentChar = 0;
	string sCurrentChar;
	int iPositionCounter = 1;
	int iStringLen = GetStringLength(sArray);
	int iStringFound = FALSE;
	string sReturnString;
	
	while(iStringFound = FALSE | iCurrentChar < iStringLen)
	{
		sCurrentChar = GetSubString(sArray,iCurrentChar,1);
		if (sCurrentChar == "|")
		{
			iPositionCounter++;
		}
		else if (iPositionCounter == iPosition)
		{
			sReturnString = sReturnString + sCurrentChar;
		}
		iCurrentChar++;
	}
	
	if (sReturnString == "")
		sReturnString = "ERROR: Substring not found";
		
	return sReturnString;
}


// Basically my astral converter, but adding days as well to the return due to longer possible durations
// the astral version of this function should never need to report days, hours are even unlikely for that one.
string PS_TimeToString(int iTime)
{
	int iDay;
	int iHour;
	int iMin;
	int iSec;
	string sTime;

	iDay = iTime / (60 * 60 * 24);	
	iHour = (iTime - (iDay * 60 * 60 * 24)) / (60 * 60);
	iMin = (iTime - ((iDay * 60 * 60 * 24) + (iHour * 60 * 60))) / 60;
	iSec = iTime - (iDay * 60 * 60 * 24) - (iHour * 60 * 60) - (iMin * 60);
	
	if (iDay == 1)
		sTime = "1 Day, ";
	else if (iDay > 1)
		sTime = IntToString(iDay) + " Days, ";
		
	if (iHour == 1)
		sTime = "1 Hour, ";
	else if (iHour > 1)
		sTime = IntToString(iHour) + " Hours, ";
	
	if (iMin == 1)
		sTime = sTime + "1 Minute, ";
	else if (iMin > 1)
		sTime = sTime + IntToString(iMin) + " Minutes, ";
		
	if (sTime != "")
		sTime = sTime + "and ";
	
	if (iSec == 1)
		sTime = sTime + "1 Second.";
	else
		sTime = sTime + IntToString(iSec) + " Seconds";
	
	return sTime;
}