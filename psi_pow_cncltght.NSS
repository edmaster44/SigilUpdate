/*
   ----------------
   Conceal Thoughts

   psi_pow_cncltght
   ----------------

   6/12/04 by Stratovarius
*/ /** @file

    Conceal Thoughts

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One willing creature
    Duration: 1 hour/level
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    You protect the subject�s thoughts from analysis. While the duration lasts,
    the subject gains a +10 circumstance bonus on Bluff checks.
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
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        // Determine duration
        float fDur = HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDur *= 2;

        // Create effects
        effect eLink =                          EffectSkillIncrease(SKILL_BLUFF, 10);
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);

        // Apply effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
    }
}