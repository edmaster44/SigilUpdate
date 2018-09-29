/*
   ----------------
   Cloud Mind, Mass

   psi_pow_mndblnkp
   ----------------

   21/7/15 by Xndar
*/ /** @file

    Cloud Mind, Mass

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 5
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 minute/level
    Power Points: 11
    Metapsionics: Augment, Extend

    Imitates the effect of a Sanctuary spell.
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
		int nDC           = GetManifesterDC(oManifester);
		if (manif.bAugment)
			nDC += 2;
        effect eLink    =                          EffectSanctuary(nDC);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_SANCTUARY));
               
        effect eVis     = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }// end if - Successfull manifestation
}