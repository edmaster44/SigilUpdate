/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

/*

1 - Prime
2 - Free League
3 - Athar
4 - Believers of the Source
5 - Bleak Cabal
6 - Doomguard
7 - Dustmen
8 - Fated
9 - Fraternity of Order
10- Harmonium
11- Mercykillers
12- Revolutionary League
13- Sign of One
14- Society of Sensation
15- Transcendent Order
16- Xaositects
17- None
18- Undecided
255 - Booted/quit from faction
*/

// RANKS_<FACTION>_MAX used for quick evaluation of promotion by DM rather than enumerating the named ranks
// must keep in sync if making changes to ranks

#include "x0_i0_position"
#include "nwnx_sql"
#include "nwnx_srvadmin"
#include "ps_inc_placeable_signs"

const int HENCH_MAX_DURATION = 43200;

const string FACTION_MESSAGE_TEXT_COLOUR = "<COLOR=green>";

const string FACTION_NPC_LEFT_HAND = "LeftHandWep";
const string FACTION_NPC_RIGHT_HAND = "RightHandWep";

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

// Just a small routine to determine if a character has a badge.
int HasFactionBadge(object oPC)
{
	object oItem = GetItemPossessedBy(oPC,"ps_faction_badge");
    
	if(GetIsObjectValid(oItem))
    	return TRUE;
	else
		return FALSE;

}

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

int GetFactionMaxRanks(int iFaction)
{
	int iMaxRanks;
	
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
	return iMaxRanks;
}

string GetFactionRankName(int iFaction, int iFactionRank)
{
	// Transforms the int rank into a name for easy reference and retrieval.
			
	string sFactionRankNames; 
	
	switch (iFaction)
		{
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

	string sNameToReturn = FindStringInArray(iFactionRank, sFactionRankNames);
	
	if (sNameToReturn == "")
		sNameToReturn = "ERROR: Faction name not found!!!";
	return sNameToReturn;
}



void PromoteInFaction(object oBadge, object oDM, object oTarget, string sTargetName)
{
	int iCurrentRank = GetLocalInt(oBadge, "FactionRank");
	int iFaction = GetLocalInt(oBadge, "Faction");
	int iMaxRanks = GetFactionMaxRanks(iFaction);
	
	
	if (iCurrentRank < iMaxRanks)
	{			
		SetLocalInt(oBadge, "FactionRank", iCurrentRank + 1);
		SetLocalString(oBadge, "FactionRankName", GetFactionRankName(iFaction, iCurrentRank + 1));
				
		SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " has been promoted in the " 
			+ GetLocalString(oBadge, "FactionName") 
			+ " from " + GetFactionRankName(iFaction, iCurrentRank) + " to "
			+ GetFactionRankName(iFaction, iCurrentRank + 1) + ".");
				
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "You have been promoted in the " 
			+ GetLocalString(oBadge, "FactionName") 
			+ " from " + GetFactionRankName(iFaction, iCurrentRank) + " to "
			+ GetFactionRankName(iFaction, iCurrentRank + 1) + ".");
	}
	else
	{
		SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " is already maximum rank in the " + GetLocalString(oBadge, "FactionName") + ".");
	}
		
}

void DemoteInFaction(object oBadge, object oDM, object oTarget, string sTargetName)
{
	int iCurrentRank = GetLocalInt(oBadge, "FactionRank");
	int iFaction = GetLocalInt(oBadge, "Faction");
	
	if (iCurrentRank > 1) //because if 1 then can't go lower!
	{
		SetLocalInt(oBadge, "FactionRank", iCurrentRank - 1);
		SetLocalString(oBadge, "FactionRankName", GetFactionRankName(iFaction, iCurrentRank - 1));
				
		SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " has been demoted in the " 
			+ GetLocalString(oBadge, "FactionName") 
			+ " from " + GetFactionRankName(iFaction, iCurrentRank) + " to "
			+ GetFactionRankName(iFaction, iCurrentRank - 1) + ".");
				
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "You have been demoted in the " 
			+ GetLocalString(oBadge, "FactionName") 
			+ " from " + GetFactionRankName(iFaction, iCurrentRank) + " to "
			+ GetFactionRankName(iFaction, iCurrentRank - 1) + ".");
	}
	else
	{
		SendMessageToPC(oDM, FACTION_MESSAGE_TEXT_COLOUR + sTargetName + " is already minimum rank in the " + GetLocalString(oBadge, "FactionName") + ".");
	}
}

