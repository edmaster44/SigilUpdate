//::///////////////////////////////////////////////
//:: Ghoul Touch: On Enter
//:: NW_S0_GhoulTchA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster attempts a touch attack on a target
    creature.  If successful creature must save
    or be paralyzed. Target exudes a stench that
    causes all enemies to save or be stricken with
    -2 Attack, Damage, Saves and Skill Checks for
    1d6+2 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 7, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	struct dSpellData data = GetSpellDataForAoE("GhoulTouch", oCaster);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    effect eAttack = EffectAttackDecrease(2);
    effect eDamage = EffectDamageDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link Effects
    effect eLink = EffectLinkEffects(eDamage, eAttack);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eSkill);
    eLink = EffectLinkEffects(eLink, eDur);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget != oCaster)
    {
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget) && !MySavingThrow(SAVING_THROW_FORT, oTarget, data.nDC, SAVING_THROW_TYPE_POISON))
        {
            if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
            {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2+d6()));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}