/*
   ----------------
   Ectoplasmic Cocoon, Mass

   psi_pow_ectococm
   ----------------

   9/4/05 by Stratovarius
*/ /** @file

    Ectoplasmic Cocoon, Mass

    Metacreativity
    Level: Shaper 7
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Area: 20-ft.-radius burst
    Duration: 1 hour/level
    Saving Throw: Reflex negates
    Power Resistance: No
    Power Points: 13
    Metapsionics: Extend, Twin, Widen

    You draw writhing strands of ectoplasm from the Astral Plane that wrap up
    the subjects in the area like mummies. The subjects can still breathe but
    are otherwise helpless, unable to see outside the cocoon, speak, or take any
    physical actions. The subjects�s nostrils are clear (air passes through the
    cocoon normally).

    Augment: For every 2 additional power points you spend, the radius of this
             power�s area increases by 5 feet.
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC         = GetManifesterDC(oManifester);
        effect eLink    = EffectCutsceneParalyze();
    	       eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));
        effect eVis     =  EffectNWN2SpecialEffectFile("psi_ectoplasmic_cocoon.sef");
		float augmentation = 0.0f;
		if (manif.bAugment)
			augmentation = 30.0f;
        float fRadius   = FeetToMeters(20.0f+augmentation);
		if (manif.bWiden)
			fRadius *= 2;
        float fDuration = RoundsToSeconds(manif.nManifesterLevel);
        object oTarget;
        location lTarget = GetSpellTargetLocation();
        if(manif.bExtend) fDuration *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while (GetIsObjectValid(oTarget))
            {
				// Only effect those that are hostile
	    		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester))
				{

        	        // Reflex negates
	                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                	{
        	            // Apply effects
	       	            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
                	}// end if - Save
				}	

                oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}