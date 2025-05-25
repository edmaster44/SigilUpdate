

void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = GetGlobalInt("CourthouseEnterLock");
	if ( iLock == 0 )
 	{
	  SetGlobalInt("CourthouseEnterLock", 1); 
	  // Only allows one clean up at a time.

 if(GetObjectByTag("cc_guva2") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_guva2");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_guva2", lSpawnpoint);    
	  }
	 
	  if(GetObjectByTag("cc_mimir01") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_mimir01");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_mimir01", lSpawnpoint);    
	  }
	  
 if(GetObjectByTag("cc_visitor") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_visitor");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_visitor", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("cc_nye") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_nye");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_nye", lSpawnpoint);    
	  }
	   if(GetObjectByTag("cc_aide02") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_aide02");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "cc_aide02", lSpawnpoint);    
	  }
	  
if(GetObjectByTag("cc_judge01") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_judge01");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "cc_judge01", lSpawnpoint);
	}
	  
if(GetObjectByTag("cc_judge03") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_judge03");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "cc_judge03", lSpawnpoint);    
	}
	
SetGlobalInt("CourthouseEnterLock", 0);
  	}
}