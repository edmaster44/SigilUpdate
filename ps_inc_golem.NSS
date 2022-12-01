// Script by Ceremorph. Reviewed by Clangeddin.
// Created for use in the Sigil: City of Doors PW
// Inclusion script for all golem creation scripts

#include "ps_inc_faction"

// Craftsmanship Feat by Ceremorph
// If character has the feat, the golem gains two levels of construct, +2 to natural AC, and +25 hp
void ApplyCraftsmanship(object oPC, object oGolem)
{
	if (GetHasFeat(2805, oPC, TRUE) == FALSE) return;
	
	LevelUpHenchman(oGolem, CLASS_TYPE_CONSTRUCT, TRUE, PACKAGE_CONSTRUCT);
	LevelUpHenchman(oGolem, CLASS_TYPE_CONSTRUCT, TRUE, PACKAGE_CONSTRUCT);
	
	effect eFX = EffectACIncrease(2, AC_NATURAL_BONUS);
	eFX = EffectLinkEffects(eFX, EffectBonusHitpoints(25));
	eFX = SupernaturalEffect(eFX);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oGolem);
}

// Abiding Masterwork feat by Ceremorph
// If character has the feat, the golem gains fast healing (regeneration) 2
void ApplyAbidingMasterwork(object oPC, object oGolem)
{
	if (GetHasFeat(2806, oPC, TRUE) == FALSE)
	{
		if (GetHasFeat(21346, oPC, TRUE) == FALSE) return;
	}

	effect eFX = EffectRegenerate(2, 6.0);
	eFX = SupernaturalEffect(eFX);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oGolem);	
}

// Master Craftsmanship feat by Ceremorph
// If character has the feat, the golem gains +4 to STR and DEX, and 2d6 magical damage
void ApplyMastercraft(object oPC, object oGolem)
{
	if (GetHasFeat(2807, oPC, TRUE) == FALSE) return;

	effect eFX = EffectDamageIncrease(DAMAGE_BONUS_2d6);
	eFX = EffectLinkEffects(eFX, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
	eFX = EffectLinkEffects(eFX, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
	eFX = SupernaturalEffect(eFX); 
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oGolem);
}

// Script by AstralEclipse
// Combination of setting to henchman set and death script specific to golems
void SetCreatureScriptsToSetAndSetDeathScript(object Creature, int ScriptSet, string DeathScript)
{
	SetCreatureScriptsToSet(Creature, ScriptSet);
	SetEventHandler(Creature, CREATURE_SCRIPT_ON_DAMAGED, DeathScript);
}

// Applies the proper buffs and settings to summoned golems
// oItem: It's the relative control device. Not used for Gorgoyle.
void AdjustGolem(object oPC, object oGolem, object oItem = OBJECT_INVALID)
{
	//SendMessageToPC(oPC, "You are commanding your " + sName + " to appear.");
	SendMessageToPC(oPC, "A " + GetName(oGolem) + " has answered the call and walks toward the location.");
	if (oItem == OBJECT_INVALID) SendMessageToPC(oPC, "To release it from service, use the feat once again");
	else SendMessageToPC(oPC, "To release it from service, use the Golem Control Device");
	
	AddHenchman(oPC, oGolem);
	if (oItem != OBJECT_INVALID) SetLocalObject(oGolem, "ControlObject", oItem);
	SetCreatureScriptsToSetAndSetDeathScript(oGolem, 10, "ps_golem_dmg");
	
	// Add bonuses from the Golem Master prestige class
	ApplyCraftsmanship(oPC, oGolem);
	ApplyAbidingMasterwork(oPC, oGolem);
	ApplyMastercraft(oPC, oGolem);
	// Add variable to prevent golem destruction with Abiding Masterwork
	if (GetHasFeat(2806, oPC, TRUE) == TRUE)
	{
		SetLocalInt(oItem, "AbidingMasterwork", 1);
	}
	
	
	DelayCommand(0.0f, StoreHenchInfo(oItem, oGolem));
}

// Returns how many sTAG items are possessed by oPC.
// nFIRST: Checks only the first stack of items found.
int GetItemQuantity(object oPC, string sTAG, int nFIRST = FALSE)
{
	object oITEM = GetItemPossessedBy(oPC, sTAG);
	if (oITEM == OBJECT_INVALID) return 0;
	else if (nFIRST == TRUE) return GetItemStackSize(oITEM);
	string sITEM;
	int nTOTAL;
	oITEM = GetFirstItemInInventory(oPC);
	while (oITEM != OBJECT_INVALID)
	{
		if (GetTag(oITEM) == sTAG) nTOTAL = nTOTAL + GetItemStackSize(oITEM);
		oITEM = GetNextItemInInventory(oPC);
	}
	return nTOTAL;
}

// Consume items from an object. Use GetItemQuantity Function to check if the items are available first.
void ConsumeItems(object oPOSSESSOR, string sTAG, int nCOUNT = 1, int nFEEDBACK = TRUE)
{
 	if (nCOUNT < 1) return;
	object oITEM = GetItemPossessedBy(oPOSSESSOR, sTAG);
	if (oITEM == OBJECT_INVALID) return;
	int nSTACK = GetItemStackSize(oITEM);
	if (nSTACK > nCOUNT)
	{
		SetItemStackSize(oITEM, nSTACK - nCOUNT, nFEEDBACK);
		return;
	}
	if (nSTACK == nCOUNT)
	{
		DestroyObject(oITEM, 0.0f, nFEEDBACK);
		return;
	}
	
	oITEM = GetFirstItemInInventory(oPOSSESSOR);
	while (oITEM != OBJECT_INVALID)
	{
		if (GetTag(oITEM) == sTAG)
		{
			nSTACK = GetItemStackSize(oITEM);
			if (nSTACK > nCOUNT) SetItemStackSize(oITEM, nSTACK - nCOUNT, nFEEDBACK);
			else DestroyObject(oITEM, 0.0f, nFEEDBACK);
			nCOUNT = nCOUNT - nSTACK;
			if (nCOUNT < 1) break;
		}
		oITEM = GetNextItemInInventory(oPOSSESSOR);
	}
}