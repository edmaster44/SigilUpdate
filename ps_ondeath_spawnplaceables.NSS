#include "ff_safevar"

//A script for creating objects on death. . for instance, chests
//Ideally this should be called from the default ondeath script
//by setting the DeathScript variable on the creature to this script
//
//Variables:
//Placeable_ResRef - the placeable to spawn
//Placeable_Num - the number of placeables to spawn
//The placeables will spawn at waypoints following the naming convention of 
//WP_ + Monster Tag + _#
void main () {

	object oPC = GetLastKiller();
	while (GetIsObjectValid(GetMaster(oPC))) {
   		oPC=GetMaster(oPC);
   	}
	
	string sTag = GetTag(OBJECT_SELF); //basing waypoint naming convention around monster tag
	string sPlac  = PS_GetLocalString(OBJECT_SELF, "Placeable_ResRef");
	int nNum = PS_GetLocalInt(OBJECT_SELF, "Placeable_Num");
	
	if (sPlac == "")
		return;
	
	int n = 0;
	for (n = 0; n < nNum; n++) {
	
		object oWP = GetWaypointByTag("WP_"+sTag+"_"+IntToString(n));
		if (GetIsObjectValid(oWP)) {
			CreateObject(OBJECT_TYPE_PLACEABLE, sPlac, GetLocation(oWP));
		}
	
	}
	
}