#include "ff_safevar"

#include "x0_i0_transport"
void main() {
  string sTag = GetTag(OBJECT_SELF);
  string sDestTag = "wp_"+sTag;
  object oPC = GetLastUsedBy();
  object oWP = GetWaypointByTag(sDestTag);
  TransportToWaypoint(oPC, oWP);
  
  string sEvent = PS_GetLocalString(OBJECT_SELF, "PORT_EVENT");
  if (sEvent != "")
  	DelayCommand(0.2f, ExecuteScript(sEvent, OBJECT_SELF));
}  