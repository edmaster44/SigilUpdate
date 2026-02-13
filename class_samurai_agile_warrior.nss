

// Agile Warrior feat for Samurai, by FlattedFifth Feb 11, 2026

#include "ps_class_inc"
#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "ff_feat_tactical_weapon_inc"

const int AW_SPELL_ID = 1537;


void main(){

	object oPC = OBJECT_SELF;
	PS_RemoveEffects(oPC, AW_SPELL_ID);
	
	// Only works in light, medium, or no armor
	if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) == ARMOR_RANK_HEAVY)
		return;
		
	// only works if using a melee weapon...
	object oRHAND = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (!IPGetIsMeleeWeapon(oRHAND))
		return;

	//... and that melee weapon is being used two handed
	if (!GetWeaponIsTwoHanded(oPC, oRHAND, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
		return;
		
	int nBonus = 0;
	int nLevel = GetLevelByClass(CLASS_TYPE_SAMURAI, oPC);
	nLevel += GetLevelByClass(CLASS_TYPE_KENSAI, oPC);
	
	if (nLevel >= 17) nBonus = 3;
	else if (nLevel >= 9) nBonus = 2;
	else if (nLevel >= 3) nBonus = 1;
	
	if (nBonus < 1) return;
	
	effect eAC = EffectACIncrease(nBonus);
	eAC = SupernaturalEffect(eAC);
	eAC = SetEffectSpellId(eAC, AW_SPELL_ID);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
}
