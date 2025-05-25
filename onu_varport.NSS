

#include "x0_i0_transport"
void main() {
  string sDestTag = GetLocalString(OBJECT_SELF, "waypoint");
  object oPC = GetLastUsedBy();
  object oWP = GetWaypointByTag(sDestTag);
  TransportToWaypoint(oPC, oWP);
}  