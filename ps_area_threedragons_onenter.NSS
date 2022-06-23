void main() {

 	object oPC = GetEnteringObject();
  
 	int iLock = GetGlobalInt("ThreeDragonsLock");
 	if ( iLock == 0 ) {
	
  		SetGlobalInt("ThreeDragonsLock", 1); // Only allows one clean up at a time.

  		if(GetObjectByTag("ps_3dragons_penelope") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_ps_3dragons_penelope");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_3dragons_penelope", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_3dragons_lorna") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_ps_3dragons_lorna");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_3dragons_lorna", lSpawnpoint);    
  		}

  
  		SetGlobalInt("ThreeDragonsLock", 0);
	}
}