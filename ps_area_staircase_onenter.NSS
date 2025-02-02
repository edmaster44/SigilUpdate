#include "ff_safevar"


void DoSpawn(string sCreature, string sWP)
{
  if(GetObjectByTag(sCreature) == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag(sWP);
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, sCreature, lSpawnpoint);    
  }
  
}

void main()
{
 object oPC = GetEnteringObject();

 int iLock = PS_GetGlobalInt("StaircaseEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("StaircaseEnterLock", 1); // Only allows one clean up at a time.

  DoSpawn("scod_x_djinniplaneswalker", "wp_staircase_alij");
  DoSpawn("scod_x_movanicdevaplaneswalker", "wp_staircase_deva");
  DoSpawn("scod_x_hagplaneswalker", "wp_staircase_hag");
  DoSpawn("scod_x_genasiplaneswalker", "wp_staircase_genasi");
  DoSpawn("ps_c_duodronegatefixer", "wp_staircase_modron");
  DoSpawn("scod_x_cultist", "wp_staircase_cultist");
  DoSpawn("scod_x_githpwalker", "wp_staircase_githf");
  DoSpawn("scod_x_drowplaneswalker", "wp_staircase_drow");
  DoSpawn("scod_x_stairazer", "wp_staircase_azer");
 
   
  PS_SetGlobalInt("StaircaseEnterLock", 0);
 }
}