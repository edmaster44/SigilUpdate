#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"

/*A black ray of energy springs from your outstretched hand to strike your enemy.

You form a momentary link between yourself and the Negative Energy Plane, allowing you to release a black ray that suppresses the life force of any living creature it strikes. You must make a ranged touch attack to hit.

If the attack succeeds, the subject gains 1d4 negative levels for 1 round (see the Negative Levels sidebar on page 100). 
If the subject has at least as many negative levels as it has Hit Dice, it is stunned for 1 round instead.
 On the following round, the subject regains lost levels.
 Usually, negative levels have a chance of permanently draining the victim’s levels (or killing creatures with Hit Dice equal to or less than the number of negative levels gained), but the negative levels from stygian ray don’t last long enough to do so.
*/


int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nWisdom = GetAbilityModifier(ABILITY_WISDOM,oManifester);
    int nDC         =  10 + nWisdom + 6;
    int nPen        = GetPsiPenetration(oManifester);
	float fDuration = 600.0f;
	int nDrain = d4();
    effect eVis     = EffectVisualEffect(VFX_IMP_HARM);
	effect eHeal  	= EffectBonusHitpoints(5);
	effect eDrain = EffectNegativeLevel(nDrain);
	eDrain = SupernaturalEffect(eDrain);

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
                if(!MySavingThrow(SAVING_THROW_TYPE_NONE, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                  
                         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, fDuration);  
						 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, oManifester, fDuration);  
                       
                

                    // Do VFX
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }// end if - Save
            }
        }
    }

    return bHit;    //Held charge is used if at least 1 touch from twi
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