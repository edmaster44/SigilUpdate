//::///////////////////////////////////////////////
//:: Jagged Tooth
//:: nw_s0_jagtooth.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	This spell doubles the critical threat range of one natural weapon
	that deals either slashing or peircing damage.  Multiple spell effects
	that increase a weapon's threat range don't stack.  This spell is
	typically cast on animal companions.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 19, 2006
//:://////////////////////////////////////////////


#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"
#include "x2_inc_itemprop"
#include "ps_inc_functions"

void  AddKeenEffectToWeapon(object oMyWeapon, float fDuration)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
   return;
}
 
void main()
{
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

//Declare major variables
	object			oTarget		=	GetSpellTargetObject();
	object			oCaster		=	OBJECT_SELF;
	object			oWeapon1	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
	object			oWeapon2	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
	object			oWeapon3	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
	object			oHide		=	GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
	object			oCWeapR		=	GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	object			oCWeapL		=	GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	itemproperty	iImpCritUna =	ItemPropertyBonusFeat(58);
	float			fDuration	=	IntToFloat(600*PS_GetCasterLevel(oCaster));
	effect			eVis		=	EffectVisualEffect(VFX_SPELL_DUR_JAGGED_TOOTH);
	int				cWeaponFound = 	FALSE;
	int				cWeapREq	=	FALSE;
	int				cWeapLEq	= 	FALSE;
	
//Determine duration
					fDuration	=	ApplyMetamagicDurationMods(fDuration);

//Validate target and apply effect, IPSafeAddItemProperty automatically handles stacking rules.
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
			if (GetIsObjectValid(oWeapon1))
			{
				cWeaponFound = TRUE;
			}
			else if (GetIsObjectValid(oWeapon2))
			{
				cWeaponFound = TRUE;
			}
			else if (GetIsObjectValid(oWeapon3))
			{
				cWeaponFound = TRUE;
			}
			if (GetIsObjectValid(oCWeapR)) 
			{
				if (IPGetIsCreatureEquippedWeapon(oCWeapR))
					cWeapREq = TRUE;
			}
			if (GetIsObjectValid(oCWeapL)) 
			{
				if (IPGetIsCreatureEquippedWeapon(oCWeapL))
					cWeapLEq = TRUE;
			}
					

		//Additional Code for Equipped Creature Weapons - Ceremorph 1/10/15
			if (cWeapREq == TRUE)
			{
 	           if (fDuration>0.0)
 	           {
	                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon)); //NWN1 VFX
	               
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oCWeapR), fDuration);
	                AddKeenEffectToWeapon(oCWeapR, fDuration);
 	           }
			}
						
			if (cWeapLEq == TRUE)
			{
 	           if (fDuration>0.0)
 	           {
	                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon)); //NWN1 VFX
	                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oCWeapL), fDuration);
	                AddKeenEffectToWeapon(oCWeapL, fDuration);
 	           }
			return;
			}
			//End of Ceremorph edits


			if (cWeaponFound == TRUE)
			{
				if (!GetIsObjectValid(oHide))
				{
					oHide = CreateItemOnObject("x2_it_emptyskin", oTarget, 1, "", FALSE);
				}
				IPSafeAddItemProperty(oHide, iImpCritUna, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
				DelayCommand(fDuration, DestroyObject(oHide,0.0f,FALSE));
				AssignCommand(oTarget, ClearAllActions());
				AssignCommand(oTarget, ActionEquipItem(oHide,INVENTORY_SLOT_CARMOUR));	
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
			}

		}
		
		if (cWeaponFound ==	FALSE && cWeapREq == FALSE && cWeapLEq == FALSE) // no creature weapons at all!
		{
			SendMessageToPC(oCaster, "Invalid Target.  Target must have at least one natural weapon, or an equipped creature weapon in its right hand.");
		}
	}
}