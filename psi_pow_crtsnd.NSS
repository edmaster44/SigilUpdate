/*
   ----------------
   Create Sound

   psi_pow_crtsnd
   ----------------

   26/3/05 by Stratovarius
*/ /** @file

    Create Sound

    Metacreativity (Creation) [Sonic]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Effect: Sounds; see text
    Duration: 1 round/level
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    You create a volume of changing sounds that disguises the target's
    movements, granting the target a bonus of +4 to your move silently
    checks.
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
                              METAPSIONIC_EXTEND
                              );
    if(manif.bCanManifest)
    {
    	effect eLink =                          EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4);
    	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        float fDur = RoundsToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDur *= 2;

        // Apply effect
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
    }
}