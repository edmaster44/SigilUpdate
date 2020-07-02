#include "x0_i0_transport"

//Like the standard tagport script, but respects the "locked" status
//If you have the key, the door unlocks for 60 seconds before re-locking
void main() {
  string sTag = GetTag(OBJECT_SELF);
  string sDestTag = "wp_"+sTag;
  object oPC = GetLastUsedBy();
  object oWP = GetWaypointByTag(sDestTag);
  
  string sKey = GetLockKeyTag(OBJECT_SELF);
  
  if (GetLocked(OBJECT_SELF)) {
  
  	if (GetItemPossessedBy(oPC, sKey) != OBJECT_INVALID) {
		SetLocked(OBJECT_SELF, FALSE);
  		TransportToWaypoint(oPC, oWP);
		DelayCommand(60.0f, SetLocked(OBJECT_SELF, TRUE));
	} 
  
  } else {
  
  	TransportToWaypoint(oPC, oWP);
	
  }
}  