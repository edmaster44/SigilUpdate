
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("LadyEnterLock");
 if ( iLock == 0 )
 {
  	SetGlobalInt("LadyEnterLock", 1); // Only allows one clean up at a time.

	//Merchants
	if(GetObjectByTag("ps_peddler_ladysward") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_ps_peddler_ladysward");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_peddler_ladysward", lSpawnpoint);    
	}
  	if(GetObjectByTag("ps_npc_lady_leilani") == OBJECT_INVALID) {
   		object oWP = GetWaypointByTag("ps_wp_leilani");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lady_leilani", lSpawnpoint);    
  	} 
	
	//Dabus
	if(GetObjectByTag("ps_npc_ladydabus") == OBJECT_INVALID) {
   		object oWP = GetWaypointByTag("wp_ps_npc_ladydabus");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladydabus", lSpawnpoint);    
  	}

	//Harmonium
  	if(GetObjectByTag("ps_npc_ladyharmonium") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_lady_harmguard1");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium", lSpawnpoint); 
		oWP = GetWaypointByTag("wp_lady_harmguard2");
   		lSpawnpoint = GetLocation(oWP);  
   		oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium", lSpawnpoint);    
		oWP = GetWaypointByTag("wp_lady_harmguard3");
   		lSpawnpoint = GetLocation(oWP);  
   		oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium_archer", lSpawnpoint, FALSE, "ps_npc_ladyharmonium");
  	}
	if(GetObjectByTag("ps_npc_ladyharmonium_walker1") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_lady_harmwalker1");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium", lSpawnpoint, FALSE, "ps_npc_ladyharmonium_walker1"); 
  	}
	if(GetObjectByTag("ps_npc_ladyharmonium_walker2") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_lady_harmwalker2");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium", lSpawnpoint, FALSE, "ps_npc_ladyharmonium_walker2"); 
  	}
	if(GetObjectByTag("ps_npc_ladyharmonium_walker3") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_lady_harmwalker3");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium", lSpawnpoint, FALSE, "ps_npc_ladyharmonium_walker3"); 
  	}
	
	//MK
  	if(GetObjectByTag("ps_npc_ladymercykiller") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_lady_mercyguard1");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladymercykiller", lSpawnpoint); 
		oWP = GetWaypointByTag("wp_lady_mercyguard2");
   		lSpawnpoint = GetLocation(oWP);  
   		oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladymercykiller", lSpawnpoint);    
		oWP = GetWaypointByTag("wp_lady_mercyguard3");
   		lSpawnpoint = GetLocation(oWP);  
   		oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladymercykiller_archer", lSpawnpoint, FALSE, "ps_npc_ladyharmonium");
  	}
	if(GetObjectByTag("ps_npc_ladymercywalker1") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_lady_mercyguard4");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladymercykiller_archer", lSpawnpoint, FALSE, "ps_npc_ladymercywalker1"); 
	}
	if(GetObjectByTag("ps_npc_ladymercywalker2") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_lady_mercyguard5");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladymercykiller_archer", lSpawnpoint, FALSE, "ps_npc_ladymercywalker2"); 
	}
	
	//Guvner
  	if(GetObjectByTag("ps_npc_ladyguvner1") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_ps_npc_ladyguvner1");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyguvner", lSpawnpoint, FALSE, "ps_npc_ladyguvner1"); 
	}
	if(GetObjectByTag("ps_npc_ladyguvner2") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_ps_npc_ladyguvner2");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyguvner", lSpawnpoint, FALSE, "ps_npc_ladyguvner2"); 
  	}
	
	//Doomguard
  	if(GetObjectByTag("ps_npc_ladydoomguard") == OBJECT_INVALID) {
  		object oWP = GetWaypointByTag("wp_ps_npc_ladydoomguard1");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladydoomguard", lSpawnpoint); 
		oWP = GetWaypointByTag("wp_ps_npc_ladydoomguard2");
   		lSpawnpoint = GetLocation(oWP);  
   		oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladydoomguard", lSpawnpoint);    
  	}
	
	//Quest
	if(GetObjectByTag("ps_npc_ladysonya") == OBJECT_INVALID) {
   		object oWP = GetWaypointByTag("wp_ps_npc_ladysonya");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladysonya", lSpawnpoint);    
  	}
	if(GetObjectByTag("ps_npc_ladyblackmarian") == OBJECT_INVALID) {
   		object oWP = GetWaypointByTag("wp_ps_npc_blackmarian");
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyblackmarian", lSpawnpoint);    
  	}
	
	//Commoners
	//Fruit Market People only come out in the daytime
	if (GetIsDay() || GetIsDawn()) {
		if(GetObjectByTag("ps_npc_ladycommon1") == OBJECT_INVALID) {
	   		object oWP = GetWaypointByTag("wp_ps_npc_ladycommon1");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon1", lSpawnpoint);    
	  	}
		if(GetObjectByTag("ps_npc_ladycommon2") == OBJECT_INVALID) {
	   		object oWP = GetWaypointByTag("wp_ps_npc_ladycommon2");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon2", lSpawnpoint);    
	  	}
		if(GetObjectByTag("ps_npc_ladycommon3") == OBJECT_INVALID) {
	   		object oWP = GetWaypointByTag("wp_ps_npc_ladycommon3");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon3", lSpawnpoint);    
	  	}
		if(GetObjectByTag("ps_npc_ladycommon4") == OBJECT_INVALID) {
	   		object oWP = GetWaypointByTag("wp_ps_npc_ladycommon4");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon4", lSpawnpoint);    
	  	}
		if(GetObjectByTag("ps_npc_ladycommon5") == OBJECT_INVALID) {
	   		object oWP = GetWaypointByTag("wp_ps_npc_ladycommon5");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon5", lSpawnpoint);    
	  	}
	}
	
	if(GetObjectByTag("ps_npc_ladycommon6") == OBJECT_INVALID) {
	   	object oWP = GetWaypointByTag("wp_ps_npc_ladycommon6");
	   	location lSpawnpoint = GetLocation(oWP);  
	   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon6", lSpawnpoint);    
	}
	if(GetObjectByTag("ps_npc_ladycommon7") == OBJECT_INVALID) {
	   	object oWP = GetWaypointByTag("wp_ps_npc_ladycommon7");
	   	location lSpawnpoint = GetLocation(oWP);  
	   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon7", lSpawnpoint);    
	}
	if(GetObjectByTag("ps_npc_ladycommon8") == OBJECT_INVALID) {
	   	object oWP = GetWaypointByTag("wp_ps_npc_ladycommon8");
	   	location lSpawnpoint = GetLocation(oWP);  
	   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon8", lSpawnpoint);    
	}
	if(GetObjectByTag("ps_npc_ladycommon9") == OBJECT_INVALID) {
	   	object oWP = GetWaypointByTag("wp_ps_npc_ladycommon9");
	   	location lSpawnpoint = GetLocation(oWP);  
	   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon9", lSpawnpoint);    
	}
	if(GetObjectByTag("ps_npc_ladycommon10") == OBJECT_INVALID) {
	   	object oWP = GetWaypointByTag("wp_ps_npc_ladycommon10");
	   	location lSpawnpoint = GetLocation(oWP);  
	   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon10", lSpawnpoint);    
	}
	if(GetObjectByTag("ps_npc_ladycommon11") == OBJECT_INVALID) {
	   	object oWP = GetWaypointByTag("wp_ps_npc_ladycommon11");
	   	location lSpawnpoint = GetLocation(oWP);  
	   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon11", lSpawnpoint);    
	}
	if(GetObjectByTag("ps_npc_ladycommon12") == OBJECT_INVALID) {
	   	object oWP = GetWaypointByTag("wp_ps_npc_ladycommon12");
	   	location lSpawnpoint = GetLocation(oWP);  
	   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon12", lSpawnpoint);    
	}
	if(GetObjectByTag("ps_npc_ladycommon13") == OBJECT_INVALID) {
	   	object oWP = GetWaypointByTag("wp_ps_npc_ladycommon13");
	   	location lSpawnpoint = GetLocation(oWP);  
	   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladycommon13", lSpawnpoint);    
	}

  SetGlobalInt("LadyEnterLock", 0);
 }
}