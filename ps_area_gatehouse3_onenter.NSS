#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("Gatehouse3Lock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("Gatehouse3Lock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ghrollk") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghrollk");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ghrollk", lSpawnpoint);    
  }
 
  if(GetObjectByTag("gh_darius") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gh_darius");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "gh_darius", lSpawnpoint);    
  }

  if(GetObjectByTag("ghbleakergen1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghbleakergen1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ghbleakergen1", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ghbleakergen2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghbleakergen2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ghbleakergen2", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ghbleakergen3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghbleakergen3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ghbleakergen3", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ghpoor1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghpoor1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ghpoor1", lSpawnpoint);    
  }

  if(GetObjectByTag("ghpoor2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghpoor2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ghpoor2", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ghpoor3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghpoor3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ghpoor3", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ghpoor4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghpoor4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ghpoor4", lSpawnpoint);    
  }
     
   
  PS_SetGlobalInt("Gatehouse3Lock", 0);
 }
}