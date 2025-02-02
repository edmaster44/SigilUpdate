#include "ff_safevar"

void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = GetGlobalInt

("CourtWoeEnterLock");
	if ( iLock == 0 )
 	{
	  PS_SetGlobalInt("CourtWoeEnterLock", 1); 
	  // Only allows one clean up at a time.

 if(GetObjectByTag("ps_commoner_courtwoe01") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe01");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe01", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe02") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe02");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "wp_commoner_courtwoe02", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe03") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe03");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe03", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe04") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe04");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe04", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe05") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe05");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe05", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe06") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe06");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe06", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe07") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe07");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe07", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe08") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe08");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe08", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe09") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe09");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe09", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe10") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe10");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe10", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe11") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe11");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe11", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe12") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe12");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe12", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe13") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe13");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe13", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("ps_commoner_courtwoe14") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe14");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe14", lSpawnpoint);    
	  }
	  
	 	  if(GetObjectByTag("ps_commoner_courtwoe15") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe15");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe15", lSpawnpoint);    
	  }
	  
	  	  if(GetObjectByTag("ps_commoner_courtwoe16") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe16");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe16", lSpawnpoint);    
	  }
	  
	  	  if(GetObjectByTag("ps_commoner_courtwoe17") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe17");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe17", lSpawnpoint);    
 if(GetObjectByTag("ps_commoner_courtwoe18") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe18");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe18", lSpawnpoint);    
	  }
	   if(GetObjectByTag("ps_commoner_courtwoe19") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe19");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe19", lSpawnpoint);    
	  }
	   if(GetObjectByTag("ps_commoner_courtwoe20") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_commoner_courtwoe20");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "ps_commoner_courtwoe20", lSpawnpoint);    
	  }
	  }
	  
	}
	
PS_SetGlobalInt("CourthouseEnterLock", 0);
  	}