


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("LaboratoryEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("LaboratoryEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_labcommoner1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_labcommoner1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_labcommoner1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_labcommoner2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_labcommoner2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_labcommoner2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_labcommoner3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_labcommoner3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_labcommoner3", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_labcommoner4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_labcommoner4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_labcommoner4", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_labcommoner5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_labcommoner5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_labcommoner5", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_npc_labcommoner6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_labcommoner6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_labcommoner6", lSpawnpoint);    
  }  
    
  if(GetObjectByTag("ps_npc_labcommoner7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_labcommoner7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_labcommoner7", lSpawnpoint);    
  }  
  
   
  SetGlobalInt("LaboratoryEnterLock", 0);
 }
}