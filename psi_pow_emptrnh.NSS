/** @file psi_pow_emptrnh

    Empathic Transfer, Hostile

    Telepathy [Mind-Affecting]
    Level: Telepath 3, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Twin, Widen

    You transfer your hurt to another. When you manifest this power and then
    make a successful touch attack, you can transfer 50 points of damage (or
    less, if you choose) from yourself to the touched creature. You immediately
    regain hit points equal to the amount of damage you transfer.

    You cannot use this power to gain hit points in excess of your full normal
    total. The transferred damage is empathic in nature, so powers and abilities
    the subject may have such as damage reduction and regeneration do not lessen
    or change this damage.

    The damage transferred by this power has no type, so even if the subject has
    immunity to the type of damage you originally took, the transfer occurs
    normally and deals hit point damage to the subject.

    Augment: You can augment this power in one or both of the following ways.
    1. For every additional power point you spend, you can transfer an additional
       10 points of damage (maximum 90 points per manifestation).
    2. If you spend 6 additional power points, this power affects all creatures
       in a 20-foot-radius spread centered on you. The amount of damage
       transferred is divided evenly among all hostile creatures in the area.

    @author Stratovarius
    @date   Created: Apr 19, 2005
    @date   Modified: Jul 3, 2006
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"

void main()
{
    if(!PsiPrePowerCastCode()) return;
	
	object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
		int nDC          = GetManifesterDC(oManifester);
    	int nPen         = GetPsiPenetration(oManifester);
		int nMaxDamage = 50;
		if (manif.bAugment)
			nMaxDamage += 20;
    	int nMaxTran     = min(nMaxDamage,                           // Maximum transferrable is 50 + 10 * augmentation (2 in this case)
                           GetMaxHitPoints(oManifester) - GetCurrentHitPoints(oManifester) // Limited to the amount of damage the manifester has actually suffered
                           );
    	float fRadius    = FeetToMeters(20.0f);
		if (manif.bWiden)
			fRadius *= 2;
    	location lTarget = GetSpellTargetLocation();

    	int bHit = 0;

	    int nRepeats = manif.bTwin ? 2 : 1;
	    for(; nRepeats > 0; nRepeats--)
	    {
			if (bHit)
				return;
	        if(TouchAttackMelee(oTarget) > 0) // No need to store the result, critical hits nor precision-based damage work with this power
	        {
	        	bHit = 1;
	            // Mind-affecting immunity
	            
	            	if(PRCMyResistPower(oManifester, oTarget, nPen))
	                {
	                	if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
	                     	nMaxTran /= 2;
	                    }
						
						// Apply the healing
	                    effect eHeal = EffectHeal(nMaxTran);
						eHeal = EffectLinkEffects(eHeal, EffectVisualEffect(VFX_HIT_SPELL_EVIL));
   	    				effect eDamage = EffectDamage(nMaxTran, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
						eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_HIT_SPELL_EVIL));
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oManifester);
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	                }// end if - SR check
	            
	        }// end if - Hit with a touch attack
	    }
	}
}