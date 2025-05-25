

void main() {

	object oPC = GetEnteringObject();

	int iLock = GetGlobalInt("twelveFactolsLock");
	if ( iLock == 0 ) {
		SetGlobalInt("twelveFactolsLock", 1); // Only allows one clean up at a time.
		
		//pigs
   		if(GetObjectByTag("ps_lw_12f_pig") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_pig", GetLocation(GetWaypointByTag("wp_lw_12f_pig1")));
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_pig", GetLocation(GetWaypointByTag("wp_lw_12f_pig2")));
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_pig", GetLocation(GetWaypointByTag("wp_lw_12f_pig3")));
		}
		
		//patrons
   		if(GetObjectByTag("ps_lw_12f_patron3") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_patron3", GetLocation(GetWaypointByTag("wp_lw_12f_patronp1")));
		}
   		if(GetObjectByTag("ps_lw_12f_patron1") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_patron1", GetLocation(GetWaypointByTag("wp_lw_12f_patronp2")));
		}
   		if(GetObjectByTag("ps_lw_12f_patron7") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_patron7", GetLocation(GetWaypointByTag("wp_lw_12f_patronp3")));
		}
   		if(GetObjectByTag("ps_lw_12f_patron8") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_patron8", GetLocation(GetWaypointByTag("wp_lw_12f_patronp4")));
		}
   		if(GetObjectByTag("ps_lw_12f_patron2") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_patron2", GetLocation(GetWaypointByTag("wp_lw_12f_patronp5")));
		}
   		if(GetObjectByTag("ps_lw_12f_patron4") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_patron4", GetLocation(GetWaypointByTag("wp_lw_12f_patronp6")));
		}
   		if(GetObjectByTag("ps_lw_12f_patron5") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_patron5", GetLocation(GetWaypointByTag("wp_lw_12f_patronp7")));
		}
   		if(GetObjectByTag("ps_lw_12f_waitress") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_waitress", GetLocation(GetWaypointByTag("wp_lw_12f_patronp8")));
		}
   		if(GetObjectByTag("ps_lw_12f_bartender") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_bartender", GetLocation(GetWaypointByTag("wp_lw_12f_bartender")));
		}
   		if(GetObjectByTag("ps_lw_12f_patron6") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_lw_12f_patron6", GetLocation(GetWaypointByTag("wp_lw_12f_patronp9")));
		}
		
		//statues
   		if(GetObjectByTag("ps_prop_factol1") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol1", GetLocation(GetWaypointByTag("wp_prop_factol1")));
		}
   		if(GetObjectByTag("ps_prop_factol2") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol2", GetLocation(GetWaypointByTag("wp_prop_factol2")));
		}
   		if(GetObjectByTag("ps_prop_factol3") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol3", GetLocation(GetWaypointByTag("wp_prop_factol3")));
		}
   		if(GetObjectByTag("ps_prop_factol4") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol4", GetLocation(GetWaypointByTag("wp_prop_factol4")));
		}
   		if(GetObjectByTag("ps_prop_factol5") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol5", GetLocation(GetWaypointByTag("wp_prop_factol5")));
		}
   		if(GetObjectByTag("ps_prop_factol6") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol6", GetLocation(GetWaypointByTag("wp_prop_factol6")));
		}
   		if(GetObjectByTag("ps_prop_factol7") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol7", GetLocation(GetWaypointByTag("wp_prop_factol7")));
		}
   		if(GetObjectByTag("ps_prop_factol8") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol8", GetLocation(GetWaypointByTag("wp_prop_factol8")));
		}
   		if(GetObjectByTag("ps_prop_factol9") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol9", GetLocation(GetWaypointByTag("wp_prop_factol9")));
		}
   		if(GetObjectByTag("ps_prop_factol10") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol10", GetLocation(GetWaypointByTag("wp_prop_factol10")));
		}
   		if(GetObjectByTag("ps_prop_factol11") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factol11", GetLocation(GetWaypointByTag("wp_prop_factol11")));
		}
   		if(GetObjectByTag("ps_prop_factoldustmen") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_prop_factoldustmen", GetLocation(GetWaypointByTag("wp_prop_factoldustmen")));
		}
			
		SetGlobalInt("twelveFactolsLock", 0);
 	}
	
}