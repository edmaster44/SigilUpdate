#include "ff_safevar"

void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = PS_GetGlobalInt("PoAPalace2EnterLock");
	if ( iLock == 0 )
 	{
	  PS_SetGlobalInt("PoAPalace2EnterLock", 1); 
	  // Only allows one clean up at a time.


if(GetObjectByTag("poa_npc49") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("WP_poa_npc49_01");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc49", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc50") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc50");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc50", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc51") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc51");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc51", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc52") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("WP_poa_npc52_01");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc52", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc53") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc53");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc53", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc54") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc54");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc54", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc55") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc55");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc55", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc56") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc56");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc56", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc57") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc57");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc57", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc58") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc58");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc58", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc59") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc59");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc59", 

lSpawnpoint);    
	}




if(GetObjectByTag("poa_npc62") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc62");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc62", 

lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc63") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc63");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc63", 

lSpawnpoint);    
	}




PS_SetGlobalInt("PoAPalace2EnterLock", 0);
  	}
}