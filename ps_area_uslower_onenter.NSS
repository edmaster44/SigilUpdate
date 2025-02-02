void main() {

 	object oPC = GetEnteringObject();

 	int iLock = GetGlobalInt("UnderLowerEnterLock");
 	if ( iLock == 0 ) {
	
  		SetGlobalInt("UnderLowerEnterLock", 1); // Only allows one clean up at a time.

  		if(GetObjectByTag("ps_quest_squeakers") == OBJECT_INVALID) {
   			object oWP = GetWaypointByTag("wp_quest_squeakers");
   			location lSpawnpoint = GetLocation(oWP);  
   			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_quest_squeakers", lSpawnpoint);    
  		}
   
  		SetGlobalInt("UnderLowerEnterLock", 0);
 	}
	
}