#include "ps_inc_functions"




void main()
{
int nType;
	object oTARGET = GetSpellTargetObject();
	if (GetAlignmentGoodEvil(oTARGET) != ALIGNMENT_EVIL)
	{return ;}
	
	effect eDam = EffectDamageOverTime(6,6.0,DAMAGE_TYPE_MAGICAL,TRUE);  
	eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_BLADEWEAVE));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTARGET);
}