/*
   ----------------
   Id Insinuation

   psi_pow_idinsin
   ----------------

   25/10/04 by Stratovarius
*/ /** @file

    Id Insinuation

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Close (25 ft. +5 ft./2 levels)
    Target: One creature
    Duration: 1 round/level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Extend, Twin, Widen

    As the confusion spell, except as noted here.

    Swift tendrils of thought disrupt the unconscious mind of any one creature,
    sapping its might. For the duration of this power, the subject is confused,
    making it unable to independently determine it will do.

    Augment: For every 2 additional power points you spend, this power�s save DC
             increases by 1, and the power can affect an additional target. Any
             additional target cannot be more than 15 feet from another target
             of the power.
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

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester);
		if (manif.bAugment)
			nDC += 2;
        int nPen         = GetPsiPenetration(oManifester);
        int nCounter;
        effect eLink     =                          EffectConfused();
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_CONFUSION));
               
        effect eVis      = EffectVisualEffect(VFX_IMP_CONFUSION_S);
		effect eRay  = EffectNWN2SpecialEffectFile("psi_id_insinuation.sef", oTarget);
		int nLoss;
		effect eFeeb = EffectAbilityDecrease(ABILITY_STRENGTH, nLoss);
        location lTarget = GetLocation(oTarget);
        object oSecondaryTarget;
        float fRadius    = FeetToMeters(15.0f);
		if (manif.bWiden)
			fRadius *= 2;
        float fDuration  = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
			if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
			{
	            // Check for Power Resistance
	            if(PRCMyResistPower(oManifester, oTarget, nPen))
	            {
	                // Will negates
					
	                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
	                {
	                    // Apply effects
						nLoss = d2(1);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFeeb, oTarget, fDuration);
	                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, OBJECT_SELF, 2.0);
	                }// end if - Save to negate
					else
					{
						nLoss = 1;
						effect eSapVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
						RemoveEffectsFromSpell(oTarget, 14440);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFeeb, oTarget, fDuration);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eSapVis, oTarget);
					}
	            }// end if - SR check
			}
        }// end for - Twin Power
    }// end if - Successfull manifestation
}