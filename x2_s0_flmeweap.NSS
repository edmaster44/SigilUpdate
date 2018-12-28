//::///////////////////////////////////////////////
//:: Flame Weapon
//:: X2_S0_FlmeWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//  Gives a melee weapon 1d4 fire damage +1 per caster
//  level to a maximum of +10.
  3.5: Gives a melee weapon +1d6 fire damage (flat).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System


// (Update JLR - OEI 07/26/05) -- 3.5 Update
// (Update BDF - OEI 08/29/05) -- Corrected the spellID param value of ItemPropertyOnHitCastSpell
// AFW-OEI 07/23/2007: If it's going to be fixed fire damage, forget the fancy on-hit spell and just
//	go with our elemental damage item property.  Also, increase to 1d8.
// RPGplayer1 03/19/2008: Won't replace non-fire elemental damage
// RPGplayer1 01/11/2009: Corrected duration to 1 turn/level


#include "nw_i0_spells"
#include "x2_i0_spells"
#include "ps_inc_functions"
#include "x2_inc_spellhook"



void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    int nDuration = PS_GetCasterLevel(OBJECT_SELF);
	
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }
	
	object oTarget			=	GetSpellTargetObject();
	object oMyWeaponRight	=  GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);	
	object oMyWeaponLeft	=  GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);		
	int bEffectApplied = FALSE;
	
	if(GetIsObjectValid(oMyWeaponRight))
	{
		if (nDuration > 0)
		{
			itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);
			
			IPSafeAddItemProperty(oMyWeaponRight, ipFlame, TurnsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			bEffectApplied = TRUE;
			
			if (GetIsObjectValid(oMyWeaponLeft))
				IPSafeAddItemProperty(oMyWeaponLeft, ipFlame, TurnsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		}
	
		//Additional lines for equipped creature weapon in the left hand - Ceremorph 1/10/15
		if (GetIsObjectValid(oMyWeaponLeft) && GetBaseItemType(oMyWeaponLeft) >= 160 && GetBaseItemType(oMyWeaponLeft) <= 174)	
		{
			itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);
		
			IPSafeAddItemProperty(oMyWeaponLeft, ipFlame, TurnsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		}
	}
	else
			// else IPGetTargetedOrEquippedMeleeWeapon must have picked up a creature weapon
			// so we want to apply it to all, otherwise just one gets the bonus.
	{
		object	oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
		object	oWeapon2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
		object	oWeapon3 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
		
		if (nDuration > 0)
		{
			itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);
		
			if (GetIsObjectValid(oWeapon1))
			{
				IPSafeAddItemProperty(oWeapon1, ipFlame, TurnsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
				bEffectApplied = TRUE;
			}
			if (GetIsObjectValid(oWeapon2))
			{
				IPSafeAddItemProperty(oWeapon2, ipFlame, TurnsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
				bEffectApplied = TRUE;
			}
			if (GetIsObjectValid(oWeapon3))
			{
				IPSafeAddItemProperty(oWeapon3, ipFlame, TurnsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
				bEffectApplied = TRUE;
			}
		 }
	}
	
	if (bEffectApplied == FALSE)
	{
		FloatingTextStrRefOnCreature(83615, oTarget);
	}
}