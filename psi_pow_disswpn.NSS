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
Target: Held weapon(s); see text
Duration: 60 Seconds Per Manifester Level, Twice that when extended
Saving Throw: None
Power Resistance: No
Power Points: 3
Metapsionics: Augment, Extend. 

Your weapon is corrosive, and sizzling moisture visibly oozes from it. You deal 4d6 points of acid damage to any creature you hit with your successful melee attack. Any creature struck by this takes an additional 1d6 irresistible acid damage each round for 8 rounds. If you cast this upon yourself while dual-wielding, the effect automatically applies to both weapons.

Augment: Grants +5d6 acid to weapon and 1d6 irresistible acid damage each round for 10 rounds.

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

void ApplyDissWeapon(object oTarget, int bAug, float fDur){
	if (bAug)
		IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonus(6, IP_CONST_DAMAGEBONUS_5d6), fDur);
	else IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonus(6, IP_CONST_DAMAGEBONUS_4d6), fDur);
	IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_DISSOLVING_WEAPON, 2), fDur);
	IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), fDur);
}


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
							  
	if(!manif.bCanManifest) return;
	
    // Validity check
    if(!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oManifester, "Target must be a weapon or creature holding a weapon!"); // Item must be weapon or creature holding a weapon
    	return;
    }
	float fDur = 60.0f;

	float fDuration = fDur * manif.nManifesterLevel;
	if(manif.bExtend)  fDuration *= 2.0f;
	
	if (manif.bAugment) SetLocalInt(oManifester, "AUGMENT_DISS_WEAP", TRUE);
	else SetLocalInt(oManifester, "AUGMENT_DISS_WEAP", FALSE);
	
	
	ApplyDissWeapon(oTarget, manif.bAugment, fDuration);
	
	object oOff = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oManifester);
	if (IPGetIsMeleeWeapon(oOff))
        ApplyDissWeapon(oOff, manif.bAugment, fDuration);
        
    
}