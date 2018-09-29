/*
   ----------------
   Oak Body

   psi_pow_oakbody
   ----------------

   25/2/04 by Stratovarius
*/ /** @file

    Oak Body

    Psychometabolism
    Level: Psion/wilder 7, psychic warrior 5
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: Psion/wilder 13, psychic warrior 9
    Metapsionics: Extend

    This power transforms your body into living oak, which grants you several
    advantages.

    You gain damage reduction 10/ slashing and a +5 bonus to natural armor that
    overlaps (does not stack with) any natural armor bonus you may already have.
    You are immune to ability damage, blindness, deafness, disease, drowning,
    poison and stunning.

    You take only half damage from cold effects of all kinds. However, you gain
    vulnerability to fire.

    You gain a +4 enhancement bonus to Strength, but you take a -2 penalty to
    Dexterity (to a minimum Dexterity score of 1), and your speed is reduced to
    half normal. You have arcane spell failure chance of 25%.

    Augment: For every additional power point you spend, this power�s duration
             increases by 1 minute.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_alterations"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

   object oManifester = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink    =                          EffectDamageResistance(DAMAGE_TYPE_SLASHING, 10);
               eLink    = EffectLinkEffects(eLink, EffectACIncrease(5, AC_NATURAL_BONUS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
               eLink    = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_DROWN));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50));
               eLink    = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
               eLink    = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));
//               eLink    = EffectLinkEffects(eLink, EffectSpellFailure(25, SPELL_SCHOOL_GENERAL));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_BARKSKIN));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS));
        effect eVis     =                         EffectVisualEffect(VFX_IMP_HEAD_NATURE);
               eVis     = EffectLinkEffects(eVis, EffectVisualEffect(VFX_FNF_NATURES_BALANCE));
               eVis     = EffectLinkEffects(eVis, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE));
        float fDuration = 60.0f * manif.nManifesterLevel;
		if (manif.bAugment)
			fDuration += 360.0f; //last five extra minutes
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        //ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, 2, DURATION_TYPE_TEMPORARY, FALSE, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

        // Apply ASF to hide
        //AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_PLUS_25_PERCENT), GetPCSkin(oTarget), fDuration);
    }// end if - Successfull manifestation
}