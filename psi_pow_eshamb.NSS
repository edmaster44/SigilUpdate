
/*
   ----------------
   Ectoplasmic Shambler, OnExit

   psi_pow_eshamb
   ----------------

   23/2/04 by Stratovarius
*/ /** @file

    Ectoplasmic Shambler, OnExit

    Metacreativity (Creation)
    Level: Psion/wilder 5
    Manifesting Time: 1 round
    Range: Long (400 ft. + 40 ft./level)
    Effect: One ectoplasmic manifestation of 10m radius
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 9
    Metapsionics: Extend, Twin, Widen

    You fashion an ephemeral mass of pseudo-living ectoplasm called an
    ectoplasmic shambler. As the consistency of the ectoplasmic shambler is
    that of thick mist, those within the shambler are blinded. In addition,
    manifesting powers (or casting spells) within the shambler is difficult
    due to the constant turbulence felt by those caught in the shambler�s form.

    Creatures enveloped by the shambler, regardless of Armor Class, take 1 point
    of damage for every two manifester levels you have in each round they become
    or remain within the roiling turbulence of the shambler. Anyone trying to
    manifest a power must make a Concentration check (DC 15 + power�s or spell�s
    level) to successfully manifest a power or cast a spell inside the shambler.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_common"

void main()
{
    object oCreator = GetAreaOfEffectCreator();
    object oTarget  = GetExitingObject();
    effect eTest;

    // Remove the blindness effect
    if(GetHasSpellEffect(14552, oTarget))
    {
        //Search through the valid effects on the target.
        eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(
               GetEffectType(eTest) == EFFECT_TYPE_BLINDNESS &&
               GetEffectSpellId(eTest) == 14552
               )
            {
                RemoveEffect(oTarget, eTest);
            }
            //Get next effect on the target
            eTest = GetNextEffect(oTarget);
        }
    }

    // Decrease the value of the marker informing a creature is inside Ectoplasmic Shambler
    SetLocalInt(oTarget, "PRC_IsInEctoplasmicShambler", GetLocalInt(oTarget, "PRC_IsInEctoplasmicShambler") - 1);

    // Delete the marker if it's reached zero. ie, the creature is no longer inside any shamblers
    if(GetLocalInt(oTarget, "PRC_IsInEctoplasmicShambler") <= 0)
        DeleteLocalInt(oTarget, "PRC_IsInEctoplasmicShambler");
}