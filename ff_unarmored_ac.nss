
#include "aaa_constants"


// Gets the total ac from Invisible Blade, Duelist, Monk, and Mystic
int GetUnarmoredAC(object oPC){
	
	int nIntelligenceAC = 0;
	//get ac from invisible blade or duelist.
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	int nArmorRank = GetArmorRank(oArmor);
	if (nArmorRank == ARMOR_RANK_NONE || !GetIsObjectValid(oArmor)){
		int nDuelist = GetLevelByClass(CLASS_TYPE_DUELIST, oPC);
		int nIB = GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE, oPC);
		if (nDuelist > 0 || nIB > 0){
			if (nDuelist > 0){
				int nOffHand = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
				if (nOffHand == BASE_ITEM_SMALLSHIELD || nOffHand == BASE_ITEM_LARGESHIELD ||
									nOffHand == BASE_ITEM_TOWERSHIELD)
					nDuelist = 0;
			}
			nIntelligenceAC = nIB;
			if (nDuelist > nIB) nIntelligenceAC = nDuelist; // invis blade and duelist ac don't stack
			int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
			if (nIntelligenceAC > nInt) nIntelligenceAC = nInt;
		}
	}
	
	//GetAC from monk and mystic
	int nWisdomAC = 0;
	int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC);
	if (nMonk > 0){
		int nMystic = GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);
		if ((((nArmorRank == ARMOR_RANK_NONE) || !GetIsObjectValid(oArmor)) && nMystic == 0) ||
			(nArmorRank == ARMOR_RANK_NONE || nArmorRank == ARMOR_RANK_LIGHT || !GetIsObjectValid(oArmor)) && nMystic > 0){
	
			int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
			int nMonkAC = nMonk / 5;
			int nMysticAC = (nMystic / 5) + 1;
			nWisdomAC = nWis + nMonkAC + nMysticAC;
		}
	}
	return nIntelligenceAC + nWisdomAC;
}
