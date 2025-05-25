


void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = GetGlobalInt("CourthouseEnterLock");
	if ( iLock == 0 )
 	{
	  SetGlobalInt("CourthouseEnterLock", 1); // Only allows one clean up at a time.
	
	  if(GetObjectByTag("cc_accused") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_accused");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_accused", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_aide") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_aide");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_aide", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_audience01") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_audience01");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_audience01", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_audience02") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_audience02");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_audience02", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_audience03") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_audience03");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_audience03", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_audience04") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_audience04");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_audience04", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_audience05") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_audience05");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_audience05", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_audience06") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_audience06");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_audience06", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_audience07") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_audience07");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_audience07", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_audience08") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_audience08");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_audience08", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_audience09") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_audience09");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_audience09", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_guva10") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_guva10");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_guva10", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_guvb1") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_guvb1");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_guvb1", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_guvb2") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_guvb2");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_guvb2", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_guvb3") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_guvb3");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_guvb3", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_judgegabberslug") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_judgegabberslug");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_judgegabberslug", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_lawyer01") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_lawyer01");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_lawyer01", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_lawyer02") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_lawyer02");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_lawyer02", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_stf") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_stf");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_stf", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_tht") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_tht");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_tht", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_visitor") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_visitor");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_visitor", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_witness") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_witness");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_witness", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_judge01") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_judge01");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_judge01", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_judge02") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_judge02");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_judge02", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_judge03") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_judge03");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_judge03", lSpawnpoint);    
	  }
	  SetGlobalInt("CourthouseEnterLock", 0);
  	}
}