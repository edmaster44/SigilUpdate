#include "ff_safevar"

void main() {

	object oPC = GetEnteringObject();
  
	int iLock = PS_GetGlobalInt("MortuaryEnterLock");
	if ( iLock == 0 ) {
	
		PS_SetGlobalInt("MortuaryEnterLock", 1); // Only allows one clean up at a time.

		if(GetObjectByTag("ps_mortuary_zombie") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("ps_mortuary_zombie_a");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_zombie_2", GetLocation(oWP));  
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

	  	if(GetObjectByTag("ps_mortuary_dustman1") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuarydustman_a");
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_dustman1", GetLocation(oWP)); 
			oWP = GetWaypointByTag("wp_mortuarydustman_e");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_dustman1", GetLocation(oWP));   
	  	}

  		if(GetObjectByTag("ps_mortuary_dustman2") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuarydustman_b");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_dustman2", GetLocation(oWP));    
			oWP = GetWaypointByTag("wp_mortuarydustman_d");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_dustman2", GetLocation(oWP));   
  		}

  		if(GetObjectByTag("ps_mortuary_dustman3") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuarydustman_c");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_dustman3", GetLocation(oWP));   
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

  		if(GetObjectByTag("ps_mortuary_mvampire") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuary_mvampire_a");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_mvampire", GetLocation(oWP));    
			oWP = GetWaypointByTag("wp_mortuary_mvampire_b");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_mvampire", GetLocation(oWP));     
			oWP = GetWaypointByTag("wp_mortuary_mvampire_c");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_mvampire", GetLocation(oWP));   
  		}

  		if(GetObjectByTag("ps_mortuary_skeletonguard") == OBJECT_INVALID) {
			object oWP = GetWaypointByTag("wp_mortuary_skeletonguard_a");
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_skeletonguard", GetLocation(oWP));    
			oWP = GetWaypointByTag("wp_mortuary_skeletonguard_b");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_skeletonguard", GetLocation(oWP));     
			oWP = GetWaypointByTag("wp_mortuary_skeletonguard_c");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_skeletonguard", GetLocation(oWP));    
			oWP = GetWaypointByTag("wp_mortuary_skeletonguard_d");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_skeletonguard", GetLocation(oWP));    
			oWP = GetWaypointByTag("wp_mortuary_skeletonguard_e");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_skeletonguard", GetLocation(oWP));     
			oWP = GetWaypointByTag("wp_mortuary_skeletonguard_f");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_skeletonguard", GetLocation(oWP));    
			oWP = GetWaypointByTag("wp_mortuary_skeletonguard_g");  
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mortuary_skeletonguard", GetLocation(oWP));     
  		}
    
  		PS_SetGlobalInt("MortuaryEnterLock", 0);
		
 	}
}