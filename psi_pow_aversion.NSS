/*
   ----------------
   Aversion

   psi_pow_aversion
   ----------------

   19/4/05 by Stratovarius
*/ /** @file

    Aversion

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Telepath 2
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: 1 hour/level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Extend, Twin

    You plant a powerful aversion in the mind of the subject. The target flees
    from you at every opportunity.

    Augment: For every 2 additional power points you spend, this power�s save DC
             increases by 1 and the duration increases by 1 hour.
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
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_AUGMENT);

    if(manif.bCanManifest)
    {
        // Get some more data
        int nDC  = GetManifesterDC(oManifester);
		if (manif.bAugment)
			nDC += 2;
	    int nPen = GetPsiPenetration(oManifester);

	    float fDur = HoursToSeconds(manif.nManifesterLevel);
		if (manif.bAugment)
			fDur = HoursToSeconds(manif.nManifesterLevel+1);
	    if(manif.bExtend) fDur *= 2;

	    // Build effects
	    effect eVis  = EffectVisualEffect(VFX_IMP_DAZED_S);
	    effect eLink =                          EffectFrightened();
	           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
	           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            //Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                //Make a saving throw check
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply VFX Impact and fear effect
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }// end if - Save to negate
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}