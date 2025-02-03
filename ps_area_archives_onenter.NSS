
void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = GetGlobalInt("ArchivesEnterLock");
	if ( iLock == 0 )
 	{
	  SetGlobalInt("ArchivesEnterLock", 1); // Only allows one clean up at a time.
	
	  if(GetObjectByTag("cc_guva2") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_guva2");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_guva2", lSpawnpoint);    
	  }
	  if(GetObjectByTag("cc_guva5") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag("wp_guva5");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cc_guva5", lSpawnpoint);    
	  }
	  SetGlobalInt("ArchivesEnterLock", 0);
  	}
}