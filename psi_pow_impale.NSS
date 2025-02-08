#include "ff_safevar"
/*
    ----------------
    Impale

    psi_pow_impale
    ----------------

    1/22/2016 by Xndar
*/ /** @file

    Impale

    Deals 10d6 Piercing damage. Reflex save vs. death unless immune to critical hits.
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
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 10;
        int nDamage;
        effect eDeathLink = EffectLinkEffects(EffectDeath(),
                                              EffectNWN2SpecialEffectFile("psi_impale.sef", oTarget)
                                              );
        effect eDamageVis = EffectNWN2SpecialEffectFile("psi_impale.sef", oTarget);
        effect eDamage;

        // Let the AI know
        SignalEvent(oTarget, EventSpellCastAt(oManifester, manif.nSpellID));

        // Check immunities
        if(GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, oManifester))
		   {
		   				nDamage = d6(nNumberOfDice);
						if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_MAXMIZE") == 1)
						{
							nDamage = 6 + (nNumberOfDice);
						}
						if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
			            {
			                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
			            }
						
                        //Apply the VFX impact and effects
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageVis, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		   				
						return;
		   }	
		else
        {
            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                // Check for immunity and Power Resistance
                
                    // Save - Will partial for just damage
                    if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_DEATH))// && !GetHasMettle(oTarget, SAVING_THROW_WILL))
                    {
                        // Roll damage
                        nDamage = d6(nNumberOfDice);
						if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_MAXMIZE") == 1)
						{
							nDamage = 6 + (nNumberOfDice);
						}
						if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
			            {
			                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
			            }
						
                        //Apply the VFX impact and effects
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageVis, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    }// end if - Save success
                    else
                    {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeathLink, oTarget);
                    }// end else - Save failure
                
            }// end for - Twin Power
        }// end if - Immunity check
    }// end if - Successfull manifestation
}