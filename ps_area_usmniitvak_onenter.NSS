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

  		if(GetObjectByTag("ps_us_smuggler1") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_smuggler1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_smuggler1", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_us_smuggler2") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_smuggler2");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_smuggler2", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_us_smuggler3") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_smuggler3");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_smuggler3", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_us_tout_smuggler") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_tout_smuggler");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_tout_smuggler", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_us_smugglermerchant") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_us_smugglermerchant");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_smugglermerchant", lSpawnpoint);    
  		}
    
  		SetGlobalInt("USigilEnterLock", 0);
 	}
	
}