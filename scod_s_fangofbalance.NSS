// Fang of Balance
// By Electrohydra
// Last update : 28 / 10 /2015

// Makes natural weapons deal 1 damage vs good / evil / law / chaos
// Based on Magic Fang script
#include "nwn2_inc_spells"

#include "ps_inc_functions"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void DoFangOfBalance(int nVFX)
{
//Declare major variables
	object			oTarget		=	GetSpellTargetObject();
	object			oCaster		=	OBJECT_SELF;
	object 			oGlove 		= 	GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
	object			oWeapon1	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
	object			oWeapon2	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
	object			oWeapon3	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
	object			oCWeapR		=	GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	object			oCWeapL		=	GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	itemproperty	property1	=	ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1);
	itemproperty	property2	=	ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1);
	itemproperty	property3	=	ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1);
	itemproperty	property4	=	ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1);
	float			fDuration	=	TurnsToSeconds(PS_GetCasterLevel(oCaster));
	int         	bApplied    = 	FALSE;
	effect			eVis		=	EffectVisualEffect(nVFX);
//Determine duration
					fDuration	=	ApplyMetamagicDurationMods(fDuration);

//Validate target and apply effect, IPSafeAddItemProperty automatically handles stacking rules.
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
			if (GetIsObjectValid(oGlove) && GetBaseItemType(oGlove) == BASE_ITEM_GLOVES)
			{
				IPSafeAddItemProperty(oGlove, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oGlove, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oGlove, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oGlove, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}
			if (GetIsObjectValid(oWeapon1))
			{
				IPSafeAddItemProperty(oWeapon1, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon1, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}
			if (GetIsObjectValid(oWeapon2))
			{
				IPSafeAddItemProperty(oWeapon2, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon2, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}
			if (GetIsObjectValid(oWeapon3))
			{
				IPSafeAddItemProperty(oWeapon3, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oWeapon3, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}
		//Additional checks to verify equippable creature weapons - Ceremorph 1/10/15
			if (GetIsObjectValid(oCWeapR) && IPGetIsCreatureEquippedWeapon(oCWeapR))
			{
				IPSafeAddItemProperty(oCWeapR, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapR, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}
			if (GetIsObjectValid(oCWeapL) && IPGetIsCreatureEquippedWeapon(oCWeapL))
			{
				IPSafeAddItemProperty(oCWeapL, property1, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property2, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property3, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				IPSafeAddItemProperty(oCWeapL, property4, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
				bApplied = TRUE;
			}				
		//End Ceremorph edits	
							
			if (bApplied != FALSE){
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
			} else {
				FloatingTextStringOnCreature("No valid creature weapons found", oCaster);
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


    DoFangOfBalance(VFX_DUR_SPELL_MAGIC_FANG);
}