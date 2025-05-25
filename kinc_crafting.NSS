

//kinc_crafting
//Crafting include w/ Trade system excised.
//NLC 10/28/08
#include "ginc_debug"
#include "ginc_param_const"
#include "ginc_2da"
#include "ginc_crafting"
#include "kinc_trade_constants"

//Utility Functions
void DestroyItems(object oTarget,string sItem,int nNumItems, int bFeedback = TRUE);

//Crafting Function Prototypes
int CheckCanCraft(int nIndex, object oPC, string sTable);
int CheckCanEnchant(int nIndex, object oItem, object oPC, string sTable);
int CheckLocalInts(int nIndex, object oPC, string sTable);
int CheckGoldCost(int nIndex, object oPC, string sTable);
int CheckItemReagents(int nIndex, object oPC, string sTable);
int CheckCraftingSpellUses(int nIndex, object oPC, string sTable);
int CheckItemPrereqs(int nIndex, object oPC, string sTable);
int CheckSkillPrereqs(int nIndex, object oPC, string sTable);
int CheckPlaceablePrereq(int nIndex, object oPC, string sTable);
int CheckFeatPrereqs(int nIndex, object oPC, string sTable);
int CheckEnchantingTargetValid(int nIndex, object oItem, object oPC, string sTable);
int CheckEnchantmentNumber(int nIndex, object oItem, object oPC, string sTable);
int CheckHasEnoughCasterLevels(int nIndex, object oPC, string sTable);

void CraftItem(int nIndex, object oPC, string sTable);
void EnchantItem(int nIndex, object oItem, object oPC, string sTable);
void DeductGoldCost(int nIndex, object oPC, string sTable);
void ConsumeItemReagents(int nIndex, object oPC, string sTable);
void ConsumeCraftingSpellUse(int nIndex, object oPC, string sTable);
void CreateCraftedItem(int nIndex, object oPC, string sTable);
void EnchantTargetItem(int nIndex, object oItem, string sTable, object oPC);


void DoCraftingFailureFeedback(int nCraftingFailure, object oPC, string sExtraFeedback = "");
/*----------------------------------\
|	Crafting Function Definitions	|
\----------------------------------*/
int CheckCanCraft(int nIndex, object oPC, string sTable)
{
	if (nIndex < 1)
	{
		PrettyDebug("Invalid Recipe Index!");
		return FALSE;
	}
	
	if( CheckLocalInts(nIndex, oPC, sTable)			&&
		CheckGoldCost(nIndex, oPC, sTable)			&&
		CheckItemReagents(nIndex, oPC, sTable)		&&
		CheckCraftingSpellUses(nIndex, oPC, sTable)	&&
		CheckFeatPrereqs(nIndex, oPC, sTable)		&&
		CheckItemPrereqs(nIndex, oPC, sTable)		&&
		CheckSkillPrereqs(nIndex, oPC, sTable)		&&
		CheckPlaceablePrereq(nIndex, oPC, sTable)		)
	{
		return TRUE;
	}
	
	else
		return FALSE;
}

int CheckCanEnchant(int nIndex, object oItem, object oPC, string sTable)
{
	if (nIndex < 1)
	{
		PrettyDebug("Invalid Recipe Index!");
		return FALSE;
	}
	
	if( CheckLocalInts(nIndex, oPC, sTable)						&&
		CheckGoldCost(nIndex, oPC, sTable)						&&
		CheckItemReagents(nIndex, oPC, sTable)					&&
		CheckCraftingSpellUses(nIndex, oPC, sTable)				&&
		CheckFeatPrereqs(nIndex, oPC, sTable)					&&
		CheckItemPrereqs(nIndex, oPC, sTable)					&&
		CheckSkillPrereqs(nIndex, oPC, sTable)					&&
		CheckEnchantingTargetValid(nIndex, oItem, oPC, sTable)	&&
		CheckEnchantmentNumber(nIndex, oItem, oPC, sTable)		&&
		CheckHasEnoughCasterLevels(nIndex, oPC, sTable)			&&
		CheckPlaceablePrereq(nIndex, oPC, sTable)	)
	{
		return TRUE;
	}
	
	else
		return FALSE;
}

