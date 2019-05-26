//::///////////////////////////////////////////////
//:: Distracted Script - for the spell effects which 
//:: need to be broken by damage
//:: [scod_s_creature_distracted.nss]
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-10-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"

void main () {

	int nDamage = GetTotalDamageDealt();
	SpeakString("Total damage recieved: "+IntToString(nDamage), TALKVOLUME_SHOUT);
	if (nDamage <= 0)
		return;

	effect eEffect = GetFirstEffect(OBJECT_SELF);
	while (GetIsEffectValid(eEffect)) {
		if (GetEffectType(eEffect) == EFFECT_TYPE_DAZED || 
		GetEffectSpellId(eEffect) == SPELL_RAINBOW_DWEOMER || 
		GetEffectSpellId(eEffect) == SPELL_HYPNOTISM) {
			SpeakString("distraction removed!", TALKVOLUME_SHOUT);
			RemoveEffect(OBJECT_SELF, eEffect);
		}
			
		eEffect = GetNextEffect(OBJECT_SELF);
	}

	//Remove me after I've been called
	SetLocalString(OBJECT_SELF, "DamagedScript", "");
}