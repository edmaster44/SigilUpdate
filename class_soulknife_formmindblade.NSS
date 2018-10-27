// Form mind blade script
// By Electrohydra
// Last edited 8/1/16 by Leoric

#include "class_soulknife_global"
#include "ginc_item"

void AddEnchant(object oPC, int nSlot, itemproperty ipBonus)
{
	object mindblade = GetItemInSlot(nSlot, oPC);
	
	if (GetTag(mindblade) == "mindblade")
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, ipBonus, mindblade);
		}
}

void main()
{
	object oPC = OBJECT_SELF;
		
	int size = GetCreatureSize(oPC);	
	int soulknifeLevels = GetLevelByClass(SOULKNIFE_ID, oPC);
	int nDex =  GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	int nStr = GetAbilityModifier(ABILITY_STRENGTH,oPC);
	
	int spellID = GetSpellId();
	
	
	string template;
	
	// Gets the appropriate template for the creature's size and weapon choice.
	switch (spellID)
	{
		case FORM_MINDBLADE_TWO_HANDED :
			if (size == CREATURE_SIZE_SMALL)
				template = MINDBLADE_LONGSWORD_TEMPLATE;
			else
				template = MINDBLADE_TWOHANDEDSWORD_TEMPLATE;
			break;
		case FORM_MINDBLADE_SINGLE :
			if (size == CREATURE_SIZE_SMALL || nDex > nStr)
				template = MINDBLADE_SHORTSWORD_TEMPLATE;
			else
				template = MINDBLADE_LONGSWORD_TEMPLATE;
			break;
		case FORM_MINDBLADE_TWIN :
			if (size == CREATURE_SIZE_SMALL)
				template = MINDBLADE_DAGGER_TEMPLATE;
			else
				template = MINDBLADE_SHORTSWORD_TEMPLATE;
			break;
		default :
			return;
	}
	// Determines the appropriate Enhancement Bonus
	int enhancementBonus = 1;

	if (soulknifeLevels >= 29)
		enhancementBonus = 8;
	else if (soulknifeLevels >= 22)
		enhancementBonus = 7;
	else if (soulknifeLevels >= 16)
		enhancementBonus = 6;
	else if (soulknifeLevels >= 11)
		enhancementBonus = 5;
	else if (soulknifeLevels >= 7)
		enhancementBonus = 4;
	else if (soulknifeLevels >= 4)
		enhancementBonus = 3;
	else if (soulknifeLevels >= 2)
		enhancementBonus = 2;
	
	if (GetHasFeat(FEAT_IMPROVED_ENHANCEMENT, oPC))
		++enhancementBonus;
		
	itemproperty ipBonus = ItemPropertyEnhancementBonus(enhancementBonus);
	
	EquipNewItem(oPC, template, INVENTORY_SLOT_RIGHTHAND, FALSE);
	SendMessageToPC(oPC, "Item template: "+template);
	//object mindblade = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	//AddItemProperty(DURATION_TYPE_PERMANENT, ipBonus, mindblade);
	DelayCommand(2.5f, AddEnchant(oPC, INVENTORY_SLOT_RIGHTHAND, ipBonus));
	if (spellID == FORM_MINDBLADE_TWIN)
	{
		EquipNewItem(oPC, template, INVENTORY_SLOT_LEFTHAND, FALSE);
		//object mindblade2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		//AddItemProperty(DURATION_TYPE_PERMANENT, ipBonus, mindblade2);
		DelayCommand(2.5f, AddEnchant(oPC, INVENTORY_SLOT_LEFTHAND, ipBonus));		
	}
			
	/* (Disabled and repalced with EquipNewItem command in lines 44 and 48)
	ActionEquipItem(mindblade, INVENTORY_SLOT_RIGHTHAND);
	
	if (spellID == FORM_MINDBLADE_TWIN)
	{
		DelayCommand(0.1f, ActionEquipItem(mindblade2, INVENTORY_SLOT_LEFTHAND));
	}*/
	
	// if psychic strike hasn't yet been initialized, do it now.
	if (GetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC) == 0)
	{
		SendMessageToPC(oPC, "Psychic strike initialized");
		SetLocalInt(oPC, VAR_PSYCHIC_STRIKE_ON, TRUE);
		SetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC, 20);
	}
	
	// Activate Mind Shield
	int INT = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
	int ACBonus = INT;
	if (GetHasFeat(FEAT_EPIC_MIND_SHIELD, oPC))
	{
		ACBonus = ACBonus + 2;
		if (ACBonus > 9)
			ACBonus = 9;
	}
	else if (GetHasFeat(FEAT_IMPROVED_MIND_SHIELD, oPC))
	{
		ACBonus = ACBonus + 1;
		if (ACBonus > 6)
			ACBonus = 6;
	}
	else if (GetHasFeat(FEAT_MIND_SHIELD, oPC))
	{
		if (ACBonus > 3)
			ACBonus = 3;
	}
	else //No mind shield
	{
		ACBonus = 0;
	}
	SetLocalInt(oPC, VAR_MIND_SHIELD, ACBonus);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(ACBonus, AC_SHIELD_ENCHANTMENT_BONUS)), oPC, 0.0f);
	
	// Debug psy strike
	DebugPsychicStrike(GetLocalInt(oPC, VAR_PSYCHIC_STRIKE_ON), GetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC));
}