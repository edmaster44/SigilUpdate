
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("HallofInformationLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("HallofInformationLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_foul_kobold") == OBJECT_INVALID) {
		object oWP = GetWaypointByTag("wp_npc_foul_kobold");
		location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_kobold", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_npc_thoughttaker") == OBJECT_INVALID) {
		object oWP = GetWaypointByTag("wp_npc_thoughttaker");
		location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_thoughttaker", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_juwete") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_hoi_juwete");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_juwete", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_zuzka") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_hoi_zuzka");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_zuzka", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_saphron") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_hoi_saphron");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_saphron", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_clericoffice1") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_hoi_clericoffice1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_clericoffice1", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_clericoffice2") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_hoi_clericoffice2");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_clericoffice2", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_djinn1") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_hoi_djinn1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_djinn1", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_djinn2") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_hoi_djinn2");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_djinn2", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_gunnarsmoon") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_hoi_gunnarsmoon");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_gunnarsmoon", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_portalregistrar") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_hoi_portalregistrar");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_portalregistrar", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_steward") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_hoi_steward");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_steward", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_factionaltest") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("mapnote-factionalmimir");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_factionaltest", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_hoi_bouncer1") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_hoi_bouncer1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_mkbouncerf", lSpawnpoint, FALSE, "ps_hoi_bouncer1");   
	   oWP = GetWaypointByTag("wp_hoi_bouncer2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_mkbouncerm", lSpawnpoint, FALSE, "ps_hoi_bouncer2"); 
	   oWP = GetWaypointByTag("wp_hoi_bouncer3");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_mkbouncerf", lSpawnpoint, FALSE, "ps_hoi_bouncer3"); 
	   oWP = GetWaypointByTag("wp_hoi_bouncer4");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hoi_mkbouncerm", lSpawnpoint, FALSE, "ps_hoi_bouncer4"); 
  }

  SetGlobalInt("HallofInformationLock", 0);
 }
}