int CheckLocalInts(int nIndex, object oPC, string sTable)
{
	string sInts = Get2DAString(sTable, "RECIPE_TAG", nIndex);
	string sParam = GetStringParam(sInts, 0);
	int i=0;
	
	while(sParam != "")
	{
		if( GetLocalInt(oPC, sParam) != TRUE )		//We want to iterate through the list of local ints and verify that they are all
		{
			DoCraftingFailureFeedback(CRAFTING_FAILURE_RECIPE, oPC);
			return FALSE;							//TRUE on the PC who is attempting to craft the item.
		}
		i++;
		sParam = GetStringParam(sInts, i);
	}
	
	PrettyDebug("CheckLocalInts returning TRUE");
	return TRUE;									//If we've made it through the loop without returning FALSE, return TRUE.
}

int CheckGoldCost(int nIndex, object oPC, string sTable)
{
	int nGoldCost = Get2DAInt(sTable, "COST_GOLD", nIndex);
	
	/*if ( GetHasFeat(1430,oPC )
	{
		nGoldcost
	}*/
	
	if ( GetGold(oPC) >= nGoldCost )
	{
	
		return TRUE;
	}	
	else
	{
		string sGoldCost = IntToString(nGoldCost);
		DoCraftingFailureFeedback(CRAFTING_FAILURE_GOLD, oPC, sGoldCost);
		return FALSE;
	}
}

int CheckItemReagents(int nIndex, object oPC, string sTable)
{
	string sItems = Get2DAString(sTable, "COST_ITEMS", nIndex);
	string sParam = GetStringParam(sItems, 0);

	int i=0;
	
	while(sParam != "")
	{
		int nNum = StringToInt( GetStringParam(sItems, i+1) );			//The NEXT parameter we are setting equal to the number to create - if it's a valid int.
		
		if ( nNum != 0 )												//if nNum is a valid int, we are going to use it as an iterator.
		{
			if(GetNumItems(oPC, sParam) < nNum)							//If the player has fewer than nNum of the required item,
			{
				object oTempItem = CreateItemOnObject(sParam, oPC, 1, "", FALSE);
				string sItemName = GetName(oTempItem);
				DoCraftingFailureFeedback(CRAFTING_FAILURE_ITEM, oPC, sItemName);
				DestroyItems(oPC, sParam, 1, FALSE);
				return FALSE;											//return FALSE.
			}
				
			i += 2;														//We want to increment i by 2 in this case to skip nNum on the next iteration.
		}
		
		else
		{
			if(GetNumItems(oPC, sParam) < 1)							//If the player has fewer than 1 of the required item,
			{
				object oTempItem = CreateItemOnObject(sParam, oPC, 1, "", FALSE);
				string sItemName = GetName(oTempItem);
				DoCraftingFailureFeedback(CRAFTING_FAILURE_ITEM, oPC, sItemName);
				DestroyItems(oPC, sParam, 1, FALSE);
				return FALSE;											//return FALSE.
			}
			
			i++;
		}
		sParam = GetStringParam(sItems, i);
	}
	
	PrettyDebug("CheckItemReagents returning TRUE");
	return TRUE;									//If we've made it through the loop without returning FALSE, return TRUE.
}

