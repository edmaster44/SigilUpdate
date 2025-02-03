#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
 	string sPlane = "Gehenna";
 	string sDescrip = "A stench assaults your nose as you step into the dimly-lit caverns - the smell of rot. The ground is warm to the touch, and every so often you feel a tremor surge through the caverns, like a far off earthquake.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
  
 	int iLock = GetGlobalInt("GehennaCavesEnterLock");
 	if ( iLock == 0 ) {
 
		SetGlobalInt("GehennaCavesEnterLock", 1); // Only allows one clean up at a time.
	  	if(GetObjectByTag("ps_gehenna_mezzolothshop") == OBJECT_INVALID) {
	  		CreateObject(OBJECT_TYPE_CREATURE, "ps_gehenna_mezzolothshop", GetLocation(GetWaypointByTag("wp_gehenna_mezzolothshop")));	
	  	} 
	                              
	  	SetGlobalInt("GehennaCavesEnterLock", 0);
 	}
}