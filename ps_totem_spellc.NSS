#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_totem_constants"

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

void main()
{
	object oCreator = GetAreaOfEffectCreator(OBJECT_SELF);
	int nAoeSpellId = GetAreaOfEffectSpellId(OBJECT_SELF);
	int nMetaMagic = GetMetaMagicFeat();
	int nSaveDC = GetSpellSaveDC();
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);

	object oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget)) {
		switch(nAoeSpellId) {
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
		}

		oTarget = GetNextInPersistentObject();
	}

}