/** @file psi_pow_destdiss

    Destiny Dissonance

    Clairsentience
    Level: Seer 1
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 round/level
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend, Twin

    Your mere touch grants your foe an imperfect, unfocused glimpse of the many
    possible futures in store. Unaccustomed to and unable to process the information,
    the subject becomes sickened for 1 round per level of the manifester.

    @author Stratovarius
    @date   Created: Jul 15, 2005
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
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
	{
		int nDC         = GetManifesterDC(oManifester);
    	int nPen        = GetPsiPenetration(oManifester);
    	effect eSickened  = EffectAttackDecrease(2);
			   eSickened  = EffectLinkEffects(eSickened, EffectDamageDecrease(2));
			   eSickened  = EffectLinkEffects(eSickened, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2));
			   eSickened  = EffectLinkEffects(eSickened, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
    	effect eImpact  = EffectVisualEffect(VFX_IMP_DOOM);
    	float fDuration = RoundsToSeconds(manif.nManifesterLevel);
    	if(manif.bExtend) fDuration *= 2;

	    int bHit = 0;
	    int nTouchAttack;
	
	    int nRepeats = manif.bTwin ? 2 : 1;
	    for(; nRepeats > 0; nRepeats--)
	    {
	        nTouchAttack = TouchAttackMelee(oTarget);
	        if(nTouchAttack > 0)
	        {
	            if(PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL)
	            {
	                //Apply VFX Impact and shaken effect
	                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSickened, oTarget, fDuration);
	                ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
	            }
	        }
		}
	}
}