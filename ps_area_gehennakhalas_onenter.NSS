#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
 	string sPlane = "Gehenna";
 	string sDescrip = "You step out onto a steep mountain side that goes on for as far as the eye can see. There is very little flat ground, and most of the rocks are slick with water from the nearby falls. There's a faint red glow about everything, and you occasionally detect a foul odor wafting by.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
  
 	int iLock = PS_GetGlobalInt("GehennaKhalasEnterLock");
 	if ( iLock == 0 ) {
 
		PS_SetGlobalInt("GehennaKhalasEnterLock", 1); // Only allows one clean up at a time.
		
	  	if(GetObjectByTag("ps_gehenna_petitioner_cage1") == OBJECT_INVALID) {
	  		CreateObject(OBJECT_TYPE_CREATURE, "ps_gehenna_petitioner_cage1", GetLocation(GetWaypointByTag("wp_gehenna_petitioner1")));	
	  	} 
	  	if(GetObjectByTag("ps_gehenna_petitioner_cage2") == OBJECT_INVALID) {
	  		CreateObject(OBJECT_TYPE_CREATURE, "ps_gehenna_petitioner_cage2", GetLocation(GetWaypointByTag("wp_gehenna_petitioner2")));	
	  	} 
	  	if(GetObjectByTag("ps_gehenna_beetle") == OBJECT_INVALID) {
	  		CreateObject(OBJECT_TYPE_CREATURE, "ps_gehenna_beetle", GetLocation(GetWaypointByTag("wp_gehenna_beetle")));	
	  	} 
	  	if(GetObjectByTag("ps_gehenna_mezzoguard") == OBJECT_INVALID) {
	  		CreateObject(OBJECT_TYPE_CREATURE, "ps_gehenna_mezzoguard", GetLocation(GetWaypointByTag("wp_gehenna_guard1")));
	  		CreateObject(OBJECT_TYPE_CREATURE, "ps_gehenna_mezzoguard", GetLocation(GetWaypointByTag("wp_gehenna_guard2")));	
	  	} 
	                              
	  	PS_SetGlobalInt("GehennaKhalasEnterLock", 0);
 	}
}