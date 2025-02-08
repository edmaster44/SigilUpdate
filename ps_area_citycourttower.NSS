#include "ff_safevar"

void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = PS_GetGlobalInt("CourthouseEnterLock3");
	
	if ( iLock == 0 )
 	{
	  PS_SetGlobalInt("CourthouseEnterLock3", 1);
	   //Only allows one clean up at a time.
	
	  if(GetObjectByTag("cc_accused") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_accused");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_accused", lSpawnpoint);    
	  }
	  
	   if(GetObjectByTag("cc_mimir02") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_mimir02");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_mimir02", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("cc_audience01") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_audience01");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_audience01", lSpawnpoint);   

 
	  }
	  if(GetObjectByTag("cc_audience02") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_audience02");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_audience02", lSpawnpoint);   

 
	  }
	  if(GetObjectByTag("cc_audience03") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_audience03");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_audience03", lSpawnpoint);   

 
	  }
	  if(GetObjectByTag("cc_audience04") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_audience04");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_audience04", lSpawnpoint);   

 
	  }
	  if(GetObjectByTag("cc_audience05") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_audience05");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_audience05", lSpawnpoint);   

 
	  }
	  if(GetObjectByTag("cc_audience06") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_audience06");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_audience06", lSpawnpoint);   

 
	  }
	  if(GetObjectByTag("cc_audience07") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_audience07");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_audience07", lSpawnpoint);   

 
	  }
	  if(GetObjectByTag("cc_audience08") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_audience08");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_audience08", lSpawnpoint);   

 
	  }
	  if(GetObjectByTag("cc_audience09") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_audience09");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_audience09", lSpawnpoint);   

 
	  }
	 
	  if(GetObjectByTag("cc_guvb1") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_guvb1");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_guvb1", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("cc_guvb3") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_guvb3");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_guvb3", lSpawnpoint);    
	  }
	 
	  if(GetObjectByTag("cc_lawyer01") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_lawyer01");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_lawyer01", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_lawyer02") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_lawyer02");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_lawyer02", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_stf") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_stf");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_stf", lSpawnpoint);    
	  }
	 
	 
	  if(GetObjectByTag("cc_witness") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_witness");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_witness", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("cc_aide03") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_aide03");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_aide03", lSpawnpoint);    
	  }
	  
	   if(GetObjectByTag("cc_guva5") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_guva5");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_guva5", lSpawnpoint);    
	  }
	  
	  
	
	  
	  if(GetObjectByTag("cc_judge02") == 

OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_judge02"); //renamed waypoint from wp_cc_judge02 to wp_judge02
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_judge02", lSpawnpoint);    
	  }
	  PS_SetGlobalInt("CourthouseEnterLock", 0);
  	}
}