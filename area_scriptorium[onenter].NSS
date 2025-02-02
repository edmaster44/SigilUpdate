void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("ScriptoriumEnterLock1");
 if ( iLock == 0 )
 {
  SetGlobalInt("ScriptoriumEnterLock1", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("npc_scriptorium01") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium01", lSpawnpoint);    
  }
  if(GetObjectByTag("npc_scriptorium02") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium02");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium02", lSpawnpoint);    
  }
  if(GetObjectByTag("npc_scriptorium03") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium03");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium03", lSpawnpoint);    
  }
  if(GetObjectByTag("npc_scriptorium04") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium04");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium04", lSpawnpoint);    
  }
  if(GetObjectByTag("npc_scriptorium05") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium05");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium05", lSpawnpoint);    
  }
  if(GetObjectByTag("npc_scriptorium06") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium06");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium06", lSpawnpoint);    
  }
  if(GetObjectByTag("npc_scriptorium07") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium07");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium07", lSpawnpoint);    
  }
  if(GetObjectByTag("npc_scriptorium08") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium08");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium08", lSpawnpoint);    
  }
  if(GetObjectByTag("npc_scriptorium09") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium09");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium09", lSpawnpoint);    
  }
  if(GetObjectByTag("npc_scriptorium10") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium10");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium10", lSpawnpoint);    
  }
 if(GetObjectByTag("npc_scriptorium10") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium10");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium10", lSpawnpoint);    
  }
 if(GetObjectByTag("npc_scriptorium11") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium11");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium11", lSpawnpoint);    
  }
 if(GetObjectByTag("npc_scriptorium12") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium12");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium12", lSpawnpoint);    
  } 
   if(GetObjectByTag("npc_scriptorium13") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium13");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium13", lSpawnpoint);    
  } 
   if(GetObjectByTag("npc_scriptorium14") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium14");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium14", lSpawnpoint);    
  } 
   if(GetObjectByTag("npc_scriptorium15") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_scriptorium15");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_scriptorium15", lSpawnpoint);    
  } 
  SetGlobalInt("ScriptoriumEnterLock1", 0);
 }
}