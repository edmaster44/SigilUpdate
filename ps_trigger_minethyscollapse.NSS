

#include "ps_inc_time"
#include "x0_i0_transport"

void main () {
		
	object oPC = GetEnteringObject();
	SendMessageToPC(oPC, "Walking over trigger.");

	//if (PS_GetTimestamp_Age_Minutes(OBJECT_SELF, "last_triggered") < 10)
	//	return;
	SendMessageToPC(oPC, "Checking.");
	
	object oTargetWP = GetWaypointByTag(GetLocalString(OBJECT_SELF, "TargetWP"));
	object oEscapeWP = GetWaypointByTag(GetLocalString(OBJECT_SELF, "EscapeWP"));
		
	if (d100() < 25) { //25% of a given trap triggering
	
		effect eVFX = EffectNWN2SpecialEffectFile("fx_wooden_explosion_big");
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, GetLocation(oPC));
		
		if (ReflexSave(oPC, 25, SAVING_THROW_TYPE_TRAP)) {
			SendMessageToPC(oPC, "The sand gives way beneath you, but you make it to stable ground.");
			DelayCommand(0.2f, TransportToWaypoint(oPC, oEscapeWP));
		} else {
			SendMessageToPC(oPC, "The sand gives way beneath you, and you fall down to a lower level.");
			DelayCommand(0.2f, TransportToWaypoint(oPC, oTargetWP));
			
			int nDam = d6(6);
			effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC));
		}
	
	}

	PS_Timestamp_UNIX(OBJECT_SELF, "last_triggered");

}