#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "City of Brass";
 	string sDescrip = "";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("FireBirdLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("FireBirdLock", 1); // Only allows one clean up at a time.
  if(GetObjectByTag("ps_fire_tiger") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_tiger", GetLocation(GetWaypointByTag("WP_ps_fire_tiger")));  
  }
  if(GetObjectByTag("ps_fire_wyvern") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_wyvern", GetLocation(GetWaypointByTag("WP_ps_fire_wyvern")));  
  }
  if(GetObjectByTag("ps_fire_azermusician") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azermusician", GetLocation(GetWaypointByTag("WP_ps_fire_azermusician")));  
  }
  if(GetObjectByTag("ps_fire_azermusician2") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azermusician2", GetLocation(GetWaypointByTag("WP_ps_fire_azermusician2")));  
  }
  if(GetObjectByTag("ps_fire_azermusician3") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azermusician3", GetLocation(GetWaypointByTag("WP_ps_fire_azermusician3")));  
  }
  if(GetObjectByTag("ps_fire_waitress1") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_waitress1", GetLocation(GetWaypointByTag("WP_ps_fire_waitress1")));  
  }
  if(GetObjectByTag("ps_fire_waitress3") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_waitress3", GetLocation(GetWaypointByTag("WP_ps_fire_waitress3")));  
  }
  if(GetObjectByTag("ps_fire_aerala") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_aerala", GetLocation(GetWaypointByTag("WP_ps_fire_aerala")));  
  }
  if(GetObjectByTag("ps_fire_cook") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_cook", GetLocation(GetWaypointByTag("WP_ps_fire_cook")));  
  }
  if(GetObjectByTag("ps_fire_azerdancer") == OBJECT_INVALID && GetObjectByTag("ps_fire_dancer") == OBJECT_INVALID)
  {
  		if (d100() < 50)
		{
			CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azerdancer", GetLocation(GetWaypointByTag("WP_ps_fire_azerdancer_A"))); 
			CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azerdancer", GetLocation(GetWaypointByTag("WP_ps_fire_azerdancer_B")));
			CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azerdancer", GetLocation(GetWaypointByTag("WP_ps_fire_azerdancer_C")));
			CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azerdancer", GetLocation(GetWaypointByTag("WP_ps_fire_azerdancer_D")));
		}
		else
		{
			CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_dancer", GetLocation(GetWaypointByTag("WP_ps_fire_azerdancer_A"))); 
			CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_dancer", GetLocation(GetWaypointByTag("WP_ps_fire_azerdancer_D")));	
		}
  }
  
  SetGlobalInt("FireBirdLock", 0);
 }
}