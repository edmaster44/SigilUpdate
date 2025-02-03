/** @file psi_pow_psyvamp

    Psychic Vampire

    Psychometabolism
    Level: Egoist 4, psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Twin

    This power shrouds your hand with darkness that you can use to drain an
    opponent�s power.

    If you make a successful melee touch attack (if the victim fails its
    Fortitude save), the darkness drains 2 power points from your foe for every
    manifester level you have. The drained points simply dissipate.

    Against a psionic being that has no power points or a nonpsionic foe, your
    attack instead deals 2 points of Intelligence, Wisdom, and Charisma damage.

    @author Stratovarius
    @date   Created: May 17, 2005
    @date   Modified: Jul 3, 2006
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_sp_func"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nDC         = GetManifesterDC(oManifester);
    int nPen        = GetPsiPenetration(oManifester);
    effect eVis     = EffectVisualEffect(VFX_IMP_HARM);

    int nDamage, nTouchAttack;
    int bHit = 0;

    SignalEvent(oTarget, EventSpellCastAt(oManifester, manif.nSpellID));

    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        nTouchAttack = TouchAttackMelee(oTarget);
        if(nTouchAttack > 0)
        {
            bHit = 1;
            if(PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL)
            {
                // Save - Fortitude negates
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    // Check if the target has PP to lose
					int currentPP = GetLocalInt(oTarget, "PSI_PP");
					int finalPP = currentPP-(2 * manif.nManifesterLevel);
					if(finalPP < 0)
					{
						finalPP = 0;
					}
                    if(currentPP != 0)
                    {
                       SetLocalInt(oTarget, "PSI_PP", finalPP);
					   SetGUIObjectText(oTarget, "powerpointscreen", "PPRatioTXT", -1, IntToString(finalPP));
                    }
                    // No PP, do ability damage
                    else
                    {
                         ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CHARISMA,2), oTarget);  
                         ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_WISDOM,2), oTarget);  
                         ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_INTELLIGENCE,2), oTarget);  
                    }

                    // Do VFX
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }// end if - Save
            }
        }
    }

    return bHit;    //Held charge is used if at least 1 touch from twinned power hits
}

void main()
{
    if(!PsiPrePowerCastCode()) return;
	
    object oManifester = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
		int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
	    	if (TouchAttackMelee(oTarget) > 0)
	            DoPower(oManifester, oTarget, manif);
		}
        
    }
}