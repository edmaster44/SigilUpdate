/*
    ----------------
    Baleful Teleport

    psi_pow_baletel
    ----------------

    21/10/04 by Stratovarius
*/ /** @file

    Baleful Teleport

    Psychoportation (Teleportation)
    Level: Nomad 5
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One corporeal creature
    Duration: Instantaneous
    Saving Throw: Fortitude half
    Power Resistance: Yes
    Power Points: 9
    Metapsionics: Empower, Maximize, Twin

    You psychoportively disperse minuscule portions of the subject, dealing 9d6
    points of damage. Targets can be protected from the effects of baleful
    teleport by dimensional anchor.

    Augment: For every additional power point you spend, this power�s damage
             increases by 1d6 points. For each extra 2d6 points of damage, this
             power�s save DC increases by 1 and your manifester level increases
             by 1 for the purpose of overcoming power resistance.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_common"
#include "psi_inc_teleport"

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
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_AUGMENT);

    if(manif.bCanManifest)
    {
        // Get more data
        int nDC           = GetManifesterDC(oManifester);
		if (manif.bAugment)
			nDC += 2;
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 9;
		if (manif.bAugment)
			nNumberOfDice += 4;
        int nDamage;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
				nDamage = d6(nNumberOfDice);
				if (manif.bEmpower)
					nDamage = FloatToInt(IntToFloat(nDamage)*1.5f);
				else if (manif.bMaximize)
					nDamage = 6*nNumberOfDice;
				if(!GetCanTeleport(oTarget, GetArea(oTarget)))
                {
                    // Fort save for half
                    if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                        nDamage /= 2;

                    //Apply the damage and some VFX
                    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_10), oTarget);
                    DelayCommand(0.75f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_20), oTarget));
                    DelayCommand(1.5f,  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), oTarget));
                } // end if - the target can be teleported
				else
				{
					FloatingTextStringOnCreature("Target Cannot Be Teleported",oManifester, FALSE);
				}
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}