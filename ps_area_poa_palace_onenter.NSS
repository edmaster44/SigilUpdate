#include "ff_safevar"

void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = PS_GetGlobalInt("PoAPalaceEnterLock");
	if ( iLock == 0 )
 	{
	  PS_SetGlobalInt("PoAPalaceEnterLock", 1); 
	  // Only allows one clean up at a time.

 if(GetObjectByTag("poa_npc60") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("WP_poa_npc60");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "poa_npc60", lSpawnpoint);    
	  }
	 
	  if(GetObjectByTag("poa_npc61") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("WP_poa_npc61");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "poa_npc61", lSpawnpoint);    
	  }
	  
 if(GetObjectByTag("poa_npc64") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("WP_poa_npc64_01");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "poa_npc64", lSpawnpoint);    
	  }
	  
	  if(GetObjectByTag("poa_npc65") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("WP_poa_npc65_01");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

(OBJECT_TYPE_CREATURE, "poa_npc65", lSpawnpoint);    
	  }
	 




PS_SetGlobalInt("PoAPalaceEnterLock", 0);
  	}
}