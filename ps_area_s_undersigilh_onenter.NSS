void main() {

 	object oPC = GetEnteringObject();
  
 	int iLock = GetGlobalInt("UndersigilHauntedLock");
 	if ( iLock == 0 ) {
  		SetGlobalInt("UndersigilHauntedLock", 1); // Only allows one clean up at a time.

 		if(GetObjectByTag("ps_us_hauntingspirit") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_ps_us_hauntingspirit");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_us_hauntingspirit", lSpawnpoint);    
  		}
      
  		SetGlobalInt("UndersigilHauntedLock", 0);
 	}
}