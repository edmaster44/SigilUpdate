/*
   ----------------
   Empty Mind

   psi_pow_emptymnd
   ----------------

   29/10/04 by Stratovarius
*/ /** @file

    Empty Mind

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 1
    Metapsionics: Extend

    You empty your mind of all transitory and distracting thoughts, improving
    your self-control. You gain a +2 bonus on all Will saves for the duration
    of the power.

    Manifesting this power is a swift action, like manifesting a quickened
    power, and it counts toward the normal limit of one quickened power per
    round. You cannot manifest this power when it isn't your turn.

    Augment: For every 2 additional power points you spend, the bonus on your
             Will saves increases by 1.
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
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nBonus = 2;
		if (manif.bAugment)
			nBonus += 1;
        effect eLink =                          EffectSavingThrowIncrease(SAVING_THROW_WILL, nBonus);
               eLink = EffectLinkEffects(eLink, EffectNWN2SpecialEffectFile("psi_empty_mind.sef"));
        effect eVis  = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
        float fDuration = RoundsToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}