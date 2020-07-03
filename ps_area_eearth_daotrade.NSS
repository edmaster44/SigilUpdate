#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
	
	string sPlane = "Elemental Plane of Earth";
 	string sDescrip = "";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
  
 int iLock = GetGlobalInt("DaoTradeLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("DaoTradeLock", 1); // Only allows one clean up at a time.
   
  if(GetObjectByTag("ps_eearth_slave01") == OBJECT_INVALID)
  {
	  object oWP = GetWaypointByTag("wp_eearth_slave01");
	  location lSpawnpoint = GetLocation(oWP);  
	  object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_eearth_slave01", lSpawnpoint);    
  }  
  if(GetObjectByTag("ps_eearth_slave02") == OBJECT_INVALID)
  {
	  object oWP = GetWaypointByTag("wp_eearth_slave02");
	  location lSpawnpoint = GetLocation(oWP);  
	  object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_eearth_slave02", lSpawnpoint);    
  }    
  if(GetObjectByTag("ps_eearth_slave03") == OBJECT_INVALID)
  {
	  object oWP = GetWaypointByTag("wp_eearth_slave03");
	  location lSpawnpoint = GetLocation(oWP);  
	  object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_eearth_slave03", lSpawnpoint);    
  }    
  if(GetObjectByTag("ps_eearth_tradecrafter") == OBJECT_INVALID)
  {
	  object oWP = GetWaypointByTag("wp_eearth_tradecrafter");
	  location lSpawnpoint = GetLocation(oWP);  
	  object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_eearth_tradecrafter", lSpawnpoint);    
  }     
  if(GetObjectByTag("ps_eearth_tradeoverseer") == OBJECT_INVALID)
  {
	  object oWP = GetWaypointByTag("wp_eearth_tradeoverseer");
	  location lSpawnpoint = GetLocation(oWP);  
	  object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_eearth_tradeoverseer", lSpawnpoint);    
  }     
  if(GetObjectByTag("ps_eearth_eelemental") == OBJECT_INVALID)
  {
	  object oWP = GetWaypointByTag("wp_eearth_eelemental");
	  location lSpawnpoint = GetLocation(oWP);  
	  object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_eearth_eelemental", lSpawnpoint);    
  }  
  if(GetObjectByTag("ps_eearth_gnollguard") == OBJECT_INVALID)
  {
	  object oWP = GetWaypointByTag("wp_eearth_gnollguard");
	  location lSpawnpoint = GetLocation(oWP);  
	  object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_eearth_gnollguard", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_eearth_ogreguard") == OBJECT_INVALID)
  {
	  object oWP = GetWaypointByTag("wp_eearth_ogreguard");
	  location lSpawnpoint = GetLocation(oWP);  
	  object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_eearth_ogreguard", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_eearth_miner") == OBJECT_INVALID)
  {
	  object oWP = GetWaypointByTag("wp_eearth_miner");
	  location lSpawnpoint = GetLocation(oWP);  
	  object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_eearth_miner", lSpawnpoint);    
  }
  
  SetGlobalInt("DaoTradeLock", 0);
  
}
}