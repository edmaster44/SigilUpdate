void main() {

 	object oPC = GetEnteringObject();
  
 	int iLock = GetGlobalInt("ClerksWardBankLock");
 	if ( iLock == 0 ) {
	
  		SetGlobalInt("ClerksWardBankLock", 1); // Only allows one clean up at a time.

  		if(GetObjectByTag("ps_cw_bankerclerk1") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_cw_bankerclerk1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_cw_bankerclerk1", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_cw_bankerclerk2") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_cw_bankerclerk2");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_cw_bankerclerk2", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_cw_bankerclerk3") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_cw_bankerclerk3");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_cw_bankerclerk3", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_cw_bankerclerk4") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_cw_bankerclerk4");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_cw_bankerclerk4", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_cw_bankercommoner1") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_cw_bankercommoner1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_cw_bankercommoner1", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_cw_bankercommoner2") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_cw_bankercommoner2");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_cw_bankercommoner2", lSpawnpoint);    
  		}

  		if(GetObjectByTag("ps_cw_bankercommoner3") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_cw_bankercommoner3");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_cw_bankercommoner3", lSpawnpoint);    
  		}
  
  		SetGlobalInt("ClerksWardBankLock", 0);
	}
}