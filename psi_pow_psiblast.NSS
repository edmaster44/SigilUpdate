/*
   ----------------
   Psionic Blast

   psi_pow_psiblast
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Psionic Blast

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: 30 ft.
    Area: 30-ft. cone-shaped burst
    Duration: Instantaneous
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Twin, Widen

    The air ripples with the force of your mental attack, which blasts the minds
    of all creatures in range. Psionic blast stuns all affected creatures for 1
    round.

    Augment: For every 2 additional power points you spend, the duration of the
             stun effect increases by 1 round.
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
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        effect eLink      = EffectLinkEffects(EffectStunned(),
                                              EffectVisualEffect(VFX_DUR_STUN)
                                              );
        float fWidth      = FeetToMeters(30.0f);
		effect eConeBlast	= EffectNWN2SpecialEffectFile("fx_mindflayer_cone");
		if (manif.bWiden)
			fWidth *= 2.0f;
        float fDuration   = 6.0f;
		if (manif.bAugment)
			fDuration *= 2.0f;
        float fDelay;
        location lTarget  = GetSpellTargetLocation();
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConeBlast, OBJECT_SELF, 1.0f);
			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                // Target validity check
                if(oTarget != oManifester                                            && // Cones have a bug where they can include the user in the area. Workaround
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester)   // Difficulty and faction dependent targeting limits, because people whine if they are missing
                   )
                {
                    // Let the AI know
                    SignalEvent(oTarget, EventSpellCastAt(oManifester, manif.nSpellID));

                    // Check for Power Resistance
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        // Save - Will negates
                        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
    	                {
    	                    // Apply effect, delayed according to distance from manifester
    	                    fDelay = GetDistanceBetween(oManifester, oTarget) / 20.0f;
    	                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
    	                }// end if - Save
                    }// end if - SR check
                }// end if - Target is valid
                // Get next target
                oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}