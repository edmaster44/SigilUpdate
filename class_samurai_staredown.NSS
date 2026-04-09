

// script for handling Staredown feats.
#include "ps_class_inc"

void DoStaredownOnTarget(object oTarget, object oPC, int iIntimidate, int iCHA)
{
	int iAffected = GetLocalInt(oTarget, "SAMURAISTAREDOWN");
	effect eEffect;
	if (iAffected != 1)
	{
		if (WillSave(oTarget, iIntimidate, SAVING_THROW_TYPE_FEAR, oPC) == SAVING_THROW_CHECK_FAILED)
		{
			eEffect = EffectACDecrease(2);
			eEffect = EffectLinkEffects(eEffect, EffectAttackDecrease(2));
			eEffect = EffectLinkEffects(eEffect, EffectDamageDecrease(2));
			eEffect = EffectLinkEffects(eEffect, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2));
			eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_SPELL_DOOM));
			eEffect = SupernaturalEffect(eEffect);
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(iCHA));
		}
	
		SetLocalInt(oTarget, "SAMURAISTAREDOWN", 1);
	}
}

void main()
{
	object oTarget;
	object oPC = OBJECT_SELF;
	int iIntimidate = GetSkillRank(SKILL_INTIMIDATE, oPC, FALSE);
	int iCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int iFeat = GetSpellFeatId();
	
	if (iFeat == FEAT_IMP_STAREDOWN || iFeat == FEAT_IMP_MASS_STAREDOWN)
		iIntimidate += 4; // bonus to intimidate for these feats.
	
	if (iFeat == FEAT_STAREDOWN || iFeat == FEAT_IMP_STAREDOWN)
	{
		oTarget = GetSpellTargetObject();
		DoStaredownOnTarget(oTarget, oPC, iIntimidate, iCHA);
	}
	else // must be mass version
	{
		location lPC = GetLocation(oPC);
		oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE, GetPositionFromLocation(lPC));
		
		while (GetIsObjectValid(oTarget))
		{
			if (GetIsEnemy(oTarget))
			{
				DoStaredownOnTarget(oTarget, oPC, iIntimidate, iCHA);
			}
		
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lPC, TRUE, OBJECT_TYPE_CREATURE);
		}
	}
}