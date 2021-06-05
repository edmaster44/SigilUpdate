/*
   ----------------
   Hail of Crystals

   prc_pow_hailcrys
   ----------------

   9/4/05 by Stratovarius
*/ /** @file

    Hail of Crystals

    Metacreativity (Creation)
    Level: Shaper 5
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Area: 20-ft.-radius burst
    Duration: Instantaneous
    Saving Throw: Reflex half
    Power Resistance: No
    Power Points: 9
    Metapsionics: Empower, Maximize, Twin, Widen

    A tiny ectoplasmic crystal emanates from your outstretched hand and rapidly
    expands to a 2-foot-diameter ball of crystal as it speeds toward the
    location you designate. You can choose to aim this crystal at a single
    target or at a specific point in space.

    If you aim the crystal at a single target, you must make a ranged touch
    attack to strike the target. Any creature or object struck by the ball of
    crystal takes 5d4 points of bludgeoning damage.

    Whether the crystal hits its target, misses, or was aimed at a point in
    space, it explodes upon arrival at the location you designated. Anyone
    within 20 feet of the explosion takes 9d4 points of slashing damage from the
    thousands of crystal shards that spray forth.

    Augment: For every additional power point you spend, this power�s damage
             from the explosion of the crystal increases by 1d4 points.
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC                   = GetManifesterDC(oManifester);
        int nPen                  = GetPsiPenetration(oManifester);
        int nNumberOfDice_Explode = 14;
		if (manif.bAugment)
			nNumberOfDice_Explode += 4;
        int nNumberOfDice_Ball    = 8;
        int nDamage, nTouchAttack;
        location lTarget          = GetSpellTargetLocation();
        effect eImpact            = EffectNWN2SpecialEffectFile("psi_crystal_hit.sef");
        effect eDamage;
        float fRadius             = FeetToMeters(20.0f);
        object oExplodeTarget;
		SignalEvent(oTarget, EventSpellCastAt(oManifester, manif.nSpellID, TRUE));

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check if a particular creature was targeted
            if(GetIsObjectValid(oTarget))
            {
                // Roll touch attack
                nTouchAttack = TouchAttackRanged(oTarget);
                if(nTouchAttack > 0)
                {
                    nDamage = d4(nNumberOfDice_Ball);
					if (manif.bMaximize)
						nDamage = 4*nNumberOfDice_Ball;
					if (manif.bEmpower)
						nDamage = nDamage + (nDamage/2);
					eImpact = EffectLinkEffects(eImpact, EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING));
                    // Apply the damage and VFX. No Reflex save here, they got hit by a touch attack
                    //ApplyTouchAttackDamage(oManifester, oBallTarget, nTouchAttack, nDamage, DAMAGE_TYPE_BLUDGEONING);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                }// end if - Touch attack hit
            }// end if - A creature was targeted with the ball

            // Either way, shrapnel time
            oExplodeTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oExplodeTarget))
            {
                if(spellsIsTarget(oExplodeTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester))
                {
                    // Let the AI know
                    //SPRaiseSpellCastAt(oExplodeTarget, TRUE, manif.nSpellID, oManifester);

                    // Roll damage
                    nDamage = d6(nNumberOfDice_Explode);
					if (manif.bMaximize)
						nDamage = 6*nNumberOfDice_Explode;
					if (manif.bEmpower)
						nDamage = nDamage + (nDamage/2);
					// Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = GetReflexAdjustedDamage(nDamage, oExplodeTarget, nDC, SAVING_THROW_TYPE_NONE);

                    // Apply effects if the target didn't Evade
                    if(nDamage > 0)
                    {
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oExplodeTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oExplodeTarget);
                    }// end if - There was still damage remaining to be dealt after adjustments
                }// end if - Difficulty check

                // Get next target
                oExplodeTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }// end while - Explosion target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}