#include "ps_inc_functions"
#include "ps_inc_spawns"
#include "x0_i0_transport"

void SpawnVine(object oPC);
void SpawnGuardian(object oPC);
int DoTrainingReflex(object oPC);

void main () {

	object oPC = GetEnteringObject();
	int nRoll = d100();
	
	int nTime = PS_GetLocalInt(OBJECT_SELF, "last_fired");
	if (GetTime()-nTime < 60)
		return;
		
	if (nRoll <= 5) {
		SendMessageToPC(oPC, "Thorn covered vines whip away from the wall, and try to snatch you!");
		if (!ReflexSave(oPC, 30, SAVING_THROW_TYPE_TRAP)) 
			SpawnVine(oPC);
	} else if (nRoll <= 15) {
		SpawnGuardian(oPC);
	}
	
			
	PS_SetLocalInt(OBJECT_SELF, "last_fired", GetTime());

}

void SpawnGuardian(object oPC) {

	string sWP = PS_GetLocalString(OBJECT_SELF, "guardian_wp");
	object oWP = GetWaypointByTag(sWP);
	if (GetNearestObjectByTag("guardian_1") != OBJECT_INVALID)
		return;
	SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_guardian");
	
}

void SpawnVine(object oPC) {
	
	string sWP = PS_GetLocalString(OBJECT_SELF, "cliff_wp");
	object oWP = GetWaypointByTag(sWP);
	TransportToWaypoint(oPC, oWP);
	
	if (d100() <= 50)
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_assassinvine");
	else
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_greenvise");
		
	effect eEffect = EffectKnockdown();
	DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 1.0f));

}