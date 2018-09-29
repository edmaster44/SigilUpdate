/*
   ----------------
   Ubiquitous Vision

   psi_pow_ubiqvis
   ----------------

   25/3/04 by Stratovarius
*/ /** @file

    Ubiquitous Vision

    Clairsentience
    Level: Psion/wilder 3, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 5
    Metapsionics: Extend

    You have metaphoric �eyes in the back of your head,� and on the sides and
    top as well, granting you benefits in specific situations. In effect, you
    have a 360-degree sphere of sight, allowing you a perfect view of creatures
    that might otherwise flank you. Thus, flanking opponents gain no bonus on
    their attack rolls, and rogues are denied their sneak attack ability because
    you do not lose your Dexterity bonus (but they may still sneak attack you if
    you are caught flat-footed). Your Spot and Search checks gain a +4
    enhancement bonus.
*/

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
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink    =                          EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT,   4));
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, 4));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Apply effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }// end if - Successfull manifestation
}