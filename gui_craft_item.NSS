#include "ff_safevar"

#include "ps_inc_newcrafting"
#include "dethia_shop_sys"

void ShowCustomizationScreen(object oPC, object oItem, struct baseitem i, string sDescrip) {
	DisplayGuiScreen(oPC, sCustomizationScreen, TRUE, xmlCustomizationFile);
	GenerateItemIconList(oPC, i);
	
	string sName = GetName(oItem);
	string sLastName = GetLastName(oItem);
	if (RemoveWhitespace(sName) == "") sName = GetFirstName(oItem);
	if (RemoveWhitespace(sLastName) != "") sName += " " + sLastName;
	if (RemoveWhitespace(sName) == ""){
		sName = GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(oItem))));
	}
	SetGUIObjectText(oPC, sCustomizationScreen, "SCOD_ITEMNAME_TEXT", -1, sName);
	SetGUIObjectText(oPC, sCustomizationScreen, "SCOD_ITEMDESC_TEXT", -1, sDescrip);
}

void main () {

	object oPC = OBJECT_SELF;
	
	int nBase = PS_GetLocalInt(oPC, "Craft_BaseItemType");
	int nMat1 = PS_GetLocalInt(oPC, "Craft_Mat1");
	int nMat2 = PS_GetLocalInt(oPC, "Craft_Mat2");
	int nMat3 = PS_GetLocalInt(oPC, "Craft_Mat3");
	
	struct baseitem i = LoadBaseItem(nBase);
	struct material m1 = LoadMaterial(nMat1, i.matlist_1);
	struct material m2 = LoadMaterial(nMat2, i.matlist_2);
	struct material m3 = LoadMaterial(nMat3, i.matlist_3);
	
	int nRequiredRank = GetCraftingRankRequirement(i, m1, m2, m3);
	int nSkill = GetRequiredCraftSkill(i);
	if (PS_GetSkillRank(nSkill, oPC, TRUE) < nRequiredRank) {
		SendMessageToPC(oPC, "You do not have the required skill rank.");
		return;
	}
	
	int nCost = GetCraftedItemCost(oPC, i, m1, m2, m3);
	if (GetGold(oPC) < nCost) {
		SendMessageToPC(oPC, "You do not have the required gold.");
		return;
	}
	
	if (!GetHasRequiredCraftingItems(oPC, i, m1, m2, m3)) {
		SendMessageToPC(oPC, "You do not have the required items");
		return;
	}
	
	TakeGoldFromCreature(nCost, oPC, TRUE);
	TakeRequiredCraftingItems(oPC, i, m1, m2, m3);
	
	//Create crafted item
	object oItem = CreateCraftedItem(oPC, i, m1, m2, m3, TRUE);
	
	string sName = GetCraftingItemName(i, m1, m2, m3);
	if (RemoveWhitespace(sName) == ""){
		sName = GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(oItem))));
	}
	SetFirstName(oItem, sName);
	
	string sDescrip = GetCraftingNameDescription(oPC, i, m1, m2, m3);
	SetDescription(oItem, sDescrip);
	//SetItemCostVariables(oItem, FALSE, oPC);
	
	PS_SetLocalObject(oPC, "crafted_item", oItem);
	
	PS_DeleteLocalInt(oPC, "Craft_BaseItemType"); 
	PS_DeleteLocalInt(oPC, "Craft_Mat1"); 
	PS_DeleteLocalInt(oPC, "Craft_Mat2"); 
	PS_DeleteLocalInt(oPC, "Craft_Mat3"); 
	
	CloseGUIScreen(oPC, sCraftingScreen);
	
	DelayCommand(0.5f, ShowCustomizationScreen(oPC, oItem, i, sDescrip));
	
}