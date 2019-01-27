//:://////////////////////////////////////////////
//:: Sigil Equip system
//:://////////////////////////////////////////////
//:: Runs the Custom OnEquip and OnUnequip Scripts.
//:://////////////////////////////////////////////
//:: Created By: Clangeddin
//:: Created On: December 29, 2017

#include "aaa_constants"
#include "ginc_2da"
#include "nw_i0_spells"
#include "x2_inc_itemprop"
#include "class_monk_shatteringblows"
#include "ps_meditative_strikes"

const int SIGIL_EQUIP_FX = -9444;

//Wrapper to check if nTYPE is a creature weapon. Item Type from 160 to 174
int GetIsCreatureWeapon(int nTYPE)
{
	if (nTYPE < 160) return FALSE;
	if (nTYPE > 174) return FALSE;
	return TRUE;
}

//A Wrapper for to Ignore Exsisting Finesse
int GetExistingFinesse(object oItem)
{
	if ((GetBaseItemType(oItem) == BASE_ITEM_DAGGER) || (GetBaseItemType(oItem) ==BASE_ITEM_GLOVES )
	 ||(GetBaseItemType(oItem) == BASE_ITEM_KAMA ) ||(GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD)||(GetBaseItemType(oItem) ==BASE_ITEM_SICKLE)
	||(GetBaseItemType(oItem) ==BASE_ITEM_HANDAXE)||(GetBaseItemType(oItem) ==BASE_ITEM_LIGHTHAMMER)||
	(GetBaseItemType(oItem) ==BASE_ITEM_MACE)||(GetBaseItemType(oItem) ==BASE_ITEM_RAPIER)) return TRUE;
else
return FALSE;


}
//A Wrapper for Get Monk Weapon Functions
int GetMonkWeapon(object oItem)

{
	if ((GetBaseItemType(oItem) == BASE_ITEM_SHURIKEN) || (GetBaseItemType(oItem) ==BASE_ITEM_GLOVES ) ||(GetBaseItemType(oItem) == BASE_ITEM_KAMA ) ||(GetBaseItemType(oItem) == BASE_ITEM_QUARTERSTAFF))return TRUE;
else
return FALSE;

}

//Wrapper to equip effects from equipment in the proper manner.
void ApplyEquipmentEffect(object oPC, effect eFX, int nDUR = DURATION_TYPE_PERMANENT)
{
	eFX = SupernaturalEffect(eFX);
	eFX = SetEffectSpellId(eFX, SIGIL_EQUIP_FX);
	ApplyEffectToObject(nDUR, eFX, oPC);
}

//Removes Shield if you don't have the feat required for it. To prevent exploit.
int FixSHIELD(object oPC, object oSHIELD, int nSHIELD)
{
	int nFEAT;
	switch (nSHIELD)
	{
		case BASE_ITEM_SMALLSHIELD: nFEAT = FEAT_SHIELD_PROFICIENCY; break;
		case BASE_ITEM_LARGESHIELD: nFEAT = FEAT_SHIELD_PROFICIENCY; break;
		case BASE_ITEM_TOWERSHIELD: nFEAT = FEAT_TOWER_SHIELD_PROFICIENCY; break;
		default: return FALSE;
	}
	if (GetHasFeat(nFEAT, oPC, TRUE) == TRUE) return FALSE;
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ActionUnequipItem(oSHIELD));
	return TRUE;
}

//Removes Armor if you don't have the feat required for it. To prevent exploit.
int FixARMOR(object oPC, object oARMOR)
{
	int nARMOR = GetArmorRank(oARMOR);
	int nFEAT;
	switch (nARMOR)
	{
		case ARMOR_RANK_LIGHT: nFEAT = FEAT_ARMOR_PROFICIENCY_LIGHT; break;
		case ARMOR_RANK_MEDIUM: nFEAT = FEAT_ARMOR_PROFICIENCY_MEDIUM; break;
		case ARMOR_RANK_HEAVY: nFEAT = FEAT_ARMOR_PROFICIENCY_HEAVY; break;
		default: return FALSE;
	}
	if (GetHasFeat(nFEAT, oPC, TRUE) == TRUE) return FALSE;
	AssignCommand(oPC, ClearAllActions(TRUE));
	AssignCommand(oPC, ActionUnequipItem(oARMOR));
	return TRUE;
}

