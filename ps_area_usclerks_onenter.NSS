#include "ff_safevar"

void main() {

 	object oPC = GetEnteringObject();
  
 	int iLock = PS_GetGlobalInt("Undersigl_ClerksWard_Lock");
 	if ( iLock == 0 ) {
	
  		PS_SetGlobalInt("Undersigl_ClerksWard_Lock", 1); // Only allows one clean up at a time.

  		if(GetObjectByTag("ps_us_onewhoknows") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_onewhoknows");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_onewhoknows", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_us_cwslave") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_cwslave");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_cwslave", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_us_cwhobgoblin") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_cwhobgoblin");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_cwhobgoblin", lSpawnpoint);    
  		}
  
  		PS_SetGlobalInt("Undersigl_ClerksWard_Lock", 0);
	}
}