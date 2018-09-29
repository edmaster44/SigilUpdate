// Power surge feat for kensai

#include "ps_class_inc"

void main()
{
	object oPC = OBJECT_SELF;
	
	int iCheck = GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, 15, TRUE);
	
	if (iCheck == TRUE)
	{
		effect eSTR = ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_STRENGTH, 8));
		int iDur = GetLevelByClass(CLASS_TYPE_KENSAI, oPC);
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSTR, oPC, RoundsToSeconds(iDur));
	}
	else
	{
		SendMessageToPC(oPC, "<color=yellow>You failed to focus your energies");
	}
}