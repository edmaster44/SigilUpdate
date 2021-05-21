//::///////////////////////////////////////////////
//:: Bind Weapon 1-3
//:: fellblade_bindweapon
//:: 5/20/21 - Mimi Fearthegn
//:://////////////////////////////////////////////
/*
  Impact script for the warlock Bind Weapon ability
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System

// JLR - OEI 07/11/05 NWN2 3.5

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "ps_inc_functions"
#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode()) {
        return;
    }
	
	object oCaster = OBJECT_SELF;
	object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();
	float fDuration = HoursToSeconds(24);
	
	if(GetIsObjectValid(oMyWeapon) ) {
	
		if (GetHasFeat(FEAT_FELLBLADE_BIND_WEAPON_3, oCaster, TRUE)) {
			IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(5), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
			IPSafeAddItemProperty(oMyWeapon,ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
		} else if (GetHasFeat(FEAT_FELLBLADE_BIND_WEAPON_2, oCaster, TRUE)) {
			IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(3), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
			IPSafeAddItemProperty(oMyWeapon,ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
		} else {
			IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(2), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
		}
	
	} else {
	
    	FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
		
    }

}