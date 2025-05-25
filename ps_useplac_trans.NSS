

// when placeable is used, transition to WP defined tag on variable WP.

#include "x0_i0_transport"

void main()
{
	object oPC = GetLastUsedBy();
	object oPlaceable = OBJECT_SELF;
	string sDest = GetLocalString(oPlaceable, "WP");
	object oWP = GetWaypointByTag(sDest);
	
	TransportToWaypoint(oPC, oWP);
	
}