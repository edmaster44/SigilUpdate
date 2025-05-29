/*
    ----------------
    Crisis of Life

    psi_pow_crslife
    ----------------

    21/10/04 by Stratovarius
*/ /** @file

    Crisis of Life

    Telepathy [Mind-Affecting, Death]
    Level: Telepath 7
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Fortitude partial; see text
    Power Resistance: Yes
    Power Points: 13
    Metapsionics: Empower, Maximize, Twin

    You interrupt the subject�s autonomic heart rhythm, killing it instantly on
    a failed saving throw if it has 11 Hit Dice or less. If the target makes its
    saving throw or has more than 11 Hit Dice, it takes 7d6 points of damage.

    Augment: For every additional power point you spend, this power can kill a
             subject that has Hit Dice equal to 11 + the number of additional
             points.
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 7;
        int nMaxHD        = 11;
		if (manif.bAugment)
			nMaxHD += 6;
        int nTargetHD     = GetHitDice(oTarget);
        int nDamage;
        effect eVisDeath  = EffectVisualEffect(VFX_IMP_DEATH_L);
        effect eVisDamage = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        effect eVis       = EffectVisualEffect(VFX_FNF_HOWL_MIND);
        effect eDamage;
    
   	 	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        // Check immunities
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH,       oManifester) &&
           !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oManifester)
           )
        {
            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Can the target die outright and if it can, does it fail the save?
                    if(nTargetHD <= nMaxHD && !MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisDeath, oTarget);
                        
                    }
                    else
                    {                   
                        // Roll damage
                        nDamage = d6(nNumberOfDice);
						if (manif.bMaximize)
							nDamage = 6*nNumberOfDice;
						if (manif.bEmpower)
							nDamage = FloatToInt(IntToFloat(nDamage)*1.5f);
						
							
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

                        //Apply the VFX impact and effects
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisDamage, oTarget);
                    }// end if - Too much HD or succeeded at save
                }// end if - SR check
            }// end if - Twin Power
        }// end if - Immunity check
    }
}