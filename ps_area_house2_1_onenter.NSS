#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("H11EnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("H11EnterLock", 1); // Only allows one clean up at a time.


  if(GetObjectByTag("ps_npc_ulbart") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ulbart");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ulbart", lSpawnpoint);    
  }


  PS_SetGlobalInt("H11EnterLock", 0);
 }
}