

#include "ps_inc_planarlocations"
void main()
{
	 object oPC = GetEnteringObject();
	 
	 string sPlane = "Pandemonium";
 	 string sDescrip = "Occasionally the tight passages open out into large caverns. Here the sound of the wind is less oppressive, replaced by the sound of dripping water. The wind is still strong, however, threatening to throw you off of the narrow pathways. With a little light, you can make out shapes moving at the edge of sight.";
 	 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	 
	 int iLock = GetGlobalInt("PanChasmEnterLock");
	 if ( iLock == 0 )
	 {
		  SetGlobalInt("PanChasmEnterLock", 1); // Only allows one clean up at a time.
		  
		  /*if(GetObjectByTag("ps_pan_malla") == OBJECT_INVALID) {
		  	   object oWP = GetWaypointByTag("wp_ps_pan_malla");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_pan_malla", lSpawnpoint);  		   
		  }*/
		  
		  if(GetObjectByTag("ps_pandemonium_monster") == OBJECT_INVALID) {
			   object oWP = GetWaypointByTag("WP_c_seamonster_01");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_pandemonium_monster", lSpawnpoint);  
			   
			   oWP = GetWaypointByTag("WP_c_seamonster_02");
			   lSpawnpoint = GetLocation(oWP);  
			   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_pandemonium_monster", lSpawnpoint);  
			   
			   oWP = GetWaypointByTag("WP_c_seamonster_03");
			   lSpawnpoint = GetLocation(oWP);  
			   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_pandemonium_monster", lSpawnpoint);  
			   
			   oWP = GetWaypointByTag("WP_c_seamonster_04");
			   lSpawnpoint = GetLocation(oWP);  
			   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_pandemonium_monster", lSpawnpoint);  
			   
			   oWP = GetWaypointByTag("WP_c_seamonster_05");
			   lSpawnpoint = GetLocation(oWP);  
			   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_pandemonium_monster", lSpawnpoint);  
			   
			   oWP = GetWaypointByTag("WP_c_seamonster_06");
			   lSpawnpoint = GetLocation(oWP);  
			   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_pandemonium_monster", lSpawnpoint); 
			   
			   oWP = GetWaypointByTag("WP_c_seamonster_07");
			   lSpawnpoint = GetLocation(oWP);  
			   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_pandemonium_monster", lSpawnpoint);   
		  }
		   
		  SetGlobalInt("PanChasmEnterLock", 0);
	  
	 }
}