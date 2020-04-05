
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("SigilEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("SigilEnterLock", 1); // Only allows one clean up at a time.
  
  if(GetObjectByTag("ps_npc_ulbart") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sigport_02ex");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ulbart", lSpawnpoint);    
  }
  
  if(GetObjectByTag("sarah") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sigil_sarah");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "sarah", lSpawnpoint);    
  }

  if(GetObjectByTag("graydon") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sigil_graydon");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "graydon", lSpawnpoint);    
  }
  
  if(GetObjectByTag("toby") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sigil_toby");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "toby", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_dabus2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_dabusspawnpoint2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_dabus2", lSpawnpoint);    
  }
  
  //gamblers
  if(GetObjectByTag("ps_npc_gambler1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_gambler1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gambler1", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_npc_gambler2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_gambler2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gambler2", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_npc_gambler3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_gambler3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gambler3", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_npc_gambler4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_gambler4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gambler4", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_eloise") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npceloise");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_eloise", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_npc_sigcommoner23") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sigilmaincommoner23");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sigcommoner23", lSpawnpoint);    
  } 

  if(GetObjectByTag("ps_npc_daisy") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_daisy");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_daisy", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_commoner14") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sigil_commoner14");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_commoner14", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_commoner9") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sigil_commoner9");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_commoner9", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_c_harmoniumpatrolguard2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_clerksward_guard");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard2", lSpawnpoint);  
  }
  
  //CAMPAIGN
  //Harmonium guards
  if(GetObjectByTag("ps_cw_campaign_harmonium") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_cw_campaign_harmonium1");
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard2", GetLocation(oWP), FALSE, "ps_cw_campaign_harmonium"); 
   oWP = GetWaypointByTag("wp_cw_campaign_harmonium2");
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard2", GetLocation(oWP), FALSE, "ps_cw_campaign_harmonium");
   oWP = GetWaypointByTag("wp_cw_campaign_harmonium3");
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard2", GetLocation(oWP), FALSE, "ps_cw_campaign_harmonium"); 
  }

  if(GetObjectByTag("ps_npc_clerkspeddler") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_npc_clerkspeddler");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_clerkspeddler", lSpawnpoint);    
  }
  
  SetGlobalInt("SigilEnterLock", 0);
 }
}