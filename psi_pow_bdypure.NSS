/*
   ----------------
   Body Purification

   psi_pow_bdypure
   ----------------

   26/3/05 by Stratovarius
*/ /** @file

    Body Purification

    Psychometabolism (Healing)
    Level: Psion/wilder 3, psychic warrior 2
    Manifesting Time: 1 round
    Range: Personal
    Target: You
    Duration: Instantaneous
    Power Points: Psion/wilder 5, psychic warrior 3
    Metapsionics: None

    When you manifest this power, you cleanse your body of all ability damage.
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
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_LESSER);
        effect eEffect = GetFirstEffect(oTarget);
        //Search for ability decrease
        while(GetIsEffectValid(eEffect))
        {
            if(GetEffectType(eEffect) == EFFECT_TYPE_ABILITY_DECREASE)
            {
                RemoveEffect(oTarget, eEffect);
				break;
            }
            eEffect = GetNextEffect(oTarget);
        }
    }
}