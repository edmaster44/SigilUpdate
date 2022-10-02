void main() {

	object oPC = GetEnteringObject();
  
 	int iLock = GetGlobalInt("ArmoryEnterLock");
 	if ( iLock == 0 ) {
	
  		SetGlobalInt("ArmoryEnterLock", 1); // Only allows one clean up at a time.

	  	if(GetObjectByTag("ps_armory_receptionist") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_receptionist");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_receptionist", lSpawnpoint);    
	  	}
  
	  	if(GetObjectByTag("ps_armory_doomguardg_1") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_doomguardg_1");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_doomguardg", lSpawnpoint, FALSE, "ps_armory_doomguardg_1");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_doomguardg_2") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_doomguardg_2");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladydoomguard", lSpawnpoint, FALSE, "ps_armory_doomguardg_2");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_doomguardg_4") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_doomguardg_4");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_doomguardg", lSpawnpoint, FALSE, "ps_armory_doomguardg_4");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_doomguardg_5") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_doomguardg_5");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladydoomguard", lSpawnpoint, FALSE, "ps_armory_doomguardg_5");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_doomguardg_6") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_doomguardg_6");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_doomguardg", lSpawnpoint, FALSE, "ps_armory_doomguardg_6");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_falcata") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_falcata");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_falcata", lSpawnpoint);    
	  	}
  
	  	if(GetObjectByTag("ps_armory_worker1") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_worker1");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_laborer1", lSpawnpoint, FALSE, "ps_armory_worker1");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_worker2") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_worker2");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_laborer2", lSpawnpoint, FALSE, "ps_armory_worker2");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_worker3") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_worker3");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_laborer3", lSpawnpoint, FALSE, "ps_armory_worker3");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_worker4") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_worker4");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_laborer1", lSpawnpoint, FALSE, "ps_armory_worker4");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_worker5") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_worker5");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_laborer2", lSpawnpoint, FALSE, "ps_armory_worker5");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_archivist") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_archivist");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_archivist", lSpawnpoint, FALSE, "ps_armory_archivist");    
	  	}
  
	  	if(GetObjectByTag("ps_armory_draftswoman") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_armory_draftswoman");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_draftswoman", lSpawnpoint, FALSE, "ps_armory_draftswoman");    
	  	}
		
		
  		SetGlobalInt("ArmoryEnterLock", 0);
 	}
}