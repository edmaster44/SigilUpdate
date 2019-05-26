//::///////////////////////////////////////////////
//:: Hallucinatory Terrain - On enter
//:: [ps_s_hallucinatory_one.nss]
//:://////////////////////////////////////////////
//:: Applies the penalties / boni of Hallucinatory Terrain
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-17-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "ps_inc_time"

void main() {

	//debug code to make sure we got here
	object oCaster = GetAreaOfEffectCreator();
	SendMessageToPC(oCaster, "Hallucinatory Terrain on exit");
	
	//Remove the aoe if the caster isn't present
	if (!GetIsObjectValid(oCaster)) {
		DestroyObject(OBJECT_SELF);
	}
	if (GetArea(oCaster) != GetArea(OBJECT_SELF)) {
		DestroyObject(OBJECT_SELF);
	}
	
	//Basic info
	int nSpellID = GetAreaOfEffectSpellId();
	
	object oTarget = GetExitingObject();
	if (GetHasSpellEffect(nSpellID, oTarget)) {
		effect eRemove = GetEffectBySpellID(oTarget, nSpellID);
		RemoveEffect(oTarget, eRemove);
	}
}