// Spell script for the various Add Property feats for Soulknifes
// Removes same level properties, then adds the appropriate property
// By Electrohydra
// Last Edited : 22/08/15

#include "class_soulknife_global"

void RemoveLeastProperties(int twohanding, int twoweapons, object weapon1, object weapon2);
void RemoveLesserProperties(int twohanding, int twoweapons, object weapon1, object weapon2);
void RemoveGreaterProperties(int twohanding, int twoweapons, object weapon1, object weapon2);
void ApplyProperty(object weapon, itemproperty property);

void main()
{
	object oPC = OBJECT_SELF;
	
	// Does not work if the user isn't using a Mind Blade!
	if (!GetUsingMindblade(oPC))
		return;
		
	int twohanding = FALSE;
	int twoweapons = FALSE;
	
	// Figure out if the user is using the two-handed form or TWF
	if (GetIsTwoHanding(oPC))
		twohanding = TRUE;
	
	if (GetIsTWF(oPC))
		twoweapons = TRUE;
		
	int spellID = GetSpellId();
	object weapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object weapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	// Remove existing properties of the right type then add the appropriate property
	switch (spellID)
	{
		case BURNING_PASSION :
			RemoveLeastProperties(twohanding, twoweapons, weapon1, weapon2);
			if (!twohanding)
			{
				ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4));
			}
			else
			{
				ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6));
			}
			if (twoweapons)
			{
				ApplyProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4));
			}
			return;
		case COLD_INTELLECT :
			RemoveLeastProperties(twohanding, twoweapons, weapon1, weapon2);
				if (!twohanding)
			{
				ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d4));
			}
			else
			{
				ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6));
			}
			if (twoweapons)
			{
				ApplyProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d4));
			}
			return;
		case MINDSILVER_BLADE :
			RemoveLeastProperties(twohanding, twoweapons, weapon1, weapon2);
			SetItemBaseMaterialType(weapon1, GMATERIAL_METAL_ALCHEMICAL_SILVER);
			if (twoweapons)
			{
				SetItemBaseMaterialType(weapon2, GMATERIAL_METAL_ALCHEMICAL_SILVER);
			}
			return;
		case PRIMAL_IRON_BLADE :
			RemoveLeastProperties(twohanding, twoweapons, weapon1, weapon2);
			SetItemBaseMaterialType(weapon1, GMATERIAL_METAL_COLD_IRON);
			if (twoweapons)
			{
				SetItemBaseMaterialType(weapon2, GMATERIAL_METAL_COLD_IRON);
			}
			return;
		case DUO_DIMENTIONAL_BLADE :
			RemoveLeastProperties(twohanding, twoweapons, weapon1, weapon2);
			ApplyProperty(weapon1, ItemPropertyKeen());
			if (twoweapons)
			{
				ApplyProperty(weapon2, ItemPropertyKeen());
			}
			return;
		case FEVERISH_CORROSION :
			RemoveLesserProperties(twohanding, twoweapons, weapon1, weapon2);
			if (!twohanding)
			{
				ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_5));
			}
			else
			{
				ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_8));
			}
			if (twoweapons)
			{
				ApplyProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_5));
			}
			return;
		case ELECTRIC_INSPIRATION :
			RemoveLesserProperties(twohanding, twoweapons, weapon1, weapon2);
			if (!twohanding)
			{
				ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d10));
			}
			else
			{
				ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_2d8));
			}
			if (twoweapons)
			{
				ApplyProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d10));
			}
			return;
		case MORAL_BLADE :
			RemoveLesserProperties(twohanding, twoweapons, weapon1, weapon2);
			if (!twohanding)
			{
				if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 0, IP_CONST_DAMAGEBONUS_1));
				}
				else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 0, IP_CONST_DAMAGEBONUS_1));
				}
				if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 0, IP_CONST_DAMAGEBONUS_1));
				}
				else if (GetAlignmentLawChaos(OBJECT_SELF) ==ALIGNMENT_CHAOTIC)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 0, IP_CONST_DAMAGEBONUS_1));
				}
			}
			else
			{
				if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 0, IP_CONST_DAMAGEBONUS_2));
				}
				else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 0, IP_CONST_DAMAGEBONUS_2));
				}
				if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 0, IP_CONST_DAMAGEBONUS_2));
				}
				else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 0, IP_CONST_DAMAGEBONUS_2));
				}
			}
			if (twoweapons)
			{
				if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
				{
					ApplyProperty(weapon2, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 0, IP_CONST_DAMAGEBONUS_1));
				}
				else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
				{
					ApplyProperty(weapon2, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 0, IP_CONST_DAMAGEBONUS_1));
				}
				if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
				{
					ApplyProperty(weapon2, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 0, IP_CONST_DAMAGEBONUS_1));
				}
				else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
				{
					ApplyProperty(weapon2, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 0, IP_CONST_DAMAGEBONUS_1));
				}
			}
			return;
		case GHOSTTOUCH_BLADE :
			RemoveLesserProperties(twohanding, twoweapons, weapon1, weapon2);
			ApplyProperty(weapon1, ItemPropertyBonusFeat(386));
			if (twoweapons)
			{
				ApplyProperty(weapon2, ItemPropertyBonusFeat(386));
			}
			return;
		case MINDVENOM :
			RemoveLesserProperties(twohanding, twoweapons, weapon1, weapon2);
			ApplyProperty(weapon1, ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_POISON_1D2_CONDAMAGE));
			if (twoweapons)
			{
				ApplyProperty(weapon2, ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_POISON_1D2_CONDAMAGE));
			}
			return;
		case STRENGTH_OF_MORALITY :
			RemoveGreaterProperties(twohanding, twoweapons, weapon1, weapon2);
			if (!twohanding)
			{
				if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6));
				}
				else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d6));
				}
				else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6));
				}
			}
			else
			{
				if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d4));
				}
				else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_2d4));
				}
				else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
				{
					ApplyProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d4));
				}
			}
			if (twoweapons)
			{
				if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
				{
					ApplyProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6));
				}
				else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
				{
					ApplyProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d6));
				}
				else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
				{
					ApplyProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6));
				}
			}
			return;
		case EDGE_OF_ETHICS :
			RemoveGreaterProperties(twohanding, twoweapons, weapon1, weapon2);
			if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
			{
				ApplyProperty(weapon1, ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_100_PERCENT_2_ROUND));
			}
			else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
			{
				ApplyProperty(weapon1, ItemPropertyOnHitProps(IP_CONST_ONHIT_CONFUSION, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_100_PERCENT_2_ROUND));
			}
			else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
			{
				ApplyProperty(weapon1, ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS));
			}
			if (twoweapons)
			{
				if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
				{
					ApplyProperty(weapon2, ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_100_PERCENT_2_ROUND));
				}
				else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
				{
					ApplyProperty(weapon2, ItemPropertyOnHitProps(IP_CONST_ONHIT_CONFUSION, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_100_PERCENT_2_ROUND));
				}
				else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
				{
					ApplyProperty(weapon2, ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS));
				}
			}
			return;
		case MIND_DRINKER :
			RemoveGreaterProperties(twohanding, twoweapons, weapon1, weapon2);
			if (!twohanding)
			{
				ApplyProperty(weapon1, ItemPropertyVampiricRegeneration(2));
			}
			else
			{
				ApplyProperty(weapon1, ItemPropertyVampiricRegeneration(3));
			}
			if (twoweapons)
			{
				ApplyProperty(weapon2, ItemPropertyVampiricRegeneration(2));
			}
			return;
		default :
			return;
	}
}

