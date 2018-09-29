/*
    ----------------
    Control Sound

    psi_pow_ctrlsnd
    ----------------

    26/3/05 by Stratovarius
*/ /** @file

    Control Sound

    Psychokinesis [Sonic]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature or object
    Duration: 1 round/level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Extend, Twin

    You shape and alter existing sounds, creating a zone of silence around the
    target. If the target is hostile, it recieves a will save and power
    resistance, otherwise the effect automatically takes place.
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
        int nDC         = GetManifesterDC(oManifester);
        int nPen        = GetPsiPenetration(oManifester);
        effect eAOE     = EffectAreaOfEffect(AOE_MOB_SILENCE);
        float fDuration = RoundsToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        // Friendly targets are considered willing. They do not get SR / save and the power is not considered hostile towards them
        if(GetIsFriend(oTarget))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
        }
        else
        {
            // SR check
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
                }
            }

        }
    }
}