int CheckCraftingSpellUses(int nIndex, object oPC, string sTable)
{
	string sSpellIds = Get2DAString(sTable, "COST_SPELLS", nIndex);
	string sParam = GetStringParam(sSpellIds, 0);
	int i=0;

	while(sParam != "")
	{
		int nSpellId = StringToInt(sParam);
		int bSpellValid = FALSE;							//Initialise the spell test to FALSE
		if(GetHasSpell(nSpellId, oPC))
			bSpellValid = TRUE;								//If I've got the spell, then we're golden.
		
		object oFM = GetFirstFactionMember(oPC, FALSE);
		while(GetIsObjectValid(oFM) && bSpellValid != TRUE)	//Otherwise, we iterate through the party until we find someone who has it (or have
		{													//iterated through the entire party).
			if(GetHasSpell(nSpellId, oFM))
				bSpellValid = TRUE;
				
			oFM = GetNextFactionMember(oPC, FALSE);
		}
		
		if (bSpellValid != TRUE)							//If we still haven't found someone who has this spell, we need to fail out at this point.
		{
			string sSpellName = GetStringByStrRef(Get2DAInt("spells", "Name", nSpellId));
			DoCraftingFailureFeedback(CRAFTING_FAILURE_SPELL, oPC, sSpellName);
			return FALSE;
		}
		++i;
		
		sParam = GetStringParam(sSpellIds, i);
	}
	PrettyDebug("CheckCraftingSpellUses returning TRUE");
	return TRUE;
}

int CheckItemPrereqs(int nIndex, object oPC, string sTable)
{
	string sItemTags = Get2DAString(sTable, "PREREQ_ITEMS", nIndex);
	string sParam = GetStringParam(sItemTags, 0);
	int i=0;
	
	while(sParam != "")
	{
		
		int bItemFound = FALSE;									//Initialise the spell test to FALSE
		if(GetIsObjectValid(GetItemPossessedBy(oPC, sParam)))
			bItemFound = TRUE;									//If I've got the item, then we're golden.
		
		object oFM = GetFirstFactionMember(oPC, FALSE);
		while(GetIsObjectValid(oFM) && bItemFound != TRUE)		//Otherwise, we iterate through the party until we find someone who has it (or have
		{														//iterated through the entire party).
			if(GetIsObjectValid(GetItemPossessedBy(oFM, sParam)))
				bItemFound = TRUE;
				
			oFM = GetNextFactionMember(oPC, FALSE);
		}

		if (bItemFound != TRUE)							//If we still haven't found someone who has this item, we need to fail out at this point.
		{
			DoCraftingFailureFeedback(CRAFTING_FAILURE_PREREQ_ITEM, oPC);
			return FALSE;
		}
				
		++i;

		sParam = GetStringParam(sItemTags, i);
	}
	PrettyDebug("CheckItemPrereqs returning TRUE");
	return TRUE;
}

int CheckFeatPrereqs(int nIndex, object oPC, string sTable)
{
	string sFeatPrereqs = Get2DAString(sTable, "PREREQ_FEATS", nIndex);
	string sParam = GetStringParam(sFeatPrereqs, 0);
	
	int i=0;
	while(sParam != "")
	{
		int bFeatFound = FALSE;
		int nFeatID = StringToInt(sParam);

		if(GetHasFeat(nFeatID, oPC, TRUE))
			bFeatFound = TRUE;
		
		object oFM = GetFirstFactionMember(oPC, FALSE);
		while(GetIsObjectValid(oFM) && bFeatFound != TRUE)
		{
			if(GetHasFeat(nFeatID, oFM, TRUE))
				bFeatFound = TRUE;
				
			oFM = GetNextFactionMember(oPC, FALSE);
		}

		if (bFeatFound != TRUE)							
		{
			string sFeatName = GetStringByStrRef(Get2DAInt("feat", "FEAT", nFeatID));
			DoCraftingFailureFeedback(CRAFTING_FAILURE_FEAT, oPC, sFeatName);
			return FALSE;
		}
				
		++i;

		sParam = GetStringParam(sFeatPrereqs, i);
	}
	PrettyDebug("CheckFeatPrereqs returning TRUE");	
	return TRUE;
}

