void main() {

	object oPC = GetEnteringObject();

	int iLock = GetGlobalInt("crypt1EnterLock");
	if ( iLock == 0 ) {
		SetGlobalInt("crypt1EnterLock", 1); // Only allows one clean up at a time.
   		if(GetObjectByTag("ps_us_crypt2_ghostgirl") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_us_crypt2_ghostgirl", GetLocation(GetWaypointByTag("wp_us_crypt2_ghostgirl")));
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_us_crypt2_ghostgirl", GetLocation(GetWaypointByTag("wp_us_crypt2_ghostgirl2")));
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_us_crypt2_ghostgirl", GetLocation(GetWaypointByTag("wp_us_crypt2_ghostgirl3")));
		}
		
		SetGlobalInt("crypt1EnterLock", 0);
 	}
	
}