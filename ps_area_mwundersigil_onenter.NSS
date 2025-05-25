

void main () {
	
	int iLock = GetGlobalInt("MWTUNNELLOCK");
	if ( iLock == 0 )
	{
	  	SetGlobalInt("MWTUNNELLOCK", 1);
		
		if (GetObjectByTag("bzr_corpse_a") == OBJECT_INVALID) {
		
			object oWP = GetWaypointByTag("wp_bzr_corpse_1");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "bzr_corpse_1", lSpawnpoint, FALSE, "bzr_corpse_a");  
			
		}
		
		if (GetObjectByTag("bzr_corpse_b") == OBJECT_INVALID) {
		
			object oWP = GetWaypointByTag("wp_bzr_corpse_2");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "bzr_corpse_2", lSpawnpoint, FALSE, "bzr_corpse_b");  
			
		}
		
		if (GetObjectByTag("bzr_corpse_c") == OBJECT_INVALID) {
		
			object oWP = GetWaypointByTag("wp_bzr_corpse_3");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "bzr_corpse_1", lSpawnpoint, FALSE, "bzr_corpse_c");  
			
		}
		
	  	if(GetObjectByTag("ps_us_tout_marketward") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_ps_us_tout_marketward");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_tout_marketward", lSpawnpoint);    
			
	  	}
		
  		SetGlobalInt("MWTUNNELLOCK", 0);
	}
}