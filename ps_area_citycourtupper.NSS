

void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = GetGlobalInt("CourthouseEnterLock2");
	if ( iLock == 0 )
 	{
	  SetGlobalInt("CourthouseEnterLock2", 1); 
	  // Only allows one clean up at a time.

	  if(GetObjectByTag("cc_tht") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_tht");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_tht", lSpawnpoint);    
	  }
	   if(GetObjectByTag("cc_guvb1") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_gub1");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_guvb1", lSpawnpoint);    
	  }
	  
	   if(GetObjectByTag("cc_guvb3") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_guvb3");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_guvb3", lSpawnpoint);    
	  }
	  
 if(GetObjectByTag("cc_aide") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_aide");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_aide", lSpawnpoint);    
	  }

if(GetObjectByTag("cc_guvb2") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_guvb2");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_guvb2", lSpawnpoint);    
	  }
 if(GetObjectByTag("cc_guva10") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_guva10");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_guva10", lSpawnpoint);    
	  }
SetGlobalInt("CourthouseEnterLock", 0);
  	}
}