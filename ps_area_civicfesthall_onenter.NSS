
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("CivicEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("CivicEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("npc_itemcloner") == OBJECT_INVALID)
  {
   //Change Room Merchant; non-motile
   object oWP = GetWaypointByTag("wp_civic_cloner");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_itemcloner", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_civicmerchant") == OBJECT_INVALID)
  {
   //Change Room Merchant; non-motile
   object oWP = GetWaypointByTag("wp_civic_cionell");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_civicmerchant", lSpawnpoint);    
  }
 
  if(GetObjectByTag("lyria") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_civic_lyria");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "lyria", lSpawnpoint);    
  }
  
  if(GetObjectByTag("filos") == OBJECT_INVALID)
  {
   //Non-motile NPC
   object oWP = GetWaypointByTag("wp_civic_filos");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "filos", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_sens_com1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_civic_amethyst");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_sens_com2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_civic_com2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com2", lSpawnpoint);    
  }  
 
  if(GetObjectByTag("ps_npc_sens_com3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sensate3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com3", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_npc_sens_com4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sensate4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com4", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_npc_sens_com5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sensate5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com5", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_npc_sens_com6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sensate6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com6", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_npc_sens_com7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sensate7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com7", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_npc_sens_com8") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sensate8");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com8", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_npc_sens_com9") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sensate9");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com9", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_npc_sens_com10") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sensate10");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sens_com10", lSpawnpoint);    
  } 
   
  if(GetObjectByTag("Iceander") == OBJECT_INVALID)
  {
   //non-motile NPC
   object oWP = GetWaypointByTag("ps_wp_sensate11");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "Iceander", lSpawnpoint);    
  } 
    
  if(GetObjectByTag("lilya") == OBJECT_INVALID)
  {
   //non-motile NPC
   object oWP = GetWaypointByTag("ps_wp_sensate12");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "lilya", lSpawnpoint);    
  } 
    
  if(GetObjectByTag("tasha") == OBJECT_INVALID)
  {
   //Spike Rack Bartender; non-motile
   object oWP = GetWaypointByTag("wp_tasha");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "tasha", lSpawnpoint);    
  } 
  
  //festhallnpc_mishka
  if(GetObjectByTag("festhallnpc_mishka") == OBJECT_INVALID)
  {
   //Spike Rack Bartender; non-motile
   object oWP = GetWaypointByTag("wp_festhallnpc_mishka");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_mishka", lSpawnpoint);    
  } 
  
  //festhallnpc_GroundlevelGuardM
  if(GetObjectByTag("festhallnpc_GroundlevelGuardM") == OBJECT_INVALID)
  {
   //Spike Rack Bartender; non-motile
   object oWP = GetWaypointByTag("wp_festhallnpc_GroundlevelGuardM");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_GroundlevelGuardM", lSpawnpoint);    
  } 
  
  //festhallnpc_sensatef2
  if(GetObjectByTag("festhallnpc_sensatef2") == OBJECT_INVALID)
  {
   //Spike Rack Bartender; non-motile
   object oWP = GetWaypointByTag("wp_festhallnpc_sensatef2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_sensatef2", lSpawnpoint);    
  } 
  
  SetGlobalInt("CivicEnterLock", 0);
 }
}