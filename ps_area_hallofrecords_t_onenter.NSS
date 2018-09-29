
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("HallrecordsTowerEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("HallrecordsTowerEnterLock", 1); // Only allows one clean up at a time.

 
  
   if(GetObjectByTag("fated_guard_4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatedguard4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_guard_4", lSpawnpoint);    
  }
    
    if(GetObjectByTag("fated_namer_7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("sp_fated_namer_7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_7", lSpawnpoint);    
  }
  
     
    if(GetObjectByTag("fated_namer_9") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("sp_fated_namer_9");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_9", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_namer_08") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatednamer08");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_08", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_guard_06") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_guard_06_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_guard_06", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_guard_07") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_guard_07_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_guard_07", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_namer_012") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_012_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_012", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_namer_014") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_014_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_014", lSpawnpoint);    
  }
  
  if(GetObjectByTag("fated_namer_08") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_08_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_08", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_namer_013") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_013_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_013", lSpawnpoint);    
  }
  
  SetGlobalInt("HallrecordsTowerEnterLock", 0);
 }
}