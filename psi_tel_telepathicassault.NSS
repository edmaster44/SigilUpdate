/*
   ----------------
   Inflict Pain

   psi_pow_inpain
   ----------------

   25/10/04 by Stratovarius
*/ /** @file

    Inflict Pain

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: 1 round/level
    Saving Throw: Will partial; see text
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Extend, Twin, Widen

    You telepathically stab the mind of your foe, causing horrible agony. The
    subject suffers wracking pain that imposes a -4 penalty on attack rolls,
    skill checks, and ability checks. If the target makes its save, it takes
    only a -2 penalty.

    Augment: For every 2 additional power points you spend, this power�s save DC
             increases by 1, and the power can affect an additional target. Any
             additional target cannot be more than 15 feet from another target
             of the power.
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

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester);
		if (manif.bAugment)
			nDC += 1;
        int nPen         = GetPsiPenetration(oManifester);
        int nCounter;
        effect eLink     =                          EffectSavingThrowDecrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_ALL);
               eLink     = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_CONCENTRATION, 4));
               
        effect eLink2    =                           EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_ALL);
               eLink2    = EffectLinkEffects(eLink2, EffectSkillDecrease(SKILL_CONCENTRATION, 2));
               
        effect eVis      = EffectNWN2SpecialEffectFile("psi_inflictpain.sef", oTarget);
        location lTarget = GetLocation(oTarget);
        float fRadius    =  FeetToMeters(15.0f);
        float fDuration  = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            /* Affect the main target */
            // Let the AI know
            //SPRaiseSpellCastAt(oMainTarget, TRUE, manif.nSpellID, oManifester);

            // Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                // Apply impact VFX
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                // Will partial
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                }// end if - Save for lesser effect
				else
				{
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration);
				}
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}