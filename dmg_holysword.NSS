#include "ps_inc_functions"
#include "aaa_constants"


void main()
{
	object oTARGET = GetSpellTargetObject();
	int nType = DAMAGE_TYPE_DIVINE;
	
	// just do divine for all 3 + anyone using a wand or scroll. 
	// it's not like divine = good, there's evil and neutral gods.
	//if (GetHasFeat(FEAT_BLACKGUARD,OBJECT_SELF)) nType = DAMAGE_TYPE_NEGATIVE;
	//else if (GetHasFeat(FEAT_PALADIN,OBJECT_SELF))nType = DAMAGE_TYPE_DIVINE;
	//else if (GetHasFeat(FEAT_KNIGHT,OBJECT_SELF)) nType = DAMAGE_TYPE_MAGICAL;
	

	effect eDMG = EffectDamage(d6(2), nType,DAMAGE_POWER_NORMAL,TRUE);
	eDMG = EffectLinkEffects(eDMG, EffectVisualEffect(VFX_HIT_SPELL_HOLY));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDMG, oTARGET);
}