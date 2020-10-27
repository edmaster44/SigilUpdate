void main() {

	object oPC = GetEnteringObject();
  
	int iLock = GetGlobalInt("MortuaryEnterLock");
	if ( iLock == 0 ) {
	
		SetGlobalInt("MortuaryEnterLock", 1); // Only allows one clean up at a time.

		if(GetObjectByTag("ps_mortuary_zombie") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("ps_mortuary_zombie_a");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_zombie", GetLocation(oWP));  
			oWP = GetWaypointByTag("ps_mortuary_zombie_b");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_zombie", GetLocation(oWP));  
			oWP = GetWaypointByTag("ps_mortuary_zombie_c");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_zombie", GetLocation(oWP)); 
			oWP = GetWaypointByTag("ps_mortuary_zombie_d");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_zombie", GetLocation(oWP));   
			oWP = GetWaypointByTag("ps_mortuary_zombie_e");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_zombie", GetLocation(oWP));   
			oWP = GetWaypointByTag("ps_mortuary_zombie_f");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_zombie", GetLocation(oWP));   
  		}

	  	if(GetObjectByTag("ps_commoner_mortuary1") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuarydustman_a");
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary1", GetLocation(oWP)); 
			oWP = GetWaypointByTag("wp_mortuarydustman_c");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary1", GetLocation(oWP));   
			oWP = GetWaypointByTag("wp_mortuarydustman_e");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary1", GetLocation(oWP));   
	  	}

  		if(GetObjectByTag("ps_commoner_mortuary2") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuarydustman_b");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary2", GetLocation(oWP));    
			oWP = GetWaypointByTag("wp_mortuarydustman_d");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary2", GetLocation(oWP));   
  		}

  		if(GetObjectByTag("ps_mortuary_lor") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuary_lor");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_lor", GetLocation(oWP));      
  		}

  		if(GetObjectByTag("ps_mortuary_deathport") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuary_deathport");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_deathport", GetLocation(oWP));      
  		}

  		if(GetObjectByTag("ps_mortuary_narl") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuary_narl");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_narl", GetLocation(oWP));      
  		}

  		if(GetObjectByTag("ps_mortuary_wight") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuary_wight");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_wight", GetLocation(oWP));      
  		}

  		if(GetObjectByTag("ps_mort_giantskeleton") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mort_giantskeleton_a");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mort_giantskeleton", GetLocation(oWP));    
			oWP = GetWaypointByTag("wp_mort_giantskeleton_b");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mort_giantskeleton", GetLocation(oWP));   
  		}

  		if(GetObjectByTag("ps_mortuary_vampire") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuary_vampire");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_vampire", GetLocation(oWP));      
  		}
    
  		SetGlobalInt("MortuaryEnterLock", 0);
		
 	}
}