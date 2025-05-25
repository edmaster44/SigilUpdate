

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 
 ExecuteScript("onenter_antimagic",OBJECT_SELF);
  
 int iLock = GetGlobalInt("DPT1EnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("DPT1EnterLock", 1); 
  
  if(GetObjectByTag("ps_slags_ghost") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_slags_ghost");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_slags_ghost", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_slagstower_mimic1") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_slagstower_chest1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_spawnchest_mimic", lSpawnpoint, FALSE, "ps_slagstower_mimic1");    
  }
  
  if(GetObjectByTag("ps_slagstower_mimic2") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_slagstower_chest2");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_spawnchest_mimic", lSpawnpoint, FALSE, "ps_slagstower_mimic2");    
  }
  
  if(GetObjectByTag("ps_slagstower_mimic3") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_slagstower_chest3");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_spawnchest_mimic", lSpawnpoint, FALSE, "ps_slagstower_mimic3");    
  }
  
  if(GetObjectByTag("ps_slagstower_mimic4") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_slagstower_chest4");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_spawnchest_mimic", lSpawnpoint, FALSE, "ps_slagstower_mimic4");    
  }
  
  if(GetObjectByTag("ps_slagstower_mimic5") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_slagstower_chest5");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_spawnchest_mimic", lSpawnpoint, FALSE, "ps_slagstower_mimic5");    
  }
  
  if(GetObjectByTag("ps_slagstower_mimic6") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_slagstower_chest6");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_spawnchest_mimic", lSpawnpoint, FALSE, "ps_slagstower_mimic6");    
  }
  
  if(GetObjectByTag("ps_slagstower_mimic7") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_slagstower_chest7");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_spawnchest_mimic", lSpawnpoint, FALSE, "ps_slagstower_mimic7");    
  }
    
  SetGlobalInt("DPT1EnterLock", 0);
 }

}