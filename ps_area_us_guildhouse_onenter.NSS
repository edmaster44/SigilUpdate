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
  
  		if(GetObjectByTag("ps_us_gwzombie") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_gwzombie");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwzombie", lSpawnpoint);    
  		} 
		
  		if(GetObjectByTag("ps_us_gwhellhound") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_gwhellhound");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwhellhound", lSpawnpoint);    
  		} 
		
  		if(GetObjectByTag("ps_us_gwkobold") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_gwkobold1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwkobold", lSpawnpoint);  
			oWP = GetWaypointByTag("wp_ps_us_gwkobold2");
   			lSpawnpoint = GetLocation(oWP);  
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwkobold", lSpawnpoint);     
  		} 
		
  		if(GetObjectByTag("ps_us_gwcultist") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_gwcultist");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwcultist", lSpawnpoint);    
  		} 
		
  		if(GetObjectByTag("ps_us_druggedperson1") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_druggedperson1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_druggedperson1", lSpawnpoint);    
  		} 
		
  		if(GetObjectByTag("ps_us_druggedperson2") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_druggedperson2");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_druggedperson2", lSpawnpoint);    
  		} 
		
  		if(GetObjectByTag("ps_us_druggedperson3") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_druggedperson3");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_druggedperson3", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_druggedperson4") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_druggedperson4");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_druggedperson4", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_drugdealer") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_drugdealer");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_drugdealer", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_sigisworker1") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_sigisworker1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_sigisworker1", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_sigisworker2") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_sigisworker2");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_sigisworker2", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_gwruffian1") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_gwruffian1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwruffian1", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_gwruffian2") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_gwruffian2");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwruffian2", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_gwruffian3") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_gwruffian3");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwruffian3", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_gwruffian4") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_gwruffian4");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwruffian4", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_rorylanned") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_rorylanned");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_rorylanned", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_tout_sevendeeds1") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_tout_sevendeeds1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_tout_sevendeeds1", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_tout_sevendeeds2") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_tout_sevendeeds2");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_tout_sevendeeds2", lSpawnpoint);    
  		}
	
  		SetGlobalInt("UndersigilGuildhouseLock", 1); // Only allows one clean up at a time.
		
	}
	
}