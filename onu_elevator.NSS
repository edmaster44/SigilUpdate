#include "x0_i0_transport"

void main() {

	  string sTag = GetTag(OBJECT_SELF);
	  string sDestTag = "wp_"+sTag;
	  object oPC = GetLastUsedBy();
	  object oWP = GetWaypointByTag(sDestTag);
  
	  PlaySound("amb_metal_creaking_3");
	  string sDoor = "dr_"+sTag;
	  object oDoor = GetNearestObjectByTag(sDoor);
	  
	  ActionCloseDoor(oDoor);
	  DelayCommand(0.5f, SetLocked(oDoor, TRUE));
	  
	  object oPresent = GetFirstObjectInShape(SHAPE_CUBE, 10.0f, GetLocation(OBJECT_SELF));
	  while (GetIsObjectValid(oPresent)) {
	  
	  	DelayCommand(1.0f, TransportToWaypoint(oPresent, oWP));
	  	oPresent = GetNextObjectInShape(SHAPE_CUBE, 10.0f, GetLocation(OBJECT_SELF));
	  
	  } 
	  
	  
	  DelayCommand(1.5f, SetLocked(oDoor, FALSE));
	  

}