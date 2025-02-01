#include "ff_safevar"

///////////////////////////////////////////////////////////
// ps_scod_onenter001
//
// Area OnEnter call to process area (traps, spawns, cleanup, etc)
//
// Author:  ADnD'R
// Date:    26 May 2006
//
// Date Last Modified: 15MAY2010
// Last Modified By: ADnD'R (SlackerSupreme@rocketmail.com)
////////////////////////////////////////////////////////////

/*
History of Changes

	1. Added a semiphore (flag) so that multiple PC's entering an area
	seperately during our processing timeout doesn't trigger multiple 
	calls for us.   


*/


#include "ps_scod_lib_traps"

void
ProcessAreaTraps(object oArea, object oPC)
{

    // if these are null strings the funcs will revert to defaults,
    // i.e., "rtdoor" and "rtfloor"
    string sAreaDoorTrapToken = PS_GetLocalString(OBJECT_SELF, "TRAP_DOOR_TOKEN");
    string sAreaFloorTrapToken = PS_GetLocalString(OBJECT_SELF, "TRAP_FLOOR_TOKEN");

    RespawnAreaDoorTraps(OBJECT_SELF, oPC, sAreaDoorTrapToken);
    RespawnAreaFloorTraps(OBJECT_SELF, oPC, sAreaFloorTrapToken);

	/// RespawnAreaMovingFloorTraps(OBJECT_SELF, oPC, "set_unique_waypoint_tag");
	/// etc, etc, for more than one set
	
}

void main()
{
	string sBusyFlag = "EXECUTING_ONENTER";
    object oPC = GetEnteringObject();	

	
    // only execute if no other PC is in this area
    if (GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
        PLAYER_CHAR_IS_PC, oPC) != OBJECT_INVALID)
        return;

	// . . . and we don't have our "we're busy" semaphore set
	// Put any calls that where we don't care about the timeout BEFORE this
	if (PS_GetLocalInt(OBJECT_SELF, sBusyFlag) == TRUE)
		return;

	PS_SetLocalInt(OBJECT_SELF, sBusyFlag, TRUE);	
	
    // Area NPC spawner, other cleanup funcs, whatever
    //ExecuteScript("scod_npc_spawner", OBJECT_SELF);	
		
		
	ProcessAreaTraps(OBJECT_SELF, oPC);

	/// We're done, reset our "busy" flag - on a delayed timer
	float fProcessDelay = PS_GetLocalFloat(OBJECT_SELF, "ONENTER_CLEANUP_DELAY");
	if (fProcessDelay == 0.0f)
		fProcessDelay = 600.0f; //defaults to 10 minutes
		 
	DelayCommand(fProcessDelay, PS_DeleteLocalInt(OBJECT_SELF, sBusyFlag));
}