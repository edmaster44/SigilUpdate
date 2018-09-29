/*
    ----------------
    Ego Whip

    psi_pow_egowhip
    ----------------

    6/11/04 by Stratovarius
*/ /** @file

    Ego Whip

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. +10 ft./level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Will half; see text
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    Your rapid mental lashings assault the ego of your enemy, debilitating its
    confidence. The target takes 1d4 points of Charisma damage, or half that
    amount (minimum 1 point) on a successful save. A target that fails its save
    is also dazed for 1 round.

    Augment: For every 4 additional power points you spend, this power�s Charisma
             damage increases by 1d4 points and its save DC increases by 2.
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
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 1;
		if (manif.bAugment)
			nNumberOfDice += 1;
        int nDamage;
        effect eDaze =                          EffectDazed();
               eDaze = EffectLinkEffects(eDaze, EffectNWN2SpecialEffectFile("psi_telepathy_dur.sef"));
               
        effect eVis  = EffectVisualEffect(VFX_IMP_MAGBLUE);
        effect eRay  = EffectNWN2SpecialEffectFile("psi_ego_whip.sef", oTarget);
        // Mind-affecting immunity check
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Roll damage
                    nDamage = d4(nNumberOfDice);
					if (manif.bMaximize)
						nDamage = 4*nNumberOfDice;
					if (manif.bEmpower)
						nDamage = FloatToInt(IntToFloat(nDamage)*1.5f);
				

                    // Will save for half and not being dazed
                    if(MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        nDamage = max(nDamage / 2, 1); // Minimum 1 damage
                    }
                    else
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(1));
		    		}
                    //Apply the VFX impact
                    effect eDamage = EffectAbilityDecrease(ABILITY_CHARISMA, nDamage);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, OBJECT_SELF, 1.7);
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
                    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					
                    //ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f, TRUE, manif.nSpellID, manif.nManifesterLevel);
                }// end if - SR check
            }// end for - Twin Power
        }// end if - Mind-affecting immunity check
    }// end if - Successfull manifestation
}