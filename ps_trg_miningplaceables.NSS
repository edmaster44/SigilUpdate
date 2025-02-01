#include "ff_safevar"

#include "ps_inc_training"

void CreateMiningPlaceable(object oPC, string sPlac, int nDC, object oLoc, string sSuccess) {

	if (GetIsTrainingSkillSuccessful(oPC, SKILL_SEARCH, nDC)) {
		SendMessageToPC(oPC, sSuccess);
		CreateObject(OBJECT_TYPE_PLACEABLE, sPlac, GetLocation(oLoc), FALSE, "mining_"+GetTag(OBJECT_SELF));
	}
	
}

void main () {

	object oPC = GetEnteringObject();
	string sPlac = PS_GetLocalString(OBJECT_SELF, "mining_placeable");	
	object oLoc = GetWaypointByTag("wp_"+GetTag(OBJECT_SELF));
	int nDC = PS_GetLocalInt(OBJECT_SELF, "mining_dc");
	string sSuccess = PS_GetLocalString(OBJECT_SELF, "mining_success");
	int lastDone = CheckTimeStamp();
	
	if (!GetIsPC(oPC))
		return;
	
	if (lastDone < 1800) //happens once per 30 minutes
		return;
	
	if (GetNearestObjectByTag("mining_"+GetTag(OBJECT_SELF)) != OBJECT_INVALID) //won't respawn anything that already exists
		return;
		
	int nRand = Random(100);
	if (nRand < 50)
		DelayCommand(2.0f, CreateMiningPlaceable(oPC, sPlac, nDC, oLoc, sSuccess));
	else if (nRand < 75) 
		DelayCommand(4.0f, CreateMiningPlaceable(oPC, sPlac, nDC, oLoc, sSuccess));
	else if (nRand < 95) 
		DelayCommand(6.0f, CreateMiningPlaceable(oPC, sPlac, nDC, oLoc, sSuccess));
	else 
		CreateMiningPlaceable(oPC, sPlac, nDC, oLoc, sSuccess);
	
	
	TimeStamp();
	
}