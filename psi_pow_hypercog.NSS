/*
   ----------------
   Hypercognition

   psi_pow_hypercog
   ----------------

   17/7/05 by Stratovarius
*/ /** @file

    Hypercognition

    Clairsentience
    Level: Seer 8
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 15
    Metapsionics: Extend

    You make lightning-fast deductions based on only the slightest clue,
    pattern, or scrap of memory resident in your mind. You can make reasonable
    statements about a person, place, or object, seemingly from very little
    knowledge. However, your knowledge is in fact the result of a rigorously
    logical process that you force your mind to undertake, digging up and
    correlating every possible piece of knowledge bearing on the topic (possibly
    even extracting echoes of knowledge from the Astral Plane).

    The knowledge you gain manifests as a +20 enhancement bonus to Lore skill.

    Augmentation: For each additional power point, the enhancement bonus to Lore
                  skill increases by +2.
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

*/if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nBonus      = 20;
		if (manif.bAugment)
			nBonus += 14;
        effect eLink    =                          EffectSkillIncrease(SKILL_LORE, nBonus);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_MAGICAL_VISION));
        float fDuration = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }
}