int CheckSkillPrereqs(int nIndex, object oPC, string sTable)
{
	string sSkillPrereqs = Get2DAString(sTable, "PREREQ_SKILLRANKS", nIndex);
	string sParam = GetStringParam(sSkillPrereqs, 0);
	
	if(sParam == "")
		return TRUE;
	
	int i=0;
	while(sParam != "")
	{
		string sRank = GetStringParam(sSkillPrereqs, i + 1);	//Because the skills and ranks are stored in the format of SKILLID,RANK we need to get
																//the list element AFTER the skill to determine the rank.
																
		int bHasSkill = FALSE;
		int nSkill = StringToInt(sParam);
		int nRanks = StringToInt(sRank);
		
		if(PS_GetSkillRank(nSkill, oPC) >= nRanks )
		{
			bHasSkill = TRUE;
		}
		
		object oFM = GetFirstFactionMember(oPC, FALSE);
		while(GetIsObjectValid(oFM) && bHasSkill != TRUE)
		{
			if(PS_GetSkillRank(nSkill, oFM) >= nRanks )
				bHasSkill = TRUE;
				
			oFM = GetNextFactionMember(oPC, FALSE);
		}
		if(bHasSkill != TRUE)
		{
			string sSkillName = GetStringByStrRef(Get2DAInt("skills", "Name", nSkill));
			DoCraftingFailureFeedback(CRAFTING_FAILURE_SKILL, oPC, sSkillName);
			return FALSE;
		}
		i+=2;													//We iterate by 2 here, so that next time through the loop sParam is a skill ID, not a rank.									
		
		sParam = GetStringParam(sSkillPrereqs, i);
	}
	PrettyDebug("CheckSkillPrereqs returning TRUE");		
	return TRUE;
}

int CheckPlaceablePrereq(int nIndex, object oPC, string sTable)
{
	string sPlaceableToFind = Get2DAString(sTable, "PREREQ_PLACEABLE", nIndex);
	
	if(sPlaceableToFind == "")
		return TRUE;
	
	// SCoD specific hack to check for user placeables....
	string sOtherPlaceable;
	if (sTable == "PLC_MR_AWBench") sOtherPlaceable = "ps_usersign_alchtable";
	else if (sTable == "PLC_MR_WWBench") sOtherPlaceable = "ps_usersign_smithtable";
	else if (sTable == "nx2_mage_bench") sOtherPlaceable = "ps_usersign_magetable";
	
	object oBench = GetNearestObjectByTag(sPlaceableToFind, oPC);
	object oOther = GetNearestObjectByTag(sOtherPlaceable, oPC);
	
	if(GetIsObjectValid(oBench))
	{
		if(LineOfSightObject(oPC, oBench))
		{
			if(GetDistanceBetween(oPC, oBench) <= CRAFTING_PLC_SEARCH_DIST)
			{
				PrettyDebug("CheckPlaceablePrereq returning TRUE");
				return TRUE;
			}
		}
	}
	
	if(GetIsObjectValid(oOther))
	{
		if(LineOfSightObject(oPC, oOther))
		{
			if(GetDistanceBetween(oPC, oOther) <= CRAFTING_PLC_SEARCH_DIST)
			{
				PrettyDebug("CheckPlaceablePrereq returning TRUE");
				return TRUE;
			}
		}
	}

	DoCraftingFailureFeedback(CRAFTING_FAILURE_PLC, oPC);
	return FALSE;
}

