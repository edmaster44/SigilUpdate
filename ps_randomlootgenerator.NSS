

///////////////////////////////////////////////////////////////////////
// SCoD Random Loot Generator (SRLG)
//
// - Creates random level-appropriate items
//
// HISTORY:
// March 2020 (pelhikano)
//   - add some more general wrappers
//   - Don't use the global variable to count remaining points,
//     this could lead to problems if we fire the script
//     from two different places (essentially like multithreading).
//
// v0.6, August 21st (pelhikano)
//   - added weapon properties to (monk) gloves except regeneration since this counts as a trinket
//
// v0.5, August 1st (pelhikano)
//   - fixed OnHit effects, added disease and poison
//   - added CastSpell and SpellImmunity properties
//   - removed divine/magical etc. damages and some other tweaks
//
// v0.4, August 1st (pelhikano)
//   - tried OnHit effects but they don't show up
//   - make sure that there's some sort of enhancement on any item (randomly chosen), for example a level
//     30 char will get a +1 to +5 enchantment with 1 in 5 chance
//   - if nothing at all was chosen anyway, put a random light on the item
//   - added a clean-up phase where redundant powers like +1 AC vs undead are removed
//     when the item is already at least +1 general AC
//   - a random cost of up to 50 gold is added to random item buys, just for slighly less predictability
//
// v0.3, July 25th (pelhikano)
//   - added constants for item type
//
// v0.2, July 24th (pelhikano)
//   - added a large amount of properties (for weapons and common to armor and weapons)
//   - currently only a random longsword can be generated
//
// v0.1, July 17th (pelhikano)
//   - made this file "ps_randomlootgenerator" to contain the code of the generator
//
///////////////////////////////////////////////////////////////////////

#include "ginc_crafting"
#include "x2_inc_itemprop"



///////////////////////////////////////////////////////////////////////
// CONSTANTS: these change the behavior of the loot generator

//---------------------------------------------------------------------
// GENERAL
const int SRLG_POINTS_PER_LEVEL = 100; // how many points a character has to spend per level
const int SRLG_PROPERTY_RETRIES = 10; // how many times max to go through the property application loop
const int SRLG_MAX_PROPERTIES = 4; // how many properties are ADDED at most (can be more in total depending what the base item had)

//---------------------------------------------------------------------
// POINT COST CONSTANTS

const int SRLG_COST_CAST_SPELL = 1000;
const int SRLG_CAST_SPELL_NUMUSES = IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE;
const int SRLG_ITEMCHARGES = 20;

const int SRLG_COST_SPELLIMMUNITY = 1000;

const int SRLG_COST_BONUSFEAT = 1000;

const int SRLG_COST_ONHITPROPERTY = 500;
const int SRLG_ONHIT_DC = IP_CONST_ONHIT_SAVEDC_20; // standard DC for all generated OnHit properties
const int SRLG_ONHIT_DURATION = IP_CONST_ONHIT_DURATION_50_PERCENT_3_ROUNDS;
const int SRLG_ONHIT_POISONDISEASE_DC = 30;

const int SRLG_WEAPON_COST_UNLIMITEDAMMO_1 = 100;
const int SRLG_WEAPON_COST_UNLIMITEDAMMO_2 = 200;
const int SRLG_WEAPON_COST_UNLIMITEDAMMO_3 = 300;
const int SRLG_WEAPON_COST_UNLIMITEDAMMO_4 = 400;
const int SRLG_WEAPON_COST_UNLIMITEDAMMO_5 = 500;
const int SRLG_WEAPON_COST_UNLIMITEDAMMO_6 = 600;
const int SRLG_WEAPON_COST_UNLIMITEDAMMO_7 = 600;
const int SRLG_WEAPON_COST_UNLIMITEDAMMO_8 = 600;
const int SRLG_WEAPON_COST_UNLIMITEDAMMO_9 = 600;
const int SRLG_WEAPON_COST_UNLIMITEDAMMO_10 = 2700;

const int SRLG_COST_ARMOR_ACVSRACE_1 = 12;
const int SRLG_COST_ARMOR_ACVSRACE_2 = 50;
const int SRLG_COST_ARMOR_ACVSRACE_3 = 100;
const int SRLG_COST_ARMOR_ACVSRACE_4 = 150;
const int SRLG_COST_ARMOR_ACVSRACE_5 = 200;

const int SRLG_COST_RANGESTRMOD_1 = 12;
const int SRLG_COST_RANGESTRMOD_2 = 50;
const int SRLG_COST_RANGESTRMOD_3 = 100;
const int SRLG_COST_RANGESTRMOD_4 = 150;
const int SRLG_COST_RANGESTRMOD_5 = 200;
const int SRLG_COST_RANGESTRMOD_6 = 500;

const int SRLG_COST_ARMOR_ACBONUSALIGNMENT_1 = 12;
const int SRLG_COST_ARMOR_ACBONUSALIGNMENT_2 = 50;
const int SRLG_COST_ARMOR_ACBONUSALIGNMENT_3 = 100;
const int SRLG_COST_ARMOR_ACBONUSALIGNMENT_4 = 150;
const int SRLG_COST_ARMOR_ACBONUSALIGNMENT_5 = 200;

const int SRLG_COST_ARMOR_WEIGHTREDUCTION_50 = 1000;

const int SRLG_COST_BONUSHP_10 = 500;
const int SRLG_COST_BONUSHP_20 = 1500;
const int SRLG_COST_BONUSHP_30 = 700; // currently only max +20 HP is used
const int SRLG_COST_BONUSHP_40 = 1000;
const int SRLG_COST_BONUSHP_50 = 1300;

const int SRLG_COST_ABILITYBONUS_1 = 100;
const int SRLG_COST_ABILITYBONUS_2 = 400;
const int SRLG_COST_ABILITYBONUS_3 = 800;
const int SRLG_COST_ABILITYBONUS_4 = 1200;
const int SRLG_COST_ABILITYBONUS_5 = 2000;

const int SRLG_COST_ACBONUS_1 = 100;
const int SRLG_COST_ACBONUS_2 = 400;
const int SRLG_COST_ACBONUS_3 = 800;
const int SRLG_COST_ACBONUS_4 = 1200;
const int SRLG_COST_ACBONUS_5 = 2000;

const int SRLG_COST_ACBONUS_BOOTS_1 = 600;
const int SRLG_COST_ACBONUS_BOOTS_2 = 900;
const int SRLG_COST_ACBONUS_BOOTS_3 = 1500;
const int SRLG_COST_ACBONUS_BOOTS_4 = 2000;
const int SRLG_COST_ACBONUS_BOOTS_5 = 2700;

const int SRLG_COST_BONUSSPELL_0 = 10;
const int SRLG_COST_BONUSSPELL_1 = 100;
const int SRLG_COST_BONUSSPELL_2 = 200;
const int SRLG_COST_BONUSSPELL_3 = 300;
const int SRLG_COST_BONUSSPELL_4 = 400;
const int SRLG_COST_BONUSSPELL_5 = 500;
const int SRLG_COST_BONUSSPELL_6 = 600;
const int SRLG_COST_BONUSSPELL_7 = 700;
const int SRLG_COST_BONUSSPELL_8 = 800;
const int SRLG_COST_BONUSSPELL_9 = 900;

// these are one particular saving throw (will OR reflex OR fortitude)
const int SRLG_COST_SAVINGTHROW_1 = 400;
const int SRLG_COST_SAVINGTHROW_2 = 800;
const int SRLG_COST_SAVINGTHROW_3 = 1200;
const int SRLG_COST_SAVINGTHROW_4 = 1600;
const int SRLG_COST_SAVINGTHROW_5 = 2000;

const int SRLG_COST_SAVINGTHROWVSX_1 = 100;
const int SRLG_COST_SAVINGTHROWVSX_2 = 400;
const int SRLG_COST_SAVINGTHROWVSX_3 = 800;
const int SRLG_COST_SAVINGTHROWVSX_4 = 1200;
const int SRLG_COST_SAVINGTHROWVSX_5 = 1600;

const int SRLG_COST_SAVINGTHROWVSUNIVERSAL_1 = 600;
const int SRLG_COST_SAVINGTHROWVSUNIVERSAL_2 = 900;
const int SRLG_COST_SAVINGTHROWVSUNIVERSAL_3 = 1500;
const int SRLG_COST_SAVINGTHROWVSUNIVERSAL_4 = 2000;
const int SRLG_COST_SAVINGTHROWVSUNIVERSAL_5 = 2700;

const int SRLG_COST_SPELLRESISTANCE_10 = 250;
const int SRLG_COST_SPELLRESISTANCE_12 = 500;
const int SRLG_COST_SPELLRESISTANCE_14 = 750;
const int SRLG_COST_SPELLRESISTANCE_16 = 1000;
const int SRLG_COST_SPELLRESISTANCE_18 = 1250;
const int SRLG_COST_SPELLRESISTANCE_20 = 1500;
const int SRLG_COST_SPELLRESISTANCE_22 = 2000;
const int SRLG_COST_SPELLRESISTANCE_24 = 2000; // only up to 22 SR is used currently
const int SRLG_COST_SPELLRESISTANCE_26 = 2250;
const int SRLG_COST_SPELLRESISTANCE_28 = 2500;
const int SRLG_COST_SPELLRESISTANCE_30 = 2750;
const int SRLG_COST_SPELLRESISTANCE_32 = 3000;

const int SRLG_COST_ELEMENTALDAMAGERESISTANCE_5 = 300;

const int SRLG_COST_LIGHT = 10;

const int SRLG_COST_REGENERATION_1 = 1500;
const int SRLG_COST_REGENERATION_TRINKET_1 = 2500; // ONLY BOOTS CURRENTLY: chance for regeneration on things that are not weapon or armor

const int SRLG_COST_ENHANCEMENT_1 = 100;
const int SRLG_COST_ENHANCEMENT_2 = 400;
const int SRLG_COST_ENHANCEMENT_3 = 800;
const int SRLG_COST_ENHANCEMENT_4 = 1200;
const int SRLG_COST_ENHANCEMENT_5 = 2000;

const int SRLG_WEAPON_COST_ELEMENTAL_DMG_1D4 = 200;
const int SRLG_WEAPON_COST_ELEMENTAL_DMG_1D6 = 500;

const int SRLG_WEAPON_COST_ATTACKBONUS_1 = 50;
const int SRLG_WEAPON_COST_ATTACKBONUS_2 = 200;
const int SRLG_WEAPON_COST_ATTACKBONUS_3 = 400;
const int SRLG_WEAPON_COST_ATTACKBONUS_4 = 600;
const int SRLG_WEAPON_COST_ATTACKBONUS_5 = 800;

const int SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_1 = 12;
const int SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_2 = 50;
const int SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_3 = 100;
const int SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_4 = 150;
const int SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_5 = 200;

const int SRLG_WEAPON_COST_ATTACKBONUSRACE_1 = 12;
const int SRLG_WEAPON_COST_ATTACKBONUSRACE_2 = 50;
const int SRLG_WEAPON_COST_ATTACKBONUSRACE_3 = 100;
const int SRLG_WEAPON_COST_ATTACKBONUSRACE_4 = 150;
const int SRLG_WEAPON_COST_ATTACKBONUSRACE_5 = 200;

const int SRLG_WEAPON_COST_NONELEMENTAL_DMG_1D4 = 2000; // magical/positive/negative energy damage etc. NOT USED AT THE MOMENT

const int SRLG_WEAPON_COST_DAMAGEBONUSALIGNMENT_1D6 = 1000;

const int SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4 = 200;

const int SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_1 = 25;
const int SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_2 = 100;
const int SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_3 = 200;
const int SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_4 = 300;
const int SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_5 = 400;

const int SRLG_WEAPON_COST_ENHANCEMENTRACE_1 = 25;
const int SRLG_WEAPON_COST_ENHANCEMENTRACE_2 = 100;
const int SRLG_WEAPON_COST_ENHANCEMENTRACE_3 = 200;
const int SRLG_WEAPON_COST_ENHANCEMENTRACE_4 = 300;
const int SRLG_WEAPON_COST_ENHANCEMENTRACE_5 = 400;

const int SRLG_WEAPON_COST_KEEN = 1000;

const int SRLG_WEAPON_COST_MASSIVECRIT_2D4 = 500;

const int SRLG_WEAPON_COST_VAMPIRIC_1 = 1000;
const int SRLG_WEAPON_COST_VAMPIRIC_2 = 1500;
const int SRLG_WEAPON_COST_VAMPIRIC_3 = 2000;

