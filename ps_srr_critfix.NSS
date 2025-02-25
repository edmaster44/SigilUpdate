#include "x2_inc_spellhook"

void main()
{
	
    object oTarget = GetSpellTargetObject();
	int deathlessMasteryId = 2617;
	
	effect eCritImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);

	eCritImmune = SupernaturalEffect(eCritImmune);
	eCritImmune = SetEffectSpellId(eCritImmune, deathlessMasteryId);
	
	PS_RemoveEffects(oTarget, deathlessMasteryId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCritImmune, oTarget);
	
}