// Check for giant weapons and monkey grip abuse
int MonkeyGripAbuse(object oPC, object oITEM, int nITEM)
{
	if (nITEM < 150) return FALSE;
	if (nITEM > 152) return FALSE;
	if (GetCreatureSize(oPC) >= CREATURE_SIZE_LARGE) return FALSE;
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ActionUnequipItem(oITEM));
	SendMessageToPC(oPC, "<c=red>Your character is too small to wield giant weapons, yes, even with monkey grip, the size/weight mechanics are simply too much for you.");
	return TRUE;
}

// once per day any temp properties stuck on the item will be cleared. Basically first time it is equipped between resets.
// might fire again if player has relogged as object ID can change, but at least won't fire every time.
void CheckForTempProperties(object oItem, object oPC)
{
	string sID = ObjectToString(oItem);
	if (GetLocalInt(oPC, sID) == TRUE) return;
	itemproperty ipProp = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ipProp))
	{
		if (GetItemPropertyDurationType(ipProp) == DURATION_TYPE_TEMPORARY) RemoveItemProperty(oItem, ipProp);
		ipProp = GetNextItemProperty(oItem);
	}
	SetLocalInt(oPC, sID, TRUE);
}

// Check No Manual Dexterity. With it you can only equip creature weapons.
int CheckManualDexterity(object oPC, object oITEM, int nITEM)
{
	if (GetIsCreatureWeapon(nITEM) == TRUE) return FALSE;
	
	switch (nITEM)
	{
		case BASE_ITEM_AMULET:
		case BASE_ITEM_ARROW:
		case BASE_ITEM_BELT:
		case BASE_ITEM_BOLT:
		case BASE_ITEM_BOOTS:
		case BASE_ITEM_BRACER:
		case BASE_ITEM_BULLET:
		case BASE_ITEM_CLOAK:
		case BASE_ITEM_GLOVES:
		case BASE_ITEM_HELMET:
		case BASE_ITEM_RING:
		case BASE_ITEM_ARMOR:
			return FALSE;
	}
	
	if (GetHasFeat(2340, oPC, TRUE) == FALSE) return FALSE;
	
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ActionUnequipItem(oITEM));
	SendMessageToPC(oPC, "<c=red>Your character cannot wield weapons, shields, or any other object in their hands due to the No Manual Dexterity feat");
	return TRUE;	
}

// No Weapons and Shields for Dragons in Natural Form and no Armor in both forms (exept clothes)
// Creature weapons are 160-177. Others are not allowed unless "in humanoid form (=1)".
int CheckDragonForms(object oPC, object oITEM, int nITEM)
{
	switch (nITEM)
	{
		case BASE_ITEM_AMULET:
		case BASE_ITEM_ARROW:
		case BASE_ITEM_BELT:
		case BASE_ITEM_BOLT:
		case BASE_ITEM_BOOTS:
		case BASE_ITEM_BRACER:
		case BASE_ITEM_BULLET:
		case BASE_ITEM_CLOAK:
		case BASE_ITEM_GLOVES:
		case BASE_ITEM_HELMET:
		case BASE_ITEM_RING:
			return FALSE;
	}
	
	if (GetHasFeat(3623, oPC, TRUE) == FALSE) return FALSE;
	
	if (GetArmorRank(oITEM) != ARMOR_RANK_NONE)
	{
		SendMessageToPC(oPC, "<c=red>Your character's scales provide a better protection then any armor could. You may only wear clothes.");
		AssignCommand(oPC, ClearAllActions(TRUE));
		AssignCommand(oPC, ActionUnequipItem(oITEM));	
		return TRUE;
	}
	
	object oESSENCE = GetItemPossessedBy(oPC, "ps_essence");
	if (GetLocalInt(oESSENCE, "TempChange") == 1)
	{
		if (GetIsCreatureWeapon(nITEM) == TRUE)
		{
			SendMessageToPC(oPC, "<c=red>Your character does not have claws or a bite in humanoid form.");
			AssignCommand(oPC, ClearAllActions());
			AssignCommand(oPC, ActionUnequipItem(oITEM));
			return TRUE;
		}
	}
	else if (GetIsCreatureWeapon(nITEM) == FALSE)
	{
		SendMessageToPC(oPC, "<c=red>Your character cannot wield weapons or shields in natural form.");
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, ActionUnequipItem(oITEM));
		return TRUE;
	}
	
	return FALSE;
}

