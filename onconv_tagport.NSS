#include "x0_i0_transport"
void main() {
  string sTag = GetTag(OBJECT_SELF);
  string sDestTag = "wp_"+sTag;
  object oPC = GetPCSpeaker();
  object oWP = GetWaypointByTag(sDestTag);
  TransportToWaypoint(oPC, oWP);
}  