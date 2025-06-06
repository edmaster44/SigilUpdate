/*
   ----------------
   Elf Sight

   psi_pow_astralseed
   ----------------

   6/11/04 by Stratovarius
*/ /** @file

    Elf Sight

    Psychometabolism
    Level: Psion/wilder 9, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Power Points: Psion/wilder 3, psychic warrior 1
    Metapsionics: Extend

    You gain low-light vision (as an elf) for the duration of the power, as
    well as a +4 bonus on Search and Spot checks.
*/
#include "psi_inc_manifest"
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
                              METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT
                              );

    if(manif.bCanManifest)
    {
        int nHeal = 80 + manif.nManifesterLevel;
		if (manif.bAugment)
			nHeal = 80 + (manif.nManifesterLevel * 2);
		effect eSeed =                          EffectHealOnZeroHP(OBJECT_SELF, nHeal);
               
        effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        float fDuration = TurnsToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;


        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSeed, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}