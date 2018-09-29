/*
    ----------------
    Shatter Mind Blank

    psi_pow_shttrmb
    ----------------

    27/3/05 by Stratovarius
*/ /** @file

    Shatter Mind Blank

    Telepathy
    Level: Psion/wilder 5
    Manifesting Time: 1 standard action
    Range: 30 ft.
    Area: 30-ft.-radius burst centered on you
    Duration: Instantaneous
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 9
    Metapsionics: Twin, Widen

    This power can negate a mind blank affecting the target. If the target fails
    its save and does not overcome your attempt with its power resistance, you
    can shatter the mind blank by making a successful check (1d20 + your
    manifester level, maximum +20) against a DC equal to 11 + the manifester
    level of the creator of the mind blank effect. If you succeed, the psionic
    mind blank or personal mind blank ends, allowing you to affect the target
    thereafter with mind-affecting powers.
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

	// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester);
        int nPen         = GetPsiPenetration(oManifester);
        int nDispelLevel = max(manif.nManifesterLevel, 20);
        int nEffectSID, nRemoveDC;
        effect eVisLink  =                             EffectVisualEffect(VFX_IMP_BREACH);
               eVisLink  = EffectLinkEffects(eVisLink, EffectNWN2SpecialEffectFile("psi_mindblank_shatter.sef"));
        effect eTest;
        float fRadius    = FeetToMeters(30.0f);
		if (manif.bAugment)
			fRadius *= 2.0f;
        location lTarget = GetSpellTargetLocation();
        object oTarget, oCreator;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                // Let the AI know
                SignalEvent(oTarget, EventSpellCastAt(oManifester, manif.nSpellID));

                // Check Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Save - Will negates
                    if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        eTest = GetFirstEffect(oTarget);
                        while(GetIsEffectValid(eTest))
                        {
                            nEffectSID = GetEffectSpellId(eTest);
                            oCreator   = GetEffectCreator(eTest);
                            nRemoveDC  = 0; // Reset DC
                            // Spells, get caster level
                            if(nEffectSID == SPELL_MIND_BLANK ||
                               nEffectSID == SPELL_LESSER_MIND_BLANK
                               )
                            {
                                nRemoveDC = 11+GetCasterLevel(oCreator);
                            }
                            // Powers, get manifester level
                            else if(nEffectSID == 14639 ||
                                    nEffectSID == 14663
                                    )
                            {
                                nRemoveDC = 11 + GetManifesterLevel(oCreator);
                            }

                            // Check if the effect is of a removable type
                            if(nRemoveDC)
                            {
                                if((d20() + nDispelLevel) >= nRemoveDC)
                                    RemoveEffect(oTarget, eTest);
                            }

                            // Get next effect
                            eTest = GetNextEffect(oTarget);
                        }// end while - Effect loop
                    }// end if - Save
                }// end if - SR check
                // Select the next target
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}