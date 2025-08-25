#include "x0_i0_transport"
#include "ps_inc_functions"
void main() {

	object oPC = GetPCSpeaker();
	int nRand = Random(4);
	object oWP = GetWaypointByTag("wp_slags_banishment_"+IntToString(nRand));
	
	object oWitch = OBJECT_SELF;
	PlayCustomAnimation(oWitch, "def_cast", 0, 1.0f);
	effect vfx = EffectNWN2SpecialEffectFile("fx_teleport", oPC);
	
	DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, vfx, GetLocation(oPC)));
	DelayCommand(0.75f, TransportToWaypoint(oPC, oWP));
	
	int nRoll = d100();
	effect eEffect;
	if (nRoll < 33) {
		eEffect = EffectDamage(d6(2), DAMAGE_TYPE_FIRE);
		if (ReflexSave(oPC, 15, SAVING_THROW_TYPE_NONE, oWitch) == FALSE) {
			DelayCommand(0.85f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oPC));
		} 
	} else if (nRoll < 66) {
		eEffect = EffectDazed();
		if (WillSave(oPC, 15, SAVING_THROW_TYPE_NONE, oWitch) == FALSE) {
			DelayCommand(0.85f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 3.0f));
		} 
	} else {
		eEffect = EffectNewBlindness();
		if (FortitudeSave(oPC, 15, SAVING_THROW_TYPE_NONE, oWitch) == FALSE) {
			DelayCommand(0.85f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 3.0f));
		} 
	}

}