#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void ApplyTemplatePseudonatural(object oCreature = OBJECT_SELF)
{
    effect ePseudoAttack  = ExtraordinaryEffect(EffectAttackIncrease(15, ATTACK_BONUS_MISC));
    effect ePseudoDefence = ExtraordinaryEffect(EffectACIncrease(35, AC_NATURAL_BONUS));
    effect ePseudoSpeed   = ExtraordinaryEffect(EffectHaste());
    effect ePseudoStr     = ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_STRENGTH, 22));
    effect ePseudoDex     = ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_DEXTERITY, 10));
    effect ePseudoCon     = ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, 10));
    effect ePseudoWis     = ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_WISDOM, 10));

    effect ePseudoLinker1 = EffectLinkEffects(ePseudoAttack,  ePseudoDefence);
    effect ePseudoLinker2 = EffectLinkEffects(ePseudoLinker1, ePseudoSpeed);
    effect ePseudoLinker3 = EffectLinkEffects(ePseudoLinker2, ePseudoStr);
    effect ePseudoLinker4 = EffectLinkEffects(ePseudoLinker3, ePseudoDex);
    effect ePseudoLinker5 = EffectLinkEffects(ePseudoLinker4, ePseudoCon);

	effect ePseudoTemplate = EffectLinkEffects(ePseudoLinker5, ePseudoWis);

    // TODO: equip tentacles (probably via CreateItemOnObject, ActionEquipItem)

    ApplyEffectToObject(DURATION_TYPE_INSTANT, ePseudoTemplate, oCreature);
}