int CheckEnchantingTargetValid(int nIndex, object oItem, object oPC, string sTable)
{
	string sEnchantmentEffect = Get2DAString(sTable, "EFFECT_STRING", nIndex);
	int nPropID = GetIntParam(sEnchantmentEffect, 0);
	int nBaseItemType = GetBaseItemType(oItem);

	string sLabel = Get2DAString(sTable, "LABEL", nIndex);
	
	if(nBaseItemType == 145 || nBaseItemType == 146 || 
		nBaseItemType == 127 || nBaseItemType == 130 ||
		nBaseItemType == 133 || nBaseItemType == 134 ||
		nBaseItemType == 135 || nBaseItemType == 136 ||
		nBaseItemType == 137 || nBaseItemType == 138 ||
		nBaseItemType == 139 || nBaseItemType == 143 ||
		nBaseItemType == 144 ||
		nBaseItemType == BASE_ITEM_ARROW || nBaseItemType == BASE_ITEM_BLANK_POTION ||
		nBaseItemType == BASE_ITEM_BLANK_SCROLL || nBaseItemType == BASE_ITEM_BLANK_WAND ||
		nBaseItemType == BASE_ITEM_BOLT || nBaseItemType == BASE_ITEM_BOOK ||
		nBaseItemType == BASE_ITEM_BULLET || nBaseItemType == BASE_ITEM_CPIERCWEAPON ||
		nBaseItemType == BASE_ITEM_CRAFTMATERIALMED || nBaseItemType == BASE_ITEM_CRAFTMATERIALSML ||
		nBaseItemType == BASE_ITEM_CREATUREITEM || nBaseItemType == BASE_ITEM_CSLASHWEAPON ||
		nBaseItemType == BASE_ITEM_CSLSHPRCWEAP || nBaseItemType == BASE_ITEM_DART ||
		nBaseItemType == BASE_ITEM_ENCHANTED_POTION || nBaseItemType == BASE_ITEM_ENCHANTED_SCROLL ||		
		nBaseItemType == BASE_ITEM_ENCHANTED_WAND || nBaseItemType == BASE_ITEM_GEM ||
		nBaseItemType == BASE_ITEM_GOLD || nBaseItemType == BASE_ITEM_HEALERSKIT ||
		nBaseItemType == BASE_ITEM_INVALID || nBaseItemType == BASE_ITEM_KEY ||		
		//nBaseItemType == BASE_ITEM_LARGEBOX || 
		nBaseItemType == BASE_ITEM_MAGICROD || 
		nBaseItemType == BASE_ITEM_MAGICWAND || nBaseItemType == BASE_ITEM_MISCLARGE ||
		nBaseItemType == BASE_ITEM_MISCMEDIUM || nBaseItemType == BASE_ITEM_MISCSMALL ||		
		nBaseItemType == BASE_ITEM_MISCTALL || nBaseItemType == BASE_ITEM_MISCTHIN ||
		nBaseItemType == BASE_ITEM_MISCWIDE || nBaseItemType == BASE_ITEM_POTIONS ||
		nBaseItemType == BASE_ITEM_SCROLL || nBaseItemType == BASE_ITEM_SHURIKEN ||		
		nBaseItemType == BASE_ITEM_THIEVESTOOLS || nBaseItemType == BASE_ITEM_THROWINGAXE ||
		nBaseItemType == BASE_ITEM_TORCH || nBaseItemType == BASE_ITEM_TRAPKIT)
	{
		DoCraftingFailureFeedback(CRAFTING_FAILURE_INV_IPRP, oPC);
		return FALSE;
	}	
	//SpeakString("before long check",TALKVOLUME_SHOUT); 			
	
	if(nBaseItemType == BASE_ITEM_AMULET && !TestStringAgainstPattern("Amulet**",sLabel) ||
		nBaseItemType == BASE_ITEM_ARMOR && !TestStringAgainstPattern("Armor**",sLabel) ||
		nBaseItemType == BASE_ITEM_BELT && !TestStringAgainstPattern("Belt**",sLabel) ||
		nBaseItemType == BASE_ITEM_BOOTS && !TestStringAgainstPattern("Boots**",sLabel) ||
		nBaseItemType == BASE_ITEM_BRACER && !TestStringAgainstPattern("Gloves**",sLabel) ||
		nBaseItemType == BASE_ITEM_GLOVES && !TestStringAgainstPattern("Gloves**",sLabel) ||
		nBaseItemType == BASE_ITEM_CLOAK && !TestStringAgainstPattern("Cloak**",sLabel) ||
		nBaseItemType == BASE_ITEM_HELMET && !TestStringAgainstPattern("Helm**",sLabel) ||
		nBaseItemType == BASE_ITEM_RING && !TestStringAgainstPattern("Ring**",sLabel) ||
		((nBaseItemType == BASE_ITEM_DRUM || nBaseItemType == BASE_ITEM_FLUTE || nBaseItemType == BASE_ITEM_MANDOLIN) && !TestStringAgainstPattern("Instrument**",sLabel)) ||
		nBaseItemType == BASE_ITEM_LARGESHIELD && !TestStringAgainstPattern("Armor**",sLabel) ||
		nBaseItemType == BASE_ITEM_SMALLSHIELD && !TestStringAgainstPattern("Armor**",sLabel) ||
		nBaseItemType == BASE_ITEM_TOWERSHIELD && !TestStringAgainstPattern("Armor**",sLabel) ||
		nBaseItemType == BASE_ITEM_BASTARDSWORD && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_BATTLEAXE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_CLUB && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_DAGGER && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_DIREMACE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_DOUBLEAXE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_DWARVENWARAXE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_GREATAXE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_GREATSWORD && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_HALBERD && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_HANDAXE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_HEAVYCROSSBOW && (!TestStringAgainstPattern("Weapon**",sLabel) && !TestStringAgainstPattern("Crossbow**",sLabel)) ||
		nBaseItemType == BASE_ITEM_HEAVYFLAIL && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_KAMA && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_KATANA && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_LIGHTCROSSBOW && (!TestStringAgainstPattern("Weapon**",sLabel) && !TestStringAgainstPattern("Crossbow**",sLabel)) ||
		nBaseItemType == BASE_ITEM_LIGHTFLAIL && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_LIGHTHAMMER && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_LIGHTMACE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_LONGBOW && (!TestStringAgainstPattern("Weapon**",sLabel) && !TestStringAgainstPattern("Bow**",sLabel)) ||
		nBaseItemType == BASE_ITEM_LONGSWORD && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_MAGICSTAFF && (!TestStringAgainstPattern("Weapon**",sLabel) && !TestStringAgainstPattern("Staff**",sLabel)) ||
		nBaseItemType == BASE_ITEM_MORNINGSTAR && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_QUARTERSTAFF && (!TestStringAgainstPattern("Weapon**",sLabel) && !TestStringAgainstPattern("Staff**",sLabel)) ||
		nBaseItemType == BASE_ITEM_RAPIER && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_SCIMITAR && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_SCYTHE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_SHORTBOW && (!TestStringAgainstPattern("Weapon**",sLabel) && !TestStringAgainstPattern("Bow**",sLabel)) ||
		nBaseItemType == BASE_ITEM_SHORTSPEAR && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_SHORTSWORD && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_SICKLE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_SLING && (!TestStringAgainstPattern("Weapon**",sLabel) && !TestStringAgainstPattern("Sling**",sLabel)) ||
		nBaseItemType == BASE_ITEM_TWOBLADEDSWORD && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_WARHAMMER && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_WHIP && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_KUKRI && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_FALCHION && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_WARMACE && !TestStringAgainstPattern("Weapon**",sLabel) ||
		nBaseItemType == BASE_ITEM_SPEAR && !TestStringAgainstPattern("Weapon**",sLabel) )
	//	!TestStringAgainstPattern("Light**",sLabel) ||
	//	!TestStringAgainstPattern("CastSpell**",sLabel) ||
{
		DoCraftingFailureFeedback(CRAFTING_FAILURE_INV_IPRP, oPC);
		return FALSE;
	}
	//SpeakString("after long check",TALKVOLUME_SHOUT); 			
	
		
	if (!GetIsLegalItemProp(nBaseItemType, nPropID))
	{
		DoCraftingFailureFeedback(CRAFTING_FAILURE_INV_IPRP, oPC);
		return FALSE;
	}
	else return TRUE;
}

