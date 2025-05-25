


void main()
{

 int iLock = GetGlobalInt("GymnasiumHallEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("GymnasiumHallEnterLock", 1); // Only allows one clean up at a time.

  //Merchant?
  if(GetObjectByTag("ps_npc_gymnasiumvaron") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_gym_varon");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumvaron", lSpawnpoint);    
  }  

  //Master of the Heart
  if(GetObjectByTag("ps_npc_gymnasiumteacher2") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_npc_gymnasiumteacher2");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumteacher2", lSpawnpoint);    
  }  

  //Zahra
  if(GetObjectByTag("ps_npc_gymnasiumzahra") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_npc_gymnasiumzahra");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumzahra", lSpawnpoint);    
  }  

  //Acolytes
  if(GetObjectByTag("ps_npc_gymnasiumacolyte3") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_npc_gymnasiumacolyte3");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumacolyte3", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_gymnasiumacolyte4") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_npc_gymnasiumacolyte4");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumacolyte4", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_gymnasiumacolyte5") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_npc_gymnasiumacolyte5");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumacolyte5", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_npc_gymnasiumacolyte6") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_npc_gymnasiumacolyte6");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumacolyte6", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_gymnasiumacolyte7") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_npc_gymnasiumacolyte7");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumacolyte7", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_gymnasiumeats") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_npc_gymnasiumeats");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumeats", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_gymnasiumcook") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_npc_gymnasiumcook");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumcook", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_gym_insideguard1") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_gym_insideguard1");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumguardf", lSpawnpoint, FALSE, "ps_gym_insideguard1");    
  }
  
  if(GetObjectByTag("ps_gym_insideguard2") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_gym_insideguard2");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumguardm", lSpawnpoint, FALSE, "ps_gym_insideguard2");    
  }
  
  if(GetObjectByTag("ps_gym_insideguard3") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_gym_insideguard3");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumguardf", lSpawnpoint, FALSE, "ps_gym_insideguard3");    
  }
  
  SetGlobalInt("GymnasiumHallEnterLock", 0);
 }
}