// Marquis Cambion Silent Metal
void SilentMetal(object oPC, object oARMOR, object oSHIELD, int nSHIELD, string s2DA = "armorrulestats", string sCOLUMN = "ACCHECK")
{
	if (GetHasFeat(FEAT_MARQCAMB_SILENT_METAL, oPC, TRUE) == FALSE) return;
	int nCACHE = GetNum2DARows(s2DA); //Faster if cached.
	int nRULES;
	int nACCHECK;
	int nPENALTY;
	
	if (GetArmorRank(oARMOR) != ARMOR_RANK_NONE)
	{
		nRULES = GetArmorRulesType(oARMOR);
		nACCHECK = Get2DAInt(s2DA, sCOLUMN, nRULES);
		if (nACCHECK != 0) nPENALTY = abs(nACCHECK);
	}
	
	if (nSHIELD == BASE_ITEM_SMALLSHIELD || nSHIELD == BASE_ITEM_LARGESHIELD || nSHIELD == BASE_ITEM_TOWERSHIELD)
	{
		nRULES = GetArmorRulesType(oSHIELD);
		nACCHECK = Get2DAInt(s2DA, sCOLUMN, nRULES);
		if (nACCHECK != 0) nPENALTY = nPENALTY + abs(nACCHECK);
	}
	
	if (nPENALTY < 1) return;
	effect eFX = EffectSkillIncrease(SKILL_HIDE, nPENALTY);
	eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nPENALTY));
	ApplyEquipmentEffect(oPC, eFX);
}

// Heavy Armor Optimization Feats
void HeavyArmorOptimizations(object oPC, object oARMOR)
{
	if (GetArmorRank(oARMOR) != ARMOR_RANK_HEAVY) return;
	int nAC;
	int nSKILL;
	if (GetHasFeat(FEAT_HEAVY_ARMOR_OPTIMIZATION_EPIC, oPC, TRUE) == TRUE)
	{
		nAC = 4;
		nSKILL = 5;
	}
	else if (GetHasFeat(FEAT_HEAVY_ARMOR_OPTIMIZATION_GREATER, oPC, TRUE) == TRUE)
	{
		nAC = 2;
		nSKILL = 3;
	}
	else if (GetHasFeat(FEAT_HEAVY_ARMOR_OPTIMIZATION, oPC, TRUE) == TRUE)
	{
		nAC = 1;
		nSKILL = 1;
	}
	else return;
	
	effect eFX = EffectACIncrease(nAC);
	eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_PARRY, nSKILL));
	eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_SET_TRAP, nSKILL));
	eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_TUMBLE, nSKILL));
	if (GetHasFeat(FEAT_MARQCAMB_SILENT_METAL, oPC, TRUE) == FALSE)
	{
		eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_HIDE, nSKILL));
		eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nSKILL));
	}
	ApplyEquipmentEffect(oPC, eFX);
}

// Check if the weapon is finessable. Custom finessables from 160 to 174 and 202.
int GetIsSpecialFinessable(int nTYPE)
{
	if (GetIsCreatureWeapon(nTYPE) == TRUE) return TRUE;
	switch (nTYPE)
	{
		case 202:
		case BASE_ITEM_WHIP:
		case BASE_ITEM_CSLASHWEAPON:
		case BASE_ITEM_CPIERCWEAPON:
		case BASE_ITEM_CBLUDGWEAPON:
		case BASE_ITEM_CSLSHPRCWEAP:
			return TRUE;
	}
	return FALSE;
}

// Weapon Finesse for custom or creature weapons
//void SpecialWeaponFinesse(object oPC, int nWeaponHand)
//{
//if (GetIsSpecialFinessable(nWeaponHand) == TRUE)
  //  {
      //  switch (nWeaponHand)
	//	{
		//	case BASE_ITEM_TORCH:
	//		case BASE_ITEM_SMALLSHIELD:
	//		case BASE_ITEM_LARGESHIELD:
		//	case BASE_ITEM_TOWERSHIELD:
		//	case BASE_ITEM_INVALID:
		//		break;
		//	default:
	//			return;
	//	}
//	}
	
//	if (GetHasFeat(FEAT_WEAPON_FINESSE, oPC, TRUE) == FALSE)
//	{
//		if (GetSubRace(oPC) != 243) return;
//	}
//if (GetIsSpecialFinessable(nWeaponHand) && GetHasFeat(FEAT_WEAPON_FINESSE, oPC, TRUE) == FALSE)
	//	{ switch (nWeaponHand)
	//	{	case BASE_ITEM_TORCH:
	//		case BASE_ITEM_SMALLSHIELD:
	//		case BASE_ITEM_LARGESHIELD:
	//		case BASE_ITEM_TOWERSHIELD:
	//		case BASE_ITEM_INVALID:
	//			break;
	//		default:
	//			return;
	//			}
	//			}
//{
	
