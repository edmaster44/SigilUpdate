// instill power in another effect for kensai

#include "ps_class_inc"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	
	if (oTarget == oPC)
	{
		SendMessageToPC(oPC, "You can't use this ability on yourself");
		return;
	}
	
	int iBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	
	if (iBonus < 1) return;
	
	int iDur = GetSkillRank(SKILL_CONCENTRATION, oPC, FALSE);
	effect eVisImp = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_LESSER_VISAGE);
	effect eBonus = EffectLinkEffects(eVis, EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus, SAVING_THROW_TYPE_ALL, FALSE));
	eBonus = EffectLinkEffects(eBonus, EffectACIncrease(iBonus, AC_DODGE_BONUS));
	eBonus = EffectLinkEffects(eBonus, EffectAttackIncrease(iBonus));
	eBonus = ExtraordinaryEffect(eBonus);
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisImp, oTarget);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oTarget, RoundsToSeconds(iDur));
}