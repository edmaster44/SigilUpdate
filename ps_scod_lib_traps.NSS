

///////////////////////////////////////////////////////////////
// ps_scod_lib_traps
//
// Library routines involving traps
//
//
// Author:  			ADnD'R
// Date Created:    	23MAY2006
// Date Last Modified:	12MAY2010 for SCOD (Sigil, City of Doors)
// Last Modified By:	ADnD'R
///////////////////////////////////////////////////////////////
/*
    This is the "heart" of the trap respawning routines, random types and placement, etc
				
		
History of Changes

	25FEB2011 - ADnD'R
		1. Changed bTrapIsRecoverable (bool) to nTrapRecoverablePercentage (int). So now
		we can set if the trap is recoverable as a percentage, even 0 percent if never
		recoverable. 



	15MAY2010 - ADnD'R
		1. Added RespawnAreaMovingFloorTraps(). This function just grabs
		a random waypoint in a set of waypoints with identical tags and spawns
		a trap there. All the waypoints in this set must have a local int
		"NUMBER_IN_SET" defined to the total number of wp's with this tag. 
		
		Note that if ANY trap with this tag token already exists in this area,
		a new one should not be spawned; desired behavior. 
		
		2. Added global strings for our OnTriggered and OnDisarmed scripts. 



	12MAY2010 - ADnD'R
		1. Changed the name of RespawnPlaceableTrap() to simply RespawnTrap(),
		since it also handles floor (trigger) traps. 
		2. Finally fixed RespawnTrap()'s problem with floor (trigger)
		traps, it originally referenced the wrong object
		3. Added builder configurable checks & flags to spawn traps 
		that can be undetectable and/or unrecoverable. 
		
		4. NOTE: NWN2 gives spawned floor traps a name of "Trap Type - Level"
		which is a bit undesirable to my mind, a SetName() call at the end
		might be nice. Which NWN2 apparently doesn't have, but DMFI does. 


    28 May 2006 - ADnD'R
    1. RespawnAreaDoorTraps(): now also tries to respawn
    a trap if its present, but flagged.
    2. RespawnTrap(): Now, if set to TRAP_BASE_TYPE_RANDOM,
    10% of the time its not trapped at all.

*/

// Global variables - if these script names change, it must be reflected here
//
// the OnTriggered will likely never be defined globally, as traps set their own individually
// nonetheless, we put a placemarker here
const string SCOD_TRAP_ONTRIGGERED_SCRIPT = "";
const string SCOD_TRAP_ONDISARMED_SCRIPT = "ps_traps-experience";



// Function Declarations

// void RespawnAreaDoorTraps(object oArea, string sDoorTagToken="rtdoor");
//
// Resets/Respawns oArea's Door Traps if Door Tag contains sDoorTagToken.
void RespawnAreaDoorTraps(object oArea, object oPC, string sDoorTagToken="rtdoor");

// void RespawnAreaFloorTraps(object oArea, string sFloorTagToken="rtfloor");
//
// Resets/Respawns oArea's Floor Traps.
//
// sFloorTagToken - string token of waypoints at which traps are respawned
void RespawnAreaFloorTraps(object oArea, object oPC, string sFloorTagToken="rtfloor");



// void RespawnAreaMovingFloorTraps(object oArea, object oPC, string sRandomWPTag="rnd_floor");
//
// Respawns 1 floor(trigger) trap at the location of one waypoint in a set
//
// object oPC - the PC responsible for us being called, currently only used
// to determine trap level if the trap is of type RANDOM and TRAP_STRENGTH
// is set to PLAYERLEVEL. Trap maximum possible strength is player level / 6.
//
// string sRandomWPTag - tag of all waypoints in this set (thus, all identical)
void RespawnAreaMovingFloorTraps(object oArea, object oPC, string sRandomWPTag="rndfloor");


// void RespawnTrap(object oTrapObject, string sDisarmScript, string sTriggeredScript, object oPC)
//
// Spawns a disarmable, recoverable, one-shot trap on oTrapObject
//
// oTrapObject can be a waypoint (floor traps/triggers), Door, or Placeable
//
// Relies on local variables embedded in trap object:
// int TRAP_TYPE - The base type of Trap (default: TRAP_BASE_TYPE_MINOR_ACID)
// int TRAP_DETECT_DC (default: 5)
// int TRAP_DISARM_DC (default: 21)
// string TRAP_KEYTAG (default is "", no key specified)
//
// string sDisarmScript and sTriggered Script - for scripts to be called on the
// trap's OnDisarmed and OnTriggered events. Note this will DISABLE
// default trap saves and damage, the script must provide this.
//
// object oPC - the PC responsible for us being called, currently only used
// to determine trap level if the trap is of type RANDOM and TRAP_STRENGTH
// is set to PLAYERLEVEL. Trap maximum possible strength is player level / 6. 
void RespawnTrap(object oTrapObject, string sDisarmScript, string sTriggeredScript, object oPC = OBJECT_INVALID);

