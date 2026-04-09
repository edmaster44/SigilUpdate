/** @file psi_pow_dsspttch

    Dissipating Touch

    Psychoportation (Teleportation)
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Empower, Maximize, Twin

    Your mere touch can disperse the surface material of a foe, sending a tiny
    portion of it far away. This effect is disruptive; thus, your successful
    melee touch attack deals 1d6 points of damage.

    Augment: For every additional power point you spend, this power�s damage
             increases by 1d6 points.

    @author Stratovarius
    @date   Created: Oct 27, 2005
    @date   Modified: Jul 3, 2006
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_teleport"

void main()
{
    if(!PsiPrePowerCastCode()) return;
    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif = EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
    	int nPen          = GetPsiPenetration(oManifester);
    	int nNumberOfDice = 1;
		if (manif.bAugment)
			nNumberOfDice += 1;
    	int nTouchAttack, nDamage;
   	 	effect eVis = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
		int bHit = 0;

    	int nRepeats = manif.bTwin ? 2 : 1;
    	for(; nRepeats > 0; nRepeats--)
    	{
			if (bHit)
				return;
        	nTouchAttack = TouchAttackMelee(oTarget);
        	if(nTouchAttack > 0)
        	{
            	bHit = 1;
            	if(PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL)
            	{
	                // Check if the target can be teleported
	               	if(!GetCanTeleport(oTarget, GetArea(oTarget)))
	                {
						nDamage = d6(nNumberOfDice);
						if (manif.bEmpower)
							nDamage = FloatToInt(IntToFloat(nDamage)*1.5f);
						else if (manif.bMaximize)
							nDamage = 6*nNumberOfDice;
						
						effect eDamage = EffectDamage(nDamage);
	
	                    // Apply VFX and damage
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	                }
				}
            }
        }
    }
}