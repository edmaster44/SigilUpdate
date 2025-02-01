#include "ff_safevar"

void main() {

 	object oPC = GetEnteringObject();
  
 	int iLock = PS_GetGlobalInt("UndersigilHauntedLock");
 	if ( iLock == 0 ) {
  		PS_SetGlobalInt("UndersigilHauntedLock", 1); // Only allows one clean up at a time.

 		if(GetObjectByTag("ps_us_hauntingspirit") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_ps_us_hauntingspirit");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_hauntingspirit", lSpawnpoint);    
  		}
      
  		PS_SetGlobalInt("UndersigilHauntedLock", 0);
 	}
}