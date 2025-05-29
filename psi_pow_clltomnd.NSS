/*
   ----------------
   Call to Mind

   psi_pow_clltomnd
   ----------------

   22/10/04 by Stratovarius
*/ /** @file

    Call to Mind

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 2 rounds
    Power Points: 1
    Metapsionics: Extend

    When you manifest this power, you gain +5 bonus to the Lore skill.

    Augment: For every additional power point you spend, the skill bonus gained increases by +1.
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nBonus = 5;
		if (manif.bAugment)
			nBonus += 2;
        float fDur = 12.0f;
        if(manif.bExtend) fDur *= 2;

        effect eLink =                          EffectSkillIncrease(SKILL_LORE, nBonus);
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_MAGICAL_VISION));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eVis  = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}