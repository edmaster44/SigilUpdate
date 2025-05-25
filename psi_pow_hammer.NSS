
/** @file psi_pow_hammer

    Hammer

    Psychometabolism
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 swift action
    Range: Touch
    Target: One creature or object
    Duration: Instantenous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Empower, Maximize, Twin

    This power charges your touch with the force of a sledgehammer. A successful
    melee touch attack deals 1d8 points of bludgeoning damage. This damage is
    not increased or decreased by your Strength modifier.

    Manifesting this power is a swift action, like manifesting a quickened
    power, and it counts toward the normal limit of one quickened power per
    round. You cannot manifest this power when it isn't your turn.

    Augment: For every additional power point spent, this power's damage
             increases by 1d8.

    @author Stratovarius
    @date   Created: Oct 31, 2004
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"


int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nDC         = GetManifesterDC(oManifester);
    int nPen        = GetPsiPenetration(oManifester);
	int nNumberOfDice = 1;
	effect eDamage;
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
			nDamage = d8(nNumberOfDice) ;
			if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
			            {
			                nDamage = nDamage * 2;
			            }
            		eDamage = EffectDamage(nDamage,DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_NORMAL,TRUE);

                    // Do VFX
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                }// end if - Save
            
        }
    

    return bHit;    //Held charge is used if at least 1 touch from twinned power hits
}

void main()
{
    if(!PsiPrePowerCastCode()) return;
    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND||METAPSIONIC_AUGMENT
                              );
 
       

        
            DoPower(oManifester, oTarget, manif);
   }