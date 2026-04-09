/*
   ----------------
   Insanity

   psi_pow_insane
   ----------------

   25/2/05 by Stratovarius
*/ /** @file

    Insanity

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Psion/wilder 7
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 13
    Metapsionics: Twin, Widen

    Creatures affected by this power are permanently confused and constantly
    behave randomly, as the spell.

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
                              METAPSIONIC_AUGMENT | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester);
		if (manif.bAugment)
			nDC += 3;
        int nPen         = GetPsiPenetration(oManifester);
        int nSecondary   = 0;
		if (manif.bAugment)
			nSecondary = 3;
        int nCounter;
        effect eLink     =                          EffectConfused();
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
               eLink     = SupernaturalEffect(eLink);
        effect eVis      = EffectVisualEffect(VFX_IMP_CONFUSION_S);
        location lTarget = GetLocation(oTarget);
        object oSecondaryTarget;
        float fRadius    = FeetToMeters(15.0f);
		if (manif.bWiden)
			fRadius *= 2;
		
		//Duration for PCs	
		float fDuration = 60.0 * manif.nManifesterLevel;
        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {

            // Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                // Will negates
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
					if (GetIsPC(oTarget))
					{
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					}
                    // Apply effects
					else
					{
	                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f);
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					}
                }// end if - Save to negate
            }// end if - SR check

            // Affect targets in the area if augmented
            if(nSecondary)
            {
                nCounter = 0;
                oSecondaryTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oSecondaryTarget) && nCounter < nSecondary)
                {
                    if(oSecondaryTarget != oManifester                                             &&
                       oSecondaryTarget != oTarget                                             &&
                       spellsIsTarget(oSecondaryTarget, SPELL_TARGET_SELECTIVEHOSTILE, oManifester)
                       )
                    {

                        // Check for Power Resistance
                        if(PRCMyResistPower(oManifester, oSecondaryTarget, nPen))
                        {
                            // Will negates
                            if(!MySavingThrow(SAVING_THROW_WILL, oSecondaryTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                            {
                                // Apply effects
                                if (GetIsPC(oTarget))
								{
									ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			                    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
								}
			                    // Apply effects
								else
								{
				                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f);
				                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
								}
                            }// end if - Save to negate
                        }// end if - SR check

                        // Use up a target slot only if we actually did something to it
                        nCounter += 1;
                    }// end if - Target is someone we want to / can affect

                    // Get next target
                    oSecondaryTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                }// end while - Target loop
            }// end if - There are secondary targets
        }// end for - Twin Power
    }// end if - Successfull manifestation
}