void RemoveLeastProperties(int twohanding, int twoweapons, object weapon1, object weapon2)
{	
	SetItemBaseMaterialType(weapon1, GMATERIAL_METAL_IRON);
	
	itemproperty property = GetFirstItemProperty(weapon1);
	while (GetIsItemPropertyValid(property))
	{
		if (GetItemPropertyDurationType(property) == DURATION_TYPE_PERMANENT && (
		GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_FIRE
		|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_COLD
		|| GetItemPropertyType(property) == ITEM_PROPERTY_KEEN))
		{
			RemoveItemProperty(weapon1, property);
		}
		property = GetNextItemProperty(weapon1);
	}
	
	if (twoweapons)
	{
		SetItemBaseMaterialType(weapon2, GMATERIAL_METAL_IRON);
	
		itemproperty property = GetFirstItemProperty(weapon2);
		while (GetIsItemPropertyValid(property))
		{
			if (GetItemPropertyDurationType(property) == DURATION_TYPE_PERMANENT && (
			GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_FIRE
			|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_COLD
			|| GetItemPropertyType(property) == ITEM_PROPERTY_KEEN))
			{
				RemoveItemProperty(weapon2, property);
			}	
			property = GetNextItemProperty(weapon2);
		}
	}
	/*
	if (!twohanding)
	{
		RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4));
		RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d4));
	}
	else
	{
		RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6));
		RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6));
	}
	RemoveItemProperty(weapon1, ItemPropertyKeen());
	
	if (twoweapons)
	{
		RemoveItemProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4));
		RemoveItemProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d4));
		RemoveItemProperty(weapon2, ItemPropertyKeen());
		SetItemBaseMaterialType(weapon2, GMATERIAL_METAL_IRON);
	}*/
}