int CheckEnchantmentNumber(int nIndex, object oItem, object oPC, string sTable)
{
	string sEnchantmentEffect = Get2DAString(sTable, "EFFECT_STRING", nIndex);
	// examine target - can more item props be placed?
	int nMaxPropCount = 3;
	int nMaxEnchantError = ERROR_TARGET_HAS_MAX_ENCHANTMENTS_NON_EPIC;
	int nItemPropCount = GetPropSlotsUsed(oItem); //GetNumberItemProperties(oItem);
	if (nItemPropCount >= nMaxPropCount)
	{
		// can't add stuff, but can still replace an old effect.
		if (!GetAreAllEncodedEffectsAnUpgrade(oItem, sEnchantmentEffect))
		{
			//output("FAILURE");
/*			if (iMaxPropCount == 4)
				nMaxEnchantError = ERROR_TARGET_HAS_MAX_ENCHANTMENTS;
				
			ErrorNotify(oPC, nMaxEnchantError); */
			DoCraftingFailureFeedback(CRAFTING_FAILURE_MAX_IPRP, oPC);
      		return FALSE;
		}
		
	}
	
	return TRUE;
}

int CheckHasEnoughCasterLevels(int nIndex, object oPC, string sTable)
{
	int nRequiredCasterLevel = Get2DAInt(sTable, "PREREQ_CASTER_LEVEL", nIndex);
	int bHasLevels;
	
	int nCasterLevel = GetHitDice(oPC);
	
	//SpeakString("casterlevel " + IntToString(nCasterLevel),TALKVOLUME_SHOUT);
	//SpeakString("needed " + IntToString(nRequiredCasterLevel),TALKVOLUME_SHOUT);

	if(nCasterLevel >= nRequiredCasterLevel)
	{
		bHasLevels = TRUE;
	}
	
	object oFM = GetFirstFactionMember(oPC, FALSE);
	while(bHasLevels != TRUE && GetIsObjectValid(oFM))
	{
		if(GetCasterLevel(oFM) >= nRequiredCasterLevel )
			bHasLevels = TRUE;
			
		oFM = GetNextFactionMember(oPC, FALSE);
	}
	
	if(bHasLevels != TRUE)
	{
		DoCraftingFailureFeedback(CRAFTING_FAILURE_CLVL, oPC);
		return FALSE;
	}	
	
	else return TRUE;
}