//.............................
// WEAPON MATERIAL CHANCES
const int SRLG_WEAPON_IRON = 40; // roll of 1 up to this-1 = iron
const int SRLG_WEAPON_DARKSTEEL = 60; // roll of ironchance up to this-1 = iron
const int SRLG_WEAPON_COLDIRON = 80; //..., rest of rolls results in alchemical silver

//.............................
// ITEM TYPES
const int	SRLG_ITEMTYPE_CLOTHING	=	1	;
const int	SRLG_ITEMTYPE_PADDEDARMOR	=	2	;
const int	SRLG_ITEMTYPE_LEATHERARMOR	=	3	;
const int	SRLG_ITEMTYPE_STUDDEDLEATHERARMOR	=	4	;
const int	SRLG_ITEMTYPE_CHAINSHIRT	=	5	;
const int	SRLG_ITEMTYPE_HIDEARMOR	=	6	;
const int	SRLG_ITEMTYPE_SCALEMAIL	=	7	;
const int	SRLG_ITEMTYPE_CHAINMAIL	=	8	;
const int	SRLG_ITEMTYPE_BREASTPLATE	=	9	;
const int	SRLG_ITEMTYPE_SPLINTMAIL	=	10	; // DOES NOT EXIST!!!
const int	SRLG_ITEMTYPE_BANDEDMAIL	=	11	;
const int	SRLG_ITEMTYPE_HALFPLATE	=	12	;
const int	SRLG_ITEMTYPE_FULLPLATE	=	13	;
const int	SRLG_ITEMTYPE_LIGHTSHIELD	=	14	;
const int	SRLG_ITEMTYPE_HEAVYSHIELD	=	15	;
const int	SRLG_ITEMTYPE_TOWERSHIELD	=	16	;
const int	SRLG_ITEMTYPE_DAGGER	=	17	;
const int	SRLG_ITEMTYPE_SICKLE	=	18	;
const int	SRLG_ITEMTYPE_HANDAXE	=	19	;
const int	SRLG_ITEMTYPE_KUKRI	=	20	;
const int	SRLG_ITEMTYPE_SHORTSWORD	=	21	;
const int	SRLG_ITEMTYPE_KAMA	=	22	;
const int	SRLG_ITEMTYPE_BATTLEAXE	=	23	;
const int	SRLG_ITEMTYPE_LONGSWORD	=	24	;
const int	SRLG_ITEMTYPE_RAPIER	=	25	;
const int	SRLG_ITEMTYPE_SCIMITAR	=	26	;
const int	SRLG_ITEMTYPE_BASTARDSWORD	=	27	;
const int	SRLG_ITEMTYPE_DWARVENWARAXE	=	28	;
const int	SRLG_ITEMTYPE_KATANA	=	29	;
const int	SRLG_ITEMTYPE_FALCHION	=	30	;
const int	SRLG_ITEMTYPE_GREATAXE	=	31	;
const int	SRLG_ITEMTYPE_GREATSWORD	=	32	;
const int	SRLG_ITEMTYPE_MACE	=	33	;
const int	SRLG_ITEMTYPE_LIGHTHAMMER	=	34	;
const int	SRLG_ITEMTYPE_CLUB	=	35	;
const int	SRLG_ITEMTYPE_MORNINGSTAR	=	36	;
const int	SRLG_ITEMTYPE_WARHAMMER	=	37	;
const int	SRLG_ITEMTYPE_FLAIL	=	38	;
const int	SRLG_ITEMTYPE_WARMACE	=	39	;
const int	SRLG_ITEMTYPE_HALBERD	=	40	;
const int	SRLG_ITEMTYPE_SCYTHE	=	41	;
const int	SRLG_ITEMTYPE_QUARTERSTAFF	=	42	;
const int	SRLG_ITEMTYPE_SPEAR	=	43	;
const int	SRLG_ITEMTYPE_LONGBOW	=	44	;
const int	SRLG_ITEMTYPE_SHORTBOW	=	45	;
const int	SRLG_ITEMTYPE_HEAVYCROSSBOW	=	46	;
const int	SRLG_ITEMTYPE_LIGHTCROSSBOW	=	47	;
const int	SRLG_ITEMTYPE_SLING	=	48	;
const int	SRLG_ITEMTYPE_BOOTS	=	49	;
const int	SRLG_ITEMTYPE_CLOAK	=	50	;
const int	SRLG_ITEMTYPE_GLOVES	=	51	;
const int	SRLG_ITEMTYPE_BELT	=	52	;
const int	SRLG_ITEMTYPE_HAT	=	53	;
const int	SRLG_ITEMTYPE_RING	=	54	;
const int	SRLG_ITEMTYPE_AMULET	=	55	;
const int	SRLG_ITEMTYPE_BRACERS	=	56	;

///////////////////////////////////////////////////////////////////////
// DECLARATIONS OF INTERFACE FUNCTIONS

//---------------------------------------------------------------------
// GIVE PC A RANDOM ITEM OF SPECIFIC TYPE

object SRLG_ApplyRandomProperties(object oItem, int itemType, int points);
object SRLG_GiveRandomItem(object oPC, int itemType, int points);
object SRLG_GiveRandomLeveledItem(object oPC, int itemType);

//---------------------------------------------------------------------
// FUNCTIONS FOR SPECIFIC MINOR TASKS

// Get the number of loot points
int GetPointEquivalentForLevel(int level);
int GetPointEquivalent(object oPC);

// Put totalPoints worth of properties on the oItem
void AddRandomWeaponProperties(object oItem, int totalPoints);
void AddRandomBowWeaponProperties(object oItem, int totalPoints);
void AddRandomSlingWeaponProperties(object oItem, int totalPoints);
void AddRandomArmorProperties(object oItem, int totalPoints);
void AddRandomTrinketProperties(object oItem, int totalPoints);
void AddRandomBootsProperties(object oItem, int totalPoints);
void AddRandomJewelryProperties(object oItem, int totalPoints);
void AddRandomGlovesProperties(object oItem, int totalPoints);

///////////////////////////////////////////////////////////////////////
// DECLARATIONS OF PRIVATE FUNCTIONS

void DebugMsg(string str);
void RandomLootGeneratorError(object oPC, string errormsg);
void AddRandomWeaponProperties_(object oItem);
void AddRandomArmorProperties_(object oItem);
void AddRandomTrinketProperties_(object oItem);
void AddRandomBowWeaponProperties_(object oItem);
void AddRandomSlingWeaponProperties_(object oItem);
void AddRandomBootsProperties_(object oItem);
void AddRandomJewelryProperties_(object oItem);
void AddRandomGlovesProperties_(object oItem);
string ChooseRandomWeaponMaterial(string sIron, string sDarksteel, string sColdiron, string sSilver);
string GetRandomBaseitemTag(int itemType);
void AddRandomProperties(object oItem, int itemType, int points);
void CleanItemProperties(object oItem);

///////////////////////////////////////////////////////////////////////
// DEFINITIONS OF INTERFACE FUNCTIONS

//---------------------------------------------------------------------
// Apply points worth of random properties to an oItem of itemType
object SRLG_ApplyRandomProperties(object oItem, int itemType, int points)
{
	AddRandomProperties(oItem, itemType, points);
	CleanItemProperties(oItem); // remove any redundant properties (+1 vs X when already +1 or greater)
	SetLocalInt(oItem, "ISGAMBLED", 1);
	return oItem;
}

//---------------------------------------------------------------------
// Give PC random item of type and with points worth of properties
object SRLG_GiveRandomItem(object oPC, int itemType, int points)
{
	string itemTag = GetRandomBaseitemTag(itemType);
	object oItem = CreateItemOnObject(itemTag, oPC);
	if (oItem == OBJECT_INVALID)
	{
		RandomLootGeneratorError(oPC, "SRLG_GiveRandomItem() could not create item");
		return OBJECT_INVALID;
	}
	return SRLG_ApplyRandomProperties(oItem, itemType, points);
}

//---------------------------------------------------------------------
// Generate an item appropriate for PCs level in their inventory
object SRLG_GiveRandomLeveledItem(object oPC, int itemType)
{
	return SRLG_GiveRandomItem(oPC, itemType, GetPointEquivalent(oPC));
}

///////////////////////////////////////////////////////////////////////
// DEFINITIONS OF INTERNAL FUNCTIONS

