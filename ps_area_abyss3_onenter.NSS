#include "ff_safevar"

///////////////////////////////////////////////////////////////
// ps_area_abyss3_onenter
//
// 
//
//
// Author:  			Unknown
// Date Created:    	??
// Date Last Modified:	26FEB2012 for SCOD (Sigil, City of Doors)
// Last Modified By:	Rust
///////////////////////////////////////////////////////////////
/*
						
History of Changes

	25FEB2012 - Rust
		1. Added calls in main() to do trap respawns. 
		2. Added ProcessAreaTraps() func. 

*/

#include "ps_scod_lib_traps"
#include "ps_inc_planarlocations"

void
ProcessAreaTraps(object oArea, object oPC)
{

    // if these are null strings the funcs will revert to defaults,
    // i.e., "rtdoor" and "rtfloor"

    string sAreaDoorTrapToken = PS_GetLocalString(OBJECT_SELF, "TRAP_DOOR_TOKEN");
    string sAreaFloorTrapToken = PS_GetLocalString(OBJECT_SELF, "TRAP_FLOOR_TOKEN");

	// Door traps respawn themselves
	//RespawnAreaDoorTraps(OBJECT_SELF, oPC, sAreaDoorTrapToken);
	
	RespawnAreaFloorTraps(OBJECT_SELF, oPC, sAreaFloorTrapToken);
	
	/// RespawnAreaMovingFloorTraps(OBJECT_SELF, oPC, "set_unique_waypoint_tag");
	/// etc, etc, for more than one set
	
	// No moving floor traps in here
	//RespawnAreaMovingFloorTraps(OBJECT_SELF, oPC, "rnd_floor_mov_01");

	
}

void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Abyss";
 string sDescrip = "The cave smells strongly of brimstone, and is crawling with demons.";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("abyss3EnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("abyss3EnterLock", 1); // Only allows one clean up at a time.

  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("abyss3EnterLock", 0);
 }
  
   	//////////////////////////////////////////
	//////////// Trap Respawns //////////////
	/////////////////////////////////////////
 	string sBusyFlag = "EXECUTING_ONENTER";	
	
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
	float fProcessDelay = PS_GetLocalFloat(OBJECT_SELF, "TRAP_RESPAWN_DELAY");
	if (fProcessDelay <= 0.0f)
		fProcessDelay = 600.0f; //defaults to 10 minutes
		 
	DelayCommand(fProcessDelay, PS_DeleteLocalInt(OBJECT_SELF, sBusyFlag));
  
  
 
}