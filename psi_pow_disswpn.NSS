//:://////////////////////////////////////////////
//:: Power: Dissolving Weapon
//:: psi_pow_disswpn
//:://////////////////////////////////////////////
/** @file

    Dissolving Weapon

    Psychometabolism [Acid]
    Level: Psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: One held weapon; see text
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    Your weapon is corrosive, and sizzling moisture visibly oozes from it.
    You deal 4d6 points of acid damage to any creature or object you touch
    with your successful melee attack. Your weapon is charged with acid until
    you make a successful attack.

    Augment: For every 2 additional power points you spend, this power�s damage
             increases by 1d6 points.


    @author Ornedan
    @date   Created - 2005.01.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//#include "psi_inc_onhit"
#include "psi_inc_psifunc"
#include "psi_spellhook"
#include "x2_inc_itemprop"

//Based on event system, needs to be reworked - Mimi
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
                              METAPSIONIC_AUGMENT
                              );
							  
	if(manif.bCanManifest)
    {
		float fDur = 6.0f;
		if (manif.bAugment)
			fDur *= 2;
			
		object oWeapon = GetItemInSlot(4, oTarget);
		if (!GetIsObjectValid(oWeapon)) {
			SendMessageToPC(oManifester, "The target must have a weapon equipped in their right hand for the spell to work.");
			return;
		}
			
        effect eVis         = EffectVisualEffect(VFX_HIT_SPELL_ACID);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		itemproperty ipAdd = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_4d6);
        IPSafeAddItemProperty(oWeapon, ipAdd, fDur);
		
    }// end else - Running OnHit*/
}