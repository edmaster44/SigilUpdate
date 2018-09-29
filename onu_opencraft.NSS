#include "ps_inc_newcrafting"

void main () {

	object oPC = GetLastUsedBy();
	string sType = GetLocalString(OBJECT_SELF, "CraftType");
	
	DeleteLocalInt(oPC, "Craft_BaseItemType"); 
	DeleteLocalInt(oPC, "Craft_Mat1"); 
	DeleteLocalInt(oPC, "Craft_Mat2"); 
	DeleteLocalInt(oPC, "Craft_Mat3"); 
	DeleteLocalObject(oPC, "crafted_item");
		
	DisplayGuiScreen(oPC, sCraftingScreen, TRUE, xmlCraftingFile);
	
	SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL1_HEADER", TRUE);
	SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL1_LIST", TRUE);
	SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL2_HEADER", TRUE);
	SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL2_LIST", TRUE);
	SetGUIObjectHidden(oPC, sCraftingScreen, "MATERIAL3_HEADER", TRUE);
	SetGUIObjectHidden(oPC, sCraftingScreen, "SCOD_MATERIAL3_LIST", TRUE);
	
	GenerateBaseItemList(oPC, sType);
	SetGUIObjectText(oPC, sCraftingScreen, "CRAFTING_DETAILS_TEXT", -1, "Pick a base item to get started");
	
}