
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("CivicEnterLock2");
 if ( iLock == 0 )
 {
  SetGlobalInt("CivicEnterLock2", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("festhall_entertainerunit") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_festhall_entertainerunit");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhall_entertainerunit", lSpawnpoint);    
  }
  
  //wp_festhallnpc_GroundlevelGuardF2
  if(GetObjectByTag("festhallnpc_GroundlevelGuardF2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_festhallnpc_GroundlevelGuardF1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_GroundlevelGuardF2", lSpawnpoint); 
   oWP = GetWaypointByTag("wp_festhallnpc_GroundlevelGuardF2");
   lSpawnpoint = GetLocation(oWP);  
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_GroundlevelGuardF2", lSpawnpoint);   
   oWP = GetWaypointByTag("wp_festhallnpc_GroundlevelGuardF3");
   lSpawnpoint = GetLocation(oWP);  
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_GroundlevelGuardF2", lSpawnpoint);  
   oWP = GetWaypointByTag("wp_festhallnpc_GroundlevelGuardF4");
   lSpawnpoint = GetLocation(oWP);  
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_GroundlevelGuardF2", lSpawnpoint);  
  }
  
  //wp_festhallnpc_GroundlevelGuardM1
  if(GetObjectByTag("festhallnpc_GroundlevelGuardM") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_festhallnpc_GroundlevelGuardM1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_GroundlevelGuardM", lSpawnpoint);    
  }
  
  //wp_festhallnpc_Mia
  if(GetObjectByTag("festhallnpc_Mia") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_festhallnpc_Mia");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_Mia", lSpawnpoint);    
  }
  
  //wp_festhallnpc_greggory
  if(GetObjectByTag("festhallnpc_greggory") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_festhallnpc_greggory");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_greggory", lSpawnpoint);    
  }
  
  SetGlobalInt("CivicEnterLock2", 0);
 }
}