//---------------------------------------------------------------------
int GetEnhancementBonus(object oItem)
{
	int enhancementBonus = -1;

	// Get the first itemproperty
	itemproperty ipLoop = GetFirstItemProperty(oItem);

	// Loop for as long as the ipLoop variable is valid
	while (GetIsItemPropertyValid(ipLoop))
	{
		if (GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
		{
			// How powerful enchantment?
			int enhancementBonus = GetItemPropertyCostTableValue(ipLoop);
			DebugMsg("enhancementBonus = " + IntToString(enhancementBonus));
			return enhancementBonus;
		}

		// Next itemproperty on the list...
		ipLoop = GetNextItemProperty(oItem);
   }
   return enhancementBonus;
}

//---------------------------------------------------------------------
int GetArmorEnhancementBonus(object oItem)
{
	int armorBonus = -1;

	// Get the first itemproperty
	itemproperty ipLoop = GetFirstItemProperty(oItem);

	// Loop for as long as the ipLoop variable is valid
	while (GetIsItemPropertyValid(ipLoop))
	{
		if (GetItemPropertyType(ipLoop) == ITEM_PROPERTY_AC_BONUS)
		{
			// How powerful enchantment?
			int armorBonus = GetItemPropertyCostTableValue(ipLoop);
			DebugMsg("armorBonus = " + IntToString(armorBonus));
			return armorBonus;
		}

		// Next itemproperty on the list...
		ipLoop = GetNextItemProperty(oItem);
   }
   return armorBonus;
}

//---------------------------------------------------------------------
void RemoveItemPropertyIfWeaker(object oItem, itemproperty ip, int propertyType, int basePower)
{
	if (GetItemPropertyType(ip) == propertyType)
	{
		int propertyPower = GetItemPropertyCostTableValue(ip);
		DebugMsg("propertyPower = " + IntToString(propertyPower));
		if (propertyPower <= basePower)
		{
			// e.g. +1 vs Good when base +1
			RemoveItemProperty(oItem, ip);
		}
	}
}

//---------------------------------------------------------------------
void CleanItemProperties(object oItem)
{
	int enhancementBonus = GetEnhancementBonus(oItem);

	if (enhancementBonus >= 1)
	{
		// Get the first itemproperty
		itemproperty ipLoop = GetFirstItemProperty(oItem);

		// Loop for as long as the ipLoop variable is valid
		while (GetIsItemPropertyValid(ipLoop))
		{
			RemoveItemPropertyIfWeaker(oItem, ipLoop, ITEM_PROPERTY_ATTACK_BONUS, enhancementBonus);
			RemoveItemPropertyIfWeaker(oItem, ipLoop, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP, enhancementBonus);
			RemoveItemPropertyIfWeaker(oItem, ipLoop, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP, enhancementBonus);
			RemoveItemPropertyIfWeaker(oItem, ipLoop, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP, enhancementBonus);
			RemoveItemPropertyIfWeaker(oItem, ipLoop, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP, enhancementBonus);

			// Next itemproperty on the list...
			ipLoop = GetNextItemProperty(oItem);
		}
	}

	int armorBonus = GetArmorEnhancementBonus(oItem);
	if (armorBonus >= 1)
	{
		// Get the first itemproperty
		itemproperty ipLoop = GetFirstItemProperty(oItem);

		// Loop for as long as the ipLoop variable is valid
		while (GetIsItemPropertyValid(ipLoop))
		{
			RemoveItemPropertyIfWeaker(oItem, ipLoop, ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP, armorBonus);
			RemoveItemPropertyIfWeaker(oItem, ipLoop, ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP, armorBonus);

			// Next itemproperty on the list...
			ipLoop = GetNextItemProperty(oItem);
		}
	}
}

//---------------------------------------------------------------------
// Get points to use for this level
int GetPointEquivalentForLevel(int level)
{
	return level * SRLG_POINTS_PER_LEVEL;
}

//---------------------------------------------------------------------
// Get points to use for this PCs level
int GetPointEquivalent(object oPC)
{
	int pcLevel;
	int usedLevel;

	if (GetIsPC(oPC))
	{
		pcLevel = GetTotalLevels(oPC, 0);
	}
	else
	{
		pcLevel = FloatToInt(GetChallengeRating(oPC));
		if (pcLevel > 30) pcLevel = 30;
	}

	return GetPointEquivalentForLevel(pcLevel);
}

//---------------------------------------------------------------------
// current total points available for item properties
int GetTotalPoints(object oItem)
{
	return GetLocalInt(oItem, "totalPoints");
}

// current total points available for item properties
void SetTotalPoints(object oItem, int points)
{
	SetLocalInt(oItem, "totalPoints", points);
}

// for counting how many properties have been assigned already
int GetTotalProperties(object oItem)
{
	return GetLocalInt(oItem, "totalProperties");
}

// for counting how many properties have been assigned already
void SetTotalProperties(object oItem, int properties)
{
	SetLocalInt(oItem, "totalProperties", properties);
}

//---------------------------------------------------------------------
void AddRandomWeaponProperties(object oItem, int totalPoints)
{
	SetTotalPoints(oItem, totalPoints);
	AddRandomWeaponProperties_(oItem);
}

//---------------------------------------------------------------------
void AddRandomBowWeaponProperties(object oItem, int totalPoints)
{
	SetTotalPoints(oItem, totalPoints);
	AddRandomBowWeaponProperties_(oItem);
}

//---------------------------------------------------------------------
void AddRandomSlingWeaponProperties(object oItem, int totalPoints)
{
	SetTotalPoints(oItem, totalPoints);
	AddRandomSlingWeaponProperties_(oItem);
}

//---------------------------------------------------------------------
void AddRandomArmorProperties(object oItem, int totalPoints)
{
	SetTotalPoints(oItem, totalPoints);
	AddRandomArmorProperties_(oItem);
}

//---------------------------------------------------------------------
void AddRandomTrinketProperties(object oItem, int totalPoints)
{
	SetTotalPoints(oItem, totalPoints);
	AddRandomTrinketProperties_(oItem);
}

//---------------------------------------------------------------------
void AddRandomBootsProperties(object oItem, int totalPoints)
{
	SetTotalPoints(oItem, totalPoints);
	AddRandomBootsProperties_(oItem);
}

//---------------------------------------------------------------------
void AddRandomJewelryProperties(object oItem, int totalPoints)
{
	SetTotalPoints(oItem, totalPoints);
	AddRandomJewelryProperties_(oItem);
}

//---------------------------------------------------------------------
void AddRandomGlovesProperties(object oItem, int totalPoints)
{
	SetTotalPoints(oItem, totalPoints);
	AddRandomGlovesProperties_(oItem);
}


///////////////////////////////////////////////////////////////////////
// DEFINITIONS OF PRIVATE FUNCTIONS

//---------------------------------------------------------------------
void RandomLootGeneratorError(object oPC, string errormsg)
{
	SendMessageToPC(oPC, "SCoD Random Loot Generator ERROR: " + errormsg);
}

//---------------------------------------------------------------------
void AddRandomProperties(object oItem, int itemType, int points)
{
	switch(itemType)
	{
		case 	SRLG_ITEMTYPE_CLOTHING	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_PADDEDARMOR	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_LEATHERARMOR	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_STUDDEDLEATHERARMOR	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_CHAINSHIRT	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_HIDEARMOR	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_SCALEMAIL	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_CHAINMAIL	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_BREASTPLATE	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_SPLINTMAIL	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_BANDEDMAIL	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_HALFPLATE	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_FULLPLATE	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_LIGHTSHIELD	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_HEAVYSHIELD	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_TOWERSHIELD	: 	AddRandomArmorProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_DAGGER	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_SICKLE	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_HANDAXE	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_KUKRI	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_SHORTSWORD	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_KAMA	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_BATTLEAXE	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_LONGSWORD	: 	AddRandomWeaponProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_RAPIER	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_SCIMITAR	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_BASTARDSWORD	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_DWARVENWARAXE	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_KATANA	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_FALCHION	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_GREATAXE	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_GREATSWORD	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_MACE	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_LIGHTHAMMER	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_CLUB	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_MORNINGSTAR	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_WARHAMMER	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_FLAIL	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_WARMACE	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_HALBERD	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_SCYTHE	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_QUARTERSTAFF	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_SPEAR	: 	AddRandomWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_LONGBOW	: 	AddRandomBowWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_SHORTBOW	: 	AddRandomBowWeaponProperties(oItem, points);		break;
		case 	SRLG_ITEMTYPE_HEAVYCROSSBOW	: 	AddRandomBowWeaponProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_LIGHTCROSSBOW	: 	AddRandomBowWeaponProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_SLING	: 	AddRandomSlingWeaponProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_BOOTS	: 	AddRandomBootsProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_CLOAK	: 	AddRandomTrinketProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_GLOVES	: 	AddRandomGlovesProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_BELT	: 	AddRandomTrinketProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_HAT	: 	AddRandomTrinketProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_RING	: 	AddRandomJewelryProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_AMULET	: 	AddRandomJewelryProperties(oItem, points);	break;
		case 	SRLG_ITEMTYPE_BRACERS	: 	AddRandomTrinketProperties(oItem, points);	break;
	}
}

//---------------------------------------------------------------------
string GetRandomBaseitemTag(int itemType)
{
switch(itemType)
{
case  SRLG_ITEMTYPE_CLOTHING :   return "NW_CLOTH022";  break;
case  SRLG_ITEMTYPE_PADDEDARMOR :  return "NW_AARCL009"; break;
case  SRLG_ITEMTYPE_LEATHERARMOR :  return "NW_AARCL001"; break;
case  SRLG_ITEMTYPE_STUDDEDLEATHERARMOR :  return "NW_AARCL002"; break;
case  SRLG_ITEMTYPE_CHAINSHIRT :  return "NW_AARCL012"; break;
case  SRLG_ITEMTYPE_HIDEARMOR :  return "NW_AARCL008"; break;
case  SRLG_ITEMTYPE_SCALEMAIL :  return "NW_AARCL003"; break;
case  SRLG_ITEMTYPE_CHAINMAIL :  return "NW_AARCL004"; break;
case  SRLG_ITEMTYPE_BREASTPLATE :  return "NW_AARCL010"; break;
case  SRLG_ITEMTYPE_BANDEDMAIL :  return "NW_AARCL011"; break;
case  SRLG_ITEMTYPE_HALFPLATE :  return "NW_AARCL006"; break;
case  SRLG_ITEMTYPE_FULLPLATE :  return "NW_AARCL007"; break;
case  SRLG_ITEMTYPE_LIGHTSHIELD :  return "NW_ASHSW001"; break;
case  SRLG_ITEMTYPE_HEAVYSHIELD :  return "NW_ASHLW001"; break;
case  SRLG_ITEMTYPE_TOWERSHIELD :  return "NW_ASHTO001"; break;
case  SRLG_ITEMTYPE_DAGGER :   return ChooseRandomWeaponMaterial("NW_WSWDG001", "mst_swdg_drk_3", "mst_swdg_cld_3", "mst_swdg_slv_3"); break;
case  SRLG_ITEMTYPE_SICKLE :   return ChooseRandomWeaponMaterial("NW_WSPSC001", "mst_spsc_drk_3", "mst_spsc_cld_3", "mst_spsc_slv_3"); break;
case  SRLG_ITEMTYPE_HANDAXE :   return ChooseRandomWeaponMaterial("NW_WAXHN001", "mst_axhn_drk_3", "mst_axhn_cld_3", "mst_axhn_slv_3"); break;
case  SRLG_ITEMTYPE_KUKRI :   return ChooseRandomWeaponMaterial("NW_WSPKU001", "mst_spku_drk_3", "mst_spku_cld_3", "mst_spku_slv_3"); break;
case  SRLG_ITEMTYPE_SHORTSWORD :   return ChooseRandomWeaponMaterial("NW_WSWSS001", "mst_swss_drk_3", "mst_swss_cld_3", "mst_swss_slv_3"); break;
case  SRLG_ITEMTYPE_KAMA :   return ChooseRandomWeaponMaterial("NW_WSPKA001", "mst_spka_drk_3", "mst_spka_cld_3", "mst_spka_slv_3"); break;
case  SRLG_ITEMTYPE_BATTLEAXE :   return ChooseRandomWeaponMaterial("NW_WAXBT001", "mst_axbt_drk_3", "mst_axbt_cld_3", "mst_axbt_slv_3"); break;
case  SRLG_ITEMTYPE_LONGSWORD :  return ChooseRandomWeaponMaterial("NW_WSWLS001", "mst_swls_drk_3", "mst_swls_cld_3", "mst_swls_slv_3"); break;
case  SRLG_ITEMTYPE_RAPIER :   return ChooseRandomWeaponMaterial("NW_WSWRP001", "mst_swrp_drk_3", "mst_swrp_cld_3", "mst_swrp_slv_3"); break;
case  SRLG_ITEMTYPE_SCIMITAR :   return ChooseRandomWeaponMaterial("NW_WSWSC001", "mst_swsc_drk_3", "mst_swsc_cld_3", "mst_swsc_slv_3"); break;
case  SRLG_ITEMTYPE_BASTARDSWORD :   return ChooseRandomWeaponMaterial("NW_WSWBS001", "mst_swbs_drk_3", "mst_swbs_cld_3", "mst_swbs_slv_3"); break;
case  SRLG_ITEMTYPE_DWARVENWARAXE :  return ChooseRandomWeaponMaterial("X2_WDWRAXE001", "mst_axdv_drk_3", "mst_axdv_cld_3", "mst_axdv_slv_3");  break;
case  SRLG_ITEMTYPE_KATANA :  return ChooseRandomWeaponMaterial("NW_WSWKA001", "mst_swka_drk_3", "mst_swka_cld_3", "mst_swka_slv_3");  break;
case  SRLG_ITEMTYPE_FALCHION :  return ChooseRandomWeaponMaterial("N2_WSWFL001", "mst_swfl_drk_3", "mst_swfl_cld_3", "mst_swfl_slv_3");  break;
case  SRLG_ITEMTYPE_GREATAXE :  return ChooseRandomWeaponMaterial("NW_WAXGR001", "mst_axgr_drk_3", "mst_axgr_cld_3", "mst_axgr_slv_3");  break;
case  SRLG_ITEMTYPE_GREATSWORD :  return ChooseRandomWeaponMaterial("NW_WSWGS001", "mst_swgs_drk_3", "mst_swgs_cld_3", "mst_swgs_slv_3");  break;
case  SRLG_ITEMTYPE_MACE :  return ChooseRandomWeaponMaterial("NW_WBLML001", "mst_blml_drk_3", "mst_blml_cld_3", "mst_blml_slv_3");  break;
case  SRLG_ITEMTYPE_LIGHTHAMMER :  return ChooseRandomWeaponMaterial("NW_WBLHL001", "mst_blhl_drk_3", "mst_blhl_cld_3", "mst_blhl_slv_3");  break;
case  SRLG_ITEMTYPE_CLUB :  return ChooseRandomWeaponMaterial("NW_WBLCL001", "mst_blcl_zal_3", "mst_blcl_dsk_3", "x2_it_iwoodclub");  break;
case  SRLG_ITEMTYPE_MORNINGSTAR :  return ChooseRandomWeaponMaterial("NW_WBLMS001", "mst_blms_drk_3", "mst_blms_cld_3", "mst_blms_slv_3");  break;
case  SRLG_ITEMTYPE_WARHAMMER :  return ChooseRandomWeaponMaterial("NW_WBLHW001", "mst_blhw_drk_3", "mst_blhw_cld_3", "mst_blhw_slv_3");  break;
case  SRLG_ITEMTYPE_FLAIL :  return ChooseRandomWeaponMaterial("NW_WBLFL001", "mst_blfl_drk_3", "mst_blfl_cld_3", "mst_blfl_slv_3");  break;
case  SRLG_ITEMTYPE_WARMACE :  return ChooseRandomWeaponMaterial("NW_WDBMA001", "mst_bldm_drk_3", "mst_bldm_cld_3", "mst_bldm_slv_3");  break;
case  SRLG_ITEMTYPE_HALBERD :  return ChooseRandomWeaponMaterial("NW_WPLHB001", "mst_plhb_drk_3", "mst_plhb_cld_3", "mst_plhb_slv_3");  break;
case  SRLG_ITEMTYPE_SCYTHE :  return ChooseRandomWeaponMaterial("NW_WPLSC001", "mst_plsc_drk_3", "mst_plsc_cld_3", "mst_plsc_slv_3");  break;
case  SRLG_ITEMTYPE_QUARTERSTAFF :  return ChooseRandomWeaponMaterial("NW_WDBQS001", "mst_dbqs_zal_3", "mst_dbqs_dsk_3", "x2_it_iwoodstaff");  break;
case  SRLG_ITEMTYPE_SPEAR :  return ChooseRandomWeaponMaterial("NW_WPLSS001", "NW_WPLSS001", "mst_plss_zal_3", "mst_plss_dsk_3");  break;
case  SRLG_ITEMTYPE_LONGBOW :  return ChooseRandomWeaponMaterial("NW_WBWLN001", "mwr_bwln_zal_3", "mwr_bwln_shd_3", "mwr_bwln_dsk_4");  break;
case  SRLG_ITEMTYPE_SHORTBOW :  return ChooseRandomWeaponMaterial("NW_WBWSH001", "mwr_bwsh_zal_3", "mwr_bwsh_shd_3", "mwr_bwsh_dsk_4");  break;
case  SRLG_ITEMTYPE_HEAVYCROSSBOW :  return ChooseRandomWeaponMaterial("NW_WBWXH001", "mwr_bwxh_zal_3", "mwr_bwxh_shd_3", "mwr_bwxh_dsk_4");  break;
case  SRLG_ITEMTYPE_LIGHTCROSSBOW :  return ChooseRandomWeaponMaterial("NW_WBWXL001", "mwr_bwxl_zal_3", "mwr_bwxl_shd_3", "mwr_bwxl_dsk_4");  break;
case  SRLG_ITEMTYPE_SLING :  return "NW_WBWSL001";  break;
case  SRLG_ITEMTYPE_BOOTS :  return "ps_srlg_boots"; break;
case  SRLG_ITEMTYPE_CLOAK :  return "ps_srlg_cloak"; break;
case  SRLG_ITEMTYPE_GLOVES :  return "ps_srlg_gloves"; break;
case  SRLG_ITEMTYPE_BELT :  return "ps_srlg_belt"; break;
case  SRLG_ITEMTYPE_HAT :  return "ps_srlg_helm"; break;
case  SRLG_ITEMTYPE_RING :  return "NW_IT_MRING022"; break;
case  SRLG_ITEMTYPE_AMULET :  return "NW_IT_MNECK021"; break;
case  SRLG_ITEMTYPE_BRACERS :  return "ps_srlg_bracers"; break;
}
return "";
}

//---------------------------------------------------------------------
void DebugMsg(string str)
{
	// SendMessageToPC(GetFirstPC(), str);
}

//---------------------------------------------------------------------
// Helper function to choose one of 4 allowed random weapon materials
string ChooseRandomWeaponMaterial(string sIron, string sDarksteel, string sColdiron, string sSilver)
{
	int nRandom = Random(100) + 1;
	string sItemtag = "";
	if ( nRandom < SRLG_WEAPON_IRON ) //iron
	{
		return sIron;
	}
	else if ( nRandom < SRLG_WEAPON_DARKSTEEL ) //darksteel
	{
		return sDarksteel;
	}
	else if ( nRandom < SRLG_WEAPON_COLDIRON ) //cold iron
	{
		return sColdiron;
	}
	else //silver
	{
		return sSilver;
	}
}

//---------------------------------------------------------------------
// Will not replace existing properties of the same kind.
void AddPropertyIfEnoughPoints(object oItem, int nCost, itemproperty ip)
{
	if (nCost <= GetTotalPoints(oItem))
	{
		SetTotalPoints(oItem, GetTotalPoints(oItem) - nCost);
		IPSafeAddItemProperty(oItem, ip, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		SetTotalProperties(oItem, GetTotalProperties(oItem) + 1);
	}
}

//---------------------------------------------------------------------
void AddRandomEnhancementBonusIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(5) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_1, ItemPropertyEnhancementBonus(1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_2, ItemPropertyEnhancementBonus(2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_3, ItemPropertyEnhancementBonus(3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_4, ItemPropertyEnhancementBonus(4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_5, ItemPropertyEnhancementBonus(5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomBonusFeatIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(26) + 1;
	switch (nPropertyRoll)
	{
		//case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_ALERTNESS)); break;
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(1324)); break; //new alertness
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_COMBAT_CASTING)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_DEFLECT_ARROWS)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_DODGE)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_EXTENDED_RAGE)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_EXTRA_MUSIC)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_EXTRA_RAGE)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_EXTRA_SMITING)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_EXTRA_STUNNING_ATTACK)); break;
		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_EXTRA_TURNING)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_EXTRA_WILD_SHAPE)); break;
		//case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_KNOCKDOWN)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_POINTBLANK)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_POWERATTACK)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFOCUSABJ)); break;
		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFOCUSCON)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFOCUSDIV)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFOCUSENC)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFOCUSEVO)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFOCUSILL)); break;
		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFOCUSNEC)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLPENETRATION)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_TWO_WEAPON_FIGHTING)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_EXOTIC)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL)); break;
		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSFEAT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomElementalDamageIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(10) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D4, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D6, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6)); break;

		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D4, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d4)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D6, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d6)); break;

		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D4, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1d4)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D6, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1d6)); break;

		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D4, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d4)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D6, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6)); break;

		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D4, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ELEMENTAL_DMG_1D6, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d6)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomAttackBonusIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(5) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUS_1, ItemPropertyAttackBonus(1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUS_2, ItemPropertyAttackBonus(2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUS_3, ItemPropertyAttackBonus(3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUS_4, ItemPropertyAttackBonus(4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUS_5, ItemPropertyAttackBonus(5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomAttackBonusVsAlignIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(25) + 1;
	switch (nPropertyRoll)
	{
		// ATTACK BONUS VS ALIGNMENT (CHAOTIC)
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_1, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_2, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_3, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_4, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_5, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 5)); break;

		// ATTACK BONUS VS ALIGNMENT (EVIL)
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_1, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 1)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_2, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 2)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_3, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 3)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_4, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_5, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 5)); break;

		// ATTACK BONUS VS ALIGNMENT (GOOD)
		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_1, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 1)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_2, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 2)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_3, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 3)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_4, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 4)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_5, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 5)); break;

		// ATTACK BONUS VS ALIGNMENT (LAWFUL)
		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_1, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 1)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_2, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 2)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_3, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 3)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_4, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 4)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_5, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 5)); break;

		// ATTACK BONUS VS ALIGNMENT (NEUTRAL)
		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_1, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 1)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_2, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 2)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_3, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 3)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_4, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 4)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSALIGNMENT_5, ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomACBonusVsAlignIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(25) + 1;
	switch (nPropertyRoll)
	{
		// BONUS VS ALIGNMENT (CHAOTIC)
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_1, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_2, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_3, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_4, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_5, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 5)); break;

		// BONUS VS ALIGNMENT (EVIL)
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_1, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 1)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_2, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 2)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_3, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 3)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_4, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_5, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 5)); break;

		// BONUS VS ALIGNMENT (GOOD)
		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_1, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 1)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_2, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 2)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_3, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 3)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_4, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 4)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_5, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 5)); break;

		// BONUS VS ALIGNMENT (LAWFUL)
		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_1, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 1)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_2, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 2)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_3, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 3)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_4, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 4)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_5, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 5)); break;

		// BONUS VS ALIGNMENT (NEUTRAL)
		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_1, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 1)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_2, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 2)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_3, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 3)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_4, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 4)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACBONUSALIGNMENT_5, ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomAttackBonusVsRaceIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(120) + 1;
	switch (nPropertyRoll)
	{
		// ATTACK BONUS VS RACE (24 groups)
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 5)); break;

		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 1)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 2)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 3)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 5)); break;

		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 1)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 2)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 3)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 4)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 5)); break;

		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 1)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 2)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 3)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 4)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 5)); break;

		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 1)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 2)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 3)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 4)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 5)); break;

		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 1)); break;
		case 27: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 2)); break;
		case 28: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 3)); break;
		case 29: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 4)); break;
		case 30: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 5)); break;

		case 31: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 1)); break;
		case 32: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 2)); break;
		case 33: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 3)); break;
		case 34: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 4)); break;
		case 35: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 5)); break;

		case 36: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELF, 1)); break;
		case 37: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELF, 2)); break;
		case 38: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELF, 3)); break;
		case 39: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELF, 4)); break;
		case 40: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELF, 5)); break;

		case 41: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_FEY, 1)); break;
		case 42: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_FEY, 2)); break;
		case 43: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_FEY, 3)); break;
		case 44: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_FEY, 4)); break;
		case 45: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_FEY, 5)); break;

		case 46: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 1)); break;
		case 47: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 2)); break;
		case 48: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 3)); break;
		case 49: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 4)); break;
		case 50: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 5)); break;

		case 51: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 1)); break;
		case 52: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 2)); break;
		case 53: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 3)); break;
		case 54: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 4)); break;
		case 55: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 5)); break;

		case 56: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 1)); break;
		case 57: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 2)); break;
		case 58: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 3)); break;
		case 59: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 4)); break;
		case 60: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 5)); break;

		case 61: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 1)); break;
		case 62: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 2)); break;
		case 63: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 3)); break;
		case 64: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 4)); break;
		case 65: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 5)); break;

		case 66: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 1)); break;
		case 67: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 2)); break;
		case 68: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 3)); break;
		case 69: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 4)); break;
		case 70: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 5)); break;

		case 71: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 1)); break;
		case 72: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 2)); break;
		case 73: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 3)); break;
		case 74: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 4)); break;
		case 75: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 5)); break;

		case 76: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 1)); break;
		case 77: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 2)); break;
		case 78: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 3)); break;
		case 79: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 4)); break;
		case 80: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 5)); break;

		case 81: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 1)); break;
		case 82: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 2)); break;
		case 83: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 3)); break;
		case 84: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 4)); break;
		case 85: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 5)); break;

		case 86: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 1)); break;
		case 87: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 2)); break;
		case 88: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 3)); break;
		case 89: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 4)); break;
		case 90: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 5)); break;

		case 91: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 1)); break;
		case 92: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 2)); break;
		case 93: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 3)); break;
		case 94: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 4)); break;
		case 95: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 5)); break;

		case 96: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 1)); break;
		case 97: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 2)); break;
		case 98: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 3)); break;
		case 99: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 4)); break;
		case 100: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 5)); break;

		case 101: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 1)); break;
		case 102: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 2)); break;
		case 103: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 3)); break;
		case 104: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 4)); break;
		case 105: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 5)); break;

		case 106: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 1)); break;
		case 107: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 2)); break;
		case 108: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 3)); break;
		case 109: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 4)); break;
		case 110: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 5)); break;

		case 111: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 1)); break;
		case 112: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 2)); break;
		case 113: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 3)); break;
		case 114: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 4)); break;
		case 115: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 5)); break;

		case 116: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_1, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 1)); break;
		case 117: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_2, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 2)); break;
		case 118: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_3, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 3)); break;
		case 119: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_4, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 4)); break;
		case 120: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ATTACKBONUSRACE_5, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomNonelementalDamageIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(4) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_NONELEMENTAL_DMG_1D4, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d4)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_NONELEMENTAL_DMG_1D4, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_NONELEMENTAL_DMG_1D4, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d4)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_NONELEMENTAL_DMG_1D4, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_1d4)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomDamageBonusVsAlignIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(5) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSALIGNMENT_1D6, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSALIGNMENT_1D6, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSALIGNMENT_1D6, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSALIGNMENT_1D6, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSALIGNMENT_1D6, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6)); break;
	}
}

