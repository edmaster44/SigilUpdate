#include "ff_safevar"

void main() {
 
	object oPC = GetEnteringObject();
  
 	int iLock = PS_GetGlobalInt("UndersigilGuildhouseLock");
 	if ( iLock == 0 ) {
	
  		PS_SetGlobalInt("UndersigilGuildhouseLock", 1); // Only allows one clean up at a time.
  
	  	if(GetObjectByTag("ps_us_gwsigiseditor") == OBJECT_INVALID) {
		
	   		object oWP = GetWaypointByTag("wp_us_gwsigiseditor");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwsigiseditor", lSpawnpoint);    
			
	  	}

  		if(GetObjectByTag("ps_randomitemmerchant") == OBJECT_INVALID) {
   
			object oWP = GetWaypointByTag("wp_ps_us_shadymerchant");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_randomitemmerchant", lSpawnpoint);    
  		}  
  
  		if(GetObjectByTag("ps_us_gw_spadix") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_us_gw_spadix");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gw_spadix", lSpawnpoint);    
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
		
   			object oWP = GetWaypointByTag("wp_us_gwcultist");
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
		
   			object oWP = GetWaypointByTag("wp_us_tout_sevendeeds1");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_tout_sevendeeds1", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_tout_sevendeeds2") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_us_tout_sevendeeds2");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_tout_sevendeeds2", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_gwtiefling") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_gwtiefling");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_gwtiefling", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_bittersymon") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_bittersymon");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_bittersymon", lSpawnpoint);    
  		}
		
  		if(GetObjectByTag("ps_us_spirithunter") == OBJECT_INVALID) {
		
   			object oWP = GetWaypointByTag("wp_ps_us_spirithunter");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_spirithunter", lSpawnpoint);    
  		}
	
  		PS_SetGlobalInt("UndersigilGuildhouseLock", 0); // Only allows one clean up at a time.
		
	}
	
}