void CraftItem(int nIndex, object oPC, string sTable)
{
	DeductGoldCost(nIndex, oPC, sTable);
	ConsumeItemReagents(nIndex, oPC, sTable);
	ConsumeCraftingSpellUse(nIndex, oPC, sTable);
	
	CreateCraftedItem(nIndex, oPC, sTable);
}

void EnchantItem(int nIndex, object oItem, object oPC, string sTable)
{
	DeductGoldCost(nIndex, oPC, sTable);
	ConsumeItemReagents(nIndex, oPC, sTable);
	ConsumeCraftingSpellUse(nIndex, oPC, sTable);
	
	EnchantTargetItem(nIndex, oItem, sTable, oPC);
	SetEnchantedItemName(oPC, oItem);
}

void DeductGoldCost(int nIndex, object oPC, string sTable)
{
	int nGoldCost = Get2DAInt(sTable, "COST_GOLD", nIndex);
	PrettyDebug("Gold Cost=" + IntToString(nGoldCost));
	PrettyDebug(GetName(oPC));
	AssignCommand(oPC, TakeGoldFromCreature(nGoldCost, oPC, TRUE));
}

void DestroyItems(object oTarget,string sItem,int nNumItems, int bFeedback = TRUE)
{
    int nCount = 0;
    object oItem = GetFirstItemInInventory(oTarget);

    while (GetIsObjectValid(oItem) == TRUE && nCount < nNumItems)
    {
        if (GetTag(oItem) == sItem)
        {
            int nRemainingToDestroy = nNumItems - nCount;
			int nStackSize = GetItemStackSize(oItem);
			
			if(nStackSize <= nRemainingToDestroy)
			{
				DestroyObject(oItem,0.1f, bFeedback);
				nCount += nStackSize;
			}
            else
			{
				int nNewStackSize = nStackSize - nRemainingToDestroy;
				SetItemStackSize(oItem, nNewStackSize, bFeedback);
				break;
			}
        }
        oItem = GetNextItemInInventory(oTarget);
    }
   return;
}

