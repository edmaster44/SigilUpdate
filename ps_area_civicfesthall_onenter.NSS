
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("CivicEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("CivicEnterLock", 1); // Only allows one clean up at a time.

  //Item Cloner Guy
  if(GetObjectByTag("festhallnpc_itemcloner") == OBJECT_INVALID) {
	object oWP = GetWaypointByTag("wp_festhallnpc_itemcloner");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_itemcloner", lSpawnpoint);    
  }
  
  //Cionell
  if(GetObjectByTag("festhallnpc_civicmerchant") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_civicmerchant");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_civicmerchant", lSpawnpoint);    
  }
    
  //Spice Rack barkeep - Tasha
  if(GetObjectByTag("festhallnpc_tasha") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_tasha");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_tasha", lSpawnpoint);    
  } 
  
  //Spice Rack barkeep - Mishka
  if(GetObjectByTag("festhallnpc_mishka") == OBJECT_INVALID) {
   object oWP = GetWaypointByTag("wp_festhallnpc_mishka");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_mishka", lSpawnpoint);    
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
  
  //festhallnpc_annaliwebspinner
  if(GetObjectByTag("festhallnpc_annaliwebspinner") == OBJECT_INVALID) {
   //Faction greeter; non-mobile
   object oWP = GetWaypointByTag("wp_festhallnpc_annaliwebspinner");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_annaliwebspinner", lSpawnpoint);    
  } 
  
  SetGlobalInt("CivicEnterLock", 0);
 }
}