// int StringTrapBaseTypeToInt(string sTrapBaseType);
//
// Converts TRAP_BASE_TYPE strings to their integer values
// returns -1 on error
int StringTrapBaseTypeToInt(string sTrapBaseType);

// int GetRandomTrapBaseType(int nTrapStrength=IP_CONST_TRAPSTRENGTH_MINOR);
//
// Returns a random Trap Base Type of no more than nTrapStrength power
int GetRandomTrapBaseType(int nTrapStrength=IP_CONST_TRAPSTRENGTH_MINOR);

// int StringTrapStrengthToInt(string sTrapStrength);
//
// Converts TRAP_STRENGTH strings to their integer values
// returns -1 if nTrapStrength is EPIC
//
// returns IP_CONST_TRAPSTRENGTH_MINOR on errors
int StringTrapStrengthToInt(string sTrapStrength, object oPC = OBJECT_INVALID);



void RespawnAreaDoorTraps(object oArea, object oPC, string sDoorTagToken="rtdoor") {

    if (oArea == OBJECT_INVALID)
        return; // fatal
		
    object oFirstObject = GetFirstObjectInArea(oArea);
    object oDoor;
    if (GetObjectType(oFirstObject) == OBJECT_TYPE_DOOR)
        oDoor = oFirstObject;
    else
        oDoor = GetNearestObject(OBJECT_TYPE_DOOR, oFirstObject);
    int i=1;

    if (sDoorTagToken == "")
        sDoorTagToken = "rtdoor";

    while (oDoor != OBJECT_INVALID)
    {
        if (FindSubString(GetTag(oDoor), sDoorTagToken) != -1)
        {
            if (!GetIsTrapped(oDoor)|| GetTrapFlagged(oDoor))
                RespawnTrap(oDoor, SCOD_TRAP_ONDISARMED_SCRIPT, SCOD_TRAP_ONTRIGGERED_SCRIPT, oPC);
        }
        oDoor = GetNearestObject(OBJECT_TYPE_DOOR, oFirstObject, ++i);
    }
}

void RespawnAreaFloorTraps(object oArea, object oPC, string sFloorTagToken="rtfloor") {

    if (oArea == OBJECT_INVALID)
        return; // fatal
		
    object oFirstObject = GetFirstObjectInArea(oArea);

		
    object oTrapWP;

    int i = 1;

    if (sFloorTagToken == "")
        sFloorTagToken = "rtfloor";

    if (GetObjectType(oFirstObject) == OBJECT_TYPE_WAYPOINT
        && FindSubString(GetTag(oFirstObject),sFloorTagToken)!= -1)
        oTrapWP = oFirstObject;
    else
        oTrapWP = GetNearestObject(OBJECT_TYPE_WAYPOINT, oFirstObject, i);
			
    object oVeryFirstWP = oTrapWP;

    while (oTrapWP != OBJECT_INVALID)
    {
		
        if (FindSubString(GetTag(oTrapWP),sFloorTagToken)!= -1)
		{
            RespawnTrap(oTrapWP,SCOD_TRAP_ONDISARMED_SCRIPT, SCOD_TRAP_ONTRIGGERED_SCRIPT, oPC);			
			
		}
        oTrapWP = GetNearestObject(OBJECT_TYPE_WAYPOINT, oFirstObject, ++i);
		
        if (oTrapWP == oVeryFirstWP) //sanity
            break;
    }
}

void
RespawnAreaMovingFloorTraps(object oArea, object oPC, string sRandomWPTag="rndfloor")
{
	if (oArea == OBJECT_INVALID)
		return; //fatal
			
	object oWP = GetObjectByTag(sRandomWPTag);
	
	// If we can't even find one instance of this waypoint, give up
	if (oWP == OBJECT_INVALID)
		return; // fatal

	int nNumberRandomWPs = GetLocalInt(oWP, "NUMBER_IN_SET");
	
	// If the number of random waypoints in this "set" (all share the same tag)
	// is zero or 1, we can only put a trap right here
	if (nNumberRandomWPs > 1)			//  otherwise we grab a random one, trusting this number
		oWP = GetObjectByTag(sRandomWPTag, Random(nNumberRandomWPs));
		
		
	RespawnTrap(oWP,SCOD_TRAP_ONDISARMED_SCRIPT, SCOD_TRAP_ONTRIGGERED_SCRIPT, oPC);		

}



