
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("Gatehouse4Lock");
 if ( iLock == 0 )
 {
  SetGlobalInt("Gatehouse4Lock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_ghlongfellow") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghlongfellow");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ghlongfellow", lSpawnpoint);    
  }
 
  if(GetObjectByTag("n_gh_peter") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_n_gh_peter");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "n_gh_peter", lSpawnpoint);    
  }

  if(GetObjectByTag("n_gh_daisy") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_n_gh_daisy");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "n_gh_daisy", lSpawnpoint);    
  }
 
  if(GetObjectByTag("n_gh_shale") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_n_gh_shale");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "n_gh_shale", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_ghcommoner") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghcommoner");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ghcommoner", lSpawnpoint);    
  }
  
  if(GetObjectByTag("n_gh_liawyn") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_n_gh_liawyn");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "n_gh_liawyn", lSpawnpoint);    
  }
 
  if(GetObjectByTag("n_cookie") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_n_cookie");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "n_cookie", lSpawnpoint);    
  }

  if(GetObjectByTag("n_gh_sable") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_n_gh_sable");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "n_gh_sable", lSpawnpoint);    
  }
 
  if(GetObjectByTag("n_gh_tyvold") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_n_gh_tyvold");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "n_gh_tyvold", lSpawnpoint);    
  }
 
  if(GetObjectByTag("n_gh_anton") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_n_gh_anton");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "n_gh_anton", lSpawnpoint);    
  }
 
     
   
  SetGlobalInt("Gatehouse4Lock", 0);
 }
}