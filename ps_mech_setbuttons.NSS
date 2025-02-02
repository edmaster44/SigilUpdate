#include "ff_safevar"

void SpawnOrbsForGroup(object oHolder, string sButton) {

	string sFire = "pl_mechanus_fire";
	string sAir = "pl_mechanus_air";
	string sEarth = "pl_mechanus_earth";
	string sWater = "pl_mechanus_water";
	
	int n = 0;
	for(n = 1; n < 5; n++) {
		
		string sWP = "wp_mechanus_"+sButton+IntToString(n);
		object oWP = GetWaypointByTag(sWP);
		string sVar = sButton+IntToString(n);
		int nElement = PS_GetLocalInt(oHolder, sVar);
		if (nElement == 0) {
			CreateObject(OBJECT_TYPE_PLACEABLE, sFire, GetLocation(oWP));
		} else if (nElement == 1) {
			CreateObject(OBJECT_TYPE_PLACEABLE, sAir, GetLocation(oWP));
		} else if (nElement == 2) {
			CreateObject(OBJECT_TYPE_PLACEABLE, sEarth, GetLocation(oWP));
		} else {
			CreateObject(OBJECT_TYPE_PLACEABLE, sWater, GetLocation(oWP));
		}
	
	}

}

void SpawnHints(object oHolder) {

	SpawnOrbsForGroup(oHolder, "firebutton");
	SpawnOrbsForGroup(oHolder, "airbutton");
	SpawnOrbsForGroup(oHolder, "earthbutton");
	SpawnOrbsForGroup(oHolder, "waterbutton");

}

void SetButtonValues(object oHolder, int nStarter, string sButton) {

	PS_SetLocalInt(oHolder, sButton+"1", nStarter);
	int nRand = Random(4);
	PS_SetLocalInt(oHolder, sButton+"2", nRand);
	nRand = Random(4);
	PS_SetLocalInt(oHolder, sButton+"3", nRand);
	nRand = Random(4);
	PS_SetLocalInt(oHolder, sButton+"4", nRand);
	
}

void main () {
	
	object oHolder = GetNearestObjectByTag("pl_mechanus_controlpanel");
	
	if (PS_GetLocalInt(oHolder, "buttonsSet") > 0)
		return;
	PS_SetLocalInt(oHolder, "buttonsSet", 1);
	
	//Set buttons
	//Values are sequential so that they are never repeated
	int nRand = Random(4);
	SetButtonValues(oHolder, nRand, "firebutton");
	nRand = (nRand+1)%4;
	SetButtonValues(oHolder, nRand, "airbutton");
	nRand = (nRand+1)%4;
	SetButtonValues(oHolder, nRand, "earthbutton");
	nRand = (nRand+1)%4;
	SetButtonValues(oHolder, nRand, "waterbutton");
	
	SpawnHints(oHolder);

}