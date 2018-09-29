/*
   ----------------
   Synesthete

   psi_pow_synsth
   ----------------

   1/11/04 by Stratovarius
*/ /** @file

    Synesthete

    Psychometabolism
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 1
    Metapsionics: Extend

    You receive one kind of sensory input when a different sense is stimulated.
    In particular, you can feel light and sound on the skin of your face. Your
    senses continue to work normally as well, unless they are impaired for some
    reason.

    By feeling light by absorbing ambient light onto your skin, you have your
    normal visual abilities, even if your eyes are closed or you are blinded.
    You gain a +4 circumstance bonus on all Spot and Search checks.

    By feeling sound by absorbing sound onto your skin, the expanded audio input
    provides you with a +4 circumstance bonus on Listen checks.

    Psionic or magical displacement effects, invisibility effects, illusions,
    and other similar effects confuse your synesthete senses just as they would
    your normal senses.

    You can also use this power to see sound if you are deafened, or hear light
    if you are blinded, thus removing all penalties associated with either
    condition.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"

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
                             METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink    =                          EffectSkillIncrease(SKILL_SPOT,   4);
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, 4));
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LISTEN, 4));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_BLINDVISION));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eTest;
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Remove existing blindness / deafness
        eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_BLINDNESS          ||
               GetEffectType(eTest) == EFFECT_TYPE_DEAF
               )
            {
                RemoveEffect(oTarget, eTest);
            }

            eTest = GetNextEffect(oTarget);
        }

        // Apply effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }// end if - Successfull manifestation
}