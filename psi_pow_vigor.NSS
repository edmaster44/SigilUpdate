/*
   ----------------
   Vigor

   psi_pow_vigor
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Vigor

    Psychometabolism
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 1
    Metapsionics: Extend

    You suffuse yourself with power, gaining 5 temporary hit points. Using this
    power again when an earlier manifestation has not expired merely replaces
    the older temporary hit points (if any remain) with the newer ones.

    Augment: For every additional power point you spend, the number of temporary
             hit points you gain increases by 5.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
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
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nHP         = 5;
		if (manif.bAugment)
			nHP += 3;
        effect eLink    =                          EffectTemporaryHitpoints(nHP);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eVis     = EffectVisualEffect(VFX_IMP_HOLY_AID);
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Remove previous Vigor
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectSpellId(eTest) == POWER_VIGOR)
                RemoveEffect(oTarget, eTest);

            eTest = GetNextEffect(oTarget);
        }

        // Apply effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }// end if - Successfull manifestation
}