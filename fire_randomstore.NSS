#include "ff_safevar"

#include "ginc_crafting"
#include "x2_inc_itemprop"
#include "x2_inc_craft"

//Get appropriate weapon power
itemproperty GetFireWeaponAbility(int secondary = 0) {
	int rand = d100();
	if (rand < 50)
	{
		if (secondary > 1) return ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_2d6);
		else if (secondary > 0) return ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);
		else return ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4);
	}
	else if (rand < 55)
	{
		if (secondary > 1) return ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d4);
		else if (secondary > 0) return ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10);
		else return ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5);
	}
	else if (rand < 60)
	{
		if (secondary > 0) return ItemPropertyNoDamage();
		else return ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4);
	}
	else if (rand < 70)
		return ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_COMBUST, 3);
	else if (rand < 80)
	{
		if (secondary > 0) 	return ItemPropertyAttackBonus(d6());
		else return ItemPropertyLight(d4(), IP_CONST_LIGHTCOLOR_ORANGE);
	}
	else
	{
		if (secondary > 1) return ItemPropertyOnHitProps(IP_CONST_ONHIT_BLINDNESS, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_ONHIT_DURATION_50_PERCENT_3_ROUNDS);
		else if (secondary > 0) return ItemPropertyOnHitProps(IP_CONST_ONHIT_BLINDNESS, IP_CONST_ONHIT_SAVEDC_16, IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS);
		else return ItemPropertyOnHitProps(IP_CONST_ONHIT_BLINDNESS, IP_CONST_ONHIT_SAVEDC_14, IP_CONST_ONHIT_DURATION_10_PERCENT_3_ROUNDS);
	}
}

//get appropriate armor power
itemproperty GetFireArmorAbility(int secondary = 0) {
	int rand = d100();
	if (rand < 55)
		return ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, d4());
	else if (rand < 60)
		return ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FIREBALL);
	else if (rand < 65)
		return ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FIRE_STORM);
	else if (rand < 70)
		return ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FLAME_ARROW);
	else if (rand < 75)
		return ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FLAME_STRIKE);
	else if (rand < 90)
		return ItemPropertyACBonus(d4());
	else if (rand < 95)
		return ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, d2());
	else
		return ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_COMBUST, 3);
}

//wrapper
void ApplyFireAbilities(object oItem, int secondary = 0) {

	itemproperty prop;
	
	if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
		prop = GetFireArmorAbility(secondary); 
	else
		prop = GetFireWeaponAbility(secondary); 
	IPSafeAddItemProperty(oItem, prop);
}

//get appropriate firey name
string GetFireName(object oItem) {
	string original = GetName(oItem);
	int rand = d12();
	switch (rand) {
		case 1: return "Flametouched "+original; break;
		case 2: return original+" of Fire"; break;
		case 3: return "Flaming "+original; break;
		case 4: return "Burning "+original; break;
		case 5: return "Blazing "+original; break;
		case 6: return "Molten "+original; break;
		case 7: return "Brilliant "+original; break;
		case 8: return "Firey "+original; break;
		case 9: return "Searing "+original; break;
		case 10: return "Glowing "+original; break;
		case 11: return "Infernal "+original; break;
		case 12: return original+" of Flame"; break;
		default: return "Flametouched "+original; break;
	}
	return "Flametouched "+original;
}

//get appropriate firey description
string GetFireDescription(object oItem) 
{
	string itemType = "";
	if (GetWeaponType(oItem) != WEAPON_TYPE_NONE)
		itemType = "weapon";
	else
		itemType = "suit of armor";
	return "This "+itemType+" was forged in the fires of the City of Brass, on the Elemental Plane of Fire. It bears the hallmarks of its firey heritage. The metal has a certain glow about it from the heat, and any leather or cloth components seem to be woven of very fine metal threads.";
}

//pull it all together!
void main ()
{
	if (PS_GetLocalInt(OBJECT_SELF, "filled") == 1)
		return;

	object oChest = GetNearestObjectByTag("chest_"+GetTag(OBJECT_SELF));
	int maxItems = PS_GetLocalInt(OBJECT_SELF, "max_items");
	object oItem = GetFirstItemInInventory(oChest);
	int count = 0;
	int numCopied = 0;
	while (GetIsObjectValid(oItem) || count < 1000 || numCopied < maxItems)
	{
		if (d6() == 1)
		{
			object newItem = CopyItem(oItem, OBJECT_SELF, TRUE);
			if (!GetIsObjectValid(newItem))
				continue;
			ApplyFireAbilities(newItem);
			if (d100() <= 10)
				ApplyFireAbilities(newItem, 2);
			if (d100() <= 1)
				ApplyFireAbilities(newItem, 3);
			SetFirstName(newItem, GetFireName(newItem));
			SetDescription(newItem, GetFireDescription(newItem));
			numCopied++;
		}
		count++;
		oItem = GetNextItemInInventory(oChest);
	}
	PS_SetLocalInt(OBJECT_SELF, "filled", 1);
}