
void main()
{

 int iLock = GetGlobalInt("GymnasiumEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("GymnasiumEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_gymnasiumcommoner1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gymnasiumhall1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumcommoner1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_gymnasiumcommoner2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gymnasiumhall2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumcommoner2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_gymnasiumcommoner3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gymnasiumhall3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumcommoner3", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_gymnasiumcommoner4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gymnasiumhall4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumcommoner4", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_gymnasiumcommoner5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gymnasiumhall5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumcommoner5", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_npc_gymnasiumcommoner6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gymnasiumhall6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumcommoner6", lSpawnpoint);    
  }  
    
  if(GetObjectByTag("ps_npc_gymnasiumcommoner7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gymnasiumhall7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumcommoner7", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_fangclawson") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gym_fang");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_fangclawson", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_gwaraff") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gym_gwhr");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gwaraff", lSpawnpoint);    
  }  
  
  SetGlobalInt("GymnasiumEnterLock", 0);
 }
}