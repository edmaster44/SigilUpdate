
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("LadyEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("LadyEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_peddler_ladysward") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_peddler_ladysward");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_peddler_ladysward", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_mercykiller") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lady_merc1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mercykiller", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_mercykiller2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lady_merc2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mercykiller2", lSpawnpoint);    
  }

  if(GetObjectByTag("c_commoner_human") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lady_com1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "c_commoner_human", lSpawnpoint);    
  }

  if(GetObjectByTag("c_commoner_tiefling") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lady_com2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "c_commoner_tiefling", lSpawnpoint);    
  }
  
  if(GetObjectByTag("c_npc_zombie") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lady_zombie");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "c_npc_zombie", lSpawnpoint);    
  }
  
  if(GetObjectByTag("c_commoner_blackabishai") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lady_abishai");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "c_commoner_blackabishai", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_behran") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lady_behran");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_behran", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_commoner6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lady_commoner6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_commoner6", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_npc_ladyharmonium1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyharmonium1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium1", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_npc_ladyharmonium2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyharmonium2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium2", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ladyh_guard_walk1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyharmonium3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ladyh_guard_walk1", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ladyh_guard_walk2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyharmonium4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ladyh_guard_walk2", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ladyh_guard_walk3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyharmonium5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ladyh_guard_walk3", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ladyh_guard_walk4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lady_commoner6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ladyh_guard_walk4", lSpawnpoint);    
  }
  
  
    if(GetObjectByTag("ps_commoner_ladysward1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyscommoner1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_ladysward1", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_commoner_ladysward2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyscommoner2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_ladysward2", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_commoner_ladysward3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyscommoner3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_ladysward3", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_commoner_ladysward4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyscommoner4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_ladysward4", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_commoner_ladysward5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyscommoner5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_ladysward5", lSpawnpoint);    
  } 
  
    if(GetObjectByTag("ps_commoner_ladysward6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyscommoner6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_ladysward6", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_commoner_ladysward7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyscommoner7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_ladysward7", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_commoner_ladysward8") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_ladyscommoner8");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_ladysward8", lSpawnpoint);    
  } 
  
    if(GetObjectByTag("ps_npc_lady_leilani") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_leilani");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lady_leilani", lSpawnpoint);    
  } 
  SetGlobalInt("LadyEnterLock", 0);
 }
}