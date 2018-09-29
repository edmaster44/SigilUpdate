/*
   ----------------
   Ectoplasmic Sheen, OnExit

   psi_pow_greaseb
   ----------------

   30/10/04 by Stratovarius
*/ /** @file

    Ectoplasmic Sheen, OnExit

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
    object oTarget  = GetExitingObject();

    // Loop over effects, removing the ones from this power
    effect eAOE;
    if(GetHasSpellEffect(POWER_GREASE, oTarget))
    {
        eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if(GetEffectCreator(eAOE) == oCreator                            &&
               GetEffectType(eAOE)    == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE &&
               GetEffectSpellId(eAOE) == 14382
               )
            {
                RemoveEffect(oTarget, eAOE);
            }
            // Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }// end while - Effect loop
    }// end if - Target has been affected at all
}