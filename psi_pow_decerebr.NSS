/*
    ----------------
    Decerebrate

    psi_pow_decerebr
    ----------------

    25/2/05 by Stratovarius
*/ /** @file

    Decerebrate

    Psychoportation [Teleportation]
    Level: Psion/wilder 7
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./level)
    Target: One living creature
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Points: 13
    Metapsionics: Twin

    With decerebrate, you selectively remove a portion of the creatures brain stem. The creature loses all cerebral functions,
    vision, hearing, and the ability to move. If greater restoration is cast on the target within 1 hour, the target lives.
    Otherwise, the target will die from the brain damage.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_teleport"

void DieMaggot(int nSpellID, object oManifester, object oTarget)
{
    // If the target hasn't been hit with restorative effects by now, kill it
    if(!(GetHasSpellEffect(nSpellID, oTarget)))
    {
        effect eVis   = EffectVisualEffect(VFX_IMP_DEATH_L);
        effect eVis2  = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        effect eDeath = EffectDeath();
        effect eLink2 = EffectLinkEffects(eVis, eVis2);
        eLink2 = EffectLinkEffects(eLink2, eDeath);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
    }
}

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
                              METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC      = GetManifesterDC(oManifester);
        int nPen     = GetPsiPenetration(oManifester);
		effect eVis = EffectNWN2SpecialEffectFile("psi_decerebrate.sef");
        // Create effects
        effect eLink = GetIsImmune(oTarget, IMMUNITY_TYPE_DAZED) ?  // If the target is immune to normal paralysis
                         EffectCutsceneParalyze() :                      // use cutscene paralysis
                         EffectDazed();                               // Otherwise, normal paralysis
        eLink = EffectLinkEffects(eLink, EffectBlindness());
        eLink = EffectLinkEffects(eLink, EffectDeaf());
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M));
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PARALYZE_HOLD));
        
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PARALYZED));
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PARALYZE_HOLD));

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            //Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)  &&   // Check if the target has a brain to mess with
                   !PS_GetLocalInt(oTarget, "DIMENSIONAL_ACHORED")  // And that the target can be teleported at all
                   )
                {
                    // Fort negates
                    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(1));
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        DelayCommand((HoursToSeconds(1) + 1.0), DieMaggot(manif.nSpellID, oManifester, oTarget));
                    }// end if - Failed save
                }// end if - Has a brain, and can be teleported
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}