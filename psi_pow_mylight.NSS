/*
   ----------------
   My Light

   psi_pow_mylight
   ----------------

   31/10/04 by Stratovarius
*/ /** @file

    My Light

    Psychokinesis [Light]
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Effect: 20 m spread of light emanating from you
    Duration: 10 min./level
    Power Points: 1
    Metapsionics: Extend

    When you manifest this power, your body begins to glow with bright white
    light, allowing you and others to see clearly even in the night.
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
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink    = EffectLinkEffects(EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20),
                                            EffectVisualEffect(VFX_DUR_SPELL_TRUE_SEEING));
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }
}