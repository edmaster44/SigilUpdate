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
	  

	int iLock = PS_GetGlobalInt("PoAFesthallEnterLock");
	if ( iLock == 0 )
 	{
	  PS_SetGlobalInt("PoAFesthallEnterLock", 1); 
	  // Only allows one clean up at a time.


if(GetObjectByTag("poa_npc71") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc71");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc71", lSpawnpoint);    
	}



if(GetObjectByTag("poa_npc72") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc72");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc72", lSpawnpoint);    
	}




if(GetObjectByTag("poa_npc73") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc73");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc73", lSpawnpoint);    
	}





if(GetObjectByTag("poa_npc74") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc74");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc74", lSpawnpoint);    
	}


if(GetObjectByTag("poa_npc75") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc75");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc75", lSpawnpoint);    
	}
 

PS_SetGlobalInt("PoAFesthallEnterLock", 0);
  	}
}