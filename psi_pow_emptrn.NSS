/** @file psi_pow_emptrn

    Empathic Transfer

    Psychometabolism
    Level: Egoist 2, psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Willing creature touched
    Duration: Instantaneous
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    You heal another creature�s wounds, transferring some of its damage to
    yourself. When you manifest this power, you can heal as much as 2d10 points
    of damage. The target regains a number of hit points equal to the dice
    result, and you lose hit points equal to half of that amount. (This loss can
    bring you to 0 or fewer hit points.) Powers and abilities you may have such
    as damage damage reduction and regeneration do not lessen or change this
    damage, since you are taking the target�s pain into yourself in an empathic
    manner. The damage transferred by this power has no type, so even if you
    have immunity to the type of damage the target originally took, the transfer
    occurs normally and deals hit point damage to you.

    Augment: For every additional power point you spend, you can heal an
             additional 2d10 points of damage (to a maximum of 10d10 points per
             manifestation).

    @author Stratovarius
    @date   Created: May 11, 2005
    @date   Modified: Jul 3, 2006
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"

void main()
{
    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif = EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

	if(manif.bCanManifest)
	{
		// Target needs to be willing
	    if(!GetIsEnemy(oTarget))
	    {
	        int nNumberOfDice = 2;
			if (manif.bAugment)
				nNumberOfDice += 2;
	        int nHeal;
	        effect eHeal, eDam;
	
	        // Handle Twin Power
	        int nRepeats = manif.bTwin ? 2 : 1;
	        for(; nRepeats > 0; nRepeats--)
	        {
	            nHeal = d10(nNumberOfDice);
				if (manif.bMaximize)
					nHeal = 10*nNumberOfDice;
				if (manif.bEmpower)
					nHeal = FloatToInt(IntToFloat(nHeal)*1.5f);
				
	            eHeal = EffectHeal(nHeal);
				eHeal = EffectLinkEffects(eHeal, EffectVisualEffect(VFX_HIT_SPELL_HOLY));
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
				eDam = EffectDamage(nHeal/2, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_ENERGY, TRUE);
				eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_HOLY));
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oManifester);
	        }
	    }
	}
}