//	int nSTR = GetAbilityModifier(ABILITY_STRENGTH, oPC);
//	int nDEX = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
//	int nDIFF = nDEX - nSTR;
//	if (nDIFF < 1) return;
//	effect eFX = EffectAttackIncrease(nDIFF);
//	ApplyEquipmentEffect(oPC, eFX);
//	}
//	return;
	
//}

//New and Improved Custom Finesse
void ED_ApplyEnhancementToFinesse(object oPC, object oItem, int iDiff)
{
	if( GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS))
	{	int iAttBonus 		= IPGetWeaponAttackBonus(oItem, ITEM_PROPERTY_ATTACK_BONUS);
		iAttBonus			= iAttBonus + iDiff;
		itemproperty ipAB	= ItemPropertyAttackBonus(iAttBonus);
		IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ATTACK_BONUS, DURATION_TYPE_TEMPORARY);
		IPSafeAddItemProperty(oItem, ipAB, HoursToSeconds(36), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
		SendMessageToPC(oPC, "Attack bonus of +" + IntToString(iAttBonus) + " applied to stack with attack bonus");	}
	
	if(	GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP))
	{	int iAttBonusA		= IPGetWeaponAttackBonus(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP);
		int iSubtypeA		= IPGetWeaponAttackBonusSubtype(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP);
		iAttBonusA			= iAttBonusA + iDiff;
		itemproperty ipABA	= ItemPropertyAttackBonusVsAlign(iSubtypeA, iAttBonusA);
		IPSafeAddItemProperty(oItem, ipABA, HoursToSeconds(36), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
		SendMessageToPC(oPC, "Attack bonus of +" + IntToString(iAttBonusA) + " vs. alignment group applied to stack with attack bonus vs. alignment group");	}

	if( GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP))
	{	int iAttBonusR 		= IPGetWeaponAttackBonus(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP);
		int iSubtypeR		= IPGetWeaponAttackBonusSubtype(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP);
		iAttBonusR			= iAttBonusR + iDiff;
		itemproperty ipABR	= ItemPropertyAttackBonusVsRace(iSubtypeR, iAttBonusR);
		IPSafeAddItemProperty(oItem, ipABR, HoursToSeconds(36), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
		SendMessageToPC(oPC, "Attack bonus of +" + IntToString(iAttBonusR) + " vs. racial type applied to stack with attack bonus vs. racial group");	}

	if(	GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT))
	{	int iAttBonusS		= IPGetWeaponAttackBonus(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT);
		int iSubtypeS		= IPGetWeaponAttackBonusSubtype(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT);
		iAttBonusS			= iAttBonusS + iDiff;
		itemproperty ipABS	= ItemPropertyAttackBonusVsSAlign(iSubtypeS, iAttBonusS);
		IPSafeAddItemProperty(oItem, ipABS, HoursToSeconds(36), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
		SendMessageToPC(oPC, "Attack bonus of +" + IntToString(iAttBonusS) + " vs. specific alignment applied to stack with attack bonus vs. specific alignment");	}
		
	if( GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS))
	{	int iEnhBonus 		= IPGetWeaponEnhancementBonus(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS);
		iEnhBonus			= iEnhBonus + iDiff;
		itemproperty ipEB	= ItemPropertyAttackBonus(iEnhBonus);
		IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ATTACK_BONUS, DURATION_TYPE_TEMPORARY);
		IPSafeAddItemProperty(oItem, ipEB, HoursToSeconds(36), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
		SendMessageToPC(oPC, "Attack bonus of +" + IntToString(iEnhBonus) + " applied to stack with enhancement bonus");  }
	
	if(	GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP))
	{	int iEnhBonusA		= IPGetWeaponEnhancementBonus(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP);
		int iESubtypeA		= IPGetWeaponEnhancementBonusSubtype(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP);
		iEnhBonusA			= iEnhBonusA + iDiff;
		itemproperty ipEBA	= ItemPropertyAttackBonusVsAlign(iESubtypeA, iEnhBonusA);
		IPSafeAddItemProperty(oItem, ipEBA, HoursToSeconds(36), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
		SendMessageToPC(oPC, "Attack bonus of +" + IntToString(iEnhBonusA) + " vs. alignment group applied to stack with enhancement bonus vs. alignment group");	}

	if( GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP))
	{	int iEnhBonusR 		= IPGetWeaponEnhancementBonus(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP);
		int iESubtypeR		= IPGetWeaponEnhancementBonusSubtype(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP);
		iEnhBonusR			= iEnhBonusR + iDiff;
		itemproperty ipEBR	= ItemPropertyAttackBonusVsRace(iESubtypeR, iEnhBonusR);
		IPSafeAddItemProperty(oItem, ipEBR, HoursToSeconds(36), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
		SendMessageToPC(oPC, "Attack bonus of +" + IntToString(iEnhBonusR) + " vs. racial type applied to stack with enhancement bonus vs. racial group");	}

	if(	GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT))
	{	int iEnhBonusS		= IPGetWeaponEnhancementBonus(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT);
		int iESubtypeS		= IPGetWeaponEnhancementBonusSubtype(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT);
		iEnhBonusS			= iEnhBonusS + iDiff;
		itemproperty ipEBS	= ItemPropertyAttackBonusVsSAlign(iESubtypeS, iEnhBonusS);
		IPSafeAddItemProperty(oItem, ipEBS, HoursToSeconds(36), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
		SendMessageToPC(oPC, "Attack bonus of +" + IntToString(iEnhBonusS) + " vs. specific alignment applied to stack with enhancement bonus vs. specific alignment");	}
}
//This applies the Custom Finesse!
void ED_ApplySpecialWeaponFinesse(object oPC, object oItem)
{
	int iStrScore		= GetAbilityScore(oPC, ABILITY_STRENGTH, FALSE);
	SendMessageToPC(oPC, "STR score: " + IntToString(iStrScore));
	int iStrMod			= FloatToInt((IntToFloat(iStrScore) / 2) - 5);
	SendMessageToPC(oPC, "STR modifier: " + IntToString(iStrMod));
	int iDexScore		= GetAbilityScore(oPC, ABILITY_DEXTERITY, FALSE);
	SendMessageToPC(oPC, "DEX bonus: " + IntToString(iDexScore));
	int iDexMod			= FloatToInt((IntToFloat(iDexScore) / 2) - 5);
	SendMessageToPC(oPC, "DEX modifier: " + IntToString(iDexMod));
	int iDiff			= (iDexMod - iStrMod);
	SendMessageToPC(oPC, "Difference in modifiers: " + IntToString(iDiff));
	if(iDiff <= 0)
	{	iDiff = 0;	}
	object oSlotR		= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	SendMessageToPC(oPC, "Item in right hand: " + GetName(oSlotR));
	object oSlotL		= GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	SendMessageToPC(oPC, "Item in left hand: " + GetName(oSlotL));
	int iHand;
	
	if(oItem == oSlotR || oItem == oSlotL)
	{	if(oItem == oSlotR && iDiff > 0)
		{	ED_ApplyEnhancementToFinesse(oPC, oItem, iDiff);
			itemproperty ipBoostR = ItemPropertyAttackBonus(iDiff);
			IPSafeAddItemProperty(oItem, ipBoostR, HoursToSeconds(36),X2_IP_ADDPROP_POLICY_REPLACE_EXISTING  ,FALSE, FALSE);
			SetLocalInt(oItem, "S_Finesse", iDiff);
			SendMessageToPC(oPC, "Weapon finesse applied.");	}
		else if(oItem == oSlotL && iDiff > 0)
		{	ED_ApplyEnhancementToFinesse(oPC, oItem, iDiff);
			itemproperty ipBoostL = ItemPropertyAttackBonus(iDiff);
			SendMessageToPC(oPC, "Bonus of +" + IntToString(iDiff) + " applied to weapon in hand: " + IntToString(iHand));
			IPSafeAddItemProperty(oItem, ipBoostL, HoursToSeconds(36),X2_IP_ADDPROP_POLICY_REPLACE_EXISTING  ,FALSE, FALSE);	}
			SetLocalInt(oItem, "S_Finesse", iDiff);
			SendMessageToPC(oPC, "Weapon finesse applied."); }	
}

