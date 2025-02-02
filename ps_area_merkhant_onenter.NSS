#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("MerkhantEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("MerkhantEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_merkh_rootofnine") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawn_rootofnine");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_merkh_rootofnine", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_merkh_teamster1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawn_teamster1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_merkh_teamster1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_merkh_teamster2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawn_teamster2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_merkh_teamster2", lSpawnpoint);    
  }

  PS_SetGlobalInt("MerkhantEnterLock", 0);
 }
}