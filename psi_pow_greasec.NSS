#include "ff_safevar"
/*
   ----------------
   Ectoplasmic Sheen, OnHeartbeat

   psi_pow_greasec
   ----------------

   30/10/04 by Stratovarius
*/ /** @file

    Ectoplasmic Sheen, OnHeartbeat

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
    object oAoE     = OBJECT_SELF;
    object oTarget;
    int nDC         = PS_GetLocalInt(oAoE, "PRC_EctoSheen_DC");
    effect eFall    = EffectKnockdown();
    float fDelay;

    // Loop over objects in the AoE
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE))
        {
            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator))
            {
                fDelay = GetRandomDelay(0.0, 2.0);
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE, oCreator, fDelay))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFall, oTarget, 4.0f));
                }// end if - Reflex to not fall down
            }// end if - Difficulty limitations
        }// end if - Immunity check
        // Get next target
        oTarget = GetNextInPersistentObject();
    }// end while - Target loop
}