/*
   ----------------
   Body Equilibrium

   psi_pow_bdyequib
   ----------------

   6/12/04 by Stratovarius
*/ /** @file

    Body Equilibrium

    Psychometabolism
    Level: Psion/wilder 2, psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 3
    Metapsionics: Extend

    You adjust your bodies equilibrium to correspond with the surface you are walking on,
    making you able to move easily across unusual and unstable surfaces. This makes you
    immune to entangle.
*/
#include "psi_inc_manifest"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_alterations"

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
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
        effect eVis      = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
        
        effect eLink     = EffectLinkEffects(eVis, eEntangle);
              

        float fDur = 600.0 * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
    }
}