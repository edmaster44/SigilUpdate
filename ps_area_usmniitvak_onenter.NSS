void main() {

 	object oPC = GetEnteringObject();
  
 	int iLock = GetGlobalInt("USigilEnterLock");
 	if ( iLock == 0 ) {
	
  		SetGlobalInt("USigilEnterLock", 1); // Only allows one clean up at a time.

  		if(GetObjectByTag("ps_us_mniitvak") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_mniitvak");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_mniitvak", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_us_bleaker") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_bleaker");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_bleaker", lSpawnpoint);    
  		}
    
  		SetGlobalInt("USigilEnterLock", 0);
 	}
	
}