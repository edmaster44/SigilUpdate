/*
   ----------------
   Crystal Shard

   psi_pow_crysshrd
   ----------------

   21/10/04 by Stratovarius
*/ /** @file

    Crystal Shard

    Metacreativity (Creation)
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Empower, Maximize, Split Psionic Ray, Twin

    Upon manifesting this power, you propel a razor-sharp crystal shard at your target.
    You must succeed on a ranged touch attack with the ray to deal damage to a target.
    The ray deals 1d6 points of piercing damage.

    Augment: For every additional power point you spend, this power�s damage increases
            by 1d6 points.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nNumberOfDice = 1;
		if (manif.bAugment)
			nNumberOfDice += 1;
        int nDamage;
        effect eShard = EffectVisualEffect(VFX_IMP_MAGBLUE); // NORMAL_DART
        effect eDamage;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Shoot the visual effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eShard, oTarget);

            // Do touch attack
            int nTouchAttack = TouchAttackRanged(oTarget);
            if(nTouchAttack)
            {
                 // Roll damage
				 nDamage = d8(nNumberOfDice);
				 if (manif.bMaximize)
						nDamage = 8*nNumberOfDice;
				 if (manif.bEmpower)
						nDamage = nDamage + (nDamage/2);
				 eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
				 ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            }
        }// end for - Twin Power
    }// end if - Successfull manifestation
}