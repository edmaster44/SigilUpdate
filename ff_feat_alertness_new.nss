#include "x2_inc_spellhook"

void main(){
	object oPC = OBJECT_SELF;
	int nId = GetSpellId();
	
	effect eAlert = EffectSkillIncrease(SKILL_SPOT, 2);
	eAlert = EffectLinkEffects(EffectSkillIncrease(SKILL_LISTEN, 2), eAlert);
	eAlert = SupernaturalEffect(eAlert);
	eAlert = SetEffectSpellId(eAlert, nId);
	
	PS_RemoveEffects(oPC, nId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAlert, oPC);
}