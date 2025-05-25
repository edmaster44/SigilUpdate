

#include "ps_inc_planarlocations"

void main()
{
	 object oPC = GetEnteringObject();
	 
	 string sPlane = "Mechanus";
 	 string sDescrip = "The grinding of gears creates a constant hum in the background. Occasionally there is a loud clank as something goes wrong. . .";
 	 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	 
	 int iLock = GetGlobalInt("MechFactoryEnterLock");
	 if ( iLock == 0 )
	 {
		  SetGlobalInt("MechFactoryEnterLock", 1); // Only allows one clean up at a time.
		
		  if(GetObjectByTag("ps_mech_inertmonodrone") == OBJECT_INVALID && GetObjectByTag("ps_mech_factorymonodrone") == OBJECT_INVALID && 
		  GetObjectByTag("ps_mech_attackingmonodrone") == OBJECT_INVALID && GetObjectByTag("ps_mech_inertduodrone") == OBJECT_INVALID && 
		  GetObjectByTag("ps_mech_factoryduodrone") == OBJECT_INVALID && GetObjectByTag("ps_mech_attackingduodrone") == OBJECT_INVALID) {
			   object oWP = GetWaypointByTag("wp_brokenmodron_01");
			   location lSpawnpoint = GetLocation(oWP);  
			   if (d100() < 20) {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertduodrone", lSpawnpoint);  
			   } else {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertmonodrone", lSpawnpoint);  
			   }
			   oWP = GetWaypointByTag("wp_brokenmodron_02");
			   lSpawnpoint = GetLocation(oWP);  
			   if (d100() < 20) {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertduodrone", lSpawnpoint);  
			   } else {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertmonodrone", lSpawnpoint);  
			   }
			   oWP = GetWaypointByTag("wp_brokenmodron_03");
			   lSpawnpoint = GetLocation(oWP);  
			   if (d100() < 20) {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertduodrone", lSpawnpoint);  
			   } else {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertmonodrone", lSpawnpoint);  
			   }
			   oWP = GetWaypointByTag("wp_brokenmodron_04");
			   lSpawnpoint = GetLocation(oWP);  
			   if (d100() < 20) {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertduodrone", lSpawnpoint);  
			   } else {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertmonodrone", lSpawnpoint);  
			   }
			   oWP = GetWaypointByTag("wp_brokenmodron_05");
			   lSpawnpoint = GetLocation(oWP);  
			   if (d100() < 20) {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertduodrone", lSpawnpoint);  
			   } else {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertmonodrone", lSpawnpoint);  
			   }
			   oWP = GetWaypointByTag("wp_brokenmodron_06");
			   lSpawnpoint = GetLocation(oWP);  
			   if (d100() < 20) {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertduodrone", lSpawnpoint);  
			   } else {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertmonodrone", lSpawnpoint);  
			   }
			   oWP = GetWaypointByTag("wp_brokenmodron_07");
			   lSpawnpoint = GetLocation(oWP);  
			   if (d100() < 20) {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertduodrone", lSpawnpoint);  
			   } else {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertmonodrone", lSpawnpoint);  
			   }
			   oWP = GetWaypointByTag("wp_brokenmodron_08");
			   lSpawnpoint = GetLocation(oWP);  
			   if (d100() < 20) {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertduodrone", lSpawnpoint);  
			   } else {
			   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mech_inertmonodrone", lSpawnpoint);  
			   }
		  }
		   
		  SetGlobalInt("MechFactoryEnterLock", 0);
	  
	 }
}