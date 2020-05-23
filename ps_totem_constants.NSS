#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

const int SPELL_ID_TOTEM_RESISTANCE = 13000;
const int SPELL_ID_TOTEM_HEALING = 13001;
const int SPELL_ID_TOTEM_BLINDING = 13002;
const int SPELL_ID_TOTEM_DESPAIR = 13003;
const int SPELL_ID_TOTEM_SHELTERING = 13004;
const int SPELL_ID_TOTEM_HARDINESS = 13005;
const int SPELL_ID_TOTEM_SLOWING = 13006;
const int SPELL_ID_TOTEM_NAUSEA = 13007;
const int SPELL_ID_TOTEM_SWIFTNESS = 13008;
const int SPELL_ID_TOTEM_SERENITY = 13009;
const int SPELL_ID_TOTEM_CLEANSING = 13010;
const int SPELL_ID_TOTEM_BREACHING = 13011;
const int SPELL_ID_TOTEM_UNDEAD_HEALING = 13012;
const int SPELL_ID_ANCESTRAL_TOTEM = 13014;
const int SPELL_ID_TOTEM_PARALYSIS = 13015;
const int SPELL_ID_TOTEM_PETRIFICATION = 13016;

const int VFX_PER_TOTEM_RESISTANCE = 200;
const int VFX_PER_TOTEM_HEALING = 201;
const int VFX_PER_TOTEM_BLINDING = 202;
const int VFX_PER_TOTEM_DESPAIR = 203;
const int VFX_PER_TOTEM_SHELTERING = 204;
const int VFX_PER_TOTEM_HARDINESS = 205;
const int VFX_PER_TOTEM_SLOWING = 206;
const int VFX_PER_TOTEM_NAUSEA = 207;
const int VFX_PER_TOTEM_SWIFTNESS = 208;
const int VFX_PER_TOTEM_SERENITY = 209;
const int VFX_PER_TOTEM_CLEANSING = 210;
const int VFX_PER_TOTEM_BREACHING = 211;
const int VFX_PER_TOTEM_UNDEAD_HEALING = 212;
const int VFX_PER_ANCESTRAL_TOTEM = 213;

const int VFX_HIT_TOTEM_STRIKE = 1108;

const int TOTEM_TYPE_BUFF = 0;
const int TOTEM_TYPE_DEBUFF = 1;

const int TOTEM_DURATION_ROUNDS = 10;
const int TOTEM_EXT_DURATION_ROUNDS = 20;

const int FEAT_TOTEM_FOCUS = 14002;
const int FEAT_GREATER_TOTEM_FOCUS = 14003;
const int FEAT_SUPREME_TOTEM_FOCUS = 14004;
const int FEAT_DEVAST_TOTEM_STRIKE = 14005;
const int FEAT_ELEM_TOTEM_STRIKE = 14006;
const int FEAT_TWIN_TOTEM_STRIKE = 14007;
const int FEAT_PIERCING_TOTEM_STRIKE = 14008;

// Return one of 0 (no focus), 1 (focus), 2 (greater), 3 (supreme)
int GetFocusPower(object oCreator)
{
	if (GetHasFeat(FEAT_SUPREME_TOTEM_FOCUS, oCreator, TRUE)) {
		return 3;
	}
	if (GetHasFeat(FEAT_GREATER_TOTEM_FOCUS, oCreator, TRUE)) {
		return 2;
	}
	if (GetHasFeat(FEAT_TOTEM_FOCUS, oCreator, TRUE)) {
		return 1;
	}
	return 0;
}

int IsTotemSpell(int spellId)
{
	switch(spellId) {
	case SPELL_ID_TOTEM_RESISTANCE:
	case SPELL_ID_TOTEM_HEALING:
	case SPELL_ID_TOTEM_BLINDING:
	case SPELL_ID_TOTEM_DESPAIR:
	case SPELL_ID_TOTEM_SHELTERING:
	case SPELL_ID_TOTEM_HARDINESS:
	case SPELL_ID_TOTEM_SLOWING:
	case SPELL_ID_TOTEM_NAUSEA:
	case SPELL_ID_TOTEM_SWIFTNESS:
	case SPELL_ID_TOTEM_SERENITY:
	case SPELL_ID_TOTEM_CLEANSING:
	case SPELL_ID_TOTEM_BREACHING:
	case SPELL_ID_TOTEM_UNDEAD_HEALING:
	case SPELL_ID_ANCESTRAL_TOTEM:
	case SPELL_ID_TOTEM_PARALYSIS:
	case SPELL_ID_TOTEM_PETRIFICATION:
		return 1;
	}
	return 0;
}

