// Fang of Balance, Greater
// By Electrohydra
// Last update : 28 / 10 /2015

// Makes natural weapons deal 1d4 damage vs good / evil / law / chaos, 1d8 if two components
// Based on Magic Fang script
#include "nwn2_inc_spells"

#include "ps_inc_functions"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void DoGreaterFangOfBalance(int nVFX)
{
//Declare major variables
	object			oTarget		=	GetSpellTargetObject();
	object			oCaster		=	OBJECT_SELF;
	object			oWeapon1	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
	object			oWeapon2	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
	object			oWeapon3	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
	object			oCWeapR		=	GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	object			oCWeapL		=	GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	itemproperty	property1	=	ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4);
	itemproperty	property2	=	ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4);
	itemproperty	property3	=	ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4);
	itemproperty	property4	=	ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4);
	itemproperty	property5	=	ItemPropertyDamageBonusVsSAlign(IP_CONST_ALIGNMENT_CE, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d8);
	itemproperty	property6	=	ItemPropertyDamageBonusVsSAlign(IP_CONST_ALIGNMENT_CG, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d8);
	itemproperty	property7	=	ItemPropertyDamageBonusVsSAlign(IP_CONST_ALIGNMENT_LG, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d8);
	itemproperty	property8	=	ItemPropertyDamageBonusVsSAlign(IP_CONST_ALIGNMENT_LE, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d8);
	float			fDuration	=	RoundsToSeconds(PS_GetCasterLevel(oCaster));
	int         	bApplied    = 	FALSE;
	effect			eVis		=	EffectVisualEffect(nVFX);
//Determine duration
					fDuration	=	ApplyMetamagicDurationMods(fDuration);

//Validate target and apply effect, IPSafeAddItemProperty automatically handles stacking rules.
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
			if (GetIsObjectValid(oWeapon1))
			{
				IPSafeAddItemProperty(oWeapon1, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property5, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property6, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property7, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property8, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}
			if (GetIsObjectValid(oWeapon2))
			{
				IPSafeAddItemProperty(oWeapon2, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property5, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property6, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property7, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property8, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}
			if (GetIsObjectValid(oWeapon3))
			{
				IPSafeAddItemProperty(oWeapon3, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property5, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property6, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property7, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property8, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}
		//Additional checks to verify equippable creature weapons - Ceremorph 1/10/15
			if (GetIsObjectValid(oCWeapR) && GetBaseItemType(oCWeapR) >= 160 && GetBaseItemType(oCWeapR) <= 177)
			{
				IPSafeAddItemProperty(oCWeapR, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property5, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property6, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property7, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property8, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}
			if (GetIsObjectValid(oCWeapL) && GetBaseItemType(oCWeapL) >= 160 && GetBaseItemType(oCWeapL) <= 177)
			{
				IPSafeAddItemProperty(oCWeapL, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property5, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property6, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property7, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property8, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}				
		//End Ceremorph edits	
							
			if (bApplied != FALSE)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
			}
		}
		else
		{
			FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_SPELL_INVALID_TARGET, oTarget);
		}
	}
}

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    DoGreaterFangOfBalance(VFX_DUR_SPELL_MAGIC_FANG);
}