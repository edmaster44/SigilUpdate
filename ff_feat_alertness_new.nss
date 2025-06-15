#include "x2_inc_spellhook"

void main(){
	object oPC = OBJECT_SELF;
	int nId = GetSpellId();
	
	effect eSpot = EffectSkillIncrease(SKILL_SPOT, 2);
	effect eListen = EffectSkillIncrease(SKILL_LISTEN, 2);
	effect eAlert = EffectLinkEffects(eSpot, eListen);
	eAlert = SupernaturalEffect(eAlert);
	eAlert = SetEffectSpellId(eAlert, nId);
	
	PS_RemoveEffects(oPC, nId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAlert, oPC);
}