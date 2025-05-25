
/*
   ----------------
   Ectoplasmic Sheen

   psi_pow_grease
   ----------------

   30/10/04 by Stratovarius
*/ /** @file

    Ectoplasmic Sheen

    Metacreativity (Creation)
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target or Area: 10-ft. square
    Duration: 1 round/level
    Saving Throw: See text
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    You create a pool of ectoplasm across the floor that inhibits motion and can cause people to slow down.
    This functions as the spell grease.
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
        int nDC          = GetManifesterDC(oManifester);
        location lTarget = GetSpellTargetLocation();
        effect eImpact   = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
        effect eAoE;
        object oAoE;
        float fDuration  = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Do impact VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

        // Create AoE
        eAoE = EffectAreaOfEffect(32);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, lTarget, fDuration);

        // Get an object reference to the newly created AoE
        oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        while(GetIsObjectValid(oAoE))
        {
            // Test if we found the correct AoE
            if(GetTag(oAoE) == Get2DAString("vfx_persistent", "LABEL", 32) &&
               !GetLocalInt(oAoE, "PRC_EctoSheen_Inited")
               )
            {
                break;
            }
            // Didn't find, get next
            oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        }

        // Store data for use in the AoE scripts
        SetLocalInt(oAoE, "PRC_EctoSheen_DC", nDC);

        SetLocalInt(oAoE, "PRC_EctoSheen_Inited", TRUE);
    }// end if - Successfull manifestation
}