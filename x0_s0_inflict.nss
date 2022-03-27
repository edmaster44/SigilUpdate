//::///////////////////////////////////////////////
//:: [Inflict Wounds]
//:: [X0_S0_Inflict.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: This script is used by all the inflict spells
//::
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

#include "ps_spellfactory_includes"


/*struct CombatSpellData InflictWoundsCommon()
{
    struct CombatSpellData spell = GetCombatSpellData(OBJECT_SELF);
    spell.TargetType = SPELL_TARGET_TYPE_SINGLE;
    spell.TouchAttackMelee = TRUE;
    spell.SneakAttack = TRUE;
    spell.SavingThrow = SAVING_THROW_WILL;
    spell.SavingThrowType = SAVING_THROW_TYPE_NEGATIVE;
    spell.DamageType = DAMAGE_TYPE_NEGATIVE;
    spell.HealRacialType = RACIAL_TYPE_UNDEAD;
    return spell;
}

void InflictMinorWounds()
{
    // Does 1 Damage
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    struct CombatSpellData spell = InflictWoundsCommon();
    spell.DiceType = 1;
    spell.DiceNumber = Limit(nCasterLevel, 1, 1);
    spell.AdditionalDamagePerDice = 1;
    spell.ImpactEffect = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_1);
    spell.HealVisEffect = EffectVisualEffect(VFX_IMP_HEALING_S);
    HandleSpell(spell);
}

void InflictLightWounds()
{
    // Does 1d6+1 every other level, max 15d6+15
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    struct CombatSpellData spell = InflictWoundsCommon();
    spell.DiceType = 8;
    spell.DiceNumber = Limit(nCasterLevel, 1, 1);
    spell.AdditionalDamagePerDice = 1;
    spell.ImpactEffect = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_2);
    spell.HealVisEffect = EffectVisualEffect(VFX_IMP_HEALING_M);
    HandleSpell(spell);
}

void InflictModerateWounds()
{
    // Does 1d8+1 every other level, max 25d8+20
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    struct CombatSpellData spell = InflictWoundsCommon();
    spell.DiceType = 8;
    spell.DiceNumber = Limit(nCasterLevel, 1,10 );
    spell.AdditionalDamagePerDice = 1;
    spell.ImpactEffect = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_3);
    spell.HealVisEffect = EffectVisualEffect(VFX_IMP_HEALING_L);
    HandleSpell(spell);
}

void InflictSeriousWounds()
{
    // Does 1d10+1 every other level, max 25d10+25
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    struct CombatSpellData spell = InflictWoundsCommon();
    spell.DiceType = 10;
    spell.DiceNumber = Limit(nCasterLevel, 1, 25);
    spell.AdditionalDamagePerDice = 1;
    spell.ImpactEffect = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_4);
    spell.HealVisEffect = EffectVisualEffect(VFX_IMP_HEALING_G);
    HandleSpell(spell);
}

void InflictCriticalWounds()
{
    // Does 1d12+1 every other level, max 30d12+30
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    struct CombatSpellData spell = InflictWoundsCommon();
    spell.DiceType = 12;
    spell.DiceNumber = Limit(nCasterLevel, 1, 30);
    spell.AdditionalDamagePerDice = 1;
    spell.ImpactEffect = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_5);
    spell.HealVisEffect = EffectVisualEffect(VFX_IMP_HEALING_X);
    HandleSpell(spell);
}
*/

//void main()
//{
 //   int nSpellID = GetSpellId();
  //  switch (nSpellID)
    //{
//*Minor*/     case 431: InflictMinorWounds(); break;
//*Light*/     case 432: case 609: InflictLightWounds(); break;
//*Moderate*/  case 433: case 610: InflictModerateWounds(); break;
//*Serious*/   case 434: case 611: InflictSeriousWounds(); break;
//*Critical*/  case 435: case 612: InflictCriticalWounds(); break;
 //   }
//}

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
//
// End of Spell Cast Hook

  
    int nSpellID = GetSpellId();
    switch (nSpellID)
    {
/*Minor*/     case 431: spellsInflictTouchAttack(1, 0, 1, 246, VFX_HIT_SPELL_INFLICT_1, nSpellID); break;
/*Light*/     case 432: case 609: spellsInflictTouchAttack(d8(2), 5, 21, 246, VFX_HIT_SPELL_INFLICT_2, nSpellID); break;
/*Moderate*/  case 433: case 610: spellsInflictTouchAttack(d8(4), 10, 42, 246, VFX_HIT_SPELL_INFLICT_3, nSpellID); break;
/*Serious*/   case 434: case 611: spellsInflictTouchAttack(d8(6), 15, 63, 246, VFX_HIT_SPELL_INFLICT_4, nSpellID); break;
/*Critical*/  case 435: case 612: spellsInflictTouchAttack(d8(8), 20, 84, 246, VFX_HIT_SPELL_INFLICT_5, nSpellID); break;

    }
}