#include "ps_inc_planarlocations"

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
 
	 string sPlane = "Mechanus";
 	 string sDescrip = "A crisp white light illuminates a land of giant spinning cogs and gears, as far as the eye can see. The larger cogs support land and buildings on their surfaces.";
 	 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));

	 int iLock = GetGlobalInt("MechanusEnterLock");
	 if ( iLock == 0 )
	 {
	  SetGlobalInt("MechanusEnterLock", 1); // Only allows one clean up at a time.
	
	  DoSpawn("ps_mechanus_3of22", "wp_mechanus_3of22");
	  DoSpawn("ps_mechanus_guvner", "wp_ps_mechanus_guvner");
	  DoSpawn("ps_mechanus_threebyfive", "wp_ps_mechanus_threebyfive");
	   
	  SetGlobalInt("MechanusEnterLock", 0);
	 }
}