//::///////////////////////////////////////////////
//:: For Painful Sleep of Ages - does the damage
//:: to monsters when they wake up
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 9-2-2020
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"

void main () {

	int nDamage = GetTotalDamageDealt();
	if (nDamage < 0)
		return;
		
	int nAwake = GetLocalInt(OBJECT_SELF, "AWAKEN_DICE");
	if (nAwake <= 2)
		nAwake = 2;

	effect eEffect = GetFirstEffect(OBJECT_SELF);
	while (GetIsEffectValid(eEffect)) {
		if (GetEffectType(eEffect) == EFFECT_TYPE_SLEEP && 
		GetEffectSpellId(eEffect) == SPELL_SLEEP_OF_AGES) {
			RemoveEffect(OBJECT_SELF, eEffect);
		}
			
		eEffect = GetNextEffect(OBJECT_SELF);
	}
	
	//Do the damage
	effect eDamage = EffectDamage(d6(nAwake));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF);

	//Remove me after I've been called
	SetLocalString(OBJECT_SELF, "DamagedScript", "");
}