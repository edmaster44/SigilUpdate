
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("CultVillageEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("CultVillageEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_cultcommoner1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_cultcommoner1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cultcommoner1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_cultcommoner2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_cultcommoner2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cultcommoner2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_cultcommoner3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_cultcommoner3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cultcommoner3", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_cultcommoner4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_cultcommoner4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cultcommoner4", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_cultcommoner5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_cultcommoner5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cultcommoner5", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_npc_cultcommoner6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_cultcommoner6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cultcommoner6", lSpawnpoint);    
  }  
    
  if(GetObjectByTag("ps_npc_cultcommoner7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_cultcommoner7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cultcommoner7", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_cultcommoner8") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_cultcommoner8");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cultcommoner8", lSpawnpoint);    
  }  
  
    if(GetObjectByTag("ps_wp_cartel_1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_cartel_1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cartelguard1", lSpawnpoint);    
  }  
  
      if(GetObjectByTag("ps_wp_cartel_2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_cartel_2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cartelguard2", lSpawnpoint);    
  }  
  
      if(GetObjectByTag("ps_wp_cartel_3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_cartel_3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cartelguard3", lSpawnpoint);    
  }  
  
      if(GetObjectByTag("ps_wp_cartel_howard") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_cartel_howard");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_cartel_howard", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_randomitemmerchant") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_shadymerchant");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_randomitemmerchant", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_randomitemmerchant") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_shadymerchant");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_randomitemmerchant", lSpawnpoint);    
  }
  
  if(GetObjectByTag("npc_sigis_editor") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sigis_editor");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_sigis_editor", lSpawnpoint);    
  }
  
  SetGlobalInt("CultVillageEnterLock", 0);
 }
}