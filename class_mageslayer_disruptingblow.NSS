#include "ps_inc_functions"

void main()
{
	object oTarget = GetSpellTargetObject();
	if (PS_GetTargetInRange(OBJECT_SELF, oTarget, GetSpellFeatId(), TRUE))
	{
		effect disruption = EffectSpellFailure(100, SPELL_SCHOOL_GENERAL);
		effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
		effect eDaze = EffectDazed();
		effect eLink = EffectLinkEffects(eMind, eDaze);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, disruption, oTarget, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0f);
		
	}
}