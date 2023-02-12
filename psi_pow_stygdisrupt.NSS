//:://////////////////////////////////////////////
//:: Power: Stygian Disruption
//:: psi_pow_stygdisrupt
//:://////////////////////////////////////////////
/** @file

    Stygian Disruption

    Psychometabolism 
    Level: Psychic warrior4
    Manifesting Time: 1 standard action
    Range: Personal
    Target: One held weapon; see text
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 7
    Metapsionics: Extend
	A massive surge of brilliant white light envelops your weapon.
	You give a weapon the disruption special ability in addition to any other properties it has. A weapon of disruption is the bane of all undead
    

    @edmaster44
	@created 2/7/2023
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"

const int IP_CONST_FEAT_UNDEAD_RUIN = 393;


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
                              METAPSIONIC_EXTEND 
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
        if(manif.bExtend){ fDuration *= 2;}
		itemproperty iRuin		= 	ItemPropertyBonusFeat(IP_CONST_FEAT_UNDEAD_RUIN);
		{IPSafeAddItemProperty(oTarget,iRuin, fDuration);
		IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration);}
        
        
    }
}