//---------------------------------------------------------------------
void AddSpellImmunityIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(56) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_ACID_FOG)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_BESTOW_CURSE)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_BLINDNESS_AND_DEAFNESS)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_BURNING_HANDS)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CALL_LIGHTNING)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHAIN_LIGHTNING)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON_OR_ANIMAL)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CIRCLE_OF_DEATH)); break;
		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CLOUDKILL)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_COLOR_SPRAY)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CONFUSION)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CONE_OF_COLD)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CAUSE_FEAR)); break;
		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CONTAGION)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DARKNESS)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DAZE)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DELAYED_BLAST_FIREBALL)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON)); break;
		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOOM)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_ENERVATION)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_EVARDS_BLACK_TENTACLES)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FEAR)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FEEBLEMIND)); break;
		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FINGER_OF_DEATH)); break;
		case 27: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FIRE_STORM)); break;
		case 28: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FIREBALL)); break;
		case 29: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FLAME_ARROW)); break;
		case 30: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_FLAME_STRIKE)); break;
		case 31: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_GREASE)); break;
		case 32: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HARM)); break;
		case 33: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON)); break;
		case 34: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_INCENDIARY_CLOUD)); break;
		case 35: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_LIGHTNING_BOLT)); break;
		case 36: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MAGIC_MISSILE)); break;
		case 37: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_BLINDNESS_AND_DEAFNESS)); break;
		case 38: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_CHARM)); break;
		case 39: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MELFS_ACID_ARROW)); break;
		case 40: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MIND_FOG)); break;
		case 41: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_PHANTASMAL_KILLER)); break;
		case 42: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_POISON)); break;
		case 43: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_POWER_WORD_STUN)); break;
		case 44: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_POWER_WORD_KILL)); break;
		case 45: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_PRISMATIC_SPRAY)); break;
		case 46: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_RAY_OF_ENFEEBLEMENT)); break;
		case 47: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_RAY_OF_FROST)); break;
		case 48: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SEARING_LIGHT)); break;
		case 49: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLAY_LIVING)); break;
		case 50: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLEEP)); break;
		case 51: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLOW)); break;
		case 52: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SOUND_BURST)); break;
		case 53: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_STINKING_CLOUD)); break;
		case 54: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SUNBEAM)); break;
		case 55: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_WEB)); break;
		case 56: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLIMMUNITY, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_WEIRD)); break;
	}
}
// IP_CONST_IMMUNITYSPELL

