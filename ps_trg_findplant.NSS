//********************************************
//Lets PC find plants
//Trigger only fires once every 30 minutes (max)
//Find chance based off of Survival, Spot, or if in detect mode, search
//Defaults to the skill with the highest rank
//Important Variables
//DC = the DC of the skill roll
//PlaceToSpawn = tag of the wp to create at
//PlantToSpawn = tag of the placeable to create
//********************************************
#include "ps_inc_training"
#include "ps_inc_functions"

int GetAppropriateSkill(object oPC) {

	int unSkilled = SKILL_SPOT;
	if (GetActionMode(oPC, ACTION_MODE_DETECT)) {
		unSkilled = SKILL_SEARCH;
	}
	
	int unSkilledRank = GetSkillRank(unSkilled, oPC, FALSE)-5;
	int skilledRank = GetSkillRank(SKILL_SURVIVAL, oPC, FALSE);
	
	if (unSkilledRank > skilledRank)
		return unSkilled;
	else
		return SKILL_SURVIVAL;

}

void SpawnPlant(object oTrigger, object oPC) {

	string sWP = PS_GetLocalString(oTrigger, "PlaceToSpawn");
	string sPlant = PS_GetLocalString(oTrigger, "PlantToSpawn");
	
	object oWP = GetWaypointByTag(sWP);
	if (!GetIsObjectValid(oWP))
		return;
		
	CreateObject(OBJECT_TYPE_PLACEABLE, sPlant, GetLocation(oWP));
	
	SendMessageToPC(oPC, "You spot an interesting plant nearby.");

}

void main() {

	object oPC = GetEnteringObject();
	
	int lastDone = CheckTimeStamp();
	
	if (!GetIsPC(oPC))
		return;
	
	if (lastDone < 1800) //happens once per 30 minutes
		return;
	TimeStamp();
		
	if (d100() < 75) //don't have all triggers fire all the time, randomize
		return;
		
	string sPlant = PS_GetLocalString(OBJECT_SELF, "PlantToSpawn");
	object nearbyPlant = GetNearestObjectByTag(sPlant);
	if (GetIsObjectValid(nearbyPlant) && GetDistanceBetween(OBJECT_SELF, nearbyPlant) < 20.0f) //another plant too close!
		return;

	int nSkill = GetAppropriateSkill(oPC);
	int nDC = PS_GetLocalInt(OBJECT_SELF, "DC");
	
	if (nSkill != SKILL_SURVIVAL) //Spot checks have a higher DC
		nDC += 5;
	
	if (GetIsTrainingSkillSuccessful(oPC, nSkill, nDC)) {
		SpawnPlant(OBJECT_SELF, oPC);
	}
		
}