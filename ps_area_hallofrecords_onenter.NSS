
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("HallrecordsEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("HallrecordsEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("fated_lobby_attendant") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_ wp_lobbyattendant");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_lobby_attendant", lSpawnpoint);    
  }
  
  if(GetObjectByTag("fated_aramoak") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_fated_aramoak");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_aramoak", lSpawnpoint);    
  }
 
   if(GetObjectByTag("fated_namer_011") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fated_namer_011");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_011", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_licensing_appointee") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatedlicense");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_licensing_appointee", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_credit_appointee") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatedcredit");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_credit_appointee", lSpawnpoint);    
  }
   
   if(GetObjectByTag("fated_guard_1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_guard_1_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_guard_1", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_guard_2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatedguard2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_guard_2", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_guard_3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatedguard3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_guard_3", lSpawnpoint);    
  }
  
   if(GetObjectByTag("fated_guard_5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatedguard5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_guard_5", lSpawnpoint);    
  }
  
  if(GetObjectByTag("fated_namer_01") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatednamer01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_01", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_02") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_02_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_02", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_03") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatednamer03");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_03", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_04") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_04_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_04", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_05") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_05_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_05", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_06") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fatednamer06");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_06", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_07") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_07_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_07", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_09") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_09_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_09", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_010") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_fated_namer_010_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_010", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("sp_fated_namer_1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_1", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("sp_fated_namer_2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_2", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("sp_fated_namer_3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_3", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("sp_fated_namer_4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_4", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("sp_fated_namer_5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_5", lSpawnpoint);    
  }
  
    if(GetObjectByTag("fated_namer_6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("sp_fated_namer_6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_6", lSpawnpoint);    
  }
  
   
    if(GetObjectByTag("fated_namer_8") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("sp_fated_namer_8");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fated_namer_8", lSpawnpoint);    
  }
  
  
  SetGlobalInt("HallrecordsEnterLock", 0);
 }
}