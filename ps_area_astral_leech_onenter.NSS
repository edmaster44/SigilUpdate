#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Astral";
 string sDescrip = "";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("LeechEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("LeechEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("astral_leech_ghyris") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_astral_ghyris");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "astral_leech_ghyris", lSpawnpoint);    
  }

  if(GetObjectByTag("astral_leech_rak1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_astral_rak1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "astral_leech_rak1", lSpawnpoint);    
  }

  if(GetObjectByTag("astral_leech_rak2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_astral_rak2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "astral_leech_rak2", lSpawnpoint);    
  }

  SetGlobalInt("LeechEnterLock", 0);
 }
}