//This gets the list of Finessable weapons!
int ED_GetIsFinessable(object oItem)
{
	int iBaseItem		= GetBaseItemType(oItem);
	object oPC			= GetItemPossessor(oItem);
	int iFinesse;
	if(	iBaseItem == BASE_ITEM_CREQ_SLASH_L				|| iBaseItem == BASE_ITEM_CREQ_BLUDGEON_L 			|| 
		iBaseItem == BASE_ITEM_CREQ_PIERCE_L			|| iBaseItem == BASE_ITEM_CREQ_SLASH_M				||
		iBaseItem == BASE_ITEM_CREQ_BLUDGEON_M	 		|| iBaseItem == BASE_ITEM_CREQ_PIERCE_M				||
		iBaseItem == BASE_ITEM_CREQ_SLASH_S				|| iBaseItem == BASE_ITEM_CREQ_BLUDGEON_S			||
		iBaseItem == BASE_ITEM_CREQ_PIERCE_S			|| iBaseItem == BASE_ITEM_CREQ_PIERCE_BLUDGEON_L	||
		iBaseItem == BASE_ITEM_CREQ_PIERCE_BLUDGEON_M	|| iBaseItem == BASE_ITEM_CREQ_PIERCE_BLUDGEON_S	||
		iBaseItem == BASE_ITEM_CREQ_PIERCE_SLASH_L		|| iBaseItem == BASE_ITEM_CREQ_PIERCE_SLASH_M		|| 
		iBaseItem == BASE_ITEM_CREQ_PIERCE_SLASH_S		|| iBaseItem == BASE_ITEM_WHIP_SCOD					||
		iBaseItem == BASE_ITEM_WHIP						|| iBaseItem == BASE_ITEM_CSLASHWEAPON				||
		iBaseItem == BASE_ITEM_CPIERCWEAPON				|| iBaseItem == BASE_ITEM_CBLUDGWEAPON				||
		iBaseItem == BASE_ITEM_CSLSHPRCWEAP)
	{	iFinesse = TRUE;
		SendMessageToPC(oPC, "This weapon qualifies for Weapon Finesse.");	}
	return iFinesse;
}