void
RespawnTrap(object oTrapObject, string sDisarmedScript,	
	string sTriggeredScript, object oPC = OBJECT_INVALID)
{
    string sObjectTag = GetTag(oTrapObject);

			
    //////////////////////
    // Trap Type& Creation
    ///////////////////////
    string sTrapType = GetLocalString(oTrapObject, "TRAP_TYPE");
	
	
    int nTrapType = TRAP_BASE_TYPE_MINOR_ACID;
	int nMaxTrapStrength = 0;
    if (sTrapType == "TRAP_BASE_TYPE_RANDOM")
    {

        nMaxTrapStrength =
            StringTrapStrengthToInt(
                GetLocalString(oTrapObject, "TRAP_STRENGTH"));

        nTrapType = GetRandomTrapBaseType(nMaxTrapStrength);
    }
    else if (sTrapType != "")
    {
        nTrapType = StringTrapBaseTypeToInt(sTrapType);

        if (nTrapType == -1)
            nTrapType = TRAP_BASE_TYPE_MINOR_ACID;
    }
	else
		nTrapType = TRAP_BASE_TYPE_MINOR_ACID;
		
	/// GRAB any and ALL of the local ints for trap configuration HERE (not later) !
    int nTrapDetectDC = GetLocalInt(oTrapObject, "TRAP_DETECT_DC");
    int nTrapDisarmDC = GetLocalInt(oTrapObject, "TRAP_DISARM_DC");
	int nTrapRecoverablePercentage = GetLocalInt(oTrapObject, "TRAP_RECOVERABLE_PERCENTAGE");
	/// SCOD: only 10% of traps recoverable
	if (nTrapRecoverablePercentage && d100() > nTrapRecoverablePercentage)
		nTrapRecoverablePercentage = 0;
    string sTrapKeyTag = GetLocalString(oTrapObject, "TRAP_KEYTAG");
	
	///////////DEBUG REMOVE THIS REMOVE THIS ///////////////////
	/*
	SendMessageToPC(oxPC, "RespawnTrap, TrapDetectDC=("+IntToString(nTrapDetectDC)+")");	
	SendMessageToPC(oxPC, "RespawnTrap, TrapDisarmDC=("+IntToString(nTrapDisarmDC)+")");	
	SendMessageToPC(oxPC, "RespawnTrap, Trap Recoverable Percentage = "
		+(IntToString(nTrapRecoverablePercentage));
	*/
	// What kind of Trap? Either Door or Placeable
	int nTrapObjectType = GetObjectType(oTrapObject);

    // Floor trap?
    if (nTrapObjectType == OBJECT_TYPE_WAYPOINT)
    {

        float fTrapSize = GetLocalFloat(oTrapObject, "TRAP_SIZE");
        if (fTrapSize == 0.0f)
            fTrapSize = 2.0f;
			
        // For floor traps, have to make sure there's not one there already . . . .
        object oTrapObject2 = GetNearestObjectByTag(sObjectTag+"_trap", oTrapObject, 1);
		if (oTrapObject2 == OBJECT_INVALID || GetTag(oTrapObject2) != sObjectTag+"_trap")
		{	   	   
            oTrapObject2 = CreateTrapAtLocation(nTrapType, GetLocation(oTrapObject), fTrapSize, sObjectTag+"_trap",
                STANDARD_FACTION_HOSTILE, sDisarmedScript, sTriggeredScript);
		}
        // Have to change from waypoint to trap object so we can set it's properties
        oTrapObject = oTrapObject2;
				
		
    }
    else   // door/placeables
        CreateTrapOnObject(nTrapType, oTrapObject, STANDARD_FACTION_HOSTILE,
            sDisarmedScript, sTriggeredScript);

    ////////////////
    // Detection
    ///////////////
	if (nTrapDetectDC == -1)
		SetTrapDetectable(oTrapObject, FALSE);
	else
	{
    	if (!nTrapDetectDC)
        	nTrapDetectDC = 5;
				
    	SetTrapDetectable(oTrapObject, TRUE);
    	SetTrapDetectDC(oTrapObject, nTrapDetectDC);
	}
	
    ////////////////
    // Disarm
    ///////////////
	if (nTrapDisarmDC == -1)
		SetTrapDisarmable(oTrapObject, FALSE);
	else
	{	
		SetTrapDisarmable(oTrapObject, TRUE);
		SetTrapDisarmDC(oTrapObject, (nTrapDisarmDC == 0 ? 21 : nTrapDisarmDC));		
    }
		
	/////////////////
	// Recoverable
	////////////////
	SetTrapRecoverable(oTrapObject, (nTrapRecoverablePercentage == 0 ? FALSE : TRUE));

    /////////////////
    // Miscellaneous
    /////////////////
    SetTrapOneShot(oTrapObject, TRUE);
    SetTrapActive(oTrapObject, TRUE);

    if (sTrapKeyTag != "")
        SetTrapKeyTag(oTrapObject, sTrapKeyTag);
	
	/// Might add a SetName() call here to change the trap name
	/// otherwise once detected it becomes "Trap type - Trap Level"
	/// which is a bit of a spoiler . . . 

}

