/** @file psi_pow_bdyadjst

    Body Adjustment

    Psychometabolism (Healing)
    Level: Psion/wilder 3, psychic warrior 2
    Manifesting Time: 1 round
    Range: Personal
    Target: You
    Duration: Instantaneous
    Power Points: Psion/wilder 5, psychic warrior 3
    Metapsionics: Empower, Maximize, Twin

    You take control of your body�s healing process, curing yourself of 1d12
    points of damage.

    Augment: For every 2 additional power points you spend, this power heals an
             additional 1d12 points of damage.

    @author Stratovarius
    @date   Created: Oct 22, 2004
    @date   Modified: Jul 3, 2006
*/
#include "psi_inc_manifest"
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
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_AUGMENT
                              );

    if(manif.bCanManifest)
    {
		int nNumberOfDice = 1;
		if (manif.bAugment)
			nNumberOfDice += 1;
	    int nHeal;
	    effect eHeal, eHealVis = EffectVisualEffect(VFX_IMP_HEALING_L);
	
	    // Handle Twin Power
	    int nRepeats = manif.bTwin ? 2 : 1;
	    for(; nRepeats > 0; nRepeats--)
	    {
	        nHeal = d12(nNumberOfDice);
			if (manif.bMaximize)
				nHeal = 12*nNumberOfDice;
			if (manif.bEmpower)
				nHeal = FloatToInt(IntToFloat(nHeal)*1.5f);
			
				
	        eHeal = EffectHeal(nHeal);
	
	        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal,    oTarget);
	        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
	    }
	}
}