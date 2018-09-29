// banzai charge for Ronin

#include "ps_class_inc"

void main()
{
	object oPC = OBJECT_SELF;
	int iFeat = GetSpellFeatId();
	
	effect eBoost;
	effect eAttack;
	effect ePenalty;

	int iLevel = GetLevelByClass(CLASS_TYPE_RONIN, oPC);
	
	if (iFeat == FEAT_BANZAI_CHARGE)
	{
		eAttack = EffectModifyAttacks(1);
		eBoost = EffectMovementSpeedIncrease(50);
		ePenalty = EffectMovementSpeedDecrease(50);
		ePenalty = EffectLinkEffects(ePenalty, EffectACDecrease(4, AC_DODGE_BONUS));
		ePenalty = EffectLinkEffects(ePenalty, EffectVisualEffect(VFX_DUR_SPELL_SLOW));
	}
	else // improved version
	{
		eAttack = EffectModifyAttacks(2);
		eBoost = EffectMovementSpeedIncrease(99);
	}
	
	effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
	effect eVisDur = EffectVisualEffect(VFX_DUR_SPELL_HASTE);
	
	eAttack = EffectLinkEffects(eAttack, EffectMaxDamage());
	eAttack = EffectLinkEffects(eAttack, EffectAttackIncrease(iLevel));
	eAttack = ExtraordinaryEffect(eAttack);
	
	eBoost = ExtraordinaryEffect(EffectLinkEffects(eVisDur, eBoost));
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBoost, oPC, RoundsToSeconds(2));
	DelayCommand(RoundsToSeconds(1),ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, RoundsToSeconds(1)));
	
	if (iFeat == FEAT_BANZAI_CHARGE)
	{
		DelayCommand(RoundsToSeconds(2), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenalty, oPC, RoundsToSeconds(1)));
		DelayCommand(RoundsToSeconds(2), ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW), oPC));
	}
}