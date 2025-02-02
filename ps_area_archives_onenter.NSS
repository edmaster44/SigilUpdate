#include "ff_safevar"


void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = PS_GetGlobalInt("ArchivesEnterLock");
	if ( iLock == 0 )
 	{
	  PS_SetGlobalInt("ArchivesEnterLock", 1); // Only allows one clean up at a time.
	
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
	  PS_SetGlobalInt("ArchivesEnterLock", 0);
  	}
}