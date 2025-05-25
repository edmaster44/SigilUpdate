


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("Mercykiller2Lock");
 if ( iLock == 0 )
 {
  SetGlobalInt("Mercykiller2Lock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_mkfy1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_mercykillergrounds-female");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkfy1", lSpawnpoint);    
  }
 
    if(GetObjectByTag("ps_npc_mkpbs") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_mercykillergrounds-smith");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkpbs", lSpawnpoint);    
  }
 
    if(GetObjectByTag("ps_npc_mkmy1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_mercykillergrounds-male");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkmy1", lSpawnpoint);    
  }
 
    if(GetObjectByTag("mkspotlight1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_mercykillergrounds-sl1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mkspotlight1", lSpawnpoint);    
  }
 
    if(GetObjectByTag("mkspotlight2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_mercykillergrounds-sl2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mkspotlight2", lSpawnpoint);    
  }
 
   
  SetGlobalInt("Mercykiller2Lock", 0);
 }
}