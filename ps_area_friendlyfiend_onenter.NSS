#include "ff_safevar"

void main()
{
 object oPC = GetEnteringObject();
 
 int iLock = PS_GetGlobalInt("FriendlyFiendLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("FriendlyFiendLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("scod_akin") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scod_akin");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "scod_akin", lSpawnpoint);    
  }
   
  PS_SetGlobalInt("FriendlyFiendLock", 0);
 }
}