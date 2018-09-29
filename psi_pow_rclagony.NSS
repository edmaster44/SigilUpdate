/*
    ----------------
    Recall Agony

    psi_pow_rclagony
    ----------------

    28/10/04 by Stratovarius
*/ /** @file

    Recall Agony

    Clairsentience [Mind-Affecting]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    The fabric of time parts to your will, revealing wounds your foe has
    received in the past (or has yet to receive). That foe takes 2d6 points of
    damage as the past (or future) impinges briefly on the present.

    Augment: For every additional power point you spend, this power�s damage
             increases by 1d6 points. For each extra 2d6 points of damage, this
             power�s save DC increases by 1.
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 2;
		if (manif.bAugment)
			nNumberOfDice += 1;
        int nDamage;
        effect eVis       = EffectNWN2SpecialEffectFile("psi_seer_hit.sef", oTarget);
        effect eDamage;

        // Let the AI know
        SignalEvent(oTarget, EventSpellCastAt(oManifester, manif.nSpellID));

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check for immunity and Power Resistance
            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oManifester) &&
               PRCMyResistPower(oManifester, oTarget, nPen)
               )
            {
                // Save - Will half
                if(MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    nDamage /= 2;          
                }

                // Roll damage
                nDamage = d6(nNumberOfDice);

                //Apply the VFX impact and effects
                eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}