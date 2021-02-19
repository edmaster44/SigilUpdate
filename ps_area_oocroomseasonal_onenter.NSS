
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
	
 int iLock = GetGlobalInt("OOCEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("OOCEnterLock", 1); // Only allows one clean up at a time.
  
  if(GetObjectByTag("ps_npc_custom0") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ooc_tailor_seasonal");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_custom0", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_oocroommerchant") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_oocroom-merchant_seasonal");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_oocroommerchant", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_mimir") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_mimir_seasonal");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mimir", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_npc_oocstyx") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_styxoarsman_seasonal");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_oocstyx", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_seasonalxanta") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_seasonal1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_seasonalxanta", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_seasonalxantahelper") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_seasonal2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_seasonalxantahelper", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_seasonalreindeer1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_seasonal3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_seasonalreindeer1", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_seasonalreindeer2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_seasonal4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_seasonalreindeer2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_seasonalreindeer3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_seasonal5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_seasonalreindeer3", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_seasonalreindeer4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_seasonal6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_seasonalreindeer4", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_seasonalreindeer5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_seasonal7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_seasonalreindeer5", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_seasonalkrampus") == OBJECT_INVALID)
  {
	object oWP = GetWaypointByTag("wp_ooc_krampus_seasonal");
   	location lSpawnpoint = GetLocation(oWP);  
	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_seasonalkrampus", lSpawnpoint);    
  }
  
  if(GetObjectByTag("kemo_storage_teller") == OBJECT_INVALID)
  {
	object oWP = GetWaypointByTag("wp_kemo_storage_teller_seasonal");
   	location lSpawnpoint = GetLocation(oWP);  
	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "kemo_storage_teller", lSpawnpoint);    
  }
    
  SetGlobalInt("OOCEnterLock", 0);
 }
}