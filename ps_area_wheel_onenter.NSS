#include "ff_safevar"


void main () {
	
	int iLock = PS_GetGlobalInt("FortunesWheelLock");
	if ( iLock == 0 )
	{
		 PS_SetGlobalInt("FortunesWheelLock", 1); // Only allows one clean up at a time.
		
		 if(GetObjectByTag("ps_fw_dicegith") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_dicegith");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_dicegith", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_beastmaster") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_beastmaster");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_beastmaster", lSpawnpoint);    
		 }
		 if(GetObjectByTag("roulettedealer") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_roulettedealer");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_roulettedealer", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_djinn") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_djinn");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_djinn", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_noble01") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_noble01");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_noble01", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_dustman") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_dustman");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_dustman", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_estrella") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_estrella");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_estrella", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_bouncer") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_bouncer");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_bouncer", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_godswoman") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_godswoman");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_godswoman", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_greeter") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_greeter");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_greeter", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_celestial") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_celestial");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_celestial", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_bartender1") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_bartender1");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_bartender1", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_cipher") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_cipher");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_cipher", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_fatednoble") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_fatednoble");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_fatednoble", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_sensate") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_sensate");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_sensate", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_wheelspinner") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_wheelspinner");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_wheelspinner", lSpawnpoint);    
		 }
		 if(GetObjectByTag("ps_fw_itemlottery") == OBJECT_INVALID)
		 {
		   object oWP = GetWaypointByTag("wp_fw_itemgambling");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_itemlottery", lSpawnpoint);    
		 }
		 PS_SetGlobalInt("FortunesWheelLock", 0);
	}	
}