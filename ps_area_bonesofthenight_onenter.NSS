#include "ff_safevar"

void main() {
 object oPC = GetEnteringObject();
  
 int iLock = PS_GetGlobalInt("BonesNightLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("BonesNightLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_low_bonespatron1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_low_bonespatron1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_low_bonespatron1", lSpawnpoint);    
  }   
  
  if(GetObjectByTag("ps_low_bonespatron2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_low_bonespatron2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_low_bonespatron2", lSpawnpoint);    
  }    

  if(GetObjectByTag("ps_low_boneslothar") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_low_boneslothar");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_low_boneslothar", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_low_bonesassistant") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_low_bonesassistant");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_low_bonesassistant", lSpawnpoint);    
  }  
  
  PS_SetGlobalInt("BonesNightLock", 0);
 }
}