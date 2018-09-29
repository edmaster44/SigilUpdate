/*
   ----------------
   Distract

   psi_pow_distract
   ----------------

   25/10/04 by Stratovarius
*/ /** @file

    Distract

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: 1 min./level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend, Twin

    You cause your subject�s mind to wander, distracting her. Subjects under the
    effect of distract make all Listen, Spot and Search checks at a -4 penalty.
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
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                                  METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC      = GetManifesterDC(oManifester);
        int nPen     = GetPsiPenetration(oManifester);
        effect eLink =                          EffectSkillDecrease(SKILL_SPOT,   4);
               eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_SEARCH, 4));
               eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_LISTEN, 4));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
        effect eVis  = EffectVisualEffect(VFX_IMP_SLOW);
        float fDur   = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

        // Let the AI know
        //SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            //Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                //Make a saving throw check
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply VFX Impact and daze effect
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
}