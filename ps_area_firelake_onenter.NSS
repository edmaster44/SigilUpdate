#include "enft_startengine"
#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Elemental Plane of Fire";
 	string sDescrip = "The metal barge floats through the lake of fire; you can feel the heat of the floor radiating through your boots. The ship burns to the touch.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	if (GetIsPC(oPC))
		startEngine(oPC);
		
 	int iLock = GetGlobalInt("FireLakeLock");
 	if ( iLock == 0 )
 	{
  		SetGlobalInt("FireLakeLock", 1); // Only allows one clean up at a time.
  		if(GetObjectByTag("ps_fire_pilot") == OBJECT_INVALID)
  		{
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_pilot", GetLocation(GetWaypointByTag("WP_ps_fire_pilot")));  
  		}
 	 	if(GetObjectByTag("ps_fire_lookout") == OBJECT_INVALID)
  		{
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_fire_lookout", GetLocation(GetWaypointByTag("WP_ps_fire_lookout")));  
  		}
  		SetGlobalInt("FireLakeLock", 0);
 	}
}