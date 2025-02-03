#include "nw_i0_plot"

void main () {

	object oPC = GetEnteringObject();

	int iLock = GetGlobalInt("ChirpersEnterLock");
	if ( iLock == 0 )
	{
		SetGlobalInt("ChirpersEnterLock", 1); // Only allows one clean up at a time.
		
		//General / Permanent NPCs
		if(GetObjectByTag("ps_chirpers_hostess_up") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_hostess_up");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_hostess_up", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_waitress") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_waitress");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_waitress", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_cook") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_cook");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_cook", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_barber") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_barber");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_barber", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_bartender") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_bartender");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_bartender", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_werewolf") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_werewolf");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_werewolf", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_flowers") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_flowers");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_flowers", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_hostess") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_hostess");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_hostess", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_gnoll") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_gnoll");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_gnoll", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_suruax") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_suruax");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_suruax", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_indepbarkeep") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_indepbarkeep");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_indepbarkeep", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_npc_foul_commoner3") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_npc_foul_commoner3");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_commoner3", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_npc_foul_commoner1") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_npc_foul_commoner1");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_commoner1", lSpawnpoint);    
		}
		
		//Pets / crystal thingies
		if(GetObjectByTag("ps_chirpers_tiger") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_tiger");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_tiger", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_eyewing") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_eyewing");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_eyewing", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_ashbat") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_ashbat");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_ashbat", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_masterofceremonies") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_masterofceremonies");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_masterofceremonies", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_chirpers_wererat") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_wererat");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_wererat", lSpawnpoint);    
		}
		
		//Bouncers
		if(GetObjectByTag("ps_chirpers_mkbouncerm_1") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_mkbouncer_1");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_mkbouncerm", lSpawnpoint, FALSE, "ps_chirpers_mkbouncerm_1");  
		   oWP = GetWaypointByTag("wp_chirpers_mkbouncer_2");
		   lSpawnpoint = GetLocation(oWP);  
		   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_mkbouncerm", lSpawnpoint, FALSE, "ps_chirpers_mkbouncerm_2");    
		   oWP = GetWaypointByTag("wp_chirpers_mkbouncer_3");
		   lSpawnpoint = GetLocation(oWP);  
		   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_mkbouncerm", lSpawnpoint, FALSE, "ps_chirpers_mkbouncerm_3");  
		   oWP = GetWaypointByTag("wp_chirpers_mkbouncer_4");
		   lSpawnpoint = GetLocation(oWP);  
		   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_mkbouncerm", lSpawnpoint, FALSE, "ps_chirpers_mkbouncerm_4"); 
		}
		
		object oSign1 = GetNearestObjectByTag("chirpers_sign_1");
		object oSign2 = GetNearestObjectByTag("chirpers_sign_2");
		//Entertainers
		if(GetObjectByTag("ps_chripers_entertainer1") == OBJECT_INVALID && GetLocalInt(oSign1, "entertainersOff") <= 0) {
			object oWP1 = GetWaypointByTag("wp_chirpers_entertainer1");
			object oWP2 = GetWaypointByTag("wp_chirpers_entertainer2");
			object oWP3 = GetWaypointByTag("wp_chirpers_entertainer3");
			
			int nRand = d100();
			if (nRand < 25) {
				//ps_chirpers_modrona
				object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_modrona", GetLocation(oWP1), FALSE, "ps_chripers_entertainer1");
				oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_modronb", GetLocation(oWP2), FALSE, "ps_chripers_entertainer2");
			} else if (nRand < 50) {
				//ps_chirpers_dancingswan
				object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_dancingswan", GetLocation(oWP1), FALSE, "ps_chripers_entertainer1");
				oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_dancingswan", GetLocation(oWP2), FALSE, "ps_chripers_entertainer2");
			} else if (nRand < 75) {
				//ps_chirpers_dancingswan
				object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_grapp1", GetLocation(oWP1), FALSE, "ps_chripers_entertainer1");
				oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_grapp2", GetLocation(oWP2), FALSE, "ps_chripers_entertainer2");
			} else {
				//ps_chirpers_dancingswan
				object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_protrix", GetLocation(oWP3), FALSE, "ps_chripers_entertainer1");
			}
		}
	}
	SetGlobalInt("ChirpersEnterLock", 0);
}