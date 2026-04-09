/** @file psi_pow_powres

    Power Resistance

    Clairsentience
    Level: Psion/wilder 5
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 9
    Metapsionics: Extend

    The creature gains power resistance equal to 12 + your manifester level.

    @author Stratovarius
    @date   Created: Feb 23, 2004
    @date   Modified: Jul 3, 2005
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_sp_func"

void main()
{
    if(!PsiPrePowerCastCode()) return;
	
    object oManifester = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND);
		
	int nSR         = 12 + manif.nManifesterLevel;
	effect eLink    =                          EffectSpellResistanceIncrease(nSR);
	       eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	       eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE));
	effect eVis     = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
	float fDuration = 60.0f * manif.nManifesterLevel;
	if(manif.bExtend) fDuration *= 2;
							  
    if(manif.bCanManifest)
    {
	
	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}