int
GetRandomTrapBaseType(int nTrapStrength=IP_CONST_TRAPSTRENGTH_MINOR)
{
    int nRanDamageType = Random(12);
    int TrapBaseType = TRAP_BASE_TYPE_MINOR_SPIKE;

    switch (nTrapStrength)
    {
        default:
        //case 0:
        case IP_CONST_TRAPSTRENGTH_MINOR:
            switch (nRanDamageType)
            {
                case 0:
                default:
                case 1: TrapBaseType = TRAP_BASE_TYPE_MINOR_ACID; break;
                case 2: TrapBaseType = TRAP_BASE_TYPE_MINOR_ACID_SPLASH; break;
                case 3: TrapBaseType = TRAP_BASE_TYPE_MINOR_ELECTRICAL; break;
                case 4: TrapBaseType = TRAP_BASE_TYPE_MINOR_FIRE; break;
                case 5: TrapBaseType = TRAP_BASE_TYPE_MINOR_FROST; break;
                case 6: TrapBaseType = TRAP_BASE_TYPE_MINOR_GAS; break;
                case 7: TrapBaseType = TRAP_BASE_TYPE_MINOR_HOLY; break;
                case 8: TrapBaseType = TRAP_BASE_TYPE_MINOR_NEGATIVE; break;
                case 9: TrapBaseType = TRAP_BASE_TYPE_MINOR_SONIC; break;
                case 10: TrapBaseType = TRAP_BASE_TYPE_MINOR_SPIKE; break;
                case 11: TrapBaseType = TRAP_BASE_TYPE_MINOR_TANGLE; break;

            }
        break; // Minor Strength
        case IP_CONST_TRAPSTRENGTH_AVERAGE:
            switch (nRanDamageType)
            {
                case 0:
                default:
                case 1: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_ACID; break;
                case 2: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH; break;
                case 3: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_ELECTRICAL; break;
                case 4: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_FIRE; break;
                case 5: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_FROST; break;
                case 6: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_GAS; break;
                case 7: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_HOLY; break;
                case 8: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_NEGATIVE; break;
                case 9: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_SONIC; break;
                case 10: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_SPIKE; break;
                case 11: TrapBaseType = TRAP_BASE_TYPE_AVERAGE_TANGLE; break;

            }
        break; // Average Strength
        case IP_CONST_TRAPSTRENGTH_STRONG:
            switch (nRanDamageType)
            {
                case 0:
                default:
                case 1: TrapBaseType = TRAP_BASE_TYPE_STRONG_ACID; break;
                case 2: TrapBaseType = TRAP_BASE_TYPE_STRONG_ACID_SPLASH; break;
                case 3: TrapBaseType = TRAP_BASE_TYPE_STRONG_ELECTRICAL; break;
                case 4: TrapBaseType = TRAP_BASE_TYPE_STRONG_FIRE; break;
                case 5: TrapBaseType = TRAP_BASE_TYPE_STRONG_FROST; break;
                case 6: TrapBaseType = TRAP_BASE_TYPE_STRONG_GAS; break;
                case 7: TrapBaseType = TRAP_BASE_TYPE_STRONG_HOLY; break;
                case 8: TrapBaseType = TRAP_BASE_TYPE_STRONG_NEGATIVE; break;
                case 9: TrapBaseType = TRAP_BASE_TYPE_STRONG_SONIC; break;
                case 10: TrapBaseType = TRAP_BASE_TYPE_STRONG_SPIKE; break;
                case 11: TrapBaseType = TRAP_BASE_TYPE_STRONG_TANGLE; break;

            }
        break; // Average Strength
        case IP_CONST_TRAPSTRENGTH_DEADLY:
            switch (nRanDamageType)
            {
                case 0:
                default:
                case 1: TrapBaseType = TRAP_BASE_TYPE_DEADLY_ACID; break;
                case 2: TrapBaseType = TRAP_BASE_TYPE_DEADLY_ACID_SPLASH; break;
                case 3: TrapBaseType = TRAP_BASE_TYPE_DEADLY_ELECTRICAL; break;
                case 4: TrapBaseType = TRAP_BASE_TYPE_DEADLY_FIRE; break;
                case 5: TrapBaseType = TRAP_BASE_TYPE_DEADLY_FROST; break;
                case 6: TrapBaseType = TRAP_BASE_TYPE_DEADLY_GAS; break;
                case 7: TrapBaseType = TRAP_BASE_TYPE_DEADLY_HOLY; break;
                case 8: TrapBaseType = TRAP_BASE_TYPE_DEADLY_NEGATIVE; break;
                case 9: TrapBaseType = TRAP_BASE_TYPE_DEADLY_SONIC; break;
                case 10: TrapBaseType = TRAP_BASE_TYPE_DEADLY_SPIKE; break;
                case 11: TrapBaseType = TRAP_BASE_TYPE_DEADLY_TANGLE; break;

            }
        break; // Deadly Strength
        case -1: // IP_CONST_TRAPSTRENGTH_EPIC: - not defined NWN 1.67
            nRanDamageType = d4();
            switch (nRanDamageType)
            {
                case 0:
                default:
                case 1: TrapBaseType = TRAP_BASE_TYPE_EPIC_ELECTRICAL; break;
                case 2: TrapBaseType = TRAP_BASE_TYPE_EPIC_FIRE; break;
                case 3: TrapBaseType = TRAP_BASE_TYPE_EPIC_FROST; break;
                case 4: TrapBaseType = TRAP_BASE_TYPE_EPIC_SONIC; break;

            }
        break; // Epic Strength

    } // switch - trap strength


    return TrapBaseType;

}
int
StringTrapBaseTypeToInt(string sTrapBaseType)
{
    string sTBType =
        GetStringRight(sTrapBaseType, GetStringLength(sTrapBaseType)-15);

    if (sTBType == "AVERAGE_ACID")
        return TRAP_BASE_TYPE_AVERAGE_ACID;
    else if (sTBType == "AVERAGE_ACID_SPLASH")
        return TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH;
    else if (sTBType == "AVERAGE_ELECTRICAL")
        return TRAP_BASE_TYPE_AVERAGE_ELECTRICAL;
    else if (sTBType == "AVERAGE_FIRE")
        return  TRAP_BASE_TYPE_AVERAGE_FIRE;
    else if (sTBType == "AVERAGE_GAS")
        return  TRAP_BASE_TYPE_AVERAGE_GAS;
    else if (sTBType == "AVERAGE_HOLY")
        return  TRAP_BASE_TYPE_AVERAGE_HOLY;
    else if (sTBType == "AVERAGE_NEGATIVE")
        return  TRAP_BASE_TYPE_AVERAGE_NEGATIVE;
    else if (sTBType == "AVERAGE_SONIC")
        return  TRAP_BASE_TYPE_AVERAGE_SONIC;
    else if (sTBType == "AVERAGE_SPIKE")
        return  TRAP_BASE_TYPE_AVERAGE_SPIKE;
    else if (sTBType == "AVERAGE_TANGLE")
        return  TRAP_BASE_TYPE_AVERAGE_TANGLE;
    else if (sTBType == "DEADLY_ACID_SPLASH")
        return  TRAP_BASE_TYPE_DEADLY_ACID_SPLASH;
    else if (sTBType == "DEADLY_ELECTRICAL")
        return  TRAP_BASE_TYPE_DEADLY_ELECTRICAL;
    else if (sTBType == "DEADLY_FIRE")
        return  TRAP_BASE_TYPE_DEADLY_FIRE;
    else if (sTBType == "DEADLY_FROST")
        return  TRAP_BASE_TYPE_DEADLY_FROST;
    else if (sTBType == "DEADLY_GAS")
        return  TRAP_BASE_TYPE_DEADLY_GAS;
    else if (sTBType == "DEADLY_HOLY")
        return TRAP_BASE_TYPE_DEADLY_HOLY;
    else if (sTBType == "DEADLY_NEGATIVE")
        return TRAP_BASE_TYPE_DEADLY_NEGATIVE;
    else if (sTBType == "DEADLY_SONIC")
        return  TRAP_BASE_TYPE_DEADLY_SONIC;
    else if (sTBType == "DEADLY_SPIKE")
        return  TRAP_BASE_TYPE_DEADLY_SPIKE;
    else if (sTBType == "DEADLY_TANGLE")
        return TRAP_BASE_TYPE_DEADLY_TANGLE;
    else if (sTBType == "EPIC_ELECTRICAL")
        return  TRAP_BASE_TYPE_EPIC_ELECTRICAL;
    else if (sTBType == "EPIC_FIRE")
        return TRAP_BASE_TYPE_EPIC_FIRE;
    else if (sTBType == "EPIC_FROST")
        return  TRAP_BASE_TYPE_EPIC_FROST;
    else if (sTBType == "EPIC_SONIC")
        return  TRAP_BASE_TYPE_EPIC_SONIC;
    else if (sTBType == "MINOR_ACID")
        return TRAP_BASE_TYPE_MINOR_ACID;
    else if (sTBType == "MINOR_ACID_SPLASH")
        return  TRAP_BASE_TYPE_MINOR_ACID_SPLASH;
    else if (sTBType == "MINOR_ELECTRICAL")
        return  TRAP_BASE_TYPE_MINOR_ELECTRICAL;
    else if (sTBType == "MINOR_FIRE")
        return  TRAP_BASE_TYPE_MINOR_FIRE;
    else if (sTBType == "MINOR_FROST")
        return  TRAP_BASE_TYPE_MINOR_FROST;
    else if (sTBType == "MINOR_HOLY")
        return  TRAP_BASE_TYPE_MINOR_HOLY;
    else if (sTBType == "MINOR_NEGATIVE")
        return  TRAP_BASE_TYPE_MINOR_NEGATIVE;
    else if (sTBType == "MINOR_SONIC")
        return  TRAP_BASE_TYPE_MINOR_SONIC;
    else if (sTBType == "MINOR_SPIKE")
        return  TRAP_BASE_TYPE_MINOR_SPIKE;
    else if (sTBType == "MINOR_TANGLE")
        return  TRAP_BASE_TYPE_MINOR_TANGLE;
    else if (sTBType == "STRONG_ACID_SPLASH")
        return  TRAP_BASE_TYPE_STRONG_ACID_SPLASH;
    else if (sTBType == "STRONG_ELECTRICAL")
        return  TRAP_BASE_TYPE_STRONG_ELECTRICAL;
    else if (sTBType == "STRONG_FIRE")
        return TRAP_BASE_TYPE_STRONG_FIRE;
    else if (sTBType == "STRONG_ACID")
        return TRAP_BASE_TYPE_STRONG_ACID;
    else if (sTBType == "STRONG_GAS")
        return  TRAP_BASE_TYPE_STRONG_GAS;
    else if (sTBType == "STRONG_HOLY")
        return  TRAP_BASE_TYPE_STRONG_HOLY;
    else if (sTBType == "STRONG_NEGATIVE")
        return  TRAP_BASE_TYPE_STRONG_NEGATIVE;
    else if (sTBType == "STRONG_SONIC")
        return  TRAP_BASE_TYPE_STRONG_SONIC;
    else if (sTBType == "STRONG_SPIKE")
        return  TRAP_BASE_TYPE_STRONG_SPIKE;
    else if (sTBType == "STRONG_TANGLE")
        return  TRAP_BASE_TYPE_STRONG_TANGLE;

    else
        return -1;
}
int
StringTrapStrengthToInt(string sTrapStrength, object oPC = OBJECT_INVALID)
{
    if (sTrapStrength == "MINOR")
        return IP_CONST_TRAPSTRENGTH_MINOR;
    else if (sTrapStrength == "AVERAGE")
        return IP_CONST_TRAPSTRENGTH_AVERAGE;
    else if (sTrapStrength == "STRONG")
        return IP_CONST_TRAPSTRENGTH_STRONG;
    else if (sTrapStrength == "DEADLY")
        return IP_CONST_TRAPSTRENGTH_DEADLY;
    else if (sTrapStrength == "EPIC")
        return -1;
	else if (sTrapStrength == "PLAYERLEVEL")
		return (GetFactionAverageLevel(oPC) / 6);


    return IP_CONST_TRAPSTRENGTH_MINOR;
}