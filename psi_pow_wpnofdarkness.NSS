#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook" 
 /** @file psi_pow_wepnrg

    Weapon of Darkness

    Psychometabolism  [Darkness]
    Level: Psychic warrior 2
    Range: Touch
    Target: Weapon touched
    Duration: 1 round/level
    Power Points: 3
    Metapsionics: Extend
You draw material from the Plane of Shadow. Your hands, weapons and forearms elongate and change shape into featureless claws of inky blackness.
1d6 Cold damage(1d8 If Augmented) , DC 12 + Key ability Modifier for chance to slow enemy down */




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
                              METAPSIONIC_EXTEND||METAPSIONIC_AUGMENT
                              );
							  

    // Validity check
    if(!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oManifester, "Target must be a weapon or creature holding a weapon!"); // Item must be weapon or creature holding a weapon
    	return;
    }

    if(manif.bCanManifest)
{
		int nDamage = IP_CONST_DAMAGEBONUS_1d6;
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;
		if (manif.bAugment) nDamage = IP_CONST_DAMAGEBONUS_1d8;
		int DamageType = IP_CONST_DAMAGETYPE_COLD;
		int iWisMod		= GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);
		int iSaveDC		= 10 + iWisMod;
		itemproperty ipSlow = ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, iSaveDC, 0);
		itemproperty ipCold = ItemPropertyDamageBonus(DamageType,nDamage);  
		{
        IPSafeAddItemProperty(oTarget, ipSlow, fDuration);
		IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_COLD), fDuration);
		IPSafeAddItemProperty(oTarget, ipCold, fDuration);}
		
		
        
    }
}