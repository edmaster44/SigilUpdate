#include "ps_inc_functions"

void main () {

	int lastDone = CheckTimeStamp();
	if (lastDone < 60) //happens once per minute
		return;
		
	string sObjTag = "pl_"+GetTag(OBJECT_SELF);
	object oObj = GetNearestObjectByTag(sObjTag);
	if (GetIsObjectValid(oObj))
		return;
		
	//60% chance of this happening
	if (d100() > 40) {
		
		string sWP = "wp_"+GetTag(OBJECT_SELF);
		object oWP = GetWaypointByTag(sWP);
		CreateObject(OBJECT_TYPE_PLACEABLE, "pl_pandemonium_winds", GetLocation(oWP), FALSE, sObjTag);
		
	}
		
	TimeStamp();

}