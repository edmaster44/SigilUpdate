

///////////////////////////////////////////////////////////////
// ps_floortrap-randomteleport
//
// Floor (trigger) trap OnTriggered function. 
//
// Randomly teleports PC to a waypoint(s) that has the same tag
// as this trap. 
//
// Also applies the trap's stock damage since NWN2 won't do it for us. 
// I use minor gas traps (poof), set them to non-disarmable (just make sure it can be avoided if spotted), nonrecoverable, and not one-shot.  
//
// SET VARIABLE INT "NUMBER_IN_SET" on the trap, for the number of random waypoints. Otherwise it defaults to 1,
// which would teleport them to the same waypoint. 
//
//
// Author:  			ADnD'R (slackersupreme@rocketmail.com)
// Date Created:    	28FEB2012 for SCOD (Sigil, City of Doors)
// Last Modified By:	ADnD'R (Rust)
// Date Last Modified:	28MAY2012
///////////////////////////////////////////////////////////////
/*
						
History of Changes

	26FEB2012 - Rust


*/

void main()
{
	object oPC = GetEnteringObject();
	
	if (!GetIsPC(oPC))
		return;
	
	//object oMyArea = GetArea(OBJECT_SELF);
	int nTrapType = GetTrapBaseType(OBJECT_SELF);
	
	//First we hit the PC(s) with the trap impact before anything else	
	string sImpactScript=Get2DAString("traps","TrapScript", nTrapType);
    ExecuteScript(sImpactScript,OBJECT_SELF);
	
	
	// Now teleport them to a random(?) waypoint that has our tag
	string sMyTag = GetTag(OBJECT_SELF);
	object oWaypoint = OBJECT_INVALID;
	int i;
	int nNumberWPs = GetLocalInt(OBJECT_SELF, "NUMBER_IN_SET");
	
	if (!nNumberWPs)
		nNumberWPs = 1;
	
	
	for (i=0; i < nNumberWPs; i++)
		oWaypoint = GetWaypointByTag(sMyTag);
		
	if (GetIsObjectValid(oWaypoint) != TRUE)
	{
		//gotta be SOME waypoint we can grab, just go there
		oWaypoint = GetNearestObject(OBJECT_TYPE_WAYPOINT, OBJECT_SELF, d6()+2);
	
	}
	if (GetIsObjectValid(oWaypoint) != TRUE)
		return; //bleah, just give up
		
	// Okay, poof
	AssignCommand(oPC, ClearAllActions(TRUE));
	DelayCommand(1.5f, FloatingTextStringOnCreature("<I>poof!</I>", oPC));
	AssignCommand(oPC, ActionJumpToObject(oWaypoint, FALSE));




}