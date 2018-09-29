/*
   ----------------
   Biofeedback

   psi_pow_biofeed
   ----------------

   1/11/04 by Stratovarius
*/ /** @file

    Biofeedback

    Psychometabolism
    Level: Psion/wilder 2, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: Psion/wilder 3, psychic warrior 1
    Metapsionics: Extend

    You can toughen your body against wounds, lessening their impact. During the
    duration of this power, you gain damage reduction 2/-.

    Augment: For every 3 additional power points you spend, your damage reduction
             increases by 1.
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
                              METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT
                              );

    if(manif.bCanManifest)
    {
        // Determine amount of damage reduction and duration
        int nDamageReduction = 2;
		if (manif.bAugment)
			nDamageReduction += 1;
        float fDur = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

        // Create effects
    	effect eLink =                          EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, nDamageReduction);
    	       eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    nDamageReduction));
    	       eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    nDamageReduction));
    	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_MINOR));

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
    }
}