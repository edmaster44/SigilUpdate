// Created by Agony_Aunt for SCoD
// New Rage feats for Barbarians.

#include "x2_inc_itemprop"
#include "ps_adjust_barbarian"
#include "ps_inc_functions"

// iType is 1 for Blazing, 2 for Frozen, 3 for Both
effect ApplyBlazingOrFrozenShield(int iType)
{
	int iAmount = BarbarianLevels(OBJECT_SELF) / 5;
	int iRandom = DAMAGE_BONUS_1;
	
    effect eDur = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
	effect eShield;
	
	if (iType == 1) eShield = EffectDamageShield(iAmount, iRandom, DAMAGE_TYPE_FIRE);
	else if (iType == 2) eShield = EffectDamageShield(iAmount, iRandom, DAMAGE_TYPE_COLD);
	else if (iType == 3) eShield = EffectLinkEffects(EffectDamageShield(iAmount, iRandom, DAMAGE_TYPE_FIRE), EffectDamageShield(iAmount, iRandom, DAMAGE_TYPE_COLD));
	
	effect eLink = EffectLinkEffects(eShield, eDur);
	
	return eLink; 
}

effect ApplyBlazingRage()
{
	effect eBlazing = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
	eBlazing = EffectLinkEffects(eBlazing, EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, 50));

	return eBlazing;
}

effect ApplyFrozenRage()
{
	effect eFrozen = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
	eFrozen = EffectLinkEffects(eFrozen, EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50));
	
	return eFrozen;
}

void ApplyChaoticRageToWeapon(object oWeapon, int iDuration)
{
	IPSafeAddItemProperty(oWeapon, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2d6), RoundsToSeconds(iDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
	IPSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), RoundsToSeconds(iDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, TRUE);
}

void ApplyChaoticRage(int iDuration)
{
	object oWeapon;
	
	oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
	if (GetIsObjectValid(oWeapon)) ApplyChaoticRageToWeapon(oWeapon, iDuration);
	
	oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
	if (GetWeaponType(oWeapon) != WEAPON_TYPE_NONE) ApplyChaoticRageToWeapon(oWeapon, iDuration);
	
	oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, OBJECT_SELF);
	if (GetBaseItemType(oWeapon) == BASE_ITEM_GLOVES) ApplyChaoticRageToWeapon(oWeapon, iDuration);
		
	oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, OBJECT_SELF);
	if (GetIsObjectValid(oWeapon)) ApplyChaoticRageToWeapon(oWeapon, iDuration);
	
	oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, OBJECT_SELF);
	if (GetIsObjectValid(oWeapon)) ApplyChaoticRageToWeapon(oWeapon, iDuration);
	
	oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, OBJECT_SELF);
	if (GetIsObjectValid(oWeapon)) ApplyChaoticRageToWeapon(oWeapon, iDuration);
}

effect ApplyFearlessRage()
{
	effect eFearless = EffectImmunity(IMMUNITY_TYPE_FEAR);
	
	return eFearless;
}

void ApplyVigorousRage()
{
	int iBarbLevels = BarbarianLevels(OBJECT_SELF);
	int iConMod = GetAbilityModifier(ABILITY_CONSTITUTION, OBJECT_SELF);

	int iHeal = iBarbLevels + iConMod;
	if (iHeal < 1) iHeal = 1;
	iHeal *= 2;
	effect eHeal = EffectHeal(iHeal);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
}

effect ApplyScentRage()
{
	effect eScent = EffectSeeInvisible();
	eScent = EffectLinkEffects(eScent, EffectSkillIncrease(SKILL_SPOT, 10));
	eScent = EffectLinkEffects(eScent, EffectSkillIncrease(SKILL_LISTEN, 10));
	eScent = EffectLinkEffects(eScent, EffectSkillIncrease(SKILL_SURVIVAL, 10));
	
	return eScent;
}

