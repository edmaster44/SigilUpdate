/*
   ----------------
   Dismissal, Psionic

   psi_pow_dismiss
   ----------------

   28/4/05 by Stratovarius
*/ /** @file

    Dismissal, Psionic

    Psychoportation
    Level: Nomad 4
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One extraplanar creature
    Duration: Instantaneous
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Twin

   This spell forces an extraplanar creature back to its home plane if it fails a save. Extraplanar creatures are outsiders and
   elementals. This spell does not work on summons that are not of these races.
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
                              METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC  = GetManifesterDC(oManifester);
    	int nPen = GetPsiPenetration(oManifester);
    	effect eVis = EffectVisualEffect(VFX_FNF_IMPLOSION);//VFX_IMP_DEATH_L);

    	// Target type check
    	if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER  ||
    	   GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL
    	   )
        {

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Will negates
                    if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }// end if - Failed save
                }// end if - SR check
            }// end for - Twin Power
        }// end if - Target is of correct type
    }// end if - Successfull manifestation
}