
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("HouseofhealingEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("GreengageEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_houseofhealing01") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_ps_npc_houseofhealing01_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_houseofhealing01", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_houseofhealing02") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_ps_npc_houseofhealing02_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_houseofhealing02", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_houseofhealing03") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_ps_npc_houseofhealing03_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_houseofhealing03", lSpawnpoint);    
  }
   
  SetGlobalInt("HouseofhealingEnterLock", 0);
 }
}