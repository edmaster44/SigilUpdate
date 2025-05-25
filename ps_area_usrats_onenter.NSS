

void main() {

	object oPC = GetEnteringObject();

	int iLock = GetGlobalInt("undersigilRatsLock");
	if ( iLock == 0 ) {
		SetGlobalInt("undersigilRatsLock", 1); // Only allows one clean up at a time.
		
   		if(GetObjectByTag("ps_us_ratrepresentative") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_us_ratrepresentative", GetLocation(GetWaypointByTag("wp_us_ratrepresentative")));
		}
		
		SetGlobalInt("undersigilRatsLock", 0);
 	}
	
}