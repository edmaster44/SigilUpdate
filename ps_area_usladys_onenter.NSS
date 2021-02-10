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
	
	int iLock = GetGlobalInt("UndersigilLadysLock");
	if ( iLock == 0 ) {
 
		SetGlobalInt("UndersigilLadysLock", 1); // Only allows one clean up at a time.
		  
		if(!GetPlaceableByTag("USLW_TRAP_ARROW_1")) {
			object oWP = GetWaypointByTag("wp_uslw_ballista1");
			object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_undersigil_ballista", GetLocation(oWP), FALSE, "USLW_TRAP_ARROW_1"); 
			/*SetLocalString(oSpawn, "ASSOCIATED_TRAP", "USLW_TRAP_ARROW_1");
			
			object oTrap = GetNearestObjectByTag("USLW_TRAP_ARROW_1");
			if (GetIsObjectValid(oTrap)) {
				SetTrapActive(oTrap, TRUE);
			}*/
		}
		
		if(!GetPlaceableByTag("USLW_TRAP_ARROW_2")) {
			object oWP = GetWaypointByTag("wp_uslw_ballista2");
			object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_undersigil_ballista", GetLocation(oWP), FALSE, "USLW_TRAP_ARROW_2"); 
			/*SetLocalString(oSpawn, "ASSOCIATED_TRAP", "USLW_TRAP_ARROW_2");
			
			object oTrap = GetNearestObjectByTag("USLW_TRAP_ARROW_2");
			if (GetIsObjectValid(oTrap)) {
				SetTrapActive(oTrap, TRUE);
			}*/
		}
		
   		if(GetObjectByTag("ps_us_lwdabus") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_us_lwdabus", GetLocation(GetWaypointByTag("wp_us_lwdabus")));
		}
		   
  		SetGlobalInt("UndersigilLadysLock", 0);
	}
}