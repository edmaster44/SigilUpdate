//:://////////////////////////////////////////////
//:: Power: Stygian Weapon
//:: psi_pow_stygwn
//:://////////////////////////////////////////////
/** @file

    Stygian Weapon

    Psychometabolism 
    Level: Psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: One held weapon; see text
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Augmented
	
	
 Tendrils of crackling black energy course from you into your weapon.

You form a momentary link between yourself and the Negative Energy Plane, allowing you to empower your weapon with fell energy, 1d4 Negative Damage, Augmenting your power 
adds an extra 1d2 Damage for a grand total of 1d6 negative
On a successful attack, your foe is treated as if struck with a stygian ray, Draining your foes level DC 10 + Wisdom Modifer 

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"



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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER|METAPSIONIC_EXTEND  
                              );
							  

    // Validity check
    if(!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oManifester, "Target must be a weapon or creature holding a weapon!"); // Item must be weapon or creature holding a weapon
    	return;
    }

    if(manif.bCanManifest)
{
		int nDamage = IP_CONST_DAMAGEBONUS_1d4;
        effect eVis     = EffectVisualEffect(VFX_IMP_AURA_NEGATIVE_ENERGY);
		int iWisMod		= GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);
		int iSaveDC		= 10 + iWisMod;
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;
		if (manif.bAugment) nDamage = IP_CONST_DAMAGEBONUS_1d6;
		
		itemproperty ipDrainer = ItemPropertyOnHitProps(IP_CONST_ONHIT_LEVELDRAIN, iSaveDC, 0);
		itemproperty ipGlow = ItemPropertyVisualEffect(ITEM_VISUAL_EVIL);
		int DamageType = IP_CONST_DAMAGETYPE_NEGATIVE;
		itemproperty ipNegative = ItemPropertyDamageBonus(DamageType,nDamage);  
        
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipNegative, oTarget, fDuration);
		AddItemProperty(DURATION_TYPE_TEMPORARY, ipGlow, oTarget, fDuration);
		AddItemProperty(DURATION_TYPE_TEMPORARY, ipDrainer, oTarget, fDuration);
		
        
    }
}