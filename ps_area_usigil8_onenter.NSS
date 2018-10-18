
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("usigilwereratEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("usigilwereratEnterLock", 1); // Only allows one clean up at a time.
  
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
   
  SetGlobalInt("usigilwereratEnterLock", 0);
 }
}