// Unearthly grace feat for Nymphs. CHA bonus to Saves and Dodge AC.
void UnearthlyGrace(object oPC, object oCHEST)
{
	if (GetHasFeat(2367, oPC, TRUE) == FALSE) return;
	if (GetArmorRank(oCHEST) > ARMOR_RANK_LIGHT) return;
	int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	if (nCHA < 1) return;
	effect eFX = EffectSavingThrowIncrease(SAVING_THROW_ALL, nCHA);
	eFX = EffectLinkEffects(eFX, EffectACIncrease(nCHA, AC_DEFLECTION_BONUS));
	ApplyEquipmentEffect(oPC, eFX);
}

//Fixes the Spell Resistance bug from items.
void SpellResistFix(object oPC, string s2DA = "iprp_srcost", string sCOLUMN = "Value")
{
	object oITEM;
	int nEQUIP;
	int nSR;
	int nMAX;
	int nTYPE;
	int nTABLE;
	int nCACHE = GetNum2DARows(s2DA);
	itemproperty iPROP;
	while (nEQUIP < 18)
	{
		oITEM = GetItemInSlot(nEQUIP, oPC);
		if (GetItemHasItemProperty(oITEM, ITEM_PROPERTY_SPELL_RESISTANCE) == TRUE)
		{
			iPROP = GetFirstItemProperty(oITEM);
			while (GetIsItemPropertyValid(iPROP))
			{
				nTYPE = GetItemPropertyType(iPROP);
				if (nTYPE == ITEM_PROPERTY_SPELL_RESISTANCE)
				{
					nTABLE = GetItemPropertyCostTableValue(iPROP);
					nSR = Get2DAInt(s2DA, sCOLUMN, nTABLE);
					if (nSR > nMAX)	nMAX = nSR;
				}
				iPROP = GetNextItemProperty(oITEM);
			}
		}
		nEQUIP = nEQUIP + 1;
	}
	if (nMAX < 1) return;
	effect eFX = EffectSpellResistanceIncrease(nMAX);
	ApplyEquipmentEffect(oPC, eFX);
}

//Shields provide concealment against ranged attacks.
void ShieldRangedConceal(object oPC, int nSHIELD)
{
	int nCONCEAL;
	switch (nSHIELD)
	{
		case BASE_ITEM_SMALLSHIELD: nCONCEAL = 10; break;
		case BASE_ITEM_LARGESHIELD: nCONCEAL = 30; break;
		case BASE_ITEM_TOWERSHIELD: nCONCEAL = 60; break;
		default: return;
	}
	effect eFX = EffectConcealment(nCONCEAL, MISS_CHANCE_TYPE_VS_RANGED);
	ApplyEquipmentEffect(oPC, eFX);
}

