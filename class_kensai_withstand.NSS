// DR effect for kensai

#include "ps_class_inc"

void main()
{
	object oPC = OBJECT_SELF;
	int iDur = GetLevelByClass(CLASS_TYPE_KENSAI, oPC);
	int iReduce = GetAbilityScore(oPC, ABILITY_CONSTITUTION, FALSE);
	int iAmount = GetSkillRank(SKILL_CONCENTRATION, oPC, FALSE) * 10;
	
	if (iReduce < 1) return;
	
	effect eDR = EffectDamageReduction(iReduce, DAMAGE_TYPE_ALL, iAmount, DR_TYPE_DMGTYPE);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_VISAGE_GOOD);
	eDR = EffectLinkEffects(eDR, eVis);
	eDR = ExtraordinaryEffect(eDR);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oPC, TurnsToSeconds(iDur));
}