void ConsumeItemReagents(int nIndex, object oPC, string sTable)
{
	string sItems = Get2DAString(sTable, "COST_ITEMS", nIndex);
	string sParam = GetStringParam(sItems, 0);
	int i=0;
	
	while(sParam != "")
	{
		int nNum = StringToInt( GetStringParam(sItems, i+1) );			//The NEXT parameter we are setting equal to the number to create - if it's a valid int.
		
		if ( nNum != 0 )												//if nNum is a valid int, we are going to use it as an iterator.
		{
			DestroyItems(oPC, sParam, nNum);		
			i += 2;														//We want to increment i by 2 in this case to skip nNum on the next iteration.
		}
		
		else															//If nNum is not a valid integer, we proceed to the next parameter directly and 
		{																//Only kill 1 item.
			DestroyItems(oPC, sParam, 1);
			i++;
		}
		sParam = GetStringParam(sItems, i);
	}
}


void ConsumeCraftingSpellUse(int nIndex, object oPC, string sTable)
{
	string sSpellIds = Get2DAString(sTable, "COST_SPELLS", nIndex);
	string sParam = GetStringParam(sSpellIds, 0);
	int i=0;
	
	while(sParam != "")
	{
		int nSpellDeducted = FALSE;
		int nSpellId = StringToInt(sParam);
				
		if(GetHasSpell(nSpellId, oPC))
		{
			DecrementRemainingSpellUses(oPC, nSpellId);
			nSpellDeducted = TRUE;
		}
		
		object oFM = GetFirstFactionMember(oPC, FALSE);
		while(GetIsObjectValid(oFM) && nSpellDeducted != TRUE)
		{
			if(GetHasSpell(nSpellId, oFM) && !GetIsOwnedByPlayer(oFM))		//Don't use another player's spells in a MP game.
			{
				DecrementRemainingSpellUses(oPC, nSpellId);
				nSpellDeducted = TRUE;
			}	
			oFM = GetNextFactionMember(oPC, FALSE);
		}
		
		++i;
		
		sParam = GetStringParam(sSpellIds, i);
	}
}

void CreateCraftedItem(int nIndex, object oPC, string sTable)
{
	string sItems = Get2DAString(sTable, "RESULT_RESREFS", nIndex);
	string sParam = GetStringParam(sItems, 0);
	int i=0;
	
	while(sParam != "")
	{
		int nNum = StringToInt( GetStringParam(sItems, i+1) );	//The NEXT parameter we are setting equal to the number to create.
		
		if ( nNum != 0 )										//if nNum is a valid int, we are going to use it as an iterator.
		{
			object oItem = CreateItemOnObject(sParam, oPC, nNum);
			SetIdentified(oItem, TRUE);
			// Setting a local int on the resulting item so that the spellhook can see that it's 
			// a crafted item, for allowing mageslayer to use it.
			SetLocalInt(oItem, "bIsCrafted", TRUE);
		
			i += 2;												//We want to increment i by 2 in this case to skip the iterator.
		}
		
		else
		{
			object oItem = CreateItemOnObject(sParam, oPC);
			SetIdentified(oItem, TRUE);
			SetLocalInt(oItem, "bIsCrafted", TRUE);
			++i;
		}


		sParam = GetStringParam(sItems, i);
	}
	
	string sSound = Get2DAString(sTable, "SOUND", nIndex);
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, PlaySound(sSound, TRUE));
}

void EnchantTargetItem(int nIndex, object oItem, string sTable, object oPC)
{
	string sEffects = Get2DAString(sTable, "EFFECT_STRING", nIndex);
	string sSound = Get2DAString(sTable, "SOUND", nIndex);
	ApplyEncodedEffectsToItem(oItem, sEffects);
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, PlaySound(sSound, TRUE));
}

void DoCraftingFailureFeedback(int nCraftingFailure, object oPC, string sExtraFeedback = "")
{
	string sFeedbackMessage = GetStringByStrRef(nCraftingFailure);
	if(sExtraFeedback != "")
	{
		sFeedbackMessage += " ";
		sFeedbackMessage += sExtraFeedback;
	}	
	SendMessageToPC(oPC, sFeedbackMessage);
}