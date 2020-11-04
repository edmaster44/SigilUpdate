#include "ps_inc_functions"
#include "aaa_constants"


void main()
{
int nType;
	object oTARGET = GetSpellTargetObject();
	if (GetHasFeat(FEAT_BLACKGUARD,OBJECT_SELF))
	{nType = DAMAGE_TYPE_NEGATIVE;
	
	}
	else if (GetHasFeat(FEAT_PALADIN,OBJECT_SELF)) 
	{
	nType = DAMAGE_TYPE_DIVINE;
	
	}
	else if (GetHasFeat(FEAT_KNIGHT,OBJECT_SELF)) 
	{
	
		nType = DAMAGE_TYPE_MAGICAL;
	
	}
	
	
	effect eDMG = EffectDamage(d6(2), nType);
	eDMG = EffectLinkEffects(eDMG, EffectVisualEffect(VFX_HIT_SPELL_HOLY));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDMG, oTARGET);
}