
void main()
{
 object oPC = GetEnteringObject();

 int iLock = GetGlobalInt("usigil8enterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("usigil8enterLock", 1); // Only allows one clean up at a time.
  
  if(GetObjectByTag("X0_TRAP_DART_K1") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_usigil8_ballista1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_undersigil_ballista", lSpawnpoint, FALSE, "X0_TRAP_DART_K1");    
  }
  
  if(GetObjectByTag("X0_TRAP_DART_K2") == OBJECT_INVALID) {
	   object oWP = GetWaypointByTag("wp_usigil8_ballista2");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_undersigil_ballista", lSpawnpoint, FALSE, "X0_TRAP_DART_K2");    
  }
   
  SetGlobalInt("usigil8enterLock", 0);
 }
}