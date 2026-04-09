/*
    ----------------
    Swarm of Crystals

    psi_pow_crysswrm
    ----------------

    9/11/04 by Stratovarius
*/ /** @file

    Swarm of Crystals

    Metacreativity (Creation)
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: 15 ft.
    Area: Cone-shaped spread
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin, Widen

    Thousands of tiny crystal shards spray forth in an arc from your hand. These
    razorlike crystals slice everything in their path. Anyone caught in the cone
    takes 3d4 points of slashing damage.

    Augment: For every additional power point you spend, this power�s damage
             increases by 1d4 points.
*/
#include "psi_inc_manifest"
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );


    if(manif.bCanManifest)
    {
        int nNumberOfDice = 3;
		if (manif.bAugment)
			nNumberOfDice += 1;
        int nDamage, i;
        effect eDamage;
        effect eSpikes    = EffectNWN2SpecialEffectFile("psi_crystal_swarm.sef", oManifester);
        effect eDart      = EffectNWN2SpecialEffectFile("psi_crystal_hit.sef", oTarget);
        float fWidth      = FeetToMeters(30.0f);
		if (manif.bWiden)
			fWidth *= 2;
        float fDelay;
        location lTarget  = GetSpellTargetLocation();
        object oTarget;

        vector vOrigin = GetPosition(oManifester);
        vector vTarget = GetPositionFromLocation(lTarget);
        float fAngle   = acos((vTarget.x - vOrigin.x) / GetDistanceBetweenLocations(GetLocation(oManifester), lTarget));

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Loop over targets
            oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE,
                                           OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpikes, OBJECT_SELF, 0.5);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester &&                                          // No hurting self
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester) // Game difficulty limitations
                   )
                {
                    // Roll damage
                    nDamage = d6(nNumberOfDice);
					if (manif.bMaximize)
						nDamage = 6*nNumberOfDice;
					if (manif.bEmpower)
						nDamage = nDamage + (nDamage/2);
					
                    eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
					

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    	            
    	            if(GetObjectType(oTarget) != OBJECT_TYPE_PLACEABLE) {// Placeables do not like the VFX, either
        	            for(i = 0; i < 15; i++) {
        	                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDart, oTarget);
						}
					}
    	        }// end if - Targeting check

    	        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE,
    	                                      OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}