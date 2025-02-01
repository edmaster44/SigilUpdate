#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("GreengageEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("GreengageEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_marda") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_marda");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_marda", lSpawnpoint);    
  }
   
  PS_SetGlobalInt("GreengageEnterLock", 0);
 }
}