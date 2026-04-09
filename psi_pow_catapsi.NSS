
/*
   ----------------
   Catapsi

   psi_pow_catapsi
   ----------------

   27/3/05 by Stratovarius
*/ /** @file

    Catapsi

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
#include "psi_inc_manifest"
#include "psi_inc_pwresist"
#include "psi_spellhook"

//The power point drain is implemented in psi_spellhook
//Its automatic on spell cast every time the PC fails their will save,
//which may mean the target cannot cast the spell
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
        int nDC  = GetManifesterDC(GetAreaOfEffectCreator());
        int nPen = GetPsiPenetration(GetAreaOfEffectCreator());
        float fDur = RoundsToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDur *= 2;
		int AOE_MOB_CATAPSI = 134;//vfx_persistent ID

        effect eAOE = EffectAreaOfEffect(AOE_MOB_CATAPSI, "psi_pow_catapsia", "", "psi_pow_catapsib"); 
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDur);

        // Get an object reference to the newly created AoE
        location lTarget = GetLocation(oTarget);
        object oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        while(GetIsObjectValid(oAoE))
        {
            // Test if we found the correct AoE
            if(GetTag(oAoE) == Get2DAString("vfx_persistent", "LABEL", AOE_MOB_CATAPSI) &&
               !GetLocalInt(oAoE, "PRC_Catapsi_Inited"))
            {
                break;
            }
            // Didn't find, get next
            oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        }
        //if(DEBUG) if(!GetIsObjectValid(oAoE)) DoDebug("ERROR: Can't find area of effect for Catapsi!");

        // Store DC and manifester level in regards to power penetration
        SetLocalInt(oAoE, "PRC_Catapsi_DC", nDC);
        SetLocalInt(oAoE, "PRC_Catapsi_PowerPenetration", nPen);

        SetLocalInt(oAoE, "PRC_Catapsi_Inited", TRUE);
    }// end if - Successfull manifestation
}