void main() {
 
	object oPC = GetEnteringObject();
  
 	int iLock = GetGlobalInt("UndersigilGuildhouseLock");
 	if ( iLock == 0 ) {
  
	  	if(GetObjectByTag("npc_sigis_editor") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_ps_us_sigis_editor");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_sigis_editor", lSpawnpoint);    
			
	  	}

  		if(GetObjectByTag("ps_randomitemmerchant") == OBJECT_INVALID) {
   
			object oWP = GetWaypointByTag("wp_ps_us_shadymerchant");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_randomitemmerchant", lSpawnpoint);    
  		}  
  
  		if(GetObjectByTag("ps_timequests_spadix") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_spadix");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_timequests_spadix", lSpawnpoint);    
  		}  
	
  		SetGlobalInt("UndersigilGuildhouseLock", 1); // Only allows one clean up at a time.
		
	}
	
}