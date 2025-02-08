#include "ff_safevar"

void main(){

 	object oPC = GetEnteringObject();
  
 	int iLock = PS_GetGlobalInt("CivicEnterLock2");
 	if ( iLock == 0 ) {
 
	  	PS_SetGlobalInt("CivicEnterLock2", 1); // Only allows one clean up at a time.
	
		if(GetObjectByTag("festhallnpc_bartender") == OBJECT_INVALID) {
	   		object oWP = GetWaypointByTag("wp_festhallnpc_bartender");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_bartender", lSpawnpoint);    
	  	}
	
		if(GetObjectByTag("festhallnpc_coatchecker") == OBJECT_INVALID) {
	   		object oWP = GetWaypointByTag("wp_festhallnpc_coatchecker1");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_coatchecker", lSpawnpoint);   
			SetFirstName(oSpawn, "Gimme");
	   		oWP = GetWaypointByTag("wp_festhallnpc_coatchecker2");
	   		lSpawnpoint = GetLocation(oWP);  
	   		oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_coatchecker", lSpawnpoint);   
			SetFirstName(oSpawn, "Mok-Mok");
	  	}
  
  		PS_SetGlobalInt("CivicEnterLock2", 0);
 	}
}