int GetTotemType(int spellId)
{
	switch(spellId) {
	case SPELL_ID_TOTEM_RESISTANCE:
	case SPELL_ID_TOTEM_HEALING:
	case SPELL_ID_TOTEM_SHELTERING:
	case SPELL_ID_TOTEM_HARDINESS:
	case SPELL_ID_TOTEM_SWIFTNESS:
	case SPELL_ID_TOTEM_SERENITY:
	case SPELL_ID_TOTEM_CLEANSING:
	case SPELL_ID_TOTEM_UNDEAD_HEALING:
	case SPELL_ID_ANCESTRAL_TOTEM:
		return TOTEM_TYPE_BUFF;
	}
	return TOTEM_TYPE_DEBUFF;
}

int GetTotemAoeEffectId(int spellId)
{
	switch(spellId) {
	case SPELL_ID_TOTEM_RESISTANCE:
		return VFX_PER_TOTEM_RESISTANCE;
	case SPELL_ID_TOTEM_HEALING:
		return VFX_PER_TOTEM_HEALING;
	case SPELL_ID_TOTEM_BLINDING:
		return VFX_PER_TOTEM_BLINDING;
	case SPELL_ID_TOTEM_DESPAIR:
		return VFX_PER_TOTEM_DESPAIR;
	case SPELL_ID_TOTEM_SHELTERING:
		return VFX_PER_TOTEM_SHELTERING;
	case SPELL_ID_TOTEM_HARDINESS:
		return VFX_PER_TOTEM_HARDINESS;
	case SPELL_ID_TOTEM_SLOWING:
		return VFX_PER_TOTEM_SLOWING;
	case SPELL_ID_TOTEM_NAUSEA:
		return VFX_PER_TOTEM_NAUSEA;
	case SPELL_ID_TOTEM_SWIFTNESS:
		return VFX_PER_TOTEM_SWIFTNESS;
	case SPELL_ID_TOTEM_SERENITY:
		return VFX_PER_TOTEM_SERENITY;
	case SPELL_ID_TOTEM_CLEANSING:
		return VFX_PER_TOTEM_CLEANSING;
	case SPELL_ID_TOTEM_BREACHING:
		return VFX_PER_TOTEM_BREACHING;
	case SPELL_ID_TOTEM_UNDEAD_HEALING:
		return VFX_PER_TOTEM_UNDEAD_HEALING;
	case SPELL_ID_ANCESTRAL_TOTEM:
		return VFX_PER_ANCESTRAL_TOTEM;
	case SPELL_ID_TOTEM_PARALYSIS:
		return VFX_PER_TOTEM_SLOWING;
	case SPELL_ID_TOTEM_PETRIFICATION:
		return VFX_PER_TOTEM_SLOWING;
	}
	return 0;
}

// Return the value or the caster's WIS bonus, whichever is lower. Returns at least 0.
// Focus feats increase the limit by 1-3
int LimitToWisBonus(object oCreator, int n)
{
	int maxn = GetAbilityModifier(ABILITY_WISDOM, oCreator);
	maxn += GetFocusPower(oCreator);
	if(n > maxn)
		n = maxn;
	if(n < 0)
		n = 0;
	return n;
}

// The bonus is +1 at caster level 1 and increases by 1 at level 5 and every 5 levels thereafter,
// up to a maximum of +5 at level 20, or the caster's Wisdom bonus, whichever is lower.
int GetTotemScaledEffect(object oCreator, int nCasterLevel)
{
	int n = 1 + nCasterLevel / 5;
	if(n > 5)
		n = 5;
	n = LimitToWisBonus(oCreator, n);
	return n;
}

