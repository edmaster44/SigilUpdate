/*
   ----------------
   Freedom of Movement, Psionic

   psi_pow_freedom
   ----------------

   19/2/04 by Stratovarius
*/ /** @file

    Freedom of Movement, Psionic

    Psychoportation
    Level: Psion/wilder 4, psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 7
    Metapsionics: Extend

    This power enables you to move and attack normally for the duration of the
    power, even under the influence of magic that usually impedes movement, such
    as paralysis, solid fog, slow, and web.
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

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink =                          EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Search and remove effects of the types the target is being granted immunity to
    	effect eLook = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eLook))
        {
            if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
               GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
               GetEffectType(eLook) == EFFECT_TYPE_SLOW     ||
               GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
               )
            {
                RemoveEffect(oTarget, eLook);
            }
            eLook = GetNextEffect(oTarget);
        }

        // Apply the effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }
}