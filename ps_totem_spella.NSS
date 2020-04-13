#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_totem_constants"

void main()
{
	object oCreator = GetAreaOfEffectCreator(OBJECT_SELF);
	int nAoeSpellId = GetAreaOfEffectSpellId(OBJECT_SELF);
	
	object oTarget = GetEnteringObject();
	int nSaveDC = GetSpellSaveDC();
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);

	switch(nAoeSpellId) {
	case SPELL_ID_TOTEM_RESISTANCE:
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_RESISTANCE, FALSE));
			int nBonus = GetTotemScaledEffect(oCreator, nCasterLevel);
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_RESISTANCE);
			effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
			effect eLinked = EffectLinkEffects(eSave, eVis);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinked, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
		}
		break;
	case SPELL_ID_TOTEM_BLINDING:
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_BLINDING, TRUE));
			if(!(GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS) || GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))) {
				effect eBlind =  EffectBlindness();
				effect eDeaf = EffectDeaf();
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLIND_DEAF);
				effect eLink = EffectLinkEffects(eBlind, eDeaf);
				eLink = EffectLinkEffects(eLink, eVis);
				if (!MyResistSpell(oCreator, oTarget)) {
					if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC)) {
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
					}
				}
			}
		}
		break;
	case SPELL_ID_TOTEM_DESPAIR:
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_DESPAIR, TRUE));
			if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)) {
				int nAmount = GetTotemScaledEffect(oCreator, nCasterLevel);
				effect eDamagePenalty = EffectDamageDecrease(nAmount);
				effect eAttackPenalty = EffectAttackDecrease(nAmount);
				effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, nAmount, SAVING_THROW_TYPE_ALL);
				effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, nAmount);
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CRUSHING_DESP);
				effect eLink = EffectLinkEffects(eDamagePenalty, eAttackPenalty);
				eLink = EffectLinkEffects(eLink, eSave);
				eLink = EffectLinkEffects(eLink, eSkill);
				eLink = EffectLinkEffects(eLink, eVis);
				if (!MyResistSpell(oCreator, oTarget)) {
					if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC)) {
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
					}
				}
			}
		}
		break;
	case SPELL_ID_TOTEM_SHELTERING:
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_SHELTERING, FALSE));
			int nMulti = nCasterLevel / 3;
			nMulti = LimitToWisBonus(oCreator, nMulti);
			int nResistance = 10 + nMulti * 10;
			effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance);
			effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance);
			effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance);
			effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance);
			effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance);
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_RESIST_ENERGY);
			effect eLinked = EffectLinkEffects(eCold, eFire);
			eLinked = EffectLinkEffects(eLinked, eAcid);
			eLinked = EffectLinkEffects(eLinked, eSonic);
			eLinked = EffectLinkEffects(eLinked, eElec);
			eLinked = EffectLinkEffects(eLinked, eVis);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinked, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
		}
		break;
	case SPELL_ID_TOTEM_HARDINESS:
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_HARDINESS, FALSE));
			int nMulti = nCasterLevel / 5;
			nMulti = LimitToWisBonus(oCreator, nMulti);
			int nResistance = 5 + nMulti * 5;
			effect eStone = EffectDamageReduction(nResistance, GMATERIAL_METAL_ADAMANTINE);
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_STONEBODY);
			effect eLinked = EffectLinkEffects(eStone, eVis);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinked, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
		}
		break;
	case SPELL_ID_TOTEM_SLOWING:
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_SLOWING, TRUE));
			effect eSlow = EffectSlow();
			effect eVis = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
			effect eLink = EffectLinkEffects(eSlow, eVis);
			if (!MyResistSpell(oCreator, oTarget)) {
				if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC)) {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
				}
			}
		}
		break;
	case SPELL_ID_TOTEM_NAUSEA:
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_NAUSEA, TRUE));
			if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON)) {
				effect eStink = EffectDazed();
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_DAZE);
				effect eLink = EffectLinkEffects(eStink, eVis);
				if (!MyResistSpell(oCreator, oTarget)) {
					if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_POISON)) {
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
					}
				}
			}
		}
		break;
	case SPELL_ID_TOTEM_SWIFTNESS:
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_SWIFTNESS, FALSE));
			effect eHaste = EffectHaste();
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HASTE);
			effect eLinked = EffectLinkEffects(eHaste, eVis);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinked, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
		}
		break;
	case SPELL_ID_TOTEM_SERENITY:
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_SERENITY, FALSE));
			int bValid;
			effect eSearch = GetFirstEffect(oTarget);
			while(GetIsEffectValid(eSearch)) {
				bValid = FALSE;
				if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED) {
					bValid = TRUE;
				} else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED) {
					bValid = TRUE;
				} else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP) {
					bValid = TRUE;
				} else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED) {
					bValid = TRUE;
				} else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED) {
					bValid = TRUE;
				} else if(GetEffectType(eSearch) == EFFECT_TYPE_DOMINATED) {
					bValid = TRUE;
				} else if (GetEffectSpellId(eSearch) == SPELL_FEEBLEMIND) {
					bValid = TRUE;
				} else if (GetEffectSpellId(eSearch) == SPELL_BANE) {
					bValid = TRUE;
				}
				if (bValid == TRUE) {
					RemoveEffect(oTarget, eSearch);
				}
				eSearch = GetNextEffect(oTarget);
			}
			effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
			effect eVis = EffectVisualEffect(VFX_DUR_SPELL_LESSER_MIND_BLANK);
			effect eLinked = EffectLinkEffects(eImm1, eVis);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinked, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
		}
		break;
	}

}