object GetFactionBadgeObject(object oPC)
{
	object oBadge = GetLocalObject(oPC, "FactionBadgeUsed");
	return oBadge;
}

void FactionCohortEquipWeapons(object oHench)
{
	object oItem;
	
	oItem = GetLocalObject(oHench, FACTION_NPC_RIGHT_HAND);
	if (GetIsObjectValid(oItem) == TRUE)
		AssignCommand(oHench, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
		
	oItem = GetLocalObject(oHench, FACTION_NPC_LEFT_HAND);
	if (GetIsObjectValid(oItem) == TRUE)
		AssignCommand(oHench, ActionEquipItem(oItem, INVENTORY_SLOT_LEFTHAND));
		
}

void FactionCohortUnequipWeapons(object oHench)
{
	object oItemLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oHench);
	if (GetIsObjectValid(oItemLeft) == TRUE)
		{
			SetIdentified(oItemLeft, TRUE);
			SetLocalObject(oHench, FACTION_NPC_LEFT_HAND, oItemLeft);
			AssignCommand(oHench, ActionUnequipItem(oItemLeft));
		}
	
	object oItemRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench);
	if (GetIsObjectValid(oItemRight) == TRUE)
		{
			SetIdentified(oItemRight, TRUE);
			SetLocalObject(oHench, FACTION_NPC_RIGHT_HAND, oItemRight);
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
	SetLocalInt(oBadge, "LastFactionHenchBoosted", TRUE);
	int iFaction = GetLocalInt(oBadge, "Faction");
	int iCurrentFactionRank = GetLocalInt(oBadge, "FactionRank");
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

int GetRealTime()
{
	int utc;
	
	SQLExecDirect("SELECT UNIX_TIMESTAMP()");
	
	while (SQLFetch() != SQL_ERROR)
	{
		utc = StringToInt(SQLGetData(1));	
	}
	return utc;
	
	//return ((GetTimeHour() * 60 * 60) + (GetTimeMinute() * 60) + GetTimeSecond());
}

int AllowRespawnHench(object oHenchObject)
{
	int iCurrentTime = GetRealTime();
	int iSpawnTime = GetLocalInt(oHenchObject, "HenchSpawnTime");
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
	SetLocalInt(oHenchObject, "LastFactionHenchBoosted", FALSE);
	SetLocalObject(oHenchObject, "HenchObject", OBJECT_INVALID);
	SetLocalInt(oHenchObject, "HenchSpawnTime", 0);
	SetLocalString(oHenchObject, "HenchResRef", "");
}

void StoreHenchInfo(object oHenchObject, object oHench)
{
	//SendMessageToPC(GetItemPossessor(oHenchObject), "DEBUG:Hench stored as " + GetResRef(oHench));
	SetLocalObject(oHenchObject, "HenchObject", oHench);
	SetLocalInt(oHenchObject, "HenchSpawnTime", GetRealTime());
	SetLocalString(oHenchObject, "HenchResRef", GetResRef(oHench));
}

void DismissFactionCohort(object oHench)
{
	RemoveHenchman(GetMaster(oHench), oHench);
	// make them dumb
	SetCreatureScriptsToSet(oHench, 0);
	AssignCommand(oHench, ActionSpeakString(GetLocalString(oHench, "Goodbye"), TALKVOLUME_TALK));
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

void SetUpHenchman(object oHench, object oPC)
{
	IdentifyHenchObjects(oHench);
	FactionCohortUnequipWeapons(oHench);
	AssignCommand(oHench, ActionMoveToObject(oPC, FALSE, 2.0));
	AssignCommand(oHench, ActionSpeakString(GetLocalString(oHench, "WelcomeStart") 
		+ GetFirstName(oPC) + GetLocalString(oHench, "WelcomeEnd"), TALKVOLUME_TALK));		
}

void FindOrReplaceHenchman(object oHenchObject)
{
	// Look for existing before spawning new
	object oPC = GetItemPossessor(oHenchObject);
	object oHench = GetLocalObject(oHenchObject, "HenchObject");
	string oHenchType = GetLocalString(oHenchObject, "HenchResRef");
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
			
			if (GetLocalInt(oHenchObject, "LastFactionHenchBoosted") == TRUE)
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


void SummonFactionCohort(object oBadge, object oPC, int iHenchNumber)
{
	//int iCooldown = CanSummonFactionCohort(oBadge, iCurrentFactionRank, iFactionMaxRank, iHenchNumber);
	
	//SetLastCohortSummonTime(oBadge, iHenchNumber);
	int iFaction = GetLocalInt(oBadge, "Faction");
	string sCritter = "ps_faction_npc_" + IntToString(iFaction) + "_";
	if (iHenchNumber == 4)
		sCritter = sCritter + "c";
	else
		sCritter = sCritter + "rp" + IntToString(iHenchNumber);
		
	object oHench = CreateObject(OBJECT_TYPE_CREATURE, sCritter, FindHenchSpawnPoint(oPC));
	
	//if (oHench == OBJECT_INVALID)
		//SendMessageToPC(oPC, "DEBUG: Failed to create henchman");
	SetLocalInt(oBadge, "LastFactionHenchBoosted", FALSE);
	DelayCommand(0.2, SetCollision(oHench, FALSE));
	DelayCommand(0.25, AddHenchman(oPC, oHench));
	DelayCommand(0.3, StoreHenchInfo(oBadge, oHench));
	DelayCommand(0.35, SetCreatureScriptsToSet(oHench, 0));
	DelayCommand(0.5, SetUpHenchman(oHench, oPC));
	DelayCommand(1.0, SetCreatureScriptsToSet(oHench, 10));
	DelayCommand(6.0, SetCollision(oHench, TRUE));
}

void GiveHarmoniumKit(object oPC)
{
	CreateItemOnObject("ps_faction_harmonium_armour", oPC);
	CreateItemOnObject("ps_faction_harmonium_helmet", oPC);
	CreateItemOnObject("ps_faction_harmonium_boots", oPC);
}

void GiveMercykillerKit(object oPC)
{
	if (GetGender(oPC) == GENDER_FEMALE)
		CreateItemOnObject("ps_faction_mercy_plate_f", oPC);
	else
		CreateItemOnObject("ps_faction_mercy_plate_m", oPC);	
}

void RemoveFactionBadge(object oBadge, object oSource, object oTarget)
{
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
	
	int iInfiltrated = 0;
	string sFactionName = GetLocalString(oBadge, "FactionName");
	object oEssence = GetItemPossessedBy(oTarget, "ps_essence");
	
	if (GetLocalInt(oBadge, "Faction") == 12)
	{
		iInfiltrated = GetLocalInt(oBadge, "Infiltrated");
		int iInfiltrationConfirmed = FALSE;
		
		// if this is anything but 0 then we need to check a badge exists of that faction
		// if it does, then we set the essence to use that as the new primary faction.
		object oItem = GetFirstItemInInventory(oTarget);
	
		while (oItem != OBJECT_INVALID)
		{
			if (GetTag(oItem) == "ps_faction_badge")
				if (GetLocalInt(oItem, "Faction") == iInfiltrated)
					iInfiltrationConfirmed = TRUE;
			
			oItem = GetNextItemInInventory(oTarget);
		}
		
		
		if (iInfiltrationConfirmed == TRUE)
			SetLocalInt(oEssence, "Faction", iInfiltrated);
		else
			SetLocalInt(oEssence, "Faction", 255);
	}
	else
	{
		SetLocalInt(oEssence, "Faction", 255);
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

void RemoveAllFactionData(object oDM, object oTarget)
{
	object oItem = GetFirstItemInInventory(oTarget);
	
	while (oItem != OBJECT_INVALID)
	{
		if (GetTag(oItem) == "ps_essence")
		{
			SetLocalInt(oItem, "Faction", 0);
		}
		else if (GetTag(oItem) == "ps_faction_badge")
			DestroyObject(oItem, 0.0, TRUE);
			
		oItem = GetNextItemInInventory(oTarget);
	}
}

void SetBadgeFaction(object oBadge, int iFaction)
{
	int iIconRow;
	object oPC = GetItemPossessor(oBadge);
	SetLocalInt(oBadge, "Faction", iFaction);
	//SetLocalInt(oBadge, "FactionPoints", 0);
	// rank 1 is Namer equivalent. 0 we may use for left/kicked out or something.
	SetLocalInt(oBadge, "FactionRank", 1);
	SetLocalString(oBadge, "FactionRankName", GetFactionRankName(iFaction, 1));
	switch (iFaction)
		{
			case 2:
				//sFaction = "Free League";
				iIconRow = 2203;
				SetLocalString(oBadge, "FactionName", "Free League");
				break;
			case 3:
				//sFaction = "Athar";
				iIconRow = 2196;
				SetLocalString(oBadge, "FactionName", "Athar");
				break;
			case 4:
				//sFaction = "Believers of the Source";
				iIconRow = 2204;
				SetLocalString(oBadge, "FactionName", "Believers of the Source");
				break;
			case 5:
				//sFaction = "Bleak Cabal";
				iIconRow = 2197;
				SetLocalString(oBadge, "FactionName", "Bleak Cabal");
				break;
			case 6:
				//sFaction = "Doomguard";
				iIconRow = 2199;
				SetLocalString(oBadge, "FactionName", "Doomguard");
				break;
			case 7:
				//sFaction = "Dustmen";
				iIconRow = 2200;
				SetLocalString(oBadge, "FactionName", "Dustmen");
				break;
			case 8:
				//sFaction = "Fated";
				iIconRow = 2201;
				SetLocalString(oBadge, "FactionName", "Fated");
				break;
			case 9:
				//sFaction = "Fraternity of Order";
				iIconRow = 2202;
				SetLocalString(oBadge, "FactionName", "Fraternity of Order");
				break;
			case 10:
				//sFaction = "Harmonium"; 
				iIconRow = 2205;
				SetLocalString(oBadge, "FactionName", "Harmonium");
				GiveHarmoniumKit(oPC);
				break;
			case 11:
				//sFaction = "Mercykillers";
				iIconRow = 2206;
				SetLocalString(oBadge, "FactionName", "Mercykillers");
				GiveMercykillerKit(oPC);
				break;
			case 12:
				//sFaction = "Revolutionary League";
				iIconRow = 2195;
				SetLocalString(oBadge, "FactionName", "Revolutionary League");
				SetLocalInt(oBadge, "Infiltrated", FALSE);
				SetLocalInt(oBadge, "InfiltratedFaction", 0);
				break;
			case 13:
				//sFaction = "Sign of One";
				iIconRow = 2208;
				SetLocalString(oBadge, "FactionName", "Sign of One");
				break;
			case 14:
				//sFaction = "Society of Sensation";
				iIconRow = 2207;
				SetLocalString(oBadge, "FactionName", "Society of Sensation");
				break;
			case 15:
				//sFaction = "Transcendent Order";
				iIconRow = 2198;
				SetLocalString(oBadge, "FactionName", "Transcendent Order");
				break;
			case 16:
				//sFaction = "Xaositects";
				iIconRow = 2209;
				SetLocalString(oBadge, "FactionName", "Xaositects");
				break;
		}
		
	SetItemIcon(oBadge, iIconRow);
	SetFirstName(oBadge, GetLocalString(oBadge, "FactionName") + " Faction Badge");
}

void DiscreteShowBadge(object oBadge, object oPC, object oTarget)
{
	SendMessageToPC(oPC,FACTION_MESSAGE_TEXT_COLOUR + "Discretely showing badge");
	if (oPC == oTarget)
	{
			SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "*You discreetly look at your badge which identifies you as a " +
			GetLocalString(oBadge, "FactionRankName") + " in the " + GetLocalString(oBadge, "FactionName") + ".*");
	}
	else if (GetIsDM(oTarget))
	{
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "*" + GetName(oPC) + " is a " +
			GetLocalString(oBadge, "FactionRankName") + " in the " + GetLocalString(oBadge, "FactionName") + ".*");
	}
	else
	{
		SendMessageToPC(oPC, FACTION_MESSAGE_TEXT_COLOUR + "*You discreetly show your badge to " + GetName(oTarget) + ".");
		SendMessageToPC(oTarget, FACTION_MESSAGE_TEXT_COLOUR + "*" + GetName(oPC) + " discretely shows you their faction badge which identifies them as a " +
			GetLocalString(oBadge, "FactionRankName") + " in the " + GetLocalString(oBadge, "FactionName") + ".*");
	}
}

void PublicShowBadge(object oBadge, object oPC)
{	
	SendMessageToPC(oPC,"Publically showing badge");
	AssignCommand(oPC, SpeakString(FACTION_MESSAGE_TEXT_COLOUR + "*" + GetName(oPC) + " displays their faction badge openly showing them to be a " + 
		GetLocalString(oBadge, "FactionRankName") + " in the " + GetLocalString(oBadge, "FactionName") + ".*", TALKVOLUME_TALK));
}

// used to get the faction from a different factioneer
// if pass in anything other than zero for checking faction then it will compare with that specifically
// mainly useful for double check on Anarchist infiltration.
int GetOtherFactioneerFaction(object oOtherPC, int iSeekingFaction)
{
	int iFaction = 0;
	object oEssence = GetItemPossessedBy(oOtherPC,"ps_essence");
   	if(GetIsObjectValid(oEssence))
   	{
		// use essence because quick to find and no checking of badge statuses required
		iFaction = GetLocalInt(oEssence, "Faction");
   	}
   	
   	if ((iFaction > 1) && (iFaction < 17))
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
				int iCoverFaction = GetLocalInt(oBadge, "Faction");
				if (iCoverFaction == 12)
				// we found the anarch badge
				{
					if (GetLocalInt(oBadge, "Infiltrated") == TRUE)
						return GetLocalInt(oBadge, "InfiltratedFaction");
					else
						return iFaction;
				}
				else
				{
					return GetLocalInt(oBadge, "Faction");
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

void SendGenericFactionMessage(object oPC)
{
	object oBadge = GetLocalObject(oPC, "FactionBadgeUsed");
	int iFaction = GetLocalInt(oBadge, "Faction");
	string sFactionName = GetLocalString(oBadge, "FactionName");
	string sFactionRankName = GetLocalString(oBadge, "FactionRankName");
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
void CreateFactionSignItem(object oPC)
{
	int iFaction = GetLocalInt(GetFactionBadgeObject(oPC), "Faction");
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
	}
	
	object oItem = CreateItemOnObject("ps_factionsign", oPC);
	
	if (oItem != OBJECT_INVALID)
	{
		SetFirstName(oItem, sItemName);
		SetLocalString(oItem, "TEMPLATE_RESREF", sTemplate);
	}
	else
	{
		SendMessageToPC(oPC, "Failed to create faction sign creator.  Please report a bug via the forums");
	}
}