int GetPlaceableByTag(string sTag) {
	int nCount = 0;
	while (nCount < 10) {
		object oObj = GetObjectByTag(sTag, nCount);
		if (GetIsObjectValid(oObj) && GetObjectType(oObj) == OBJECT_TYPE_PLACEABLE)
			return TRUE;
		nCount++;
	}
	return FALSE;
}

void main() {

	object oPC = GetEnteringObject();
	
	int iLock = GetGlobalInt("usigil8enterLock");
	if ( iLock == 0 ) {
 
		SetGlobalInt("usigil8enterLock", 1); // Only allows one clean up at a time.
		  
		if(!GetPlaceableByTag("X0_TRAP_DART_K_USIGIL1")) {
			object oWP = GetWaypointByTag("wp_usigil8_ballista1");
			location lSpawnpoint = GetLocation(oWP);  
			object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_undersigil_ballista", lSpawnpoint, FALSE, "X0_TRAP_DART_K_USIGIL1"); 
		}
		  
		if(!GetPlaceableByTag("X0_TRAP_DART_K_USIGIL2")) {
			object oWP = GetWaypointByTag("wp_usigil8_ballista2");
			location lSpawnpoint = GetLocation(oWP);  
			object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_undersigil_ballista", lSpawnpoint, FALSE, "X0_TRAP_DART_K_USIGIL2");
		}
		   
  		SetGlobalInt("usigil8enterLock", 0);
	}
}