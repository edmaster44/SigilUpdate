

#include "ps_inc_time"
#include "x0_i0_transport"

void main () {
		
	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC))
		return;
	
	object oEscapeWP = GetWaypointByTag(GetLocalString(OBJECT_SELF, "EscapeWP"));
	int nDC = GetLocalInt(OBJECT_SELF, "ReflexSave");
	string sSuccessMessage = GetLocalString(OBJECT_SELF, "SuccessMessage");
	string sFailMessage = GetLocalString(OBJECT_SELF, "FailMessage");
		
	int nDam = d6(15);
	
	if (ReflexSave(oPC, nDC, SAVING_THROW_TYPE_TRAP)) {
	
		SendMessageToPC(oPC, sSuccessMessage);
		nDam /= 2;
		effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC));
		
	} else {
	
		SendMessageToPC(oPC, sFailMessage);
		effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC));
		
	}
		
	DelayCommand(0.2f, TransportToWaypoint(oPC, oEscapeWP));

}