//---------------------------------------------------------------------
void AddRandomDamageBonusVsRaceIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(24) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_BEAST, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_DWARF, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_ELF, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_FEY, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_GIANT, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_GNOME, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_DAMAGEBONUSRACE_2D4, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d4)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomEnhancementBonusVsAlignIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(5) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_1, ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_2, ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_3, ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_4, ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEBONUSALIGNMENT_5, ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_NEUTRAL, 5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomUnlimitedAmmoIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(10) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_1, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_BASIC)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_2, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_PLUS1)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_3, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_PLUS2)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_4, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_PLUS3)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_5, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_PLUS4)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_6, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_PLUS5)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_7, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_1D6COLD)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_8, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_1D6FIRE)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_9, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_1D6LIGHT)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_UNLIMITEDAMMO_10, ItemPropertyUnlimitedAmmo(IP_CONST_UNLIMITEDAMMO_NATURES_RAGE)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomEnhancementBonusVsRaceIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(120) + 1;
	switch (nPropertyRoll)
	{
		// ATTACK BONUS VS RACE (24 groups)
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 5)); break;

		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 1)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 2)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 3)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 5)); break;

		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 1)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 2)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 3)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 4)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 5)); break;

		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 1)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 2)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 3)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 4)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 5)); break;

		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 1)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 2)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 3)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 4)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 5)); break;

		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 1)); break;
		case 27: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 2)); break;
		case 28: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 3)); break;
		case 29: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 4)); break;
		case 30: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 5)); break;

		case 31: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 1)); break;
		case 32: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 2)); break;
		case 33: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 3)); break;
		case 34: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 4)); break;
		case 35: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 5)); break;

		case 36: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELF, 1)); break;
		case 37: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELF, 2)); break;
		case 38: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELF, 3)); break;
		case 39: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELF, 4)); break;
		case 40: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_ELF, 5)); break;

		case 41: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_FEY, 1)); break;
		case 42: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_FEY, 2)); break;
		case 43: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_FEY, 3)); break;
		case 44: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_FEY, 4)); break;
		case 45: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_FEY, 5)); break;

		case 46: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 1)); break;
		case 47: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 2)); break;
		case 48: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 3)); break;
		case 49: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 4)); break;
		case 50: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 5)); break;

		case 51: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 1)); break;
		case 52: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 2)); break;
		case 53: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 3)); break;
		case 54: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 4)); break;
		case 55: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 5)); break;

		case 56: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 1)); break;
		case 57: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 2)); break;
		case 58: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 3)); break;
		case 59: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 4)); break;
		case 60: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 5)); break;

		case 61: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 1)); break;
		case 62: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 2)); break;
		case 63: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 3)); break;
		case 64: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 4)); break;
		case 65: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 5)); break;

		case 66: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 1)); break;
		case 67: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 2)); break;
		case 68: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 3)); break;
		case 69: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 4)); break;
		case 70: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 5)); break;

		case 71: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 1)); break;
		case 72: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 2)); break;
		case 73: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 3)); break;
		case 74: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 4)); break;
		case 75: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 5)); break;

		case 76: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 1)); break;
		case 77: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 2)); break;
		case 78: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 3)); break;
		case 79: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 4)); break;
		case 80: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 5)); break;

		case 81: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 1)); break;
		case 82: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 2)); break;
		case 83: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 3)); break;
		case 84: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 4)); break;
		case 85: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 5)); break;

		case 86: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 1)); break;
		case 87: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 2)); break;
		case 88: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 3)); break;
		case 89: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 4)); break;
		case 90: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 5)); break;

		case 91: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 1)); break;
		case 92: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 2)); break;
		case 93: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 3)); break;
		case 94: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 4)); break;
		case 95: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 5)); break;

		case 96: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 1)); break;
		case 97: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 2)); break;
		case 98: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 3)); break;
		case 99: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 4)); break;
		case 100: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 5)); break;

		case 101: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 1)); break;
		case 102: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 2)); break;
		case 103: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 3)); break;
		case 104: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 4)); break;
		case 105: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 5)); break;

		case 106: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 1)); break;
		case 107: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 2)); break;
		case 108: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 3)); break;
		case 109: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 4)); break;
		case 110: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 5)); break;

		case 111: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 1)); break;
		case 112: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 2)); break;
		case 113: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 3)); break;
		case 114: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 4)); break;
		case 115: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 5)); break;

		case 116: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_1, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 1)); break;
		case 117: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_2, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 2)); break;
		case 118: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_3, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 3)); break;
		case 119: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_4, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 4)); break;
		case 120: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_ENHANCEMENTRACE_5, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomACBonusVsRaceIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(120) + 1;
	switch (nPropertyRoll)
	{
		// ATTACK BONUS VS RACE (24 groups)
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ABERRATION, 5)); break;

		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 1)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 2)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 3)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 5)); break;

		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 1)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 2)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 3)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 4)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_BEAST, 5)); break;

		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 1)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 2)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 3)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 4)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, 5)); break;

		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 1)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 2)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 3)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 4)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 5)); break;

		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 1)); break;
		case 27: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 2)); break;
		case 28: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 3)); break;
		case 29: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 4)); break;
		case 30: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DWARF, 5)); break;

		case 31: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 1)); break;
		case 32: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 2)); break;
		case 33: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 3)); break;
		case 34: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 4)); break;
		case 35: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, 5)); break;

		case 36: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELF, 1)); break;
		case 37: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELF, 2)); break;
		case 38: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELF, 3)); break;
		case 39: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELF, 4)); break;
		case 40: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELF, 5)); break;

		case 41: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_FEY, 1)); break;
		case 42: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_FEY, 2)); break;
		case 43: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_FEY, 3)); break;
		case 44: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_FEY, 4)); break;
		case 45: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_FEY, 5)); break;

		case 46: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 1)); break;
		case 47: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 2)); break;
		case 48: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 3)); break;
		case 49: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 4)); break;
		case 50: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 5)); break;

		case 51: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 1)); break;
		case 52: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 2)); break;
		case 53: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 3)); break;
		case 54: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 4)); break;
		case 55: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GNOME, 5)); break;

		case 56: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 1)); break;
		case 57: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 2)); break;
		case 58: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 3)); break;
		case 59: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 4)); break;
		case 60: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFELF, 5)); break;

		case 61: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 1)); break;
		case 62: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 2)); break;
		case 63: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 3)); break;
		case 64: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 4)); break;
		case 65: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFLING, 5)); break;

		case 66: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 1)); break;
		case 67: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 2)); break;
		case 68: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 3)); break;
		case 69: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 4)); break;
		case 70: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HALFORC, 5)); break;

		case 71: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 1)); break;
		case 72: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 2)); break;
		case 73: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 3)); break;
		case 74: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 4)); break;
		case 75: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMAN, 5)); break;

		case 76: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 1)); break;
		case 77: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 2)); break;
		case 78: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 3)); break;
		case 79: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 4)); break;
		case 80: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, 5)); break;

		case 81: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 1)); break;
		case 82: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 2)); break;
		case 83: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 3)); break;
		case 84: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 4)); break;
		case 85: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 5)); break;

		case 86: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 1)); break;
		case 87: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 2)); break;
		case 88: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 3)); break;
		case 89: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 4)); break;
		case 90: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_ORC, 5)); break;

		case 91: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 1)); break;
		case 92: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 2)); break;
		case 93: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 3)); break;
		case 94: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 4)); break;
		case 95: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, 5)); break;

		case 96: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 1)); break;
		case 97: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 2)); break;
		case 98: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 3)); break;
		case 99: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 4)); break;
		case 100: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_MAGICAL_BEAST, 5)); break;

		case 101: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 1)); break;
		case 102: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 2)); break;
		case 103: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 3)); break;
		case 104: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 4)); break;
		case 105: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 5)); break;

		case 106: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 1)); break;
		case 107: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 2)); break;
		case 108: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 3)); break;
		case 109: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 4)); break;
		case 110: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 5)); break;

		case 111: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 1)); break;
		case 112: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 2)); break;
		case 113: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 3)); break;
		case 114: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 4)); break;
		case 115: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 5)); break;

		case 116: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_1, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 1)); break;
		case 117: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_2, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 2)); break;
		case 118: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_3, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 3)); break;
		case 119: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_4, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 4)); break;
		case 120: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_ACVSRACE_5, ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_VERMIN, 5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomVampiricRegenerationIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(3) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_VAMPIRIC_1, ItemPropertyVampiricRegeneration(1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_VAMPIRIC_2, ItemPropertyVampiricRegeneration(2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_VAMPIRIC_3, ItemPropertyVampiricRegeneration(3)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomACBonusIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(5) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_1, ItemPropertyACBonus(1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_2, ItemPropertyACBonus(2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_3, ItemPropertyACBonus(3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_4, ItemPropertyACBonus(4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_5, ItemPropertyACBonus(5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomBootsACBonusIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(5) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_BOOTS_1, ItemPropertyACBonus(1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_BOOTS_2, ItemPropertyACBonus(2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_BOOTS_3, ItemPropertyACBonus(3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_BOOTS_4, ItemPropertyACBonus(4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_BOOTS_5, ItemPropertyACBonus(5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomBonusLevelSpellIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(55) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_0, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 0)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_1, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 1)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_2, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 2)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_3, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 3)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_4, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 4)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_5, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 5)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_6, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_BARD, 6)); break;

		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_0, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 0)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_1, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 1)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_2, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 2)); break;
		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_3, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 3)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_4, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 4)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_5, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 5)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_6, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 6)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_7, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 7)); break;
		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_8, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 8)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_9, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_CLERIC, 9)); break;

		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_0, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 0)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_1, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 1)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_2, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 2)); break;
		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_3, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 3)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_4, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 4)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_5, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 5)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_6, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 6)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_7, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 7)); break;
		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_8, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 8)); break;
		case 27: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_9, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_DRUID, 9)); break;

		case 28: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_1, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_PALADIN, 1)); break;
		case 29: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_2, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_PALADIN, 2)); break;
		case 30: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_3, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_PALADIN, 3)); break;
		case 31: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_4, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_PALADIN, 4)); break;

		case 32: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_1, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_RANGER, 1)); break;
		case 33: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_2, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_RANGER, 2)); break;
		case 34: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_3, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_RANGER, 3)); break;
		case 35: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_4, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_RANGER, 4)); break;

		case 36: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_0, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 0)); break;
		case 37: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_1, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 1)); break;
		case 38: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_2, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 2)); break;
		case 39: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_3, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 3)); break;
		case 40: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_4, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 4)); break;
		case 41: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_5, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 5)); break;
		case 42: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_6, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 6)); break;
		case 43: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_7, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 7)); break;
		case 44: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_8, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 8)); break;
		case 45: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_9, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, 9)); break;

		case 46: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_0, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 0)); break;
		case 47: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_1, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 1)); break;
		case 48: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_2, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 2)); break;
		case 49: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_3, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 3)); break;
		case 50: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_4, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 4)); break;
		case 51: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_5, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 5)); break;
		case 52: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_6, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 6)); break;
		case 53: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_7, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 7)); break;
		case 54: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_8, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 8)); break;
		case 55: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSSPELL_9, ItemPropertyBonusLevelSpell(IP_CONST_CLASS_WIZARD, 9)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomBonusSavingThrowIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(15) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_1, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_2, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_3, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_4, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_5, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 5)); break;

		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_1, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, 1)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_2, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, 2)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_3, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, 3)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_4, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, 4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_5, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, 5)); break;

		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_1, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, 1)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_2, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, 2)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_3, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, 3)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_4, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, 4)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROW_5, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, 5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomBonusSavingThrowVsXIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(65) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ACID, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ACID, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ACID, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ACID, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ACID, 5)); break;

		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_COLD, 1)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_COLD, 2)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_COLD, 3)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_COLD, 4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_COLD, 5)); break;

		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DEATH, 1)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DEATH, 2)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DEATH, 3)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DEATH, 4)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DEATH, 5)); break;

		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 1)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 2)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 3)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 4)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DISEASE, 5)); break;

		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DIVINE, 1)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DIVINE, 2)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DIVINE, 3)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DIVINE, 4)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DIVINE, 5)); break;

		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ELECTRICAL, 1)); break;
		case 27: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ELECTRICAL, 2)); break;
		case 28: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ELECTRICAL, 3)); break;
		case 29: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ELECTRICAL, 4)); break;
		case 30: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_ELECTRICAL, 5)); break;

		case 31: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 1)); break;
		case 32: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 2)); break;
		case 33: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 3)); break;
		case 34: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 4)); break;
		case 35: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FEAR, 5)); break;

		case 36: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FIRE, 1)); break;
		case 37: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FIRE, 2)); break;
		case 38: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FIRE, 3)); break;
		case 39: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FIRE, 4)); break;
		case 40: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_FIRE, 5)); break;

		case 41: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 1)); break;
		case 42: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 2)); break;
		case 43: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 3)); break;
		case 44: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 4)); break;
		case 45: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 5)); break;

		case 46: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_NEGATIVE, 1)); break;
		case 47: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_NEGATIVE, 2)); break;
		case 48: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_NEGATIVE, 3)); break;
		case 49: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_NEGATIVE, 4)); break;
		case 50: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_NEGATIVE, 5)); break;

		case 51: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 1)); break;
		case 52: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 2)); break;
		case 53: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 3)); break;
		case 54: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 4)); break;
		case 55: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POISON, 5)); break;

		case 56: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POSITIVE, 1)); break;
		case 57: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POSITIVE, 2)); break;
		case 58: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POSITIVE, 3)); break;
		case 59: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POSITIVE, 4)); break;
		case 60: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_POSITIVE, 5)); break;

		case 61: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_SONIC, 1)); break;
		case 62: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_SONIC, 2)); break;
		case 63: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_SONIC, 3)); break;
		case 64: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_SONIC, 4)); break;
		case 65: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSX_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_SONIC, 5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomBonusUniversalSavingThrowIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(5) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSUNIVERSAL_1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSUNIVERSAL_2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSUNIVERSAL_3, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSUNIVERSAL_4, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SAVINGTHROWVSUNIVERSAL_5, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomSpellResistanceIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(7) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_10, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_10)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_12, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_14, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_16, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_18, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_20, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_22, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22)); break;
