#include "ps_inc_time"
void main() {

	object oTrigger = OBJECT_SELF;
	object oPC = GetLocalObject(oTrigger, "SAVED_PC");
	//SendMessageToPC(oPC, "Running after spawn");
	
	float timeInterval = 6.0f;
	/*int lastDone = PS_GetTimestamp_Age_Seconds(oTrigger, "afterspawn_check");
	
	if (lastDone < FloatToInt(timeInterval)) //happens once per 6 seconds
		return;*/
	//SendMessageToPC(oPC, "Valid time");
	
	string sMonster1 = GetLocalString(oTrigger, "M1");
	string sMonster2 = GetLocalString(oTrigger, "M2");
	
	//Check to see if there are monsters left
	if (sMonster1 != "") {
		//SendMessageToPC(oPC, "Checking for "+sMonster1+".");
		object oMonster1 = GetNearestObjectByTag(sMonster1);
		if (GetIsObjectValid(oMonster1)) {
			DelayCommand(timeInterval, ExecuteScript("ps_afterspawn_createcreature", OBJECT_SELF));
			return;
		}
		oMonster1 = GetNearestObjectByTag(sMonster1+"2");
		if (GetIsObjectValid(oMonster1)) {
			DelayCommand(timeInterval, ExecuteScript("ps_afterspawn_createcreature", OBJECT_SELF));
			return;
		}
		oMonster1 = GetNearestObjectByTag(sMonster1+"3");
		if (GetIsObjectValid(oMonster1)) {
			DelayCommand(timeInterval, ExecuteScript("ps_afterspawn_createcreature", OBJECT_SELF));
			return;
		}
	}
		
	if (sMonster2 != "") {
		//SendMessageToPC(oPC, "Checking for "+sMonster2+".");
		object oMonster1 = GetNearestObjectByTag(sMonster2);
		if (GetIsObjectValid(oMonster1)) {
			DelayCommand(timeInterval, ExecuteScript("ps_afterspawn_createcreature", OBJECT_SELF));
			return;
		}
		oMonster1 = GetNearestObjectByTag(sMonster2+"2");
		if (GetIsObjectValid(oMonster1)) {
			DelayCommand(timeInterval, ExecuteScript("ps_afterspawn_createcreature", OBJECT_SELF));
			return;
		}
		oMonster1 = GetNearestObjectByTag(sMonster2+"3");
		if (GetIsObjectValid(oMonster1)) {
			DelayCommand(timeInterval, ExecuteScript("ps_afterspawn_createcreature", OBJECT_SELF));
			return;
		}
	}
	
	//Probably no monsters left, spawning creature
	
	string sCreatureToSpawn = GetLocalString(oTrigger, "CreatureToSpawn");
	string sWP = GetLocalString(oTrigger, "WaypointToUse");
	
	//SendMessageToPC(oPC, "Spawning "+sCreatureToSpawn+" at "+sWP);
	if (sCreatureToSpawn != "" && sWP != "") {
		object oWP = GetWaypointByTag(sWP);
		if (GetIsObjectValid(oWP)) {
			object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sCreatureToSpawn, GetLocation(oWP));
			DeleteLocalInt(oTrigger, "afterspawn_check");
		}
	}

}