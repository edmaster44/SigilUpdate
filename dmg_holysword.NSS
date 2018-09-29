#include "ps_inc_functions"

void main()
{
	object oTARGET = GetSpellTargetObject();
	if (GetAlignmentGoodEvil(oTARGET) != ALIGNMENT_EVIL) return;
	effect eDMG = EffectDamage(d6(2), DAMAGE_TYPE_DIVINE);
	eDMG = EffectLinkEffects(eDMG, EffectVisualEffect(VFX_HIT_SPELL_HOLY));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDMG, oTARGET);
}