//Sacred fists get a -8AB penalty if they are wielding non-creature weapons.
void SacredFirstPenalty(object oPC, int nRIGHT, int nLEFT)
{
	if (GetHasFeat(2852, oPC, TRUE) == FALSE) return;
	int nRETURN = 0;
	if (nRIGHT == BASE_ITEM_INVALID) nRETURN = 1;
	else if (GetIsCreatureWeapon(nRIGHT) == TRUE) nRETURN = 1;
	if (nLEFT == BASE_ITEM_INVALID) nRETURN = nRETURN + 1;
	else if (GetIsCreatureWeapon(nLEFT) == TRUE) nRETURN = nRETURN + 1;
	if (nRETURN > 1) return;
	effect eFX = EffectAttackDecrease(8);
	ApplyEquipmentEffect(oPC, eFX);
}

//Samurais get AB and damage bonus when they dual wield katana/longsword in main hand and shortsword in off hand.
void TwoSwordsAsOne(object oPC, int nRIGHT, int nLEFT)
{
	int nSAMURAI = GetLevelByClass(65, oPC);
	if (nSAMURAI < 2) return;
	if ((nRIGHT != BASE_ITEM_KATANA) && (nRIGHT != BASE_ITEM_LONGSWORD)) return;
	if (nLEFT != BASE_ITEM_SHORTSWORD) return;
	int nBONUS = 1;
	int nDMG_TYPE = DAMAGE_TYPE_BLUDGEONING;
	if (nSAMURAI >= 30) nDMG_TYPE = DAMAGE_TYPE_DIVINE;
	if (nSAMURAI >= 26) nBONUS = 5;
	else if (nSAMURAI >= 21) nBONUS = 4;
	else if (nSAMURAI >= 16) nBONUS = 3;
	else if (nSAMURAI >= 11) nBONUS = 2;
	effect eFX = EffectAttackIncrease(nBONUS);
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(nBONUS, nDMG_TYPE));
	ApplyEquipmentEffect(oPC, eFX);
}

//When a Samurai draws their weapon (a katana or longsword) foes can be frightened by it.
void FrightfulPresence(object oPC)
{
	if (GetHasFeat(2419, oPC, TRUE) == FALSE) return;
	location lPC = GetLocation(oPC);
	int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	float fDUR = RoundsToSeconds(nCHA);
	int nDC = 20 + nCHA;
	int nHD;
	effect eFX_1 = EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_STUN));
	effect eFX_2 = EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_DUR_SPELL_FEAR));
	effect eFX_3 = EffectLinkEffects(EffectLinkEffects(EffectACDecrease(2), EffectAttackDecrease(2)), EffectVisualEffect(VFX_DUR_SPELL_DOOM));
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
	while (oTARGET != OBJECT_INVALID)
	{
		if (GetIsEnemy(oTARGET, oPC) == TRUE)
		{
			if (WillSave(oTARGET, nDC, SAVING_THROW_TYPE_FEAR, oPC) == SAVING_THROW_CHECK_FAILED)
			{
				nHD = GetHitDice(oTARGET);
				if (nHD >= 20) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_3, oTARGET, fDUR);
				else if (nHD >= 5) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_2, oTARGET, fDUR);
				else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_1, oTARGET, fDUR);	
			}
		}
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
	}
}

//At level 5, when the Samurai draws a longsword or katana (in right hand) they gain an attack bonus 
//equal to their charisma bonus for 1 round. They also gain 1 extra attack for that round as well. 
void IajaitsuMaster(object oPC, object oITEM, int nITEM)
{
	if ((nITEM != BASE_ITEM_KATANA) && (nITEM != BASE_ITEM_LONGSWORD)) return;
	if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND) != oITEM) return;
	if (GetHasFeat(2414, oPC, TRUE) == TRUE)
	{
		int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
		float fDUR = RoundsToSeconds(1);
		effect eFX = EffectModifyAttacks(1);
		if (nCHA > 0) eFX = EffectLinkEffects(eFX, EffectAttackIncrease(nCHA));
		eFX = ExtraordinaryEffect(eFX);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oPC, fDUR);
	}
	DelayCommand(0.0f, FrightfulPresence(oPC));
}

// Do bonus damage when unarmed or wielding a creature weapon (new creature weapons)
// need to check on-equip script and cancel these effects if a weapon is equipped.
// Not implemented yet (TatooedMonk)
void TatooedMonk(object oPC, int nRIGHT, int nLEFT)
{
	if (GetLevelByClass(998, oPC) < 1) return;
	
}

