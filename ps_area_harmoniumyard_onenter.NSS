
void main()
{

 int iLock = GetGlobalInt("HarmYardEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("HarmYardEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_peddler_harmonium") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_peddler_harmonium");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_peddler_harmonium", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_harmoniumyardguard1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcspawnpoint_yardguard1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumyardguard1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_harmoniumyardguard2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcspawnpoint_yardguard2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumyardguard2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_harmoniumyardguard3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcspawnpoint_yardguard3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumyardguard3", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_harmoniumyardguard4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcspawnpoint_yardguard4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumyardguard4", lSpawnpoint);    
  }  
 
  SetGlobalInt("HarmYardEnterLock", 0);
 }
}