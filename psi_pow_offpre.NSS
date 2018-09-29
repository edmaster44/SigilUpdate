/*
   ----------------
   Precognition, Offensive

   psi_pow_offpre
   ----------------

   31/10/04 by Stratovarius
*/ /** @file

    Precognition, Offensive

    Clairsentience
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 1
    Metapsionics: Extend

    Your awareness extends a fraction of a second into the future, allowing you
    to better land blows against your opponent. You gain a +1 insight bonus on
    your attack rolls.

    Augment: For every 3 additional power points you spend, the insight bonus
             gained on your attack rolls increases by 1.
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nBonus      = 1;
		if (manif.bAugment)
			nBonus += 1;
        effect eLink    = EffectLinkEffects(EffectAttackIncrease(nBonus),
                                            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)
                                            );
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }
}