//		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_24, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24)); break;
//		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_26, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_26)); break;
//		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_28, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_28)); break;
//		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_30, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_30)); break;
//		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_SPELLRESISTANCE_32, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_32)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomDamageResistanceIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(5) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ELEMENTALDAMAGERESISTANCE_5, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_5)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ELEMENTALDAMAGERESISTANCE_5, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ELEMENTALDAMAGERESISTANCE_5, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ELEMENTALDAMAGERESISTANCE_5, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ELEMENTALDAMAGERESISTANCE_5, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_5)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomOnHitIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(29) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, SRLG_ONHIT_DC, IP_CONST_ABILITY_STR)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, SRLG_ONHIT_DC, IP_CONST_ABILITY_DEX)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, SRLG_ONHIT_DC, IP_CONST_ABILITY_CON)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, SRLG_ONHIT_DC, IP_CONST_ABILITY_INT)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, SRLG_ONHIT_DC, IP_CONST_ABILITY_WIS)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, SRLG_ONHIT_DC, IP_CONST_ABILITY_CHA)); break;

		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_BLINDNESS, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_CONFUSION, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_DEAFNESS, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_DOOM, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_FEAR, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_HOLD, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_SILENCE, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_SLEEP, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_STUN, SRLG_ONHIT_DC, SRLG_ONHIT_DURATION)); break;

		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, SRLG_ONHIT_POISONDISEASE_DC, DISEASE_BLINDING_SICKNESS)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, SRLG_ONHIT_POISONDISEASE_DC, DISEASE_CACKLE_FEVER)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, SRLG_ONHIT_POISONDISEASE_DC, DISEASE_MINDFIRE)); break;
		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, SRLG_ONHIT_POISONDISEASE_DC, DISEASE_RED_ACHE)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, SRLG_ONHIT_POISONDISEASE_DC, DISEASE_SHAKES)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, SRLG_ONHIT_POISONDISEASE_DC, DISEASE_SLIMY_DOOM)); break;

		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, SRLG_ONHIT_POISONDISEASE_DC, IP_CONST_POISON_1D2_STRDAMAGE)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, SRLG_ONHIT_POISONDISEASE_DC, IP_CONST_POISON_1D2_DEXDAMAGE)); break;
		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, SRLG_ONHIT_POISONDISEASE_DC, IP_CONST_POISON_1D2_CONDAMAGE)); break;
		case 27: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, SRLG_ONHIT_POISONDISEASE_DC, IP_CONST_POISON_1D2_INTDAMAGE)); break;
		case 28: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, SRLG_ONHIT_POISONDISEASE_DC, IP_CONST_POISON_1D2_WISDAMAGE)); break;
		case 29: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ONHITPROPERTY, ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, SRLG_ONHIT_POISONDISEASE_DC, IP_CONST_POISON_1D2_CHADAMAGE)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomLightIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(7) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_LIGHT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_BLUE)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_LIGHT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_GREEN)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_LIGHT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_ORANGE)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_LIGHT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_PURPLE)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_LIGHT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_RED)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_LIGHT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_LIGHT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_YELLOW)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomBonusHpIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(2) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSHP_10, ItemPropertyBonusHitpoints(10)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSHP_20, ItemPropertyBonusHitpoints(20)); break;
		// case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSHP_30, ItemPropertyBonusHitpoints(22)); break;
		// case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSHP_40, ItemPropertyBonusHitpoints(24)); break;
		// case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_BONUSHP_50, ItemPropertyBonusHitpoints(26)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomMaxRangeStrengthModIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(6) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_RANGESTRMOD_1, ItemPropertyMaxRangeStrengthMod(1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_RANGESTRMOD_2, ItemPropertyMaxRangeStrengthMod(2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_RANGESTRMOD_3, ItemPropertyMaxRangeStrengthMod(3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_RANGESTRMOD_4, ItemPropertyMaxRangeStrengthMod(4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_RANGESTRMOD_5, ItemPropertyMaxRangeStrengthMod(5)); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_RANGESTRMOD_6, ItemPropertyMaxRangeStrengthMod(6)); break;
	}
}

//---------------------------------------------------------------------
void AddRandomAbilityBonusIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(30) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_1, ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 1)); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_2, ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 2)); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_3, ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 3)); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_4, ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 4)); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_5, ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 5)); break;

		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_1, ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 1)); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_2, ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 2)); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_3, ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 3)); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_4, ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 4)); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_5, ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 5)); break;

		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_1, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 1)); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_2, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2)); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_3, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 3)); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_4, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 4)); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_5, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 5)); break;

		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_1, ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 1)); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_2, ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 2)); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_3, ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 3)); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_4, ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 4)); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_5, ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, 5)); break;

		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_1, ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 1)); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_2, ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 2)); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_3, ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 3)); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_4, ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 4)); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_5, ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 5)); break;

		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_1, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 1)); break;
		case 27: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_2, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2)); break;
		case 28: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_3, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 3)); break;
		case 29: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_4, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 4)); break;
		case 30: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ABILITYBONUS_5, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 5)); break;
	}
}

//---------------------------------------------------------------------
// Called in case nothing at all was assigned to an item, this ensures that at least one
// fairly weak property (e.g. light) is put on it.
void AddOneCertainRandomProperty(object oItem)
{
	int nPropertyRoll = Random(7) + 1;
	switch (nPropertyRoll)
	{
		case 1: IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_BLUE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); break;
		case 2: IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_GREEN), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); break;
		case 3: IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_ORANGE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); break;
		case 4: IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_PURPLE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); break;
		case 5: IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_RED), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); break;
		case 6: IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); break;
		case 7: IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_YELLOW), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); break;
	}
}

//---------------------------------------------------------------------
//---------------------------------------------------------------------
void AddRandomCastSpellIfEnoughPoints(object oItem)
{
	int nPropertyRoll = Random(194) + 1;
	switch (nPropertyRoll)
	{
		case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ACID_FOG_11, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ACID_SPLASH_1, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ANIMATE_DEAD_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ANIMATE_DEAD_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ANIMATE_DEAD_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 6: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ASSAY_RESISTANCE_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 7: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_BANE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_BANISHMENT_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 10: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_BESTOW_CURSE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 12: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_BURNING_HANDS_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 13: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_BURNING_HANDS_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 14: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CALL_LIGHTNING_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 15: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CALL_LIGHTNING_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 16: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHAIN_LIGHTNING_11, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 17: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHAIN_LIGHTNING_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 18: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 19: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_MONSTER_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 20: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_MONSTER_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_PERSON_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 22: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHARM_PERSON_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 23: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_11, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 24: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 25: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_20, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 26: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CLOUDKILL_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 27: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_COLOR_SPRAY_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 28: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONE_OF_COLD_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 29: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONE_OF_COLD_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 30: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONFUSION_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 31: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONTAGION_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 32: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONFUSION_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 33: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONTROL_UNDEAD_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 34: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONTROL_UNDEAD_20, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 35: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 36: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_16, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 37: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 38: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CREATE_UNDEAD_11, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 39: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CREATE_UNDEAD_14, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 40: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CREATE_UNDEAD_16, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 41: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CREEPING_DOOM_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 42: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 43: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 44: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 45: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 46: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 47: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 48: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 49: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 50: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 51: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 52: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 53: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 54: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DAZE_1, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 55: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 56: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 57: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_20, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 58: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DESTRUCTION_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 59: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISMISSAL_12, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 60: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISMISSAL_18, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 61: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISMISSAL_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 62: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPEL_MAGIC_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 63: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPEL_MAGIC_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 64: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DOMINATE_MONSTER_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 65: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DOMINATE_PERSON_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 66: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DOMINATE_ANIMAL_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 67: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DOOM_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 68: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DOOM_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 69: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DROWN_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 70: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_EARTHQUAKE_20, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 71: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 72: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 73: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ELEMENTAL_SWARM_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 74: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ENERGY_DRAIN_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 75: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ENERVATION_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 76: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ENTANGLE_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 77: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ENTANGLE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 78: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 79: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 80: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 81: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FEAR_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 82: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FEEBLEMIND_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 83: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FINGER_OF_DEATH_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 84: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIRE_STORM_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 85: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIRE_STORM_18, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 86: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIREBALL_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 87: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIREBALL_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 88: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIREBRAND_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 89: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FLAME_ARROW_12, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 90: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FLAME_ARROW_18, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 91: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FLAME_ARROW_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 92: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FLAME_STRIKE_12, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 93: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FLAME_STRIKE_18, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 94: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FLAME_STRIKE_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 95: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_FLESH_TO_STONE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 96: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_GREASE_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 97: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_GUST_OF_WIND_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 98: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 99: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 100: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_HARM_11, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 101: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_HASTE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 102: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_HASTE_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 103: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_HOLD_ANIMAL_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 104: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_HOLD_MONSTER_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 105: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_HOLD_PERSON_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 106: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_HORRID_WILTING_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 107: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ICE_STORM_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 108: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_IDENTIFY_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 109: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INCENDIARY_CLOUD_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 110: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INFERNO_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 111: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INFLICT_CRITICAL_WOUNDS_12, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 112: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INFLICT_LIGHT_WOUNDS_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 113: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 114: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INFLICT_MODERATE_WOUNDS_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 115: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INFLICT_SERIOUS_WOUNDS_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 116: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 117: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 118: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		// case 119: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		// case 120: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 119: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAR_CRY_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 120: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_WEB_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 121: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_KNOCK_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 122: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_LEGEND_LORE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 123: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_LESSER_DISPEL_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 124: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 125: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_LESSER_RESTORATION_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 126: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 127: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHT_1, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 128: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHT_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 129: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHTNING_BOLT_10, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 130: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHTNING_BOLT_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 131: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_FANG_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 132: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 133: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 134: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 135: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MASS_BLINDNESS_DEAFNESS_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 136: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MASS_CHARM_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 137: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 138: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MELFS_ACID_ARROW_6, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 139: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 140: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_METEOR_SWARM_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 141: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MIND_FOG_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		//case 142: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		// case 142: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_WORD_OF_FAITH_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 142: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_WALL_OF_FIRE_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 143: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 144: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_18, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 145: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 146: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 147: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_PLANAR_ALLY_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 148: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_PLANAR_BINDING_11, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 149: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_POISON_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 150: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_POLYMORPH_SELF_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 151: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_POWER_WORD_KILL_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 152: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_POWER_WORD_STUN_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 153: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 154: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_QUILLFIRE_8, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 155: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_RAISE_DEAD_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 156: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 157: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_RAY_OF_FROST_1, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		// case 158: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_REGENERATE_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 158: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_WEIRD_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 159: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 160: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_REMOVE_CURSE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 161: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_REMOVE_DISEASE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 162: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_REMOVE_FEAR_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 163: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 164: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_RESTORATION_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 165: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SANCTUARY_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 166: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SCARE_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 167: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SCINTILLATING_SPHERE_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 168: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SEARING_LIGHT_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 169: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SEE_INVISIBILITY_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 170: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHADOW_CONJURATION_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 171: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHAPECHANGE_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 172: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SILENCE_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 173: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SLAY_LIVING_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 174: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SLEEP_2, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 175: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SLEEP_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 176: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SLOW_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 177: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SOUND_BURST_3, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 178: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SPIKE_GROWTH_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 179: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_STINKING_CLOUD_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 180: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_STONE_TO_FLESH_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		// case 181: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_STORM_OF_VENGEANCE_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 181: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_WAIL_OF_THE_BANSHEE_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 182: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 183: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 184: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 185: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 186: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 187: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 188: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 189: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 190: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 191: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUNBEAM_13, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 192: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SUNBURST_20, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 193: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		// case 194: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
		case 194: AddPropertyIfEnoughPoints(oItem, SRLG_COST_CAST_SPELL, ItemPropertyCastSpell(IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5, SRLG_CAST_SPELL_NUMUSES)); SetItemCharges(oItem, SRLG_ITEMCHARGES); break;
	}
}
// ItemPropertyCastSpell IP_CONST_CASTSPELL IP_CONST_CASTSPELL_NUMUSES


