void main() {

	object oPC = GetEnteringObject();

	int iLock = GetGlobalInt("crypt1EnterLock");
	if ( iLock == 0 ) {
		SetGlobalInt("crypt1EnterLock", 1); // Only allows one clean up at a time.
   		if(GetObjectByTag("ps_prop_statuekelemvor") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_statuekelemvor", GetLocation(GetWaypointByTag("wp_prop_statuekelemvor")));
		}
   		if(GetObjectByTag("ps_prop_statuehades") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_statuehades", GetLocation(GetWaypointByTag("wp_prop_statuehades")));
		}
   		if(GetObjectByTag("ps_prop_statueanubis") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_statueanubis", GetLocation(GetWaypointByTag("wp_prop_statueanubis")));
		}
   		if(GetObjectByTag("ps_prop_statuechronepsis") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_statuechronepsis", GetLocation(GetWaypointByTag("wp_prop_statuechronepsis")));
		}
   		if(GetObjectByTag("ps_prop_statueevening") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_statueevening", GetLocation(GetWaypointByTag("wp_prop_statueevening")));
		}
   		if(GetObjectByTag("ps_prop_statuemorrigan") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_statuemorrigan", GetLocation(GetWaypointByTag("wp_prop_statuemorrigan")));
		}
		
   		if(GetObjectByTag("ps_us_imtiyaz") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_us_imtiyaz", GetLocation(GetWaypointByTag("wp_undersigil_imtiyaz")));
		}
		
		SetGlobalInt("crypt1EnterLock", 0);
 	}
	
}