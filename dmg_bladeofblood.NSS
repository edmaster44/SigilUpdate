#include "ps_inc_functions"
#include "aaa_constants"

#include "x0_i0_spells"



void main()
{
	float fDur = TurnsToSeconds(PS_GetCasterLevel(OBJECT_SELF));
	object oTarget	= GetSpellTargetObject();
	
	 if (GetHasSpellEffect(SPELL_BLADE_OF_BLOOD, oTarget))
    {
        RemoveEffectsFromSpell(oTarget, SPELL_BLADE_OF_BLOOD);}
		
	if (GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_EVIL)
	{return ;}
	
	
	effect eDam = EffectDamageOverTime(6,6.0,DAMAGE_TYPE_MAGICAL,TRUE);  
	eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_BLADEWEAVE));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget,fDur);
}