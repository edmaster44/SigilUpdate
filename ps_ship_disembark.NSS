#include "ff_safevar"

#include "ps_ship_generic_inc"
#include "x0_i0_transport"
void main ()
{
	object oPC = GetLastUsedBy();
	string sWP = PS_GetLocalString(OBJECT_SELF, "ship_dock");
	if (sWP == "")
		SpeakString("The ship isn't docked, don't disembark yet!");
	else
	{
		object oWP = GetWaypointByTag(sWP);
  		TransportToWaypoint(oPC, oWP);
	}
}