

#include "ps_inc_achievements"

void main() {
 	object oPC = GetEnteringObject();
  
 	int iLock = GetGlobalInt("ZeroEnterLock");
 	if ( iLock == 0 ) {
  
		SetGlobalInt("ZeroEnterLock", 1); // Only allows one clean up at a time.

  		if(GetObjectByTag("ps_zero_morvun") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("WP_ps_zero_morvun");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_zero_morvun", lSpawnpoint);    
  		}   

  		if(GetObjectByTag("ps_zero_phineas") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("WP_ps_zero_phineas");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_zero_phineas", lSpawnpoint);    
  		}  

  		if(GetObjectByTag("ps_zero_bartender_sven") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("WP_ps_zero_bartender_sven");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_zero_bartender_sven", lSpawnpoint);    
  		} 

  		if(GetObjectByTag("ps_zero_bleaker2") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("WP_ps_zero_bleaker2");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_zero_bleaker2", lSpawnpoint);    
  		} 

  		if(GetObjectByTag("ps_zeronpc_bleaker1") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("WP_ps_zeronpc_bleaker1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_zeronpc_bleaker1", lSpawnpoint);    
  		} 

  		if(GetObjectByTag("ps_zero_bleaknikartist") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("WP_ps_zero_bleaknikartist");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_zero_bleaknikartist", lSpawnpoint);    
  		} 
  
  		SetGlobalInt("ZeroEnterLock", 0);
 	}
}