void RemoveLesserProperties(int twohanding, int twoweapons, object weapon1, object weapon2)
{
	itemproperty property = GetFirstItemProperty(weapon1);
	while (GetIsItemPropertyValid(property))
	{
		if (GetItemPropertyDurationType(property) == DURATION_TYPE_PERMANENT && (
		GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_ACID
		|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_ELECTRICAL
		|| GetItemPropertyType(property) == ITEM_PROPERTY_BONUS_FEAT
		|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP
		|| GetItemPropertyType(property) == ITEM_PROPERTY_ON_HIT_PROPERTIES && GetItemPropertySubType(property) == IP_CONST_ONHIT_ITEMPOISON))
		{
			RemoveItemProperty(weapon1, property);
		}
		property = GetNextItemProperty(weapon1);
	}
	
	if (twoweapons)
	{
		itemproperty property = GetFirstItemProperty(weapon2);
		while (GetIsItemPropertyValid(property))
		{
			if (GetItemPropertyDurationType(property) == DURATION_TYPE_PERMANENT && (
			GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_ACID
			|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_ELECTRICAL
			|| GetItemPropertyType(property) == ITEM_PROPERTY_BONUS_FEAT
			|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP
			|| GetItemPropertyType(property) == ITEM_PROPERTY_ON_HIT_PROPERTIES && GetItemPropertySubType(property) == IP_CONST_ONHIT_ITEMPOISON))
			{
				RemoveItemProperty(weapon2, property);
			}
			property = GetNextItemProperty(weapon2);
		}
	}
	/*
	RemoveItemProperty(weapon1, ItemPropertyBonusFeat(386));
	RemoveItemProperty(weapon1, ItemPropertyOnHitProps(ITEM_PROPERTY_POISON, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_POISON_1D2_CONDAMAGE));
	if (!twohanding)
	{
		RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_5));
		RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d10));
		if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 0, IP_CONST_DAMAGEBONUS_1));
		}
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 0, IP_CONST_DAMAGEBONUS_1));
		}
		if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 0, IP_CONST_DAMAGEBONUS_1));
		}
		else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 0, IP_CONST_DAMAGEBONUS_1));
		}
	}
	else
	{
		RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_8));
		RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_2d8));
		
		if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 0, IP_CONST_DAMAGEBONUS_2));
		}
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 0, IP_CONST_DAMAGEBONUS_2));
		}
		if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 0, IP_CONST_DAMAGEBONUS_2));
		}
		else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 0, IP_CONST_DAMAGEBONUS_2));
		}
	}
	
	if (twoweapons)
	{
		RemoveItemProperty(weapon2, ItemPropertyBonusFeat(386));
		RemoveItemProperty(weapon2, ItemPropertyOnHitProps(ITEM_PROPERTY_POISON, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_POISON_1D2_CONDAMAGE));
	
		RemoveItemProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_5));
		RemoveItemProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d10));
		if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
		{
			RemoveItemProperty(weapon2, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 0, IP_CONST_DAMAGEBONUS_1));
		}
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
		{
			RemoveItemProperty(weapon2, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 0, IP_CONST_DAMAGEBONUS_1));
		}
		if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
		{
			RemoveItemProperty(weapon2, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 0, IP_CONST_DAMAGEBONUS_1));
		}
		else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
		{
			RemoveItemProperty(weapon2, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 0, IP_CONST_DAMAGEBONUS_1));
		}
	}*/
}

