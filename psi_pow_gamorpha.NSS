/*
   ----------------
   Greater Concealing Amorpha

   psi_pow_gamorpha
   ----------------

   22/10/04 by Stratovarius
*/ /**

    Concealing Amorpha, Greater

    Metacreativity (Creation)
    Level: Shaper 3, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 5
    Metapsionics: Extend

    Using concealing amorpha, you weave a quasi-real membrane around yourself.
    You remain visible within the translucent, amorphous enclosure. This
    distortion grants you total concealment (opponents have a 50% miss chance), thanks
    to the rippling membrane encasing your form. You can pick up or drop objects,
    easily reaching through the film. Anything you hold is enveloped by the
    amorpha. Likewise, you can engage in melee, make ranged attacks, and manifest
    powers without hindrance.
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

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
    	effect eVis     = EffectVisualEffect(VFX_DUR_INVISIBILITY);
        effect eConceal = EffectConcealment(50);
        effect eDur     = EffectNWN2SpecialEffectFile("psi_concealing_amorpha");
        effect eLink    = EffectLinkEffects(eDur, eConceal);

        float fDuration = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}