//Drunk Masters get bonuses with improvised weapons.
//Not implemented yet
void DrunkMasterImprovised(object oPC, int nRIGHT)
{
	int nDRUNK = GetLevelByClass(999, oPC);
	if (nDRUNK < 1) return;
	if (nRIGHT != BASE_ITEM_INVALID && nRIGHT != BASE_ITEM_CLUB && nRIGHT != 152) return;
	int nLEVEL = nDRUNK + GetLevelByClass(CLASS_TYPE_MONK, oPC);
	int nATTACKS = 2;
	if (nLEVEL < 11) nATTACKS = 1;
	
	int nDMG = DAMAGE_BONUS_1d8;
	int nAB = 1;
	int nAC = 1;
	
	if (GetHasFeat(12468, oPC, TRUE)) 
	{
		nDMG = DAMAGE_BONUS_2d12;
		nAB = 4;
		nAC = 7;
	}	
	else if (GetHasFeat(12467, oPC, TRUE))
	{
		nDMG = DAMAGE_BONUS_2d8;
		nAB = 3;
		nAC = 5;
	}
	else if (GetHasFeat(12466, oPC, TRUE))
	{
		nDMG = DAMAGE_BONUS_1d12;
		nAB = 2;
		nAC = 3;
	}
	
	effect eFX = EffectModifyAttacks(nATTACKS);
	eFX = EffectLinkEffects(eFX, EffectAttackIncrease(nAB));
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(nDMG));
	eFX = EffectLinkEffects(eFX, EffectACIncrease(nAC, AC_DEFLECTION_BONUS));
	ApplyEquipmentEffect(oPC, eFX);
}






//Con Drain Protection in OOC rooms.
void ConDrainProtection(object oItem, object oPC)
{	
	string sArea = GetTag(GetArea(oPC));
	if (sArea == "appearance_changer_room" || sArea == "ps_area_clerks-festhallchanging")
	{	
		if (IPGetItemHasItemAbilityBonusPropertySubType(oItem, ABILITY_CONSTITUTION)) ForceRest(oPC);
	}	
}

//When all is said and done, the various custom effects dependant on equipment are applied.
void EquipmentEffects(object oPC)
{
	object oCHEST = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	if (FixARMOR(oPC, oCHEST) == TRUE) return;
	
	object oLHAND = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	int nLEFT = GetBaseItemType(oLHAND);
	if (FixSHIELD(oPC, oLHAND, nLEFT) == TRUE) return;
	
	object oRHAND = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRIGHT = GetBaseItemType(oRHAND);	
	SpellResistFix(oPC);
	ShieldRangedConceal(oPC, nLEFT);
	SilentMetal(oPC, oCHEST, oLHAND, nLEFT);
	HeavyArmorOptimizations(oPC, oCHEST);
	UnearthlyGrace(oPC, oCHEST);
	SacredFirstPenalty(oPC, nRIGHT, nLEFT);
	TwoSwordsAsOne(oPC, nRIGHT, nLEFT);
	//TatooedMonk(oPC, nRIGHT, nLEFT);
	//DrunkMasterImprovised(oPC, nRIGHT, nLEFT);
}

//This starts all the various checks and effects to be applied based on equipment, as per Sigil's custom rules.
//nEQUIP: TRUE when called from OnEqup and FALSE when called from OnUnequip.
//Found in "ps_inc_equipment.nss".
void SigilEquipment(object oPC, object oITEM, int nEQUIP)
{
	RemoveEffectsFromSpell(oPC, SIGIL_EQUIP_FX);
	int nITEM = GetBaseItemType(oITEM);
	if (nEQUIP == TRUE)
	{
		CheckForTempProperties(oITEM, oPC);
	
		if (GetMonkWeapon(oITEM)) ApplyMeditativeStrikes(oPC,oITEM);
		
			if (ED_GetIsFinessable(oITEM)  && GetHasFeat(FEAT_WEAPON_FINESSE, oPC))
			 ED_ApplySpecialWeaponFinesse(oPC, oITEM);
			 
			if (!GetExistingFinesse(oITEM)&&  GetSubRace(oPC) == 243) 
			ED_ApplySpecialWeaponFinesse(oPC, oITEM);


		
		if (nITEM == BASE_ITEM_GLOVES) SetGlovesOnHitProperty(oPC);
		
	
		{
			if (MonkeyGripAbuse(oPC, oITEM, nITEM) == TRUE) return;
			if (CheckManualDexterity(oPC, oITEM, nITEM) == TRUE) return;
			if (CheckDragonForms(oPC, oITEM, nITEM) == TRUE) return; 
			IajaitsuMaster(oPC, oITEM, nITEM);
		}
	}
	else
	{
		ConDrainProtection(oITEM, oPC);
		if (nITEM == BASE_ITEM_GLOVES) RemoveTempOnHitProperty(oITEM);
	}
	DelayCommand(0.1f, EquipmentEffects(oPC));
}