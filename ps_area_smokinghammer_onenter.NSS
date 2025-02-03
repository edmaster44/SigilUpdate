
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("SmokingEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("SmokingEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_creature_sigilbarmaid") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_smokinghammerbarmaid");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_creature_sigilbarmaid", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_smoke_bartender") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_smokinghammerbartender");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_smoke_bartender", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_retiredbard") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_smokinghammerbard");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_retiredbard", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_smoke_drunkbard") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_smokinghammerbard2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_smoke_drunkbard", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_smoke_bouncer") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sh_bouncer");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_smoke_bouncer", lSpawnpoint);    
  }  

  if(GetObjectByTag("symon") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sh_symon");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "symon", lSpawnpoint);    
  }  
    
  if(GetObjectByTag("ps_npc_commoner7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sh_commoner7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_commoner7", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_commoner16") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sh_commoner16");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_commoner16", lSpawnpoint);    
  }  
  
    if(GetObjectByTag("ps_npc_shadventurer1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_shadventurer1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_shadventurer1", lSpawnpoint);    
  }  
  
    if(GetObjectByTag("ps_npc_shadventurer2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_shadventurer2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_shadventurer2", lSpawnpoint);    
  }  
  
    if(GetObjectByTag("ps_npc_shadventurer3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_shadventurer3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_shadventurer3", lSpawnpoint);    
  }  
  
    if(GetObjectByTag("ps_npc_shadventurer4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_shadventurer4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_shadventurer4", lSpawnpoint);    
  }  
  
    if(GetObjectByTag("ps_npc_shadventurer5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_shadventurer5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_shadventurer5", lSpawnpoint);    
  }  
  
  SetGlobalInt("SmokingEnterLock", 0);
 }
}