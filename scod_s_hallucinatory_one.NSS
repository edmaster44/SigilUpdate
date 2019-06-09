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
	
	//Remove the aoe if the caster isn't present
	if (!GetIsObjectValid(oCaster)) {
		DestroyObject(OBJECT_SELF);
	}
	if (GetArea(oCaster) != GetArea(OBJECT_SELF)) {
		DestroyObject(OBJECT_SELF);
	}
	
	//Basic info
	int nSpellID = GetAreaOfEffectSpellId();
	
	object oTarget = GetEnteringObject();
	if (GetIsEnemy(oTarget, oCaster)) {
		effect eSlow = EffectMovementSpeedDecrease(65);
		effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
		eSlow = EffectLinkEffects(eVis, eSlow);
		SetEffectSpellId(eSlow, nSpellID);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
	} else {
		effect eProtection = EffectACIncrease(4);
		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_SHIELD);
		eProtection = EffectLinkEffects(eVis, eProtection);
		SetEffectSpellId(eProtection, nSpellID);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eProtection, oTarget);
	}
}