//---------------------------------------------------------------------
// Choose a random enhancement bonus depending on the total points, this function is called before the main loop.
void AddGuaranteedEnhancementBonus(object oItem)
{
	int totalPoints = GetTotalPoints(oItem);
	if (totalPoints >= SRLG_COST_ENHANCEMENT_1 && totalPoints < SRLG_COST_ENHANCEMENT_2)
	{
		// max +1 enchantment possible

		// special case: 50/50 chance that this is a +1 weapon
		int nPropertyRoll = Random(2) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_1, ItemPropertyEnhancementBonus(1)); break;
			case 2: break;
		}
	}
	else if (totalPoints >= SRLG_COST_ENHANCEMENT_2 && totalPoints < SRLG_COST_ENHANCEMENT_3)
	{
		// max +2 enchantment possible
		int nPropertyRoll = Random(2) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_1, ItemPropertyEnhancementBonus(1)); break;
			case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_2, ItemPropertyEnhancementBonus(2)); break;
		}
	}
	else if (totalPoints >= SRLG_COST_ENHANCEMENT_3 && totalPoints < SRLG_COST_ENHANCEMENT_4)
	{
		// max +3 enchantment possible
		int nPropertyRoll = Random(3) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_1, ItemPropertyEnhancementBonus(1)); break;
			case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_2, ItemPropertyEnhancementBonus(2)); break;
	    	case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_3, ItemPropertyEnhancementBonus(3)); break;
		}
	}
	else if (totalPoints >= SRLG_COST_ENHANCEMENT_4 && totalPoints < SRLG_COST_ENHANCEMENT_5)
	{
		// max +4 enchantment possible
		int nPropertyRoll = Random(4) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_1, ItemPropertyEnhancementBonus(1)); break;
			case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_2, ItemPropertyEnhancementBonus(2)); break;
	    	case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_3, ItemPropertyEnhancementBonus(3)); break;
			case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_4, ItemPropertyEnhancementBonus(4)); break;
		}
	}
	else
	{
		// max +5 enchantment possible
		int nPropertyRoll = Random(5) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_1, ItemPropertyEnhancementBonus(1)); break;
			case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_2, ItemPropertyEnhancementBonus(2)); break;
	    	case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_3, ItemPropertyEnhancementBonus(3)); break;
			case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_4, ItemPropertyEnhancementBonus(4)); break;
			case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ENHANCEMENT_5, ItemPropertyEnhancementBonus(5)); break;
		}
	}
}

//---------------------------------------------------------------------
// Choose a random enhancement bonus depending on the total points, this function is called before the main loop.
void AddGuaranteedArmorEnhancementBonus(object oItem)
{
	int totalPoints = GetTotalPoints(oItem);
	if (totalPoints >= SRLG_COST_ACBONUS_1 && totalPoints < SRLG_COST_ACBONUS_1)
	{
		// max +1 enchantment possible

		// special case: 50/50 chance that this is +1
		int nPropertyRoll = Random(2) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_1, ItemPropertyACBonus(1)); break;
			case 2: break;
		}
	}
	else if (totalPoints >= SRLG_COST_ACBONUS_2 && totalPoints < SRLG_COST_ACBONUS_3)
	{
		// max +2 enchantment possible
		int nPropertyRoll = Random(2) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_1, ItemPropertyACBonus(1)); break;
			case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_2, ItemPropertyACBonus(2)); break;
		}
	}
	else if (totalPoints >= SRLG_COST_ACBONUS_3 && totalPoints < SRLG_COST_ACBONUS_4)
	{
		// max +3 enchantment possible
		int nPropertyRoll = Random(3) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_1, ItemPropertyACBonus(1)); break;
			case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_2, ItemPropertyACBonus(2)); break;
			case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_3, ItemPropertyACBonus(3)); break;
		}
	}
	else if (totalPoints >= SRLG_COST_ACBONUS_4 && totalPoints < SRLG_COST_ACBONUS_5)
	{
		// max +4 enchantment possible
		int nPropertyRoll = Random(4) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_1, ItemPropertyACBonus(1)); break;
			case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_2, ItemPropertyACBonus(2)); break;
			case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_3, ItemPropertyACBonus(3)); break;
			case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_4, ItemPropertyACBonus(4)); break;
		}
	}
	else
	{
		// max +5 enchantment possible
		int nPropertyRoll = Random(5) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_1, ItemPropertyACBonus(1)); break;
			case 2: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_2, ItemPropertyACBonus(2)); break;
			case 3: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_3, ItemPropertyACBonus(3)); break;
			case 4: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_4, ItemPropertyACBonus(4)); break;
			case 5: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ACBONUS_5, ItemPropertyACBonus(5)); break;
		}
	}
}

//---------------------------------------------------------------------
// add random properties to a weapon
void AddRandomWeaponProperties_(object oItem)
{
	SetTotalProperties(oItem, 0);

	// Put a random enhancement bonus on the weapon first
	AddGuaranteedEnhancementBonus(oItem);

	int propertyIdx;
	for (propertyIdx = 0; propertyIdx < SRLG_PROPERTY_RETRIES; propertyIdx++)
	{
		if (GetTotalPoints(oItem) == 0)
			break;

		if (GetTotalProperties(oItem) >= SRLG_MAX_PROPERTIES)
			break;

		int nPropertyRoll = Random(21) + 1;
		// nPropertyRoll = 20;
		switch (nPropertyRoll)
		{
			case 1: AddRandomElementalDamageIfEnoughPoints(oItem); break;
			case 2: AddRandomAttackBonusIfEnoughPoints(oItem); break;
			case 3: AddRandomAttackBonusVsAlignIfEnoughPoints(oItem); break;
			case 4: AddRandomAttackBonusVsRaceIfEnoughPoints(oItem); break;
			// case 5: AddRandomNonelementalDamageIfEnoughPoints(oItem); break;
			case 5: AddRandomOnHitIfEnoughPoints(oItem); break;
			case 6: AddRandomDamageBonusVsAlignIfEnoughPoints(oItem); break;
			case 7: AddRandomDamageBonusVsRaceIfEnoughPoints(oItem); break;
			case 8: AddRandomEnhancementBonusVsAlignIfEnoughPoints(oItem); break;
			case 9: AddRandomEnhancementBonusVsRaceIfEnoughPoints(oItem); break;
			case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_KEEN, ItemPropertyKeen()); break;
			case 11: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_MASSIVECRIT_2D4, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d4)); break;
			case 12: AddRandomVampiricRegenerationIfEnoughPoints(oItem); break;
			case 13: AddRandomACBonusIfEnoughPoints(oItem); break;
			case 14: AddRandomBonusLevelSpellIfEnoughPoints(oItem); break;
			case 15: AddRandomBonusSavingThrowIfEnoughPoints(oItem); break;
			case 16: AddRandomBonusSavingThrowVsXIfEnoughPoints(oItem); break;
			case 17: AddRandomBonusUniversalSavingThrowIfEnoughPoints(oItem); break;
			case 18: AddRandomSpellResistanceIfEnoughPoints(oItem); break;
			case 19: AddRandomDamageResistanceIfEnoughPoints(oItem); break;
			// case 20: AddRandomLightIfEnoughPoints(oItem); break;
			case 20: AddRandomCastSpellIfEnoughPoints(oItem); break;
			case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_REGENERATION_1, ItemPropertyRegeneration(1)); break;
			default: break;
		}
	}

	if (GetTotalProperties(oItem) == 0)
		AddOneCertainRandomProperty(oItem);
}

//---------------------------------------------------------------------
void AddRandomGlovesProperties_(object oItem)
{
	SetTotalProperties(oItem, 0);
	AddGuaranteedEnhancementBonus(oItem);

	int propertyIdx;
	for (propertyIdx = 0; propertyIdx < SRLG_PROPERTY_RETRIES; propertyIdx++)
	{
		if (GetTotalPoints(oItem) == 0)
			break;

		if (GetTotalProperties(oItem) >= SRLG_MAX_PROPERTIES)
			break;

		int nPropertyRoll = Random(20) + 1;
		// nPropertyRoll = 20;
		switch (nPropertyRoll)
		{
			case 1: AddRandomElementalDamageIfEnoughPoints(oItem); break;
			case 2: AddRandomAttackBonusIfEnoughPoints(oItem); break;
			case 3: AddRandomAttackBonusVsAlignIfEnoughPoints(oItem); break;
			case 4: AddRandomAttackBonusVsRaceIfEnoughPoints(oItem); break;
			// case 5: AddRandomNonelementalDamageIfEnoughPoints(oItem); break;
			case 5: AddRandomOnHitIfEnoughPoints(oItem); break;
			case 6: AddRandomDamageBonusVsAlignIfEnoughPoints(oItem); break;
			case 7: AddRandomDamageBonusVsRaceIfEnoughPoints(oItem); break;
			case 8: AddRandomEnhancementBonusVsAlignIfEnoughPoints(oItem); break;
			case 9: AddRandomEnhancementBonusVsRaceIfEnoughPoints(oItem); break;
			case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_KEEN, ItemPropertyKeen()); break;
			case 11: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_MASSIVECRIT_2D4, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d4)); break;
			case 12: AddRandomVampiricRegenerationIfEnoughPoints(oItem); break;
			case 13: AddRandomACBonusIfEnoughPoints(oItem); break;
			case 14: AddRandomBonusLevelSpellIfEnoughPoints(oItem); break;
			case 15: AddRandomBonusSavingThrowIfEnoughPoints(oItem); break;
			case 16: AddRandomBonusSavingThrowVsXIfEnoughPoints(oItem); break;
			case 17: AddRandomBonusUniversalSavingThrowIfEnoughPoints(oItem); break;
			case 18: AddRandomSpellResistanceIfEnoughPoints(oItem); break;
			case 19: AddRandomDamageResistanceIfEnoughPoints(oItem); break;
			// case 20: AddRandomLightIfEnoughPoints(oItem); break;
			case 20: AddRandomCastSpellIfEnoughPoints(oItem); break;
			default: break;
		}
	}

	if (GetTotalProperties(oItem) == 0)
		AddOneCertainRandomProperty(oItem);
}

