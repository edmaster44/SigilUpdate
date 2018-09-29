// The Chaosman's Blade on-hit script. Changes it's properties on every hit

// By Electrohydra
// Last edit 19/09/2015

// rolls a 9-sided dice
int d9()
{
	int result = d10(1);
	if (result == 10)
		return d9();
	else
		return result;
}

int GetBonusDamage();
int GetMaterialType();

void main()
{
	object weapon = GetSpellCastItem();
	itemproperty prop = GetFirstItemProperty(weapon);
	
	// removes enhancement bonus and 
	while (GetIsItemPropertyValid(prop))
	{
		if ((GetItemPropertyType(prop) == ITEM_PROPERTY_DAMAGE_BONUS
			|| GetItemPropertyType(prop) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
			&& GetItemPropertyDurationType(prop) == DURATION_TYPE_PERMANENT)
		{
			RemoveItemProperty(weapon, prop);
		}
		prop = GetNextItemProperty(weapon);
	}
	
	// Add the enhancement bonus
	prop = ItemPropertyEnhancementBonus(d6());
	AddItemProperty(DURATION_TYPE_PERMANENT, prop, weapon);
	
	// Add the bonus damage 1d9 + 4
	prop = ItemPropertyDamageBonus(d9() + 4, GetBonusDamage());
	AddItemProperty(DURATION_TYPE_PERMANENT, prop, weapon);
	
	// set the material type
	SetItemBaseMaterialType(weapon, GetMaterialType());
}

int GetMaterialType()
{
	int roll = d4(1);
	switch (roll)
	{
		case 1 :
			return GMATERIAL_METAL_IRON;
		case 2 :
			return GMATERIAL_METAL_COLD_IRON;
		case 3 :
			return GMATERIAL_METAL_ALCHEMICAL_SILVER;
		default :
			return GMATERIAL_METAL_ADAMANTINE;
	}
	return 0;
}

int GetBonusDamage()
{
	int roll = d20(1);
	switch (roll)
	{
		case 1 :
			return IP_CONST_DAMAGEBONUS_1;
		case 2 :
			return IP_CONST_DAMAGEBONUS_2;
		case 3 :
			return IP_CONST_DAMAGEBONUS_3;
		case 4 :
			return IP_CONST_DAMAGEBONUS_4;
		case 5 :
			return IP_CONST_DAMAGEBONUS_5;
		case 6 :
			return IP_CONST_DAMAGEBONUS_6;
		case 7 :
			return IP_CONST_DAMAGEBONUS_7;
		case 8 :
			return IP_CONST_DAMAGEBONUS_8;
		case 9 :
			return IP_CONST_DAMAGEBONUS_9;
		case 10 :
			return IP_CONST_DAMAGEBONUS_1d4;
		case 12 :
			return IP_CONST_DAMAGEBONUS_1d6;
		case 13 :
			return IP_CONST_DAMAGEBONUS_1d8;
		case 14 :
			return IP_CONST_DAMAGEBONUS_1d10;
		case 15 :
			return IP_CONST_DAMAGEBONUS_1d12;
		case 16 :
			return IP_CONST_DAMAGEBONUS_2d6;
		case 17 :
			return IP_CONST_DAMAGEBONUS_2d4;
		case 18 :
			return IP_CONST_DAMAGEBONUS_2d10;
		case 19 :
			return IP_CONST_DAMAGEBONUS_2d8;
		default :
			return IP_CONST_DAMAGEBONUS_3d6;
	}
	return 0; // should never reach here
}