#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("GBEnterLock1");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("GBEnterLock1", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_gb_goldenmane") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_goldenmane");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_goldenmane", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_luwe") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_luwe");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_luwe", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_tinvenel") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_tinvenel");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_tinvenel", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_fateless") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_fateless");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_fateless", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_gotthold") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_gotthold");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_gotthold", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_ulda") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_ulda");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_ulda", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_meri") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_meri");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_meri", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_giovannino") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_giovannino");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_giovannino", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_layma") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_layma");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_layma", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_pierre") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_pierre");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_pierre", lSpawnpoint);    
  }
  
  PS_SetGlobalInt("GBEnterLock1", 0);
 }
}