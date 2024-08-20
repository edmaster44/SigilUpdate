/** @file psi_pow_restore

    Restoration, Psionic

    Psychometabolism (Healing)
    Level: Egoist 6
    Manifesting Time: 3 rounds
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 11
    Metapsionics: None

    As the restoration spell, except as noted here.

    @author Stratovarius
    @date   Created: Feb 19, 2004
    @date   Modified: Jul 3, 2006
*/

// Aug 20, 2024 FlattedFifth -  Streamlined Code by reducing the number of external function calls from 36 
//				per effect on target to 3. Introduced function call in spellhook to check for effects that
//				include some negative aspects but should NOT be removed due to them being racial, class feats
//				beneficial spells that are only partly negative, etc. Removed checks that are now redundant due
//				to aforementioned. 

#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_sp_func"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nEffectType;
    effect eVis = EffectVisualEffect(VFX_IMP_RESTORATION);
    effect eTest;
	int nId;
    // Let the AI know - Special handling
    SignalEvent(oTarget, EventSpellCastAt(oManifester, manif.nSpellID));

    // Loop over remaining effects, remove any negative ones
    eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
		nId = GetEffectSpellId(eTest);
		nEffectType = GetEffectType(eTest);
		if((nEffectType == EFFECT_TYPE_ABILITY_DECREASE          ||
			nEffectType == EFFECT_TYPE_AC_DECREASE               ||
			nEffectType == EFFECT_TYPE_ATTACK_DECREASE           ||
			nEffectType == EFFECT_TYPE_DAMAGE_DECREASE           ||
			nEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE  ||
			nEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE     ||
			nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
			nEffectType == EFFECT_TYPE_SKILL_DECREASE            ||
			nEffectType == EFFECT_TYPE_BLINDNESS                 ||
			nEffectType == EFFECT_TYPE_DEAF                      ||
			nEffectType == EFFECT_TYPE_PARALYZE                  ||
			nEffectType == EFFECT_TYPE_NEGATIVELEVEL)			&&
			!GetSkipByRestoration(nId)
			/* The following are redundant since the inclusion of the
			 more thorough function call above
			nId != SPELL_ENLARGE_PERSON &&
			nId != SPELL_RIGHTEOUS_MIGHT &&
			nId != SPELL_STONE_BODY &&
			nId != SPELL_IRON_BODY
			*/
			)
		{
			RemoveEffect(oTarget, eTest);
			eTest = GetFirstEffect(oTarget);
		} else
			eTest = GetNextEffect(oTarget);
		
    }// end while - Effect loop

    // Apply visuals
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    return TRUE;    //Held charge is used if at least 1 touch from twinned power hits
}

void main()
{
    if(!PsiPrePowerCastCode()) return;
    object oManifester = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
    	DoPower(oManifester, oTarget, manif);
    }
}