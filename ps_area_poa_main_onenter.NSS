#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	
	string sPlane = "Elemental Plane of Air";
 	string sDescrip = "";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	  
	int iLock = PS_GetGlobalInt("PoAEnterLock");
	
	if ( iLock == 0 ) {
	
	  	PS_SetGlobalInt("PoAEnterLock", 1); 
	  	// Only allows one clean up at a time.

	  	if(GetObjectByTag("poa_npc01") == OBJECT_INVALID)
	  	{
		   object oWP = GetWaypointByTag("wp_poa_npc01");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "poa_npc01", lSpawnpoint);    
	  	}
	 
	  	if(GetObjectByTag("poa_npc02") == OBJECT_INVALID)
	  	{
		   object oWP = GetWaypointByTag("wp_poa_npc02");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "poa_npc02", lSpawnpoint);    
	  	}
	  
 		if(GetObjectByTag("poa_npc03") == OBJECT_INVALID)
	  	{
		   object oWP = GetWaypointByTag("WP_poa_npc03_01");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "poa_npc03", lSpawnpoint);    
	  	}
	  
	  	if(GetObjectByTag("poa_npc04") == OBJECT_INVALID)
	  	{
		   object oWP = GetWaypointByTag("wp_poa_npc04");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "poa_npc04", lSpawnpoint);    
	  	}
		
	   	if(GetObjectByTag("poa_npc05") == OBJECT_INVALID)
	  	{
		   object oWP = GetWaypointByTag("wp_poa_npc05");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "poa_npc05", lSpawnpoint);    
	  	}
	  
		if(GetObjectByTag("poa_npc06") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc06");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc06", lSpawnpoint);
		}
	  
		if(GetObjectByTag("poa_npc07") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc07");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc07", lSpawnpoint);    
		}
	
		if(GetObjectByTag("poa_npc08") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc08");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc08", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc09") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc09");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc09", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc10") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("WP_poa_npc10_01");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc10", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc11") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("WP_poa_npc11_01");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc11", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc12") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc12");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc12", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc13") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc13");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc13", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc14") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc14");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc14", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc15") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc15");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc15", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc16") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc16");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc16", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc17") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc17");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc17", lSpawnpoint);    
		}


		if(GetObjectByTag("poa_npc43") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc43");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc43", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc44") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc44");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc44", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc42") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("WP_poa_npc42_01");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc42", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc33") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc33");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc33", lSpawnpoint);    
		}
		
		if(GetObjectByTag("poa_npc36") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc36");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc36", lSpawnpoint);    
		}
		
		if(GetObjectByTag("poa_npc40") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc40");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc40", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc30") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc30");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc30", lSpawnpoint);    
		}
	
		if(GetObjectByTag("poa_npc32") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc32");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc32", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc34") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc34");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc34", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc35") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc35");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc35", lSpawnpoint);    
		}

		if(GetObjectByTag("poa_npc37") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc37");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc37", lSpawnpoint);    
		}


		if(GetObjectByTag("poa_npc38") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag ("wp_poa_npc38");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc38", lSpawnpoint);    
		}


		if(GetObjectByTag("poa_npc39") == OBJECT_INVALID)
		{
			object oWP = GetWaypointByTag ("wp_poa_npc39");
			location lSpawnpoint = GetLocation (oWP);  
			object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc39", lSpawnpoint);    
		}
	
		PS_SetGlobalInt("PoAEnterLock", 0);
  	}
}