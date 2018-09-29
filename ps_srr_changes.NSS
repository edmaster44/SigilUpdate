// script to handle the variety of appearance changes and polymorphs on lycanthropes and vampires

#include "x2_inc_itemprop"
#include "lycantrope_stats"

// spell ID consts
const int SRR_HUMAN_FORM = 1346;
const int SRR_HYBRID_FORM = 1347;
const int SRR_VDARK_FORM = 1348;
const int SRR_BEAST_FORM = 1349;
const int SRR_VBAT_FORM = 1350;
const int SRR_VWOLF_FORM = 1351;
const int SRR_VGAS_FORM = 1352;

// appearance consts
// const int SRR_APP_WWOLF_F = 171; - removed due to problems with model wielding weapon. Females now have the same male form.
const int SRR_APP_WRAT = 1045;
const int SRR_APP_WWOLF_M = 1294;
const int SRR_APP_HUMAN = 6;

// race consts
const int SUBRACE_VAMPIRE = 159;
const int SUBRACE_WEREWOLF = 144;
const int SUBRACE_WERERAT = 145;

// polymorph consts
const int SRR_POLY_LWOLF = 395;
const int SRR_POLY_LRAT = 396;
const int SRR_POLY_VWOLF = 397;
const int SRR_POLY_VBAT = 398;
const int SRR_POLY_VGAS = 399;
const int SRR_POLY_VAMP_M = 400;
const int SRR_POLY_VAMP_F = 401;

void main()
{
	object oPC = OBJECT_SELF;
	int iSpell = GetSpellId();
	int iShape;
	effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
	object oHide;
	
	if (iSpell == SRR_HUMAN_FORM || iSpell == SRR_HYBRID_FORM)
	{
		if (iSpell == SRR_HUMAN_FORM)
		{
			applyPenalties(oPC);
			
			iShape = SRR_APP_HUMAN;
			object oHideDel = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
			SetItemCursedFlag(oHideDel, FALSE);
			DestroyObject(oHideDel, 0.5);
		}
		else if (iSpell == SRR_HYBRID_FORM)
		{
			removePenalties(oPC);
			
			if (GetSubRace(oPC) == SUBRACE_WERERAT)
			{
				iShape = SRR_APP_WRAT;
				oHide = CreateItemOnObject("ps_srr_wrhyhide", oPC);
			}
			else
			{
				/*if (GetGender(oPC) == GENDER_FEMALE)
					iShape = SRR_APP_WWOLF_F;
				else */
					iShape = SRR_APP_WWOLF_M; // females now get same form as males due to model issues
				
				oHide = CreateItemOnObject("ps_srr_wwhyhide", oPC);
			}
		}
	
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
		SetCreatureAppearanceType(oPC, iShape);
		
		if (GetIsObjectValid(oHide))
		{
			AssignCommand(oPC, ActionEquipItem(oHide, INVENTORY_SLOT_CARMOUR));
		}
	}
	else // its a polymorph
	{
		if (iSpell == SRR_BEAST_FORM)
		{	
			// First set them to hybrid form and remove human form penalties
			removePenalties(oPC);
			if (GetSubRace(oPC) == SUBRACE_WERERAT)
			{
				iShape = SRR_POLY_LRAT;
				SetCreatureAppearanceType(oPC, SRR_APP_WRAT);
			}
			else
			{
				iShape = SRR_POLY_LWOLF;
				SetCreatureAppearanceType(oPC, SRR_APP_WWOLF_M);
			}
		}
		else if (iSpell == SRR_VBAT_FORM)
			iShape = SRR_POLY_VBAT;
		else if (iSpell == SRR_VWOLF_FORM)
			iShape = SRR_POLY_VWOLF;
		else if (iSpell == SRR_VGAS_FORM)
			iShape = SRR_POLY_VGAS;
		else if (iSpell == SRR_VDARK_FORM)
		{
			if (GetGender(oPC) == GENDER_FEMALE)
				iShape = SRR_POLY_VAMP_F;
			else
				iShape = SRR_POLY_VAMP_M;
		}
			
		effect ePoly = EffectPolymorph(iShape, FALSE, TRUE);
		ePoly = EffectLinkEffects(eVis, ePoly);
			
	    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",iShape)) == 1;
	    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",iShape)) == 1;
	    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",iShape)) == 1;
	
	    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
	    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
	    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
	    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
	    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
	    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
	    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
	    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
	    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
	    if (GetIsObjectValid(oShield))
	    {
	        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
	            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
	            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
	        {
	            oShield = OBJECT_INVALID;
	        }
	    }

		ClearAllActions();
		
		// grant bonuses based off caster level.
		effect eBuild;
		
		if (iShape != SRR_POLY_VGAS) // don't apply bonuses to non-combat form.
		{
			int iLevel = GetTotalLevels(oPC, TRUE);
			int iBonus = iLevel/5 + 1;
			eBuild = EffectAbilityIncrease(ABILITY_STRENGTH, iBonus);
			eBuild = EffectLinkEffects(eBuild, EffectAbilityIncrease(ABILITY_DEXTERITY, iBonus));
			eBuild = EffectLinkEffects(eBuild, EffectAbilityIncrease(ABILITY_CONSTITUTION, iBonus));
			eBuild = EffectLinkEffects(eBuild, EffectACIncrease(iBonus, AC_DODGE_BONUS));
			eBuild = EffectLinkEffects(eBuild, EffectDamageIncrease(iBonus,DAMAGE_TYPE_MAGICAL));
			
			if (iShape == SRR_POLY_VBAT)
			{
				eBuild = EffectLinkEffects(eBuild, EffectMovementSpeedIncrease(99));
			}
		
			ePoly = EffectLinkEffects(eBuild, ePoly);
		}
		
		string sVFX = Get2DAString("polymorph", "VFX", iShape);
		if (sVFX != "")
			ePoly = EffectLinkEffects(ePoly, EffectNWN2SpecialEffectFile(sVFX));
	
		ePoly = ExtraordinaryEffect(ePoly);
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(GetTotalLevels(oPC, TRUE)));
		
		// Now get VFX that should really be applied
		
		object oCW1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,OBJECT_SELF);
		object oCW2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,OBJECT_SELF);
		object oCW3 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,OBJECT_SELF);
	    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
	
	    if (bWeapon)
	    {
			if (GetIsObjectValid(oCW1)) IPWildShapeCopyItemProperties(oWeaponOld,oCW1, TRUE);
			if (GetIsObjectValid(oCW2)) IPWildShapeCopyItemProperties(oWeaponOld,oCW2, TRUE);
			if (GetIsObjectValid(oCW3)) IPWildShapeCopyItemProperties(oWeaponOld,oCW3, TRUE);
	    }
	    if (bArmor)
	    {
	        IPWildShapeCopyItemProperties(oShield,oArmorNew);
	        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
	        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
			if (iSpell == SRR_BEAST_FORM) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_10, GMATERIAL_METAL_ALCHEMICAL_SILVER, 0, DR_TYPE_GMATERIAL) , oArmorNew, 0.0f);
	    }
	    if (bItems)
	    {
	        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
	        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
	        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
	        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
	        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
	        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
	    }
	}
}