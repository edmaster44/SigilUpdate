/*
   ----------------
   Energy Burst

   prc_all_enbrst
   ----------------

   11/12/04 by Stratovarius

    Psychokinesis [see text]
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: 40 ft.
    Area: 40-ft-radius burst centered on you
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Empower, Maximize, Twin, Widen

*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_enrgypow"

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
                              METAPSIONIC_AUGMENT |  METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nManifesterLevel = manif.nManifesterLevel;
		int nCap = 15;
		if (manif.bAugment)
		{
			nCap = 20;
		}
		if(nManifesterLevel > nCap)
	    {
	        nManifesterLevel = nCap;
	    }

        int nDC              = GetManifesterDC(oManifester);
		if (manif.bAugment)
			nDC += 1;
        int nPen          = GetPsiPenetration(oManifester);
        
        location lOrigin  = GetLocation(oManifester);
        float fRadius     = FeetToMeters(40.0f);
		if (manif.bWiden)
			fRadius *= 2;
        float fDelay;
        effect eFNF = EffectNWN2SpecialEffectFile("psi_nullpsiburst.sef", oManifester);
        effect eVis = EffectVisualEffect(VFX_FNF_DISPEL);
		effect eImpact;
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Do area VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, lOrigin);

            // Loop over targets in the line shape
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lOrigin, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester &&
                   GetIsEnemy(oTarget, oManifester)
                   )
                {
                    // Make an SR check
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        

                        spellsDispelMagic(oTarget, nManifesterLevel, eVis, eImpact, FALSE);
                    }// end if - SR check
                }// end if - Target validity check

                // Get next target
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lOrigin, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }// end while - Target loop
        }// end for - Twin Power
    }
}