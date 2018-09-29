
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("ShatteredLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("ShatteredLock", 1); // Only allows one clean up at a time.

  
  if(GetObjectByTag("ps_shattered_atharguard1") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_shattered_atharguard1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_atharguard", lSpawnpoint, FALSE, "ps_shattered_atharguard1");
	   oWP = GetWaypointByTag("wp_shattered_atharguard2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_atharguard", lSpawnpoint, FALSE, "ps_shattered_atharguard2");   
	   oWP = GetWaypointByTag("wp_shattered_atharguard3");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_atharguard", lSpawnpoint, FALSE, "ps_shattered_atharguard3");   
	   oWP = GetWaypointByTag("wp_shattered_atharguard4");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_atharguard", lSpawnpoint, FALSE, "ps_shattered_atharguard4");    
  }
  //wp_shattered_guide4
   if(GetObjectByTag("ps_shattered_guide1") == OBJECT_INVALID)
   {
  	   object oWP = GetWaypointByTag("wp_shattered_guide1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_guide1", lSpawnpoint);
   } 
  //wp_shattered_guide4
   if(GetObjectByTag("ps_shattered_guide2") == OBJECT_INVALID)
   {
  	   object oWP = GetWaypointByTag("wp_shattered_guide2");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_guide2", lSpawnpoint);
   } 
  //wp_shattered_guide4
   if(GetObjectByTag("ps_shattered_guide3") == OBJECT_INVALID)
   {
  	   object oWP = GetWaypointByTag("wp_shattered_guide3");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_guide3", lSpawnpoint);
   } 
  //wp_shattered_guide4
   if(GetObjectByTag("ps_shattered_guide4") == OBJECT_INVALID)
   {
  	   object oWP = GetWaypointByTag("wp_shattered_guide4");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_guide4", lSpawnpoint);
   } 
   //ps_shattered_hobard
   if(GetObjectByTag("ps_shattered_hobard") == OBJECT_INVALID)
   {
  	   object oWP = GetWaypointByTag("wp_shattered_hobard");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shattered_hobard", lSpawnpoint);
   } 
    
  SetGlobalInt("ShatteredLock", 0);
 }
}