//---------------------------------------------------------------------
// add random properties to an armor
void AddRandomArmorProperties_(object oItem)
{
	SetTotalProperties(oItem, 0);

	// Put a random AC bonus on the item first.
	AddGuaranteedArmorEnhancementBonus(oItem);

	int propertyIdx;
	for (propertyIdx = 0; propertyIdx < SRLG_PROPERTY_RETRIES; propertyIdx++)
	{
		if (GetTotalPoints(oItem) == 0)
			break;

		if (GetTotalProperties(oItem) >= SRLG_MAX_PROPERTIES)
			break;

		int nPropertyRoll = Random(14) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddRandomBonusLevelSpellIfEnoughPoints(oItem); break;
			case 2: AddRandomBonusSavingThrowIfEnoughPoints(oItem); break;
			case 3: AddRandomBonusSavingThrowVsXIfEnoughPoints(oItem); break;
			case 4: AddRandomBonusUniversalSavingThrowIfEnoughPoints(oItem); break;
			case 5: AddRandomSpellResistanceIfEnoughPoints(oItem); break;
			case 6: AddRandomDamageResistanceIfEnoughPoints(oItem); break;
			// case 7: AddRandomLightIfEnoughPoints(oItem); break;
			case 7: AddRandomCastSpellIfEnoughPoints(oItem); break;
			case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_REGENERATION_1, ItemPropertyRegeneration(1)); break;
			case 9: AddRandomAbilityBonusIfEnoughPoints(oItem); break;
			case 10: AddRandomBonusHpIfEnoughPoints(oItem); break;
			case 11: AddPropertyIfEnoughPoints(oItem, SRLG_COST_ARMOR_WEIGHTREDUCTION_50, ItemPropertyContainerReducedWeight(IP_CONST_REDUCEDWEIGHT_50_PERCENT)); break;
			case 12: AddRandomACBonusVsAlignIfEnoughPoints(oItem); break;
			case 13: AddRandomACBonusVsRaceIfEnoughPoints(oItem); break;
			case 14: AddRandomBonusFeatIfEnoughPoints(oItem); break;
			default: break;
		}
	}

	if (GetTotalProperties(oItem) == 0)
		AddOneCertainRandomProperty(oItem);
}

//---------------------------------------------------------------------
void AddRandomBowWeaponProperties_(object oItem)
{
	SetTotalProperties(oItem, 0);

	// Put a random enhancement bonus on the weapon first
	AddGuaranteedEnhancementBonus(oItem);

	int propertyIdx;
	for (propertyIdx = 0; propertyIdx < SRLG_PROPERTY_RETRIES; propertyIdx++)
	{
		if (GetTotalPoints(oItem) == 0)
			break;

		if (GetTotalProperties(oItem) >= SRLG_MAX_PROPERTIES)
			break;

		int nPropertyRoll = Random(22) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddRandomElementalDamageIfEnoughPoints(oItem); break;
			case 2: AddRandomAttackBonusIfEnoughPoints(oItem); break;
			case 3: AddRandomAttackBonusVsAlignIfEnoughPoints(oItem); break;
			case 4: AddRandomAttackBonusVsRaceIfEnoughPoints(oItem); break;
			// case 5: AddRandomNonelementalDamageIfEnoughPoints(oItem); break;
			case 5: AddRandomUnlimitedAmmoIfEnoughPoints(oItem); break;
			case 6: AddRandomDamageBonusVsAlignIfEnoughPoints(oItem); break;
			case 7: AddRandomDamageBonusVsRaceIfEnoughPoints(oItem); break;
			case 8: AddRandomEnhancementBonusVsAlignIfEnoughPoints(oItem); break;
			case 9: AddRandomEnhancementBonusVsRaceIfEnoughPoints(oItem); break;
			case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_KEEN, ItemPropertyKeen()); break;
			case 11: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_MASSIVECRIT_2D4, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d4)); break;
			case 12: AddRandomVampiricRegenerationIfEnoughPoints(oItem); break;
			case 13: AddRandomACBonusIfEnoughPoints(oItem); break;
			case 14: AddRandomBonusLevelSpellIfEnoughPoints(oItem); break;
			case 15: AddRandomBonusSavingThrowIfEnoughPoints(oItem); break;
			case 16: AddRandomBonusSavingThrowVsXIfEnoughPoints(oItem); break;
			case 17: AddRandomBonusUniversalSavingThrowIfEnoughPoints(oItem); break;
			case 18: AddRandomSpellResistanceIfEnoughPoints(oItem); break;
			case 19: AddRandomDamageResistanceIfEnoughPoints(oItem); break;
			// case 20: AddRandomLightIfEnoughPoints(oItem); break;
			case 20: AddRandomCastSpellIfEnoughPoints(oItem); break;
			case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_REGENERATION_1, ItemPropertyRegeneration(1)); break;
			case 22: AddRandomMaxRangeStrengthModIfEnoughPoints(oItem); break;

			default: break;
		}
	}

	if (GetTotalProperties(oItem) == 0)
		AddOneCertainRandomProperty(oItem);
}

//---------------------------------------------------------------------
void AddRandomSlingWeaponProperties_(object oItem)
{
	SetTotalProperties(oItem, 0);

	// Put a random enhancement bonus on the weapon first
	AddGuaranteedEnhancementBonus(oItem);

	int propertyIdx;
	for (propertyIdx = 0; propertyIdx < SRLG_PROPERTY_RETRIES; propertyIdx++)
	{
		if (GetTotalPoints(oItem) == 0)
			break;

		if (GetTotalProperties(oItem) >= SRLG_MAX_PROPERTIES)
			break;

		int nPropertyRoll = Random(21) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddRandomElementalDamageIfEnoughPoints(oItem); break;
			case 2: AddRandomAttackBonusIfEnoughPoints(oItem); break;
			case 3: AddRandomAttackBonusVsAlignIfEnoughPoints(oItem); break;
			case 4: AddRandomAttackBonusVsRaceIfEnoughPoints(oItem); break;
			// case 5: AddRandomNonelementalDamageIfEnoughPoints(oItem); break;
			case 5: AddRandomUnlimitedAmmoIfEnoughPoints(oItem); break;
			case 6: AddRandomDamageBonusVsAlignIfEnoughPoints(oItem); break;
			case 7: AddRandomDamageBonusVsRaceIfEnoughPoints(oItem); break;
			case 8: AddRandomEnhancementBonusVsAlignIfEnoughPoints(oItem); break;
			case 9: AddRandomEnhancementBonusVsRaceIfEnoughPoints(oItem); break;
			case 10: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_KEEN, ItemPropertyKeen()); break;
			case 11: AddPropertyIfEnoughPoints(oItem, SRLG_WEAPON_COST_MASSIVECRIT_2D4, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d4)); break;
			case 12: AddRandomVampiricRegenerationIfEnoughPoints(oItem); break;
			case 13: AddRandomACBonusIfEnoughPoints(oItem); break;
			case 14: AddRandomBonusLevelSpellIfEnoughPoints(oItem); break;
			case 15: AddRandomBonusSavingThrowIfEnoughPoints(oItem); break;
			case 16: AddRandomBonusSavingThrowVsXIfEnoughPoints(oItem); break;
			case 17: AddRandomBonusUniversalSavingThrowIfEnoughPoints(oItem); break;
			case 18: AddRandomSpellResistanceIfEnoughPoints(oItem); break;
			case 19: AddRandomDamageResistanceIfEnoughPoints(oItem); break;
			// case 20: AddRandomLightIfEnoughPoints(oItem); break;
			case 23: AddRandomCastSpellIfEnoughPoints(oItem); break;
			case 21: AddPropertyIfEnoughPoints(oItem, SRLG_COST_REGENERATION_1, ItemPropertyRegeneration(1)); break;

			default: break;
		}
	}

	if (GetTotalProperties(oItem) == 0)
		AddOneCertainRandomProperty(oItem);
}

//---------------------------------------------------------------------
void AddRandomTrinketProperties_(object oItem)
{
	SetTotalProperties(oItem, 0);

	int propertyIdx;
	for (propertyIdx = 0; propertyIdx < SRLG_PROPERTY_RETRIES; propertyIdx++)
	{
		if (GetTotalPoints(oItem) == 0)
			break;

		if (GetTotalProperties(oItem) >= SRLG_MAX_PROPERTIES)
			break;

		int nPropertyRoll = Random(12) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddRandomBonusLevelSpellIfEnoughPoints(oItem); break;
			case 2: AddRandomBonusSavingThrowIfEnoughPoints(oItem); break;
			case 3: AddRandomBonusSavingThrowVsXIfEnoughPoints(oItem); break;
			case 4: AddRandomBonusUniversalSavingThrowIfEnoughPoints(oItem); break;
			case 5: AddRandomSpellResistanceIfEnoughPoints(oItem); break;
			case 6: AddRandomDamageResistanceIfEnoughPoints(oItem); break;
			// case 7: AddRandomLightIfEnoughPoints(oItem); break;
			case 7: AddRandomBonusFeatIfEnoughPoints(oItem); break;
			// case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_REGENERATION_TRINKET_1, ItemPropertyRegeneration(1)); break;
			case 8: AddRandomCastSpellIfEnoughPoints(oItem); break;
			case 9: AddRandomAbilityBonusIfEnoughPoints(oItem); break;
			case 10: AddRandomBonusHpIfEnoughPoints(oItem); break;
			case 11: AddRandomACBonusVsAlignIfEnoughPoints(oItem); break;
			case 12: AddRandomACBonusVsRaceIfEnoughPoints(oItem); break;
			default: break;
		}
	}

	if (GetTotalProperties(oItem) == 0)
		AddOneCertainRandomProperty(oItem);
}

//---------------------------------------------------------------------
void AddRandomBootsProperties_(object oItem)
{
	SetTotalProperties(oItem, 0);
	int propertyIdx;
	for (propertyIdx = 0; propertyIdx < SRLG_PROPERTY_RETRIES; propertyIdx++)
	{
		if (GetTotalPoints(oItem) == 0)
			break;

		if (GetTotalProperties(oItem) >= SRLG_MAX_PROPERTIES)
			break;

		int nPropertyRoll = Random(14) + 1;
		// nPropertyRoll = 11;
		switch (nPropertyRoll)
		{
			case 1: AddRandomBootsACBonusIfEnoughPoints(oItem); break;
			case 2: AddRandomBonusLevelSpellIfEnoughPoints(oItem); break;
			case 3: AddRandomBonusSavingThrowIfEnoughPoints(oItem); break;
			case 4: AddRandomBonusSavingThrowVsXIfEnoughPoints(oItem); break;
			case 5: AddRandomBonusUniversalSavingThrowIfEnoughPoints(oItem); break;
			case 6: AddRandomSpellResistanceIfEnoughPoints(oItem); break;
			case 7: AddRandomDamageResistanceIfEnoughPoints(oItem); break;
			// case 8: AddRandomLightIfEnoughPoints(oItem); break;
			case 8: AddRandomCastSpellIfEnoughPoints(oItem); break;
			case 9: AddPropertyIfEnoughPoints(oItem, SRLG_COST_REGENERATION_TRINKET_1, ItemPropertyRegeneration(1)); break;
			case 10: AddRandomAbilityBonusIfEnoughPoints(oItem); break;
			case 11: AddRandomBonusHpIfEnoughPoints(oItem); break;
			case 12: AddRandomACBonusVsAlignIfEnoughPoints(oItem); break;
			case 13: AddRandomACBonusVsRaceIfEnoughPoints(oItem); break;
			case 14: AddRandomBonusFeatIfEnoughPoints(oItem); break;
			default: break;
		}
	}

	if (GetTotalProperties(oItem) == 0)
		AddOneCertainRandomProperty(oItem);
}

//---------------------------------------------------------------------
void AddRandomJewelryProperties_(object oItem)
{
	SetTotalProperties(oItem, 0);

	int propertyIdx;
	for (propertyIdx = 0; propertyIdx < SRLG_PROPERTY_RETRIES; propertyIdx++)
	{
		if (GetTotalPoints(oItem) == 0)
			break;

		if (GetTotalProperties(oItem) >= SRLG_MAX_PROPERTIES)
			break;

		int nPropertyRoll = Random(13) + 1;
		switch (nPropertyRoll)
		{
			case 1: AddRandomBonusLevelSpellIfEnoughPoints(oItem); break;
			case 2: AddRandomBonusSavingThrowIfEnoughPoints(oItem); break;
			case 3: AddRandomBonusSavingThrowVsXIfEnoughPoints(oItem); break;
			case 4: AddRandomBonusUniversalSavingThrowIfEnoughPoints(oItem); break;
			case 5: AddRandomSpellResistanceIfEnoughPoints(oItem); break;
			case 6: AddRandomDamageResistanceIfEnoughPoints(oItem); break;
			// case 7: AddRandomLightIfEnoughPoints(oItem); break;
			case 7: AddSpellImmunityIfEnoughPoints(oItem); break;
			// case 8: AddPropertyIfEnoughPoints(oItem, SRLG_COST_REGENERATION_TRINKET_1, ItemPropertyRegeneration(1)); break;
			case 8: AddRandomCastSpellIfEnoughPoints(oItem); break;
			case 9: AddRandomAbilityBonusIfEnoughPoints(oItem); break;
			case 10: AddRandomBonusHpIfEnoughPoints(oItem); break;
			case 11: AddRandomACBonusVsAlignIfEnoughPoints(oItem); break;
			case 12: AddRandomACBonusVsRaceIfEnoughPoints(oItem); break;
			case 13: AddRandomBonusFeatIfEnoughPoints(oItem); break;
			default: break;
		}
	}

	if (GetTotalProperties(oItem) == 0)
		AddOneCertainRandomProperty(oItem);
}