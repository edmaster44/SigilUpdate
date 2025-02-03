
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("Mercykiller4Lock");
 if ( iLock == 0 )
 {
  SetGlobalInt("Mercykiller4Lock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_mkp4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawnwp_mercykillerwarden");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkp4", lSpawnpoint);    
  }
 
    if(GetObjectByTag("ps_npc_mkp3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawnwp_mercykillerwarden2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkp3", lSpawnpoint);    
  }

   
  SetGlobalInt("Mercykiller4Lock", 0);
 }
}