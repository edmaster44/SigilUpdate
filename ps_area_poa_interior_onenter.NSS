void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = GetGlobalInt

("PoAInteriorEnterLock");
	if ( iLock == 0 )
 	{
	  SetGlobalInt("PoAInteriorEnterLock", 1); 
	  // Only allows one clean up at a time.

if(GetObjectByTag("poa_npc18") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc18");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc18", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc19") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc19");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc19", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc20") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("WP_poa_npc20_01");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc20", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc21") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc21");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc21", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc22") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc22");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc22", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc23") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc23");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc23", lSpawnpoint);    
	}


if(GetObjectByTag("poa_npc24") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc24");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc24", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc25") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc25");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc25", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc26") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc26");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc26", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc27") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc27");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc27", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc28") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc28");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc28", lSpawnpoint);    
	}








if(GetObjectByTag("poa_npc66") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc66");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc66", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc67") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc67");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc67", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc68") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc68");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc68", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc69") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc69");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc69", lSpawnpoint);    
	}

if(GetObjectByTag("poa_npc70") == OBJECT_INVALID)
	{
		   object oWP = GetWaypointByTag ("wp_poa_npc70");
		   location lSpawnpoint = GetLocation (oWP);  
		   object oSpawn = CreateObject (OBJECT_TYPE_CREATURE, "poa_npc70", lSpawnpoint);    
	}




SetGlobalInt("PoAInteriorEnterLock", 0);
  	}
}