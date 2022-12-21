#include "ps_inc_functions"
#include "ps_inc_music"

void main() {

	int isHolidays = GetIsChristmas();

 	object oPC = GetEnteringObject();
	string lockVariable = "OOCEnterLock"; //change this to something unique for this area

	SwitchMusic(GetArea(oPC));
	
	//declaring some variables for tidyness
	string sNPCTag;
	string sWPTag;
	object oWP;
	
 	int iLock = GetGlobalInt(lockVariable);
 	if ( iLock == 0 )
 	{
  		SetGlobalInt(lockVariable, 1); // Makes sure the script doesn't retrigger while still running
  
		//*******************************************************
		sNPCTag = "ps_ooc_mimic"; //the resref of the creature to spawn
		sWPTag = "wp_ps_ooc_mimic"; //the tag of the waypoint where the creature should spawn
  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
		
   			oWP = GetWaypointByTag(sWPTag);
   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
			 
  		}
		sNPCTag = "npc_sigis_journalist_ooc"; //the resref of the creature to spawn
		sWPTag = "wp_npc_sigis_journalist_ooc"; //the tag of the waypoint where the creature should spawn
  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
		
   			oWP = GetWaypointByTag(sWPTag);
   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
			 
  		}
		sNPCTag = "ps_npc_mimir"; //the resref of the creature to spawn
		sWPTag = "wp_ps_npc_mimir"; //the tag of the waypoint where the creature should spawn
  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
		
   			oWP = GetWaypointByTag(sWPTag);
   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
			 
  		}
		sNPCTag = "ps_npc_ditchoarsman"; //the resref of the creature to spawn
		sWPTag = "wp_ps_npc_ditchoarsman"; //the tag of the waypoint where the creature should spawn
  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
		
   			oWP = GetWaypointByTag(sWPTag);
   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
			 
  		}
		
		if (isHolidays) {
			sNPCTag = "ps_npc_seasonalxantahelper"; //the resref of the creature to spawn
			sWPTag = "wp_ps_npc_seasonalxantahelper"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			sNPCTag = "ps_npc_seasonalxanta"; //the resref of the creature to spawn
			sWPTag = "wp_ps_npc_seasonalxanta"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			sNPCTag = "ps_npc_seasonalkrampus"; //the resref of the creature to spawn
			sWPTag = "wp_ps_npc_seasonalkrampus"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_CREATURE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			
			//Placeables
			sNPCTag = "plc_oocseasonal_1"; //the resref of the creature to spawn
			sWPTag = "wp_plc_oocseasonal_1"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_PLACEABLE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			
			sNPCTag = "plc_oocseasonal_2"; //the resref of the creature to spawn
			sWPTag = "wp_plc_oocseasonal_2"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_PLACEABLE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			
			sNPCTag = "plc_oocseasonal_3"; //the resref of the creature to spawn
			sWPTag = "wp_plc_oocseasonal_3"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_PLACEABLE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			
			sNPCTag = "plc_oocseasonal_4"; //the resref of the creature to spawn
			sWPTag = "wp_plc_oocseasonal_4"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_PLACEABLE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			
			sNPCTag = "plc_oocseasonal_5"; //the resref of the creature to spawn
			sWPTag = "wp_plc_oocseasonal_5"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_PLACEABLE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			
			sNPCTag = "plc_oocseasonal_6"; //the resref of the creature to spawn
			sWPTag = "wp_plc_oocseasonal_6"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_PLACEABLE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			
			sNPCTag = "plc_christmas_4"; //the resref of the creature to spawn
			sWPTag = "wp_plc_christmas_4"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_PLACEABLE, sNPCTag, GetLocation(oWP));   
				 
	  		}
			
			sNPCTag = "plc_christmas_6"; //the resref of the creature to spawn
			sWPTag = "wp_plc_christmas_6"; //the tag of the waypoint where the creature should spawn
	  		if(GetObjectByTag(sNPCTag) == OBJECT_INVALID) {
			
	   			oWP = GetWaypointByTag(sWPTag);
	   			CreateObject(OBJECT_TYPE_PLACEABLE, sNPCTag, GetLocation(oWP));   
				 
	  		}
		}
		//*******************************************************
		
    
  		SetGlobalInt(lockVariable, 0); //release area for future spawning
 	}
}