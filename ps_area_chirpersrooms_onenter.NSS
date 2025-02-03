
void main()
{
	 object oPC = GetEnteringObject();
	
	 int iLock = GetGlobalInt("chirpersRoomsLock");
	 if ( iLock == 0 )
	 {
		  SetGlobalInt("chirpersRoomsLock", 1); // Only allows one clean up at a time.
		
		  
		if(GetObjectByTag("ps_chirpers_gregor") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_chirpers_gregor");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_chirpers_gregor", lSpawnpoint);    
		}
		   
		  SetGlobalInt("chirpersRoomsLock", 0);
	 }
}