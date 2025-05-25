

#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "City of Brass";
 	string sDescrip = "The city is the temperature of a hot summer day on the primes - a pleasant respite from the terrible heat of the rest of the plane. The will of the sultan keeps the city 'cool' for the sake of visitors.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("BrassLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("BrassLock", 1); // Only allows one clean up at a time.
  if(GetObjectByTag("ps_fire_efreetiguard") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_efreetiguard", GetLocation(GetWaypointByTag("WP_ps_fire_efreetiguard_A")));  
	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_efreetiguard", GetLocation(GetWaypointByTag("WP_ps_fire_efreetiguard_B")));  
	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_efreetiguard", GetLocation(GetWaypointByTag("WP_ps_fire_efreetiguard_C")));  
	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_efreetiguard", GetLocation(GetWaypointByTag("WP_ps_fire_efreetiguard_D")));  
	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_efreetiguard", GetLocation(GetWaypointByTag("WP_ps_fire_efreetiguard_E"))); 
  }
  if (GetObjectByTag("ps_fire_azerdockworker") == OBJECT_INVALID)//wp_ps_fire_azerdockworker_B
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azerdockworker", GetLocation(GetWaypointByTag("wp_ps_fire_azerdockworker_A")));  
	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azerdockworker", GetLocation(GetWaypointByTag("wp_ps_fire_azerdockworker_B")));  
  }
  if(GetObjectByTag("ps_fire_spicemerchant") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_spicemerchant", GetLocation(GetWaypointByTag("WP_ps_fire_spicemerchant")));  
  }
  if(GetObjectByTag("ps_fire_firegiantf") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_firegiantf", GetLocation(GetWaypointByTag("WP_ps_fire_firegiantf")));  
  }
  if(GetObjectByTag("ps_fire_haraknin") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_haraknin", GetLocation(GetWaypointByTag("WP_ps_fire_haraknin")));  
  }
 /* if(GetObjectByTag("ps_fire_fireweird") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_fireweird", GetLocation(GetWaypointByTag("WP_ps_fire_fireweird")));  
  }*/
  if(GetObjectByTag("ps_fire_waitress2") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_waitress2", GetLocation(GetWaypointByTag("WP_ps_fire_waitress2_A")));  
  }
  if(GetObjectByTag("ps_fire_efreeticaptain") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_efreeticaptain", GetLocation(GetWaypointByTag("WP_ps_fire_efreeticaptain")));  
  }
  if(GetObjectByTag("ps_fire_flamingarmor") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_flamingarmor", GetLocation(GetWaypointByTag("WP_ps_fire_flamingarmor_A"))); 
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_flamingarmor", GetLocation(GetWaypointByTag("WP_ps_fire_flamingarmor_B"))); 
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_flamingarmor", GetLocation(GetWaypointByTag("WP_ps_fire_flamingarmor_C")));  
  }
  if(GetObjectByTag("ps_fire_smith") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_smith", GetLocation(GetWaypointByTag("WP_ps_fire_smith")));  
  }
  if(GetObjectByTag("ps_fire_genasi1") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_genasi1", GetLocation(GetWaypointByTag("WP_ps_fire_genasi1")));  
  }
  if(GetObjectByTag("ps_fire_genasi2") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_genasi2", GetLocation(GetWaypointByTag("WP_ps_fire_genasi2")));  
  }
  if(GetObjectByTag("ps_fire_genasi3") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_genasi3", GetLocation(GetWaypointByTag("WP_ps_fire_genasi3")));  
  }
  if(GetObjectByTag("ps_fire_genasi4") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_genasi4", GetLocation(GetWaypointByTag("WP_ps_fire_genasi4")));  
  }
  if(GetObjectByTag("ps_fire_slaver") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_slaver", GetLocation(GetWaypointByTag("WP_ps_fire_slaver_A")));  
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_slaver", GetLocation(GetWaypointByTag("WP_ps_fire_slaver_B")));  
  }
  if(GetObjectByTag("ps_fire_salamanderslaver") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_salamanderslaver", GetLocation(GetWaypointByTag("WP_ps_fire_salamanderslaver")));  
  }
  if(GetObjectByTag("ps_fire_azercommoner") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azercommoner", GetLocation(GetWaypointByTag("WP_ps_fire_azercommoner")));  
  }
  if(GetObjectByTag("ps_fire_azercommonerf") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_azercommonerf", GetLocation(GetWaypointByTag("WP_ps_fire_azercommonerf")));  
  }
  
  SetGlobalInt("BrassLock", 0);
 }
}