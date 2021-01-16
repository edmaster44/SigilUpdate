#include "ps_inc_time"
void main() {

	object oTrigger = OBJECT_SELF;
	SpeakString("Running after spawn", TALKVOLUME_SHOUT);
	
	int lastDone = PS_GetTimestamp_Age_Seconds(oTrigger, "afterspawn_check");
	float timeInterval = 6.0f;
	
	if (lastDone < FloatToInt(timeInterval)) //happens once per 6 seconds
		return;
	
	string sMonster1 = GetLocalString(oTrigger, "M1");
	string sMonster2 = GetLocalString(oTrigger, "M2");
	
	//Check to see if there are monsters left
	if (sMonster1 != "") {
		SpeakString("Checking for "+sMonster1+".", TALKVOLUME_SHOUT);
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
		SpeakString("Checking for "+sMonster2+".", TALKVOLUME_SHOUT);
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
	
	if (sCreatureToSpawn != "" && sWP != "") {
		object oWP = GetWaypointByTag(sWP);
		if (GetIsObjectValid(oWP)) {
			object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sCreatureToSpawn, GetLocation(oWP));
			DeleteLocalInt(oTrigger, "afterspawn_check");
		}
	}

}