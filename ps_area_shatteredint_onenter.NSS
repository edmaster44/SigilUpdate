


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("ShatteredIntLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("ShatteredIntLock", 1); // Only allows one clean up at a time.

  
  if(GetObjectByTag("ps_shattered_atharguardi1") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_shattered_atharguardi1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_atharguard", lSpawnpoint, FALSE, "ps_shattered_atharguardi1");
	   oWP = GetWaypointByTag("wp_shattered_atharguardi2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_atharguard", lSpawnpoint, FALSE, "ps_shattered_atharguardi2");   
	   oWP = GetWaypointByTag("wp_shattered_atharguardi3");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_atharguard", lSpawnpoint, FALSE, "ps_shattered_atharguardi3");   
	   oWP = GetWaypointByTag("wp_shattered_atharguardi4");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_atharguard", lSpawnpoint, FALSE, "ps_shattered_atharguardi4");    
  }
  
  if(GetObjectByTag("ps_shattered_scribefi1") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_shattered_scribefi1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_scribef", lSpawnpoint, FALSE, "ps_shattered_scribefi1");
	   oWP = GetWaypointByTag("wp_shattered_scribefi2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_scribef", lSpawnpoint, FALSE, "ps_shattered_scribefi2");   
	   oWP = GetWaypointByTag("wp_shattered_scribefi3");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_scribef", lSpawnpoint, FALSE, "ps_shattered_scribefi3");   
  }
  
  if(GetObjectByTag("ps_shattered_scribemi1") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_shattered_scribemi1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_scribem", lSpawnpoint, FALSE, "ps_shattered_scribemi1");
	   oWP = GetWaypointByTag("wp_shattered_scribemi2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_scribem", lSpawnpoint, FALSE, "ps_shattered_scribemi2");   
	   oWP = GetWaypointByTag("wp_shattered_scribemi3");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_scribef", lSpawnpoint, FALSE, "ps_shattered_scribemi3");   
  }
    
  SetGlobalInt("ShatteredIntLock", 0);
 }
}