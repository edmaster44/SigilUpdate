#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Astral";
 string sDescrip = "You are on an island in the middle of a great endless expanse of silvery-blue sky. Large tube-shaped clouds slowly coil into the distance, with the occasional rock or whirlpool of color spinning through the void. Ships come and go from the docks of this town, but it is otherwise eerily silent.";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("DeadGodLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("DeadGodLock", 1); // Only allows one clean up at a time.
  if(GetObjectByTag("astral_reaver") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "astral_reaver", GetLocation(GetWaypointByTag("wp_astralreaver_spawn1")));  
	CreateObject(OBJECT_TYPE_CREATURE, "astral_reaver", GetLocation(GetWaypointByTag("wp_astralreaver_spawn2")));  
	CreateObject(OBJECT_TYPE_CREATURE, "astral_reaver", GetLocation(GetWaypointByTag("wp_astralreaver_spawn3")));  
	CreateObject(OBJECT_TYPE_CREATURE, "astral_reaver", GetLocation(GetWaypointByTag("wp_astralreaver_spawn4")));  
	CreateObject(OBJECT_TYPE_CREATURE, "astral_reaver", GetLocation(GetWaypointByTag("wp_astralreaver_spawn5")));  
	CreateObject(OBJECT_TYPE_CREATURE, "astral_reaver", GetLocation(GetWaypointByTag("wp_astralreaver_spawn6")));  
  }
  
  PS_SetGlobalInt("DeadGodLock", 0);
 }
}