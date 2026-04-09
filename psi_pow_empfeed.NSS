/*
   ----------------
   Empathic Feedback

   psi_pow_empfeed
   ----------------

   19/2/04 by Stratovarius
*/ /** @file

    Empathic Feedback

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 4, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: Psion/wilder 7, psychic warrior 5
    Metapsionics: Extend

    You empathically share your pain and suffering with your attacker. Each time
    a creature strikes you in melee, it takes damage equal to the amount it
    dealt to you or 5 points, whichever is less. This damage is empathic in
    nature, so powers and abilities the attacker may have such as damage
    reduction and regeneration do not lessen or change this damage. The damage
    from empathic feedback has no type, so even if you took fire damage from a
    creature that has immunity to fire, empathic feedback will damage your
    attacker.

    Augment: For every additional power point you spend, this power�s damage
             potential increases by 1 point.
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );
							  
	float fDuration = 600.0f * manif.nManifesterLevel;
	if (manif.bExtend)
		fDuration *= 2;
							  
	int nDamage = 4;
	if (manif.bAugment)
		nDamage += 3;		
	//fx_shining_shield
	effect eLink = EffectDamageShield(nDamage, DAMAGE_BONUS_1, DAMAGE_TYPE_ALL);
	       eLink = EffectLinkEffects(eLink, EffectNWN2SpecialEffectFile("fx_shining_shield"));
		   
	if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	}
	
}