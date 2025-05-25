


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
int iLock = GetGlobalInt("BJEnterLock");
	if ( iLock == 0 )
 {
  SetGlobalInt("BJEnterLock", 1); // Only allows one clean up at a time.
  
//Resets the fight event trigger if there are not already PCs in the area
	object oTrigger = GetObjectByTag("ps_bjevent_trigger"); 
	object oEmpty = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, GetFirstObjectInArea());

	if (!GetIsObjectValid(oEmpty))
  {
	SetLocalInt(oTrigger,"Used",FALSE);    
	
	//Generates Barl Hoxun, proprietor
	if(GetObjectByTag("ps_bjevent_hoxun") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_hoxun");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_hoxun", lSpawnpoint);    
	}

	//Generates Ghuurakk the bartender
	if(GetObjectByTag("ps_bjevent_ghuurakk") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_ghuurakk");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_ghuurakk", lSpawnpoint);    
	}

	//Generates Mahkata the bartender
	if(GetObjectByTag("ps_bjevent_mahkata") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_mahkata");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_mahkata", lSpawnpoint);    
	}

	//Generates Fensir bouncers
	if(GetObjectByTag("ps_bjevent_fensir") == OBJECT_INVALID)
	{
	object oWP1 = GetWaypointByTag("wp_bjevent_fensir1");
	object oWP2 = GetWaypointByTag("wp_bjevent_fensir2");
	object oWP3 = GetWaypointByTag("wp_bjevent_fensir3");
	location lSpawnpoint1 = GetLocation(oWP1);  
	location lSpawnpoint2 = GetLocation(oWP2);  
	location lSpawnpoint3 = GetLocation(oWP3);  
		object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_fensir", lSpawnpoint1);    
		object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_fensir", lSpawnpoint2);    
		object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_fensir", lSpawnpoint3);    
	}

	//Generates Bouncer (Quest NPC)
	if(GetObjectByTag("ps_npc_hiveward1") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("ps_hivespawn_ogrebounce");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_hiveward1", lSpawnpoint);    
	}   
 
	//Generates Minotaur Captain
	if(GetObjectByTag("ps_bjevent_minotaurc") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_minotaurc");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_minotaurc", lSpawnpoint);    
	}

	//Generates Fight Fan 1
	if(GetObjectByTag("ps_bjevent_fightfan1") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_fightfan1");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_fightfan1", lSpawnpoint);    
	}

	//Generates Fight Fan 2
	if(GetObjectByTag("ps_bjevent_fightfan2") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_fightfan2");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_fightfan2", lSpawnpoint);    
	}

	//Generates Fight Fan 3
	if(GetObjectByTag("ps_bjevent_fightfan3") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_fightfan3");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_fightfan3", lSpawnpoint);    
	}

	//Generates Fight Fan 4
	if(GetObjectByTag("ps_bjevent_fightfan4") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_fightfan4");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_fightfan4", lSpawnpoint);    
	}

	//Generates Draano the Bookmaker
	if(GetObjectByTag("ps_bjevent_draano") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_draano");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_draano", lSpawnpoint);    
	}

	//Generates Drunk Girl at bar
	if(GetObjectByTag("ps_bjevent_drunkgirl") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_bjevent_drunkgirl");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_drunkgirl", lSpawnpoint);    
	}

	if(GetObjectByTag("npc_sigis_journalist") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sigis_journalist");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_sigis_journalist", lSpawnpoint);    
  }
	
  }
  SetGlobalInt("BJEnterLock", 0);
 
  }
}