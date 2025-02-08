#include "ff_safevar"
/*
   ----------------
   Catapsi, OnExit

   psi_pow_catapsib
   ----------------

   27/3/05 by Stratovarius
*/ /** @file

    Catapsi, OnExit

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 5, psychic warrior 5
    Manifesting Time: 1 standard action
    Range: 30 ft.
    Area: 30-ft.-radius emanation centered on you
    Duration: 1 round/level
    Saving Throw: Will negates; see text
    Power Resistance: Yes
    Power Points: 9
    Metapsionics: Extend

    By manifesting this power, you generate psychic static, interfering with the
    ability of other psionic characters to manifest their powers or use psi-like
    abilities (you are not affected by your own catapsi manifestation). All
    psionic activity within the area requires 4 more power points to manifest
    than normal, unless a character makes a Will save each time he attempts to
    manifest a power. If two or more fields of catapsi overlap, the effects are
    not cumulative.

    The limit on the number of power points a subject can spend on a power
    remains in effect; thus, a subject may not be able to manifest its highest-
    level powers. If manifesting a power would cause the manifester to exceed
    his available power points or his spending limits, the manifestation fails
    automatically, but no power points are expended.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_alterations"

void main()
{
    object oTarget = GetExitingObject();

    // Clear variables. Unfortunately, if they are inside another Catapsi effect at this moment, they will be unaffected by it until it's next HB
    PS_DeleteLocalInt(oTarget, "PRC_IsInCatapsi");
    PS_DeleteLocalInt(oTarget, "PRC_Catapsi_DC");
    PS_DeleteLocalObject(oTarget, "PRC_Catapsi_Manifester");
}