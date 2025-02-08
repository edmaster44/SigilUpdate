#include "ff_safevar"

#include "ps_inc_achievements"

void main() {
 object oPC = GetEnteringObject();
	
 AddAchievement(oPC, 6);
  
 int iLock = PS_GetGlobalInt("NightMarketEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("NightMarketEnterLock", 1); // Only allows one clean up at a time.
  
  if(GetObjectByTag("ps_commoner_hiveward4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_thug1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward4", lSpawnpoint);    
   oWP = GetWaypointByTag("ps_hivespawn_thug3");
   lSpawnpoint = GetLocation(oWP);  
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward4", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_commoner_hiveward5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_thug2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward5", lSpawnpoint);    
  }    
   
  if(GetObjectByTag("ps_hivespawn_merchant") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_merchant1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hivespawn_merchant", lSpawnpoint);    
  }   
   
  if(GetObjectByTag("ps_hivespawn_merchant2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_hivespawn_merchant2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hivespawn_merchant2", lSpawnpoint);    
  }   

  if(GetObjectByTag("ps_nmpawn_basher") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_nmpawn_basher");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward5", lSpawnpoint, FALSE, "ps_nmpawn_basher");    
  }  
  
  if(GetObjectByTag("ps_nightmarket_woman") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_nightmarket_woman");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_nightmarket_woman", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_nightmarket_bariaur") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_nightmarket_bariaur");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_bariaur", lSpawnpoint, FALSE, "ps_nightmarket_bariaur");    
  } 
  
  if(GetObjectByTag("ps_nightmarket_tout") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_nightmarket_tout");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_nightmarket_tout", lSpawnpoint);    
  } 
  
  PS_SetGlobalInt("NightMarketEnterLock", 0);
 }
}