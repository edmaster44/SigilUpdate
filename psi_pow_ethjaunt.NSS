/*
   ----------------
   Ethereal Jaunt, Psionic

   psi_pow_ethjaunt
   ----------------

   8/4/05 by Stratovarius
*/ /** @file

    Ethereal Jaunt, Psionic

    Psychoportation
    Level: Nomad 7
    Display: Visual
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 13
    Metapsionics: Extend

    You become ethereal, along with your equipment. For the duration of the
    power, you are in a place called the Ethereal Plane, which overlaps the
    normal, physical, Material Plane. When the power expires, you return to
    material existence.

    Taking any hostile actions will force the power to expire immediately.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_teleport"

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
        effect eLink     =                          EffectEthereal();
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SANCTUARY));
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_ETHEREALNESS));
        float fDuration  = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Check ability to move extra-dimensionally
        if(!GetCanTeleport(oManifester, GetArea(oManifester)))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        }// end if - Manifester can move extra-dimensionally
    }// end if - Successfull manifestation
}