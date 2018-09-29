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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nPen          = GetPsiPenetration(oManifester);
		effect eSpellInvul = EffectSpellImmunity(SPELL_ALL_SPELLS);
		effect eSlash = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 300, 0);
		effect eBlud = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 300, 0);
		effect ePierc = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 300, 0);
		effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, 300, 0);
		effect eMagic = EffectDamageResistance(DAMAGE_TYPE_MAGICAL, 300, 0);
		effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 300, 0);
		effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 300, 0);
		effect eDiv = EffectDamageResistance(DAMAGE_TYPE_DIVINE, 300, 0);
		effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, 300, 0);
		effect eNeg = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 300, 0);
		effect ePos = EffectDamageResistance(DAMAGE_TYPE_POSITIVE, 300, 0);
		effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, 300, 0);
        effect eLink    = EffectCutsceneParalyze();
    	       eLink    = EffectLinkEffects(eLink, EffectEthereal());
			   eLink    = EffectLinkEffects(eLink, eSpellInvul);
			   eLink    = EffectLinkEffects(eLink, eSlash);
			   eLink    = EffectLinkEffects(eLink, eBlud);
			   eLink    = EffectLinkEffects(eLink, ePierc);
			   eLink    = EffectLinkEffects(eLink, eAcid);
			   eLink    = EffectLinkEffects(eLink, eMagic);
			   eLink    = EffectLinkEffects(eLink, eElec);
			   eLink    = EffectLinkEffects(eLink, eCold);
			   eLink    = EffectLinkEffects(eLink, eDiv);
			   eLink    = EffectLinkEffects(eLink, eFire);
			   eLink    = EffectLinkEffects(eLink, eNeg);
			   eLink    = EffectLinkEffects(eLink, ePos);
			   eLink    = EffectLinkEffects(eLink, eSonic);
        effect eVis     =  EffectNWN2SpecialEffectFile("psi_time_stop.sef");
		effect eLink2 = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
			   eLink2 = EffectLinkEffects(eLink2, eVis);
		float augmentation = 0.0f;
		if (manif.bAugment)
			augmentation = 30.0f;
        float fRadius   = FeetToMeters(20.0f+augmentation);
		if (manif.bWiden)
			fRadius *= 2;
        float fDuration = RoundsToSeconds(manif.nManifesterLevel);
        object oTarget;
        location lTarget = GetSpellTargetLocation();
		int nDC           = GetManifesterDC(oManifester);
        if(manif.bExtend) fDuration *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while (GetIsObjectValid(oTarget))
            {
				// Only effect those that are hostile
	    		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester) && oTarget != oManifester)
				{

        	        // Will negates
	                if(PRCMyResistPower(oManifester, oTarget, nPen))
                	{
						if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
						{
        	            // Apply effects
		       	            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
		                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration);
						}
                	}// end if - Save
				}	

                oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}