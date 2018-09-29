// Functions for Tattooed Monk
// By Agony/Loki

#include "ps_class_inc"
#include "x0_i0_position"


effect MakeTattooEffect(int iFeat, object oPC, int iLevel)
{
	effect eEffect;
	 
	switch (iFeat)
	{
		case FEAT_TATTOO_PHOENIX: eEffect = EffectHealOnZeroHP(oPC, 20*iLevel); break;
		case FEAT_TATTOO_BULL: eEffect = EffectAbilityIncrease(ABILITY_STRENGTH, 6); break;
		case FEAT_TATTOO_CAT: eEffect = EffectAbilityIncrease(ABILITY_DEXTERITY, 6); break;
		case FEAT_TATTOO_BEAR: eEffect = EffectAbilityIncrease(ABILITY_CONSTITUTION, 6); break;
		case FEAT_TATTOO_FOX: eEffect = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 6); break;
		case FEAT_TATTOO_OWL: eEffect = EffectAbilityIncrease(ABILITY_WISDOM, 6); break;
		case FEAT_TATTOO_EAGLE: eEffect = EffectAbilityIncrease(ABILITY_CHARISMA, 6); break;
		case FEAT_TATTOO_SKULL: eEffect = EffectSavingThrowIncrease(SAVING_THROW_ALL, 10, SAVING_THROW_TYPE_DEATH, FALSE); break;
		case FEAT_TATTOO_DRAGON_GOLD: eEffect = EffectDamageResistance(DAMAGE_TYPE_FIRE, 30, 0); break;
		case FEAT_TATTOO_DRAGON_WHITE: eEffect = EffectDamageResistance(DAMAGE_TYPE_COLD, 30, 0); break;
		case FEAT_TATTOO_DRAGON_BLACK: eEffect = EffectDamageResistance(DAMAGE_TYPE_ACID, 30, 0); break;
		case FEAT_TATTOO_DRAGON_BRONZE: eEffect = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 30, 0); break;
		case FEAT_TATTOO_LOTUS: eEffect = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS); break;
		case FEAT_TATTOO_ANGEL: eEffect = EffectACIncrease(7, AC_DEFLECTION_BONUS); eEffect = VersusAlignmentEffect(eEffect,ALIGNMENT_ALL, ALIGNMENT_EVIL); break;
		case FEAT_TATTOO_FIEND: eEffect = EffectACIncrease(7, AC_DEFLECTION_BONUS); eEffect = VersusAlignmentEffect(eEffect,ALIGNMENT_ALL, ALIGNMENT_GOOD); break;
		case FEAT_TATTOO_SPIDER:
			{
				eEffect = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    			eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
    			eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_SLOW));
    			eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
				eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_POISON));
			}
			break;
		case FEAT_TATTOO_TREE: eEffect = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN); break;
		case FEAT_TATTOO_LIZARD: eEffect = EffectRegenerate(iLevel, 12.0); break;
		case FEAT_TATTOO_TORTOISE: eEffect = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS); break;
		case FEAT_TATTOO_BUTTERFLY: eEffect = EffectACIncrease(4, AC_DODGE_BONUS); break;
		case FEAT_TATTOO_EYES: eEffect = EffectSeeInvisible(); eEffect = EffectLinkEffects(eEffect, EffectSkillIncrease(SKILL_SPOT, 5)); break;
		case FEAT_TATTOO_BLINKDOG: eEffect = EffectDisappearAppear(GetRandomLocation(GetArea(oPC), oPC, 10.0)); break;
		case FEAT_TATTOO_FLAMEHAND: eEffect = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE); eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_INVOCATION_BRIMSTONE_BLOW)); break;
		case FEAT_TATTOO_FROZENHAND: eEffect = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD); eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_INVOCATION_HELLRIME_BLOW)); break;
		case FEAT_TATTOO_ELECTRICHAND: eEffect = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_ELECTRICAL); eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_INVOCATION_UTTERDARK_BLOW)); break;
		case FEAT_TATTOO_CORRODINGHAND: eEffect = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_ACID); eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_INVOCATION_VITRIOLIC_BLOW)); break;
		case FEAT_TATTOO_GHOST: eEffect = EffectInvisibility(INVISIBILITY_TYPE_NORMAL); eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_INVISIBILITY)); break;
		case FEAT_TATTOO_CHAMELEON: eEffect = EffectConcealment(5*iLevel); break;
		case FEAT_TATTOO_DOVE:  eEffect = EffectSanctuary(10 + iLevel*2); eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_SPELL_SANCTUARY)); break;
		case FEAT_TATTOO_ALOEVERA: eEffect = EffectHeal(d20(iLevel)); eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_IMP_HEALING_M)); break;
		case FEAT_TATTOO_MAGICCIRCLE: eEffect = EffectSpellLevelAbsorption(9, d6(iLevel)); break;
		case FEAT_TATTOO_HEART: eEffect = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2, SAVING_THROW_TYPE_ALL);
	}
	
	eEffect = ExtraordinaryEffect(eEffect);
	return eEffect;
}

