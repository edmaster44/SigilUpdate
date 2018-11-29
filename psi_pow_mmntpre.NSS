/*
   ----------------
   Moment of Prescience, Psionic

   psi_pow_mmntpre
   ----------------

   25/3/05 by Stratovarius
*/ /** @file

    Moment of Prescience, Psionic

    Clairsentience
    Level: Psion/wilder 7
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 round
    Power Points: 13
    Metapsionics: Extend

    You add a bonus of six to attack, armour
    class, saves, or skills for the duration of the power.

    Manifesting the power is a swift action, like manifesting a quickened power,
    and it counts toward the normal limit of one quickened power per round.
*/
#include "psi_inc_manifest"
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
        int nBonus      = 6
        effect eLink    = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
        float fDuration = 6.0f;
        if(manif.bExtend) fDuration *= 2;

        switch(manif.nSpellID)
        {
            case 14644:
                eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nBonus));
                break;
            case 14645:
                eLink = EffectLinkEffects(eLink, EffectACIncrease(nBonus));
                break;
            case 14646:
                eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus));
                break;
            case 14647:
                eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus));
                break;

            default:{
                string sErr = "psi_pow_mmntpre: ERROR: Unknown spellID: " + IntToString(manif.nSpellID);
               // if(DEBUG) DoDebug(sErr);
               // else      WriteTimestampedLogEntry(sErr);
            }
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }
}