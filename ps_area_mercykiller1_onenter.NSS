

void main() {
	object oPC = GetEnteringObject();
  
  	int iLock = GetGlobalInt("Mercykiller1Lock");
   	if ( iLock == 0 ) {
	
  		SetGlobalInt("Mercykiller1Lock", 1); // Only allows one clean up at a time.
		
		object oSpawn;
  		if(GetObjectByTag("mk_prison_frontdoorguard") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_frontdoorguard", GetLocation(GetWaypointByTag("wp_mk_prison_frontdoorguard_1")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_frontdoorguard", GetLocation(GetWaypointByTag("wp_mk_prison_frontdoorguard_2")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_frontdoorguard", GetLocation(GetWaypointByTag("wp_mk_prison_frontdoorguard_3")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_frontdoorguard", GetLocation(GetWaypointByTag("wp_mk_prison_frontdoorguard_4")));   
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_frontdoorguard", GetLocation(GetWaypointByTag("wp_mk_prison_frontdoorguard_5")));   
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_frontdoorguard", GetLocation(GetWaypointByTag("wp_mk_prison_frontdoorguard_6")));   
  		}
		
  		if(GetObjectByTag("mk_prison_visitortechnician") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitortechnician", GetLocation(GetWaypointByTag("wp_mk_prison_visitortechnician_1")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitortechnician", GetLocation(GetWaypointByTag("wp_mk_prison_visitortechnician_2")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitortechnician", GetLocation(GetWaypointByTag("wp_mk_prison_visitortechnician_3")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitortechnician", GetLocation(GetWaypointByTag("wp_mk_prison_visitortechnician_4")));    
  		}
		
  		if(GetObjectByTag("mk_prison_halforc") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_halforc", GetLocation(GetWaypointByTag("wp_mk_prison_halforc_1")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_halforc", GetLocation(GetWaypointByTag("wp_mk_prison_halforc_2")));    
  		}
		
  		if(GetObjectByTag("mk_prisonmain_shooter1") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_mshooter", GetLocation(GetWaypointByTag("wp_mk_prison_mshooter_1")), FALSE, "mk_prisonmain_shooter1");    
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_mshooter", GetLocation(GetWaypointByTag("wp_mk_prison_mshooter_2")), FALSE, "mk_prisonmain_shooter2");  
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_mshooter", GetLocation(GetWaypointByTag("wp_mk_prison_mshooter_3")), FALSE, "mk_prisonmain_shooter3"); 
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_mshooter", GetLocation(GetWaypointByTag("wp_mk_prison_mshooter_4")), FALSE, "mk_prisonmain_shooter4");  
  		}
		
  		if(GetObjectByTag("mk_prison_prisonerbouncer") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_prisonerbouncer", GetLocation(GetWaypointByTag("wp_mk_prison_prisonerbouncer_1")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_prisonerbouncer", GetLocation(GetWaypointByTag("wp_mk_prison_prisonerbouncer_2")));    
  		}
		
		if(GetObjectByTag("mk_prison_smith") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_smith", GetLocation(GetWaypointByTag("wp_mk_prison_smith")));    
  		}
		
		if(GetObjectByTag("mk_prison_squiremale_e") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_squiremale_e", GetLocation(GetWaypointByTag("wp_mk_prison_squiremale_e")));     
  		}
		
		if(GetObjectByTag("mk_prison_justiceofficerb") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_justiceofficerb", GetLocation(GetWaypointByTag("wp_mk_prison_justiceofficerb")));    
  		}
		
		if(GetObjectByTag("mk_prison_showerguy") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_showerguy", GetLocation(GetWaypointByTag("wp_mk_prison_showerguy")));    
  		}
		
		if(GetObjectByTag("mk_prison_marcella") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_marcella", GetLocation(GetWaypointByTag("wp_mk_prison_marcella")));    
  		}
		
		if(GetObjectByTag("mk_prison_receptionistimp") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_receptionistimp", GetLocation(GetWaypointByTag("wp_mk_prison_receptionistimp")));    
  		}
		
		if(GetObjectByTag("mk_prison_receptionist") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_receptionist", GetLocation(GetWaypointByTag("wp_mk_prison_receptionist")));    
  		}
		
		if(GetObjectByTag("mk_prison_justiceofficera") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_justiceofficera", GetLocation(GetWaypointByTag("wp_mk_prison_justiceofficera")));    
  		}
		
		if(GetObjectByTag("mk_prison_justiceofficerb") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_justiceofficerb", GetLocation(GetWaypointByTag("wp_mk_prison_justiceofficerb")));    
  		}
		
		if(GetObjectByTag("mk_prison_prisonerline_start") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_prisonerline_start", GetLocation(GetWaypointByTag("wp_mk_prison_prisonerline_start")));    
  		}
		
		if(GetObjectByTag("mk_prison_visitorentranceguard") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitorentranceguard", GetLocation(GetWaypointByTag("wp_mk_prison_visitorentranceguard_1")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitorentranceguard", GetLocation(GetWaypointByTag("wp_mk_prison_visitorentranceguard_2")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitorentranceguard", GetLocation(GetWaypointByTag("wp_mk_prison_visitorentranceguard_3")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitorentranceguard", GetLocation(GetWaypointByTag("wp_mk_prison_visitorentranceguard_4")));    
  			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitorentranceguard", GetLocation(GetWaypointByTag("wp_mk_prison_visitorentranceguard_5")));    
  		}
		
		if(GetObjectByTag("mk_prison_squirefemale_a") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_squirefemale_a", GetLocation(GetWaypointByTag("wp_mk_prison_squirefemale_a")));    
  		}
		
		if(GetObjectByTag("mk_prison_luprion") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_luprion", GetLocation(GetWaypointByTag("wp_mk_prison_luprion")));    
  		}
		
		if(GetObjectByTag("mk_prison_factioneerclerk") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_factioneerclerk", GetLocation(GetWaypointByTag("wp_mk_prison_factioneerclerk")));    
  		}
		
		if(GetObjectByTag("mk_prison_visitorclerk_exit") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitorclerk_exit", GetLocation(GetWaypointByTag("wp_mk_prison_visitorclerk_exit")));    
  		}
		
		if(GetObjectByTag("mk_prison_visitorclerk_pass") == OBJECT_INVALID) {
   			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mk_prison_visitorclerk_pass", GetLocation(GetWaypointByTag("wp_mk_prison_visitorclerk_pass")));    
  		}
		
  		SetGlobalInt("Mercykiller1Lock", 0);
 	}
}