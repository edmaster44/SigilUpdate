


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("Mercykiller3Lock");
 if ( iLock == 0 )
 {
  SetGlobalInt("Mercykiller3Lock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_arwyl") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawnwp_arwyl");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_arwyl", lSpawnpoint);    
  }
 
    if(GetObjectByTag("ps_npc_mkm01") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawnwp_mercykiller1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkm01", lSpawnpoint);    
  }
 
    if(GetObjectByTag("ps_npc_mkm02") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawnwp_mercykiller2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkm02", lSpawnpoint);    
  }
 
    if(GetObjectByTag("ps_npc_mkf01") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawnwp_mercykiller3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkf01", lSpawnpoint);    
  }
 
    if(GetObjectByTag("ps_npc_mkbeholder") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawnwp_beholder");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkbeholder", lSpawnpoint);    
  }
   
  SetGlobalInt("Mercykiller3Lock", 0);
 }
}