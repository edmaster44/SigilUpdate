#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Baator";
 	string sDescrip = "";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
  
	int iLock = PS_GetGlobalInt("MinaurosRPEnterLock");
 	if ( iLock == 0 ) {
 
  		PS_SetGlobalInt("MinaurosRPEnterLock", 1); // Only allows one clean up at a time.

		if(GetObjectByTag("ps_rpswampmonster") == OBJECT_INVALID) {
		
		   	object oWP = GetWaypointByTag("ps_npcwp_swampmonster_1");
		   	location lSpawnpoint = GetLocation(oWP);  
		   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_rpswampmonster", lSpawnpoint);    
		   	oWP = GetWaypointByTag("ps_npcwp_swampmonster_2");
		   	lSpawnpoint = GetLocation(oWP);  
		   	oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_rpswampmonster", lSpawnpoint);    
	  	}

		if(GetObjectByTag("ps_rpswamp_horneddevil") == OBJECT_INVALID) {
		
		   	object oWP = GetWaypointByTag("wp_rpswamp_horneddevil_1");
		   	location lSpawnpoint = GetLocation(oWP);  
		   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_rpswamp_horneddevil", lSpawnpoint);    
		   	oWP = GetWaypointByTag("wp_rpswamp_horneddevil_2");
		   	lSpawnpoint = GetLocation(oWP);  
		   	oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_rpswamp_horneddevil", lSpawnpoint);    
	  	}
    
  		PS_SetGlobalInt("MinaurosRPEnterLock", 0);
 	}
}