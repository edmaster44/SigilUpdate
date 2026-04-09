
/*
   ----------------
   Ectoplasmic Sheen, OnEnter

   psi_pow_greasea
   ----------------

   30/10/04 by Stratovarius
*/ /** @file

    Ectoplasmic Sheen, OnEnter

    Metacreativity (Creation)
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target or Area: 10-ft. square
    Duration: 1 round/level
    Saving Throw: See text
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    You create a pool of ectoplasm across the floor that inhibits motion and can cause people to slow down.
    This functions as the spell grease.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"


void main()
{
    object oCreator = GetAreaOfEffectCreator();
    object oTarget  = GetEnteringObject();
    object oAoE     = OBJECT_SELF;
    int nDC         = GetLocalInt(oAoE, "PRC_EctoSheen_DC");
    effect eLink    = EffectLinkEffects(EffectMovementSpeedDecrease(50),
                                        EffectVisualEffect(VFX_IMP_SLOW)
                                        );
    float fDelay = GetRandomDelay(1.0, 2.2);

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator))
    {
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE))
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_GREASE));

            //Apply reduced movement effect and VFX_Impact
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f);
        }// end if - Immunity check
    }// end if - Difficulty check
}