int GetTattooDurationType(int iFeat)
{
	int iRet;
	
	switch (iFeat)
	{
		case FEAT_TATTOO_ALOEVERA:
		case FEAT_TATTOO_BLINKDOG:
			iRet = DURATION_TYPE_INSTANT; break;
		case FEAT_TATTOO_FLAMEHAND:
		case FEAT_TATTOO_FROZENHAND:
		case FEAT_TATTOO_ELECTRICHAND:
		case FEAT_TATTOO_CORRODINGHAND:
		case FEAT_TATTOO_CHAMELEON:
		case FEAT_TATTOO_GHOST:
		case FEAT_TATTOO_DOVE:
			iRet = DURATION_TYPE_TEMPORARY; break;
		default: iRet = DURATION_TYPE_PERMANENT; break;
	}
	
	return iRet;
}

// most tattoos are persistent, but some have durations, so this gets the duration.
float GetTattooDuration(int iFeat)
{
	float fRet;
	int iLevel = GetLevelByClass(CLASS_TYPE_TATOOMONK, OBJECT_SELF);
	int iWis = GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);
	
	switch (iFeat)
	{
		case FEAT_TATTOO_FLAMEHAND:
		case FEAT_TATTOO_FROZENHAND:
		case FEAT_TATTOO_ELECTRICHAND:
		case FEAT_TATTOO_CORRODINGHAND:
		case FEAT_TATTOO_CHAMELEON:
			fRet = RoundsToSeconds(iLevel + iWis); break; // 1 round/level
		case FEAT_TATTOO_GHOST:
		case FEAT_TATTOO_DOVE:
			fRet = RoundsToSeconds(iWis * 10); break; // 1 min/level
		default: fRet = 0.0; break;
	}
	
	return fRet;
}

// checks id of feat/spell and then calls appropriate function
void main()
{
	object oPC = OBJECT_SELF;
	
	int iFeat = GetSpellFeatId();
	int iSpell = GetSpellId();
	int iLevel = GetLevelByClass(CLASS_TYPE_TATOOMONK, oPC);
	
	if (GetHasSpellEffect(iSpell, oPC))
	{
		return;
	}
	else
	{
		// check to make sure no weapon equipped when using these feats
		if (iFeat >= FEAT_TATTOO_FLAMEHAND && iFeat <= FEAT_TATTOO_CORRODINGHAND && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))
		{
			SendMessageToPC(oPC, "<color=red>This feat will not work with a weapon equipped");
		}
		else
		{
			effect eEffect = MakeTattooEffect(iFeat, oPC, iLevel);
			int iDurationType = GetTattooDurationType(iFeat);
			float fDuration = GetTattooDuration(iFeat);
			
			ApplyEffectToObject(iDurationType, eEffect, oPC, fDuration);
		}
	}
}