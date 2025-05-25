

#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Limbo";
 	string sDescrip = "Stinging rain pours from the sky, and the wind whips up the waves around a beleaguered series of islands, as pockets of water and air violently come together. A flash of lightning reveals a battle up ahead; but the noise of the conflict is drowned out by the storm.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
 	int iLock = GetGlobalInt("Limbo_Stormlock");
	if ( iLock == 0 )
	{
		  SetGlobalInt("Limbo_Stormlock", 1); // Only allows one clean up at a time.
		
		  if(GetObjectByTag("limbo_lightning") == OBJECT_INVALID)
		  {
			   object oWP = GetWaypointByTag("wp_limbo_lightning");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "limbo_lightning", lSpawnpoint);    
		  }
		  
		  SetGlobalInt("Limbo_Stormlock", 0);
	}
}