int TotemRemoveProtections(int nSpell_ID, object oTarget, object oCreator)
{
	int found = 0;
	effect eProtection;
	if(GetHasSpellEffect(nSpell_ID, oTarget)) {
		eProtection = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eProtection)) {
			if(GetEffectSpellId(eProtection) == nSpell_ID) {
				RemoveEffect(oTarget, eProtection);
				eProtection = GetFirstEffect(oTarget); // start back at the beginning to ensure that linked effects are removed safely
				found = 1;
			}
			else
				eProtection = GetNextEffect(oTarget);
		}
	}
	
	if(found) {
		SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_BREACHING));
		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_LESSER_SPELL_BREACH);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
	
	return found;
}

int TotemEffectActive(
	object oTarget,
	object oCreator,
	int nAoeSpellId
	)
{
	effect eAOE = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eAOE)) {
		if (GetEffectCreator(eAOE) == oCreator) {
			int spellId = GetEffectSpellId(eAOE);
			if(spellId == nAoeSpellId) {
				return TRUE;
			}
		}
		eAOE = GetNextEffect(oTarget);
	}
	return FALSE;
}

void ApplyTotemSpell(
	object oTarget,
	object oCreator,
	int nAoeSpellId,
	int nSaveDC,
	int nCasterLevel,
	int nMetaMagic
	)
{
	nSaveDC += GetFocusPower(oCreator);

	switch(nAoeSpellId) {
	case SPELL_ID_ANCESTRAL_TOTEM:
		break;
	case SPELL_ID_TOTEM_HEALING:
	case SPELL_ID_TOTEM_UNDEAD_HEALING:
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator)) {
			if((nAoeSpellId == SPELL_ID_TOTEM_HEALING && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
				|| (nAoeSpellId == SPELL_ID_TOTEM_UNDEAD_HEALING && GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)) {
				SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_HEALING, FALSE));
				int healAmount = d20();
				if(nMetaMagic == METAMAGIC_EMPOWER) {
					healAmount = healAmount + healAmount / 2;
				}
				else if(nMetaMagic == METAMAGIC_MAXIMIZE) {
					healAmount = 20;
				}
				healAmount = LimitToWisBonus(oCreator, healAmount);
				effect eHeal = EffectHeal(healAmount);
				RemoveEffectOfType(oTarget, EFFECT_TYPE_WOUNDING);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
				effect eVis = EffectVisualEffect((nAoeSpellId == SPELL_ID_TOTEM_HEALING) ? VFX_IMP_HEALING_S : VFX_HIT_SPELL_INFLICT_1);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}
		break;
	case SPELL_ID_TOTEM_RESISTANCE:
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_RESISTANCE, FALSE));
			int nBonus = GetTotemScaledEffect(oCreator, nCasterLevel);
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_RESISTANCE);
			effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
			effect eLinked = EffectLinkEffects(eSave, eVis);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinked, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
		}
		break;
	case SPELL_ID_TOTEM_BLINDING:
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
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
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
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
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
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
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
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
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_SLOWING, TRUE));
			if(!GetIsImmune(oTarget, IMMUNITY_TYPE_SLOW)) {
				effect eSlow = EffectSlow();
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
				effect eLink = EffectLinkEffects(eSlow, eVis);
				if (!MyResistSpell(oCreator, oTarget)) {
					if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC)) {
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
					}
				}
			}
		}
		break;
	case SPELL_ID_TOTEM_NAUSEA:
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
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
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_SWIFTNESS, FALSE));
			effect eHaste = EffectHaste();
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HASTE);
			effect eLinked = EffectLinkEffects(eHaste, eVis);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinked, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
		}
		break;
	case SPELL_ID_TOTEM_SERENITY:
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
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
	case SPELL_ID_TOTEM_CLEANSING:
		if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCreator)) {
			effect eBad = GetFirstEffect(oTarget);
			while(GetIsEffectValid(eBad)) {
				if ((GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
					GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
					GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
					GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
					GetEffectType(eBad) == EFFECT_TYPE_POISON ||
					GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
					GetEffectType(eBad) == EFFECT_TYPE_CHARMED ||
					GetEffectType(eBad) == EFFECT_TYPE_DOMINATED ||
					GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
					GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
					GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
					GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
					GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
					GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
					GetEffectType(eBad) == EFFECT_TYPE_STUNNED) &&
					GetEffectSpellId(eBad) != SPELL_ENLARGE_PERSON &&
					GetEffectSpellId(eBad) != SPELL_REDUCE_ANIMAL &&
					GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON &&
					GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON_GREATER &&
					GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON_MASS &&
					GetEffectSpellId(eBad) != SPELL_LIVING_UNDEATH &&
					GetEffectSpellId(eBad) != SPELL_RIGHTEOUS_MIGHT &&
					GetEffectSpellId(eBad) != SPELL_STONE_BODY &&
					GetEffectSpellId(eBad) != SPELL_IRON_BODY &&
					GetEffectSpellId(eBad) != 803) {
					RemoveEffect(oTarget, eBad);

					SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_CLEANSING, FALSE));
					effect eVis = EffectVisualEffect(VFX_IMP_RESTORATION_LESSER);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					break;
				}
				else
					eBad = GetNextEffect(oTarget);
			}
		}
		break;
	case SPELL_ID_TOTEM_BREACHING:
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator)) {
			if(TotemRemoveProtections(SPELL_GREATER_SPELL_MANTLE, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_PREMONITION, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_SPELL_MANTLE, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_SHADOW_SHIELD, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_GREATER_STONESKIN, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_ETHEREAL_VISAGE, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_GLOBE_OF_INVULNERABILITY, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_ENERGY_BUFFER, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_ENERGY_IMMUNITY_ACID, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_ENERGY_IMMUNITY_COLD, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_ENERGY_IMMUNITY_ELECTRICAL, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_ENERGY_IMMUNITY_FIRE, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_ENERGY_IMMUNITY_SONIC, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_LESSER_GLOBE_OF_INVULNERABILITY, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_SPELL_RESISTANCE, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_IRON_BODY, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_STONE_BODY, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_STONESKIN, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_LESSER_SPELL_MANTLE, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_LEAST_SPELL_MANTLE, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_MIND_BLANK, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_LIVING_UNDEATH, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_ELEMENTAL_SHIELD, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_PROTECTION_FROM_SPELLS, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_PROTECTION_FROM_ENERGY, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_RESIST_ENERGY, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_DEATH_ARMOR, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_GHOSTLY_VISAGE, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_MIRROR_IMAGE, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_ENDURE_ELEMENTS, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_SHADOW_SHIELD, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_SHADOW_CONJURATION_MAGE_ARMOR, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_SANCTUARY, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_MAGE_ARMOR, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_BARKSKIN, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_SHIELD, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_SHIELD_OF_FAITH, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_LESSER_MIND_BLANK, oTarget, oCreator))
				break;
			if(TotemRemoveProtections(SPELL_RESISTANCE, oTarget, oCreator))
				break;
		}
		break;
	case SPELL_ID_TOTEM_PARALYSIS:
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_PARALYSIS, TRUE));
			if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)) {
				effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_WILL, FALSE);
				effect eHit = EffectVisualEffect( VFX_DUR_SPELL_HOLD_MONSTER );
				effect eLink = EffectLinkEffects( eParal, eHit );
				if (!MyResistSpell(oCreator, oTarget)) {
					if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC)) {
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
					}
				}
			}
		}
		break;
	case SPELL_ID_TOTEM_PETRIFICATION:
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator) && !TotemEffectActive(oTarget, oCreator, nAoeSpellId)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_ID_TOTEM_PETRIFICATION, TRUE));
			effect ePetrify	= EffectPetrify();
			effect eVis	= EffectVisualEffect(VFX_DUR_SPELL_POWER_WORD_PETRIFY);
			effect eLink = EffectLinkEffects(ePetrify, eVis);
			if (!MyResistSpell(oCreator, oTarget)) {
				if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC)) {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(TOTEM_EXT_DURATION_ROUNDS));
				}
			}
		}
		break;
	}

}