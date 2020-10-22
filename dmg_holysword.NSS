#include "ps_inc_functions"



void main()
{
int nType;
	object oTARGET = GetSpellTargetObject();
	if (GetAlignmentGoodEvil(oTARGET) == ALIGNMENT_EVIL)
	{nType = DAMAGE_TYPE_NEGATIVE;
	
	}
	else if (GetAlignmentGoodEvil(oTARGET) == ALIGNMENT_GOOD)
	{
	nType = DAMAGE_TYPE_DIVINE;
	
	}
	else if (GetAlignmentGoodEvil(oTARGET) == ALIGNMENT_NEUTRAL)
	{
	
		nType = DAMAGE_TYPE_MAGICAL;
	
	}
	
	
	effect eDMG = EffectDamage(d6(2), nType);
	eDMG = EffectLinkEffects(eDMG, EffectVisualEffect(VFX_HIT_SPELL_HOLY));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDMG, oTARGET);
}