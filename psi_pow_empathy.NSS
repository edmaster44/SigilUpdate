/*
   ----------------
   Empathy

   psi_pow_empathy
   ----------------

   6/12/04 by Stratovarius
*/ /** @file

    Empathy

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 1
    Metapsionics: Extend

    You detect the surface emotions of creatures around you, giving you a +2 bonus to Bluff,
    Intimidate, and Persuade when interacting with them.
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
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink =                          EffectSkillIncrease(SKILL_BLUFF,      2);
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DIPLOMACY,   2));
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, 2));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eVis  = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        float fDuration = RoundsToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}