/*
    ----------------
    Dispel Psionics

    psi_pow_dispel
    ----------------

    26/3/05 by Stratovarius
*/ /** @file

    Dispel Psionics

    Psychokinesis
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Target or Area: One creature; or 20-ft.-radius burst
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 5
    Metapsionics: Twin, Widen

    This power attempts to strip all magical effects from a single target. It can also target a group of creatures,
    attempting to remove the most powerful spell effect from each creature. To remove an effect, the manifester makes a dispel
    check of 1d20 +1 per manifester level (to a maximum of +10) against a DC of 11 + the power effect's manifester level.

    Augment: For every additional power point spent, the manifester level limit
             on your dispel check increases by 2 (to a maximum bonus of +10 for
             a 5-point expenditure).
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x0_i0_spells"
//#include "spinc_common"

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
                              METAPSIONIC_AUGMENT | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
		int augmentation = 0;
		if (manif.bAugment)
			augmentation  = 6;
        int nMLCap       = min(10 + augmentation, manif.nManifesterLevel);
        effect eVis      = EffectVisualEffect(VFX_IMP_BREACH);
        effect eImpact   = EffectVisualEffect(VFX_FNF_DISPEL);
        location lTarget = GetSpellTargetLocation();
        float fRadius    = FeetToMeters(20.0f);
		if (manif.bWiden)
			fRadius *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Targeted dispel - Remove all effects
            if(GetIsObjectValid(oTarget))
            {
                spellsDispelMagic(oTarget, manif.nManifesterLevel, eVis, eImpact);
            }
            // Dispel in an area - Only remove single effect from each target
            else
            {
                // Do area VFX
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

                // Target loop
                oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE,
                                               OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE
                                               );
                while(GetIsObjectValid(oTarget))
                {
                    // Area of Effects are handled using a separate function
                    if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
                        spellsDispelAoE(oTarget, oManifester, manif.nManifesterLevel);
                    // It's a creature, take out the highest caster/manifester level effect on it
                    else
                        spellsDispelMagic(oTarget, manif.nManifesterLevel, eVis, eImpact, FALSE);

                    // Get next target
                    oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE,
                                                  OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE
                                                  );
                }// end while - Target loop
            }// end else - Area dispel
        }// end for - Twin Power
    }// end if - Successfull manifestation
}