
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("HarmoniumEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("HarmoniumEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_peddler_harmonium") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_peddler_harmonium", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_harmoniumsmith") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumsmith", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_harmonium4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium4", lSpawnpoint);    
  }
  
  if(GetObjectByTag("h_guard_walk") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "h_guard_walk", lSpawnpoint);    
  }
  
  if(GetObjectByTag("h_guard_walk_01") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "h_guard_walk_01", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_harmonium2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_harmonium1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_harmonium3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm8");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium3", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_harmonium7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm9");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium7", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_harmonium5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm10");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium5", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_harmonium6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm11");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium6", lSpawnpoint);    
  }

  if(GetObjectByTag("h_guard_walk_02") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm12");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "h_guard_walk_02", lSpawnpoint);    
  }
  
  if(GetObjectByTag("h_guard_walk_03") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm13");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "h_guard_walk_03", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_harmonium8") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm14");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium8", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_harmonium9") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm15");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium9", lSpawnpoint);    
  }

   if(GetObjectByTag("harmonium_traineem2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmtrainee01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_traineem2", lSpawnpoint);    
  }
  
   if(GetObjectByTag("harmonium_traineeorc") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmtrainee02");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_traineeorc", lSpawnpoint);    
  } 
  
    if(GetObjectByTag("harmonium_traineem") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmtrainee03");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_traineem", lSpawnpoint);    
  } 
  
    if(GetObjectByTag("harmonium_traineef") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmtrainee04");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_traineef", lSpawnpoint);    
  } 
  
     if(GetObjectByTag("harmonium_ulfsgord") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmjailor");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_ulfsgord", lSpawnpoint);    
  } 
  
    if(GetObjectByTag("ps_npc_harmonium7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harm6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium7", lSpawnpoint);    
  } 
  
   if(GetObjectByTag("ps_harmonium_abyssguard_orc") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("harm_abyssguard01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_harmonium_abyssguard_orc", lSpawnpoint);    
  } 
  
    if(GetObjectByTag("ps_harmonium_abyssguard_orc") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("harm_abyssguard02");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_harmonium_abyssguard_orc", lSpawnpoint);    
  } 
  
   if(GetObjectByTag("ps_harmonium_abyssguard_cleric") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("harm_abyssguard03");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_harmonium_abyssguard_cleric", lSpawnpoint);    
  } 
  
     if(GetObjectByTag("ps_harmonium_abyssguard_measure") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("harm_abyssguard04");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_harmonium_abyssguard_measure", lSpawnpoint);    
  } 
  
   if(GetObjectByTag("ps_npc_harmonium3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("harm_abyssguard05");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmonium3", lSpawnpoint);    
  } 
  
   if(GetObjectByTag("harmonium_beholder") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmbeholder");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_beholder", lSpawnpoint);    
  } 
  
   if(GetObjectByTag("harmonium_liza") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmlibrarian");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_liza", lSpawnpoint);    
  } 
  
   if(GetObjectByTag("harmonium_scholarf") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmscholar03");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_scholarf", lSpawnpoint);    
  } 
  
   if(GetObjectByTag("harmonium_scholar") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmscholar02");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_scholar", lSpawnpoint);    
  } 
  
   if(GetObjectByTag("harmonium_scholar") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_harmscholar01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_scholar", lSpawnpoint);    
  } 
  
  SetGlobalInt("HarmoniumEnterLock", 0);
 }
}