effect ApplySuperstitiousRage()
{
	int iBarbLevels = BarbarianLevels(OBJECT_SELF);
	// let's be sure we can't divide by zero if there is some error here...
	if (iBarbLevels < 1) iBarbLevels = 1;
	int iBonus = (iBarbLevels / 4);
	if (iBonus < 1) iBonus = 1;
	
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus);
	
	return eSave;
}

effect ApplyDodgeACRage()
{
	effect eAC = EffectACIncrease(4, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
	
	return eAC;
}

effect ApplyShieldACRage()
{
	effect eAC = EffectACIncrease(2, AC_SHIELD_ENCHANTMENT_BONUS, AC_VS_DAMAGE_TYPE_ALL);
	
	return eAC;
}

effect ApplyNaturalACRage()
{
	effect eAC = EffectACIncrease(6, AC_NATURAL_BONUS, AC_VS_DAMAGE_TYPE_ALL);
	
	return eAC;
}

effect ApplyAncestorRage()
{
	int iBarbLevels = BarbarianLevels(OBJECT_SELF);
	int iConceal = (iBarbLevels / 5) + 1;
	effect eSpirit = EffectDetectSpirits();
	eSpirit = EffectLinkEffects(eSpirit, EffectConcealment(iConceal));
	eSpirit = EffectLinkEffects(eSpirit, EffectACIncrease(10, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL, TRUE));
	eSpirit = EffectLinkEffects(eSpirit, EffectSavingThrowIncrease(SAVING_THROW_ALL, 10, SAVING_THROW_TYPE_ALL, TRUE));
	
	return eSpirit;
}

effect ApplyDamageRage()
{
	effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_MAGICAL);
	
	return eDmg;
}

effect ApplyABRage()
{
	effect eAB = EffectAttackIncrease(2);
	
	return eAB;
}

effect ApplyRegenRage()
{
	int iAmount;
	int iBarbLevels = BarbarianLevels(OBJECT_SELF);
	if (iBarbLevels < 11) iAmount = 1;
	else if (iBarbLevels < 21) iAmount = 2;
	else iAmount = 3;
	 
	effect eRegen = EffectRegenerate(iAmount, 6.0);
	
	return eRegen;
}

void DestroyAncestralWeapon(object oWeapon)
{
	if (GetIsObjectValid(oWeapon))
	{
		SetPlotFlag(oWeapon, FALSE);
		SetItemCursedFlag(oWeapon, FALSE);
		// we unequip first so in case of old weapon still in hands when new one is created (from crash event or similar) the new one can be equipped as old one won't destroy
		// until ApplyAncestralWeapon() script completes.
		// theoretically, the equip call from the new one should move the old one out of place.
		AssignCommand(GetItemPossessor(oWeapon), ActionUnequipItem(oWeapon));
		DestroyObject(oWeapon, 0.1, FALSE);
	}
}

void ApplyAncestralProperties(object oPC, object oWeapon, float fDuration)
{
	int iBarbLevels			= BarbarianLevels(OBJECT_SELF);
	int iDamageBonus		= 10; //IP_CONST_DAMAGEBONUS_2d6
	int iDC					= 0; //IP_CONST_ONHIT_SAVEDC_14
	int iDur				= 7; //IP_CONST_ONHIT_DURATION_5_PERCENT_3_ROUNDS
	
	int iEB					= iBarbLevels / 5; // enhancement bonus;
	if (iEB < 1)
	{	iEB = 1;	}
	
	if (iBarbLevels >= 30)
	{	iDamageBonus = 59;	// IP_CONST_DAMAGEBONUS_6d12;
		iDC = 6;			// IP_CONST_ONHIT_SAVEDC_26;
		iDur = 32;		}	// IP_CONST_ONHIT_DURATION_75_PERCENT_3_ROUND;		}
	else if (iBarbLevels >= 26)
	{	iDamageBonus = 56;	// IP_CONST_DAMAGEBONUS_4d12;
		iDC = 5;			// IP_CONST_ONHIT_SAVEDC_24;
		iDur = 28;		}	// IP_CONST_ONHIT_DURATION_66_PERCENT_3_ROUNDS;		}
	else if (iBarbLevels >= 21)
	{	iDamageBonus = 61;	// IP_CONST_DAMAGEBONUS_6d6;	
		iDC = 4;			// IP_CONST_ONHIT_SAVEDC_22;
		iDur = 23;		}	// IP_CONST_ONHIT_DURATION_50_PERCENT_3_ROUNDS;		}
	else if (iBarbLevels >= 16)
	{	iDamageBonus = 57;	// IP_CONST_DAMAGEBONUS_5d6;	
		iDC = 3;			// IP_CONST_ONHIT_SAVEDC_20;
		iDur = 19;		}	// IP_CONST_ONHIT_DURATION_33_PERCENT_3_ROUNDS;		}
	else if (iBarbLevels >= 11)
	{	iDamageBonus = 53;	// IP_CONST_DAMAGEBONUS_4d6;
		iDC = 2;			// IP_CONST_ONHIT_SAVEDC_18;
		iDur = 2;		}	// IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS;		}
	else if (iBarbLevels >= 6)
	{	iDamageBonus = 60;	// IP_CONST_DAMAGEBONUS_3d6;
		iDC = 1;			// IP_CONST_ONHIT_SAVEDC_16;
		iDur = 11;		}	// IP_CONST_ONHIT_DURATION_10_PERCENT_3_ROUNDS;		}
		
	itemproperty ipBonus	= ItemPropertyEnhancementBonus(iEB);
	itemproperty ipColdDam	= ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, iDamageBonus);
	itemproperty ipSlow		= ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, iDC, iDur);
	
	IPSafeAddItemProperty(oWeapon, ipBonus, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipColdDam, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipSlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	SendMessageToPC(oPC, "Ancestral properties applied: level " + IntToString(iBarbLevels) + ".");
}	


void ApplyAncestralWeapon(int iDuration)
{
	object oPC = OBJECT_SELF;
	object oOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
	object oWeapon;
	float fDuration = RoundsToSeconds(iDuration);
	if (GetIsObjectValid(oOld))
	{	// Check to see if weapon stuck from previous rage
		if (GetTag(oOld) == "barbancestoraxe" || GetTag(oOld) == "barbancestoraxs")
		{	DestroyAncestralWeapon(oOld);	}
	}
	if (GetCreatureSize(oPC) == CREATURE_SIZE_SMALL)
	{	oWeapon = CreateItemOnObject("barbancestoraxs", OBJECT_SELF, 1, "", FALSE);	}
	else
	{	oWeapon = CreateItemOnObject("barbancestoraxe", OBJECT_SELF, 1, "", FALSE);	}

	ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND);
	DelayCommand(0.1f, ApplyAncestralProperties(oPC, oWeapon, fDuration));
	
	// can't unequip or sell
	DelayCommand(0.3f, SetPlotFlag(oWeapon, TRUE));
	DelayCommand(0.4f, SetItemCursedFlag(oWeapon, TRUE));
	
	// delay destruction
	DelayCommand(fDuration, DestroyAncestralWeapon(oWeapon));
}

// Makes sure that the Totem Barb has creature weapons and the appropriate feats to use without problem.
// Checks for existing creature weapons and hide before adding
// This means that special races with creature weapons will not be adversely affected by taking this feat
// This function should only run once, the first time a Totem Barb goes into a rage.
void CheckAndApplyUnarmedRage(int iDuration)
{
	object oSkin = CreateItemOnObject("totembarbtamu", OBJECT_SELF, 1, "", FALSE);
	
	object oCreWep = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, OBJECT_SELF);
	if (!GetIsObjectValid(oCreWep)) oCreWep = CreateItemOnObject("nw_it_crewpb010", OBJECT_SELF, 1, "", FALSE);
	SetIdentified(oCreWep, TRUE);
	if (GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, OBJECT_SELF) != oCreWep) ActionEquipItem(oCreWep, INVENTORY_SLOT_CWEAPON_B);

	// use the bite slot to store whether this feat has already run
	// saves scanning for essence or the totem amulet
	PS_SetLocalInt(oCreWep, "TOTEMBACKGROUNDSET", 1);
	
	oCreWep = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, OBJECT_SELF);
	if (!GetIsObjectValid(oCreWep)) oCreWep = CreateItemOnObject("nw_it_crewps010", OBJECT_SELF, 1, "", FALSE);
	SetIdentified(oCreWep, TRUE);
	if (GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, OBJECT_SELF) != oCreWep) ActionEquipItem(oCreWep, INVENTORY_SLOT_CWEAPON_L);

	
	oCreWep = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, OBJECT_SELF);
	if (!GetIsObjectValid(oCreWep)) oCreWep = CreateItemOnObject("nw_it_crewpp010", OBJECT_SELF, 1, "", FALSE);
	SetIdentified(oCreWep, TRUE);
	if (GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, OBJECT_SELF) != oCreWep) ActionEquipItem(oCreWep, INVENTORY_SLOT_CWEAPON_R);
}

void CheckAndApplyRageFeats(int iDuration)
{
	// object oPC = OBJECT_SELF; // not needed as just use OBJECT_SELF in the code.
	effect eLink;
	
	if (GetHasFeat(2320, OBJECT_SELF, TRUE))
	{
		if (GetHasFeat(2300, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyBlazingRage());
		if (GetHasFeat(2301, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyFrozenRage());
		if (GetHasFeat(2303, OBJECT_SELF, TRUE)) ApplyChaoticRage(iDuration);
		if (GetHasFeat(2304, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyFearlessRage());
		if (GetHasFeat(2305, OBJECT_SELF, TRUE)) ApplyVigorousRage();
		if (GetHasFeat(2306, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyScentRage());
		if (GetHasFeat(2307, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplySuperstitiousRage());
		
		if (GetHasFeat(2300, OBJECT_SELF, TRUE) && GetHasFeat(2301, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyBlazingOrFrozenShield(3));
		else if (GetHasFeat(2300, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyBlazingOrFrozenShield(1));
		else if (GetHasFeat(2301, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyBlazingOrFrozenShield(2));
	}
	// check for totem background feat
	if (GetHasFeat(2316, OBJECT_SELF, TRUE))
	{
		// check to see if this has already been run once on the character
		if (PS_GetLocalInt(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, OBJECT_SELF), "TOTEMBACKGROUNDSET") != 1)
			CheckAndApplyUnarmedRage(iDuration); // Totem barbs are better at unarmed
		
		if (GetHasFeat(2311, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyDodgeACRage());
		if (GetHasFeat(2312, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyShieldACRage());
		if (GetHasFeat(2313, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyNaturalACRage());
		if (GetHasFeat(2314, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyAncestorRage());
		if (GetHasFeat(2315, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyDamageRage());
		if (GetHasFeat(2317, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyABRage());
		if (GetHasFeat(2318, OBJECT_SELF, TRUE)) eLink = EffectLinkEffects(eLink, ApplyRegenRage());
		if (GetHasFeat(2319, OBJECT_SELF, TRUE)) 
		{
			if (GetHasFeat(2340, OBJECT_SELF, TRUE))
			{
				SendMessageToPC(OBJECT_SELF, "<c=red>WARNING: Ancestral Weapon feat cannot work with races that cannot wield weapons. Recommend releveling and chosing a different feat");
			}
			else
			{
				ApplyAncestralWeapon(iDuration);
			}
		}
	}
	
	eLink = ExtraordinaryEffect(eLink);
	float fDuration = RoundsToSeconds(iDuration);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
}