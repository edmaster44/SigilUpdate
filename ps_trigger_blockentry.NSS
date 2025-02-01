#include "ff_safevar"

//*********************************************
// This trigger blocks entry to a room until the "AllowPassage" int is set to 1
// Mimi Fearthegn
// 6/30/19
//*********************************************
#include "x0_i0_transport"

void main () {

	object oPC = GetEnteringObject();
	
	if (!GetIsPC(oPC) && GetControlledCharacter(oPC) == OBJECT_INVALID)
		return;
		
	string sWP = PS_GetLocalString(OBJECT_SELF, "ExitWP");
	object oWP = GetWaypointByTag(sWP);
	
	if (!PS_GetLocalInt(OBJECT_SELF, "AllowPassage")) {
		TransportToWaypoint(oPC, oWP);
	}

}