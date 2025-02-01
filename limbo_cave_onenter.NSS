#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Limbo";
 	string sDescrip = "The ground shakes, and closes in around you. Despite having a solid surface under your feet, you have the feeling that this place is far from permanent.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
 
 	int iLock = PS_GetGlobalInt("Limbo_Cavelock");
	if ( iLock == 0 )
	{
		  PS_SetGlobalInt("Limbo_Cavelock", 1); // Only allows one clean up at a time.
		
		  if(GetObjectByTag("limbo_cave") == OBJECT_INVALID)
		  {
			   object oWP = GetWaypointByTag("wp_limbo_cave");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "limbo_cave", lSpawnpoint);    
		  }
		  
		  PS_SetGlobalInt("Limbo_Cavelock", 0);
	}
}