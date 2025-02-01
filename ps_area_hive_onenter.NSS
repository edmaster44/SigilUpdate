#include "ff_safevar"

#include "ps_inc_achievements"
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("HiveEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("HiveEnterLock", 1); // Only allows one clean up at a time.
  
  if (PS_GetLocalInt(OBJECT_SELF, "XaosPicked") == 0)
  {
  	int num = Random(5)+1;
	string sTag = "wp_xaos_out"+IntToString(num);
	object oWP = GetWaypointByTag(sTag);
	SetMapPinEnabled(oWP, TRUE);
	PS_SetLocalString(GetObjectByTag("pl_xaos_out"), "waypoint", sTag);
	
	if (num != 1) DestroyObject(GetObjectByTag("pl_xaos_1"));
	if (num != 2) DestroyObject(GetObjectByTag("pl_xaos_2"));
	if (num != 3) DestroyObject(GetObjectByTag("pl_xaos_3"));
	if (num != 4) DestroyObject(GetObjectByTag("pl_xaos_4"));
	if (num != 5) DestroyObject(GetObjectByTag("pl_xaos_5"));
  	PS_SetLocalInt(OBJECT_SELF, "XaosPicked", 1);
  }

  if(GetObjectByTag("ps_npc_hivepeddler") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_npc_hivepeddler");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_hivepeddler", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_commoner_hiveward1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_rustygolem");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward1", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_commoner_hiveward2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_xaositect");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_commoner_hiveward3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_harlot1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward3", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_commoner_hiveward6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_harlot2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward6", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_commoner_hiveward7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_dustman1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward7", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_commoner_hiveward8") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_dustman2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward8", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_commoner_hiveward9") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_zombie");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_hiveward9", lSpawnpoint);    
  } 
 
  if(GetObjectByTag("ps_hivespawn_rogue") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_hivespawn_rogue");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hivespawn_rogue", lSpawnpoint);    
  }   
 
  if(GetObjectByTag("ps_hivespawn_hardhead") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_hivespawn_hardhead1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hivespawn_hardhead", lSpawnpoint);    
  }   
   
  if(GetObjectByTag("ps_hivespawn_vargouille") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_ps_hivespawn_vargouille_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hivespawn_vargouille", lSpawnpoint);    
  }   
   
  if(GetObjectByTag("ps_hivespawn_basher") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_hivespawn_basher");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hivespawn_basher", lSpawnpoint);    
  }   
   
  if(GetObjectByTag("ps_c_hivepatrolguard1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_hive_patrolguard1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard2", lSpawnpoint, FALSE, "ps_c_hivepatrolguard1");    
  }  
   
  if(GetObjectByTag("ps_c_hivepatrolguard2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_hive_patrolguard2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard2", lSpawnpoint, FALSE, "ps_c_hivepatrolguard2");    
  }  
  
  //ps_hiveward_tout
  if(GetObjectByTag("ps_hiveward_tout") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_hiveward_tout");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_hiveward_tout", lSpawnpoint);    
  } 
  
	//Generates Fensir bouncers
	if(GetObjectByTag("ps_bjevent_fensir0") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_hivespawn_fensir");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bjevent_fensir0", lSpawnpoint);    
	}
  
  string sID = PS_GetCharID(oPC);
  DelayCommand(6.0f, SetPermanentInt(sID, "Hive_Ward", 1));
  
  DelayCommand(7.0f, CheckToutAchievement(oPC));
  
  PS_SetGlobalInt("HiveEnterLock", 0);
 }
}