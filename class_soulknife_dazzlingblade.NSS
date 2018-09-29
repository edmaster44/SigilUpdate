// Dazzling Blade feat script for the Soulknife class
// Blinds surrounding ennemies, or gives them an attack penalty if they make the save
// By Electrohydra
// Last Edited : 20/08/15

#include "class_soulknife_global"

void main()
{
	object oPC = OBJECT_SELF;
	if (!GetUsingMindblade(oPC))
	{
		return;
	}
	int level = GetLevelByClass(SOULKNIFE_ID, oPC);
	int CHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int DC = 10 + CHA + (level+1) / 2;
	
	effect blind = EffectBlindness();
	effect vfxblind = EffectVisualEffect(VFX_DUR_BLIND);
	effect blindlink = ExtraordinaryEffect(EffectLinkEffects(blind, vfxblind));
	
	effect attackPenalty = EffectAttackDecrease(2);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
	
	while (GetIsObjectValid(oTarget))
	{
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(oTarget, oPC))
		{
			if (!FortitudeSave(oTarget, DC))
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, blindlink, oTarget, RoundsToSeconds(CHA));
			}
			else
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY,attackPenalty, oTarget, RoundsToSeconds(CHA));
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
	}
}