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

    Augment: For every 2 additional power points you spend, this power’s damage
             increases by 1d6 points.


    @author Ornedan
    @date   Created - 2005.01.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"

const int IP_CONST_ONHIT_CASTSPELL_DISSOLVING_WEAPON = 148;


void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/
    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oManifester = OBJECT_SELF;
    object oTarget     = IPGetTargetedOrEquippedMeleeWeapon();
     struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER |METAPSIONIC_EXTEND 
                              );
							  

    // Validity check
    if(!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oManifester, "Target must be a weapon or creature holding a weapon!"); // Item must be weapon or creature holding a weapon
    	return;
    }

    if(manif.bCanManifest)
{
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;
		IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_DISSOLVING_WEAPON, 2), fDuration);
		IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), fDuration);
        
        
    }
}