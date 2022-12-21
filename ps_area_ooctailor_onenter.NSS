void main() {

	int isHolidays = TRUE; //do something more sophisticated later

 	object oPC = GetEnteringObject();
	string lockVariable = "OOCEnterLock"; //change this to something unique for this area
	
	//declaring some variables for tidyness
	string sNPCTag;
	string sWPTag;
	object oWP;
	
 	int iLock = GetGlobalInt(lockVariable);
 	if ( iLock == 0 )
 	{
  		SetGlobalInt(lockVariable, 1); // Makes sure the script doesn't retrigger while still running
  
		//*******************************************************
		sNPCTag = "ps_npc_oocbarber"; //the resref of the creature to spawn
		sWPTag = "wp_ps_npc_oocbarber"; //the tag of the waypoint where the creature should spawn
  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
		
   			oWP = GetWaypointByTag(sWPTag);
   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
			 
  		}
		sNPCTag = "ps_heightadjust"; //the resref of the creature to spawn
		sWPTag = "wp_ps_heightadjust"; //the tag of the waypoint where the creature should spawn
  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
		
   			oWP = GetWaypointByTag(sWPTag);
   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
			 
  		}
		sNPCTag = "ps_npc_oocroommerchant"; //the resref of the creature to spawn
		sWPTag = "wp_ps_npc_oocroommerchant"; //the tag of the waypoint where the creature should spawn
  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
		
   			oWP = GetWaypointByTag(sWPTag);
   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
			 
  		}
		//*******************************************************
		
    
  		SetGlobalInt(lockVariable, 0); //release area for future spawning
 	}
}