void RemoveGreaterProperties(int twohanding, int twoweapons, object weapon1, object weapon2)
{
	itemproperty property = GetFirstItemProperty(weapon1);
	while (GetIsItemPropertyValid(property))
	{
		if (GetItemPropertyDurationType(property) == DURATION_TYPE_PERMANENT && (
		GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_MAGICAL
		|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_DIVINE
		|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_NEGATIVE
		|| GetItemPropertyType(property) == ITEM_PROPERTY_REGENERATION_VAMPIRIC
		|| GetItemPropertyType(property) == ITEM_PROPERTY_ON_HIT_PROPERTIES && GetItemPropertySubType(property) == IP_CONST_ONHIT_DAZE
		|| GetItemPropertyType(property) == ITEM_PROPERTY_ON_HIT_PROPERTIES && GetItemPropertySubType(property) == IP_CONST_ONHIT_SLOW
		|| GetItemPropertyType(property) == ITEM_PROPERTY_ON_HIT_PROPERTIES && GetItemPropertySubType(property) == IP_CONST_ONHIT_CONFUSION))
		{
			RemoveItemProperty(weapon1, property);
		}
		property = GetNextItemProperty(weapon1);
	}
	
	if (twoweapons)
	{
		itemproperty property = GetFirstItemProperty(weapon2);
		while (GetIsItemPropertyValid(property))
		{
			if (GetItemPropertyDurationType(property) == DURATION_TYPE_PERMANENT && (
			GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_MAGICAL
			|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_DIVINE
			|| GetItemPropertyType(property) == ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(property) == IP_CONST_DAMAGETYPE_NEGATIVE
			|| GetItemPropertyType(property) == ITEM_PROPERTY_REGENERATION_VAMPIRIC
			|| GetItemPropertyType(property) == ITEM_PROPERTY_ON_HIT_PROPERTIES && GetItemPropertySubType(property) == IP_CONST_ONHIT_DAZE
			|| GetItemPropertyType(property) == ITEM_PROPERTY_ON_HIT_PROPERTIES && GetItemPropertySubType(property) == IP_CONST_ONHIT_SLOW
			|| GetItemPropertyType(property) == ITEM_PROPERTY_ON_HIT_PROPERTIES && GetItemPropertySubType(property) == IP_CONST_ONHIT_CONFUSION))
			{
				RemoveItemProperty(weapon2, property);
			}
			property = GetNextItemProperty(weapon2);
		}
	}
	/*
	if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
	{
		RemoveItemProperty(weapon1, ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_100_PERCENT_2_ROUND));
	}
	else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
	{
		RemoveItemProperty(weapon1, ItemPropertyOnHitProps(IP_CONST_ONHIT_CONFUSION, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_100_PERCENT_2_ROUND));
	}
	else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
	{
		RemoveItemProperty(weapon1, ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS));
	}
		
	if (!twohanding)
	{
		RemoveItemProperty(weapon1, ItemPropertyVampiricRegeneration(2));
		if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6));
		}
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d6));
		}
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6));
		}
	}
	else
	{		
		RemoveItemProperty(weapon1, ItemPropertyVampiricRegeneration(3));
		if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d4));
		}
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_2d4));
		}
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
		{
			RemoveItemProperty(weapon1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d4));
		}
	}
	
	if (twoweapons)
	{
		if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
		{
			RemoveItemProperty(weapon2, ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_100_PERCENT_2_ROUND));
		}
		else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
		{
			RemoveItemProperty(weapon2, ItemPropertyOnHitProps(IP_CONST_ONHIT_CONFUSION, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_100_PERCENT_2_ROUND));
		}
		else if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
		{
			RemoveItemProperty(weapon2, ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS));
		}
		
		RemoveItemProperty(weapon2, ItemPropertyVampiricRegeneration(2));
		
		if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
		{
			RemoveItemProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6));
		}
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
		{
			RemoveItemProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d6));
		}
		else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
		{
			RemoveItemProperty(weapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6));
		}
	}*/
}

// Permanantly applies a property to a weapon.
void ApplyProperty(object weapon, itemproperty property)
{
	AddItemProperty(DURATION_TYPE_PERMANENT, property, weapon);
}