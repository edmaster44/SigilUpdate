

#include "ps_inc_newenchanting"

void PlayEnchantingAnimation(object oPC) {

	PlayCustomAnimation(oPC, "def_conjureloop", TRUE, 1.0f);
	
}

void main () {

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();
	object oTarget = GetItemActivatedTarget();
	
	CloseGUIScreen(oPC, sEnchantingScreen);
	
	//Clear enchanting focus before we start the GUI
	DeleteLocalObject(oPC, "ObjectToEnchant");
	DeleteLocalInt(oPC, "EnchantmentToApply");
	
	//SendMessageToPC(oPC, GetName(oItem)+" base item type = "+IntToString(GetBaseItemType(oItem)));
	
	//Must target item
	if (GetIsObjectValid(oTarget) == FALSE ||
		GetObjectType(oTarget) != OBJECT_TYPE_ITEM ||
		GetBaseItemType(oTarget) == BASE_ITEM_INVALID) {
		SendMessageToPC(oPC, "You must target an item to start enchanting.");
		return;
	}
	
	if (!GetIsDM(oPC)) { //DMs get free pass!
	
		//Must have enchantment feat
		if (!GetHasFeat(FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR, oPC, TRUE) && 
			!GetHasFeat(FEAT_IMBUE_ITEM, oPC, TRUE) && 
			!GetHasFeat(FEAT_ALCHEMICAL_INFUSION, oPC, TRUE)) {
			SendMessageToPC(oPC, "You must have Craft Magic Arms and Armor, Imbue Item, or Alchemical Infusion in order to enchant.");
			return;
		}
	
		object oBench = GetNearestEnchantingWorkbench(oPC);
		if (!GetIsObjectValid(oBench)) {
			SendMessageToPC(oPC, "You must be next to a magician's workbench in order to enchant.");
			return;
		}
	
		AssignCommand(oPC, ActionMoveToObject(oBench, FALSE, 0.5f));
		DelayCommand(1.0f, PlayEnchantingAnimation(oPC));
		
	}
	
	SendMessageToPC(oPC, "Starting enchanting. . .");
	
	string sName = GetName(oTarget);
	string sLastName = GetLastName(oTarget);
	if (RemoveWhitespace(sName) == "") sName = GetFirstName(oTarget);
	if (RemoveWhitespace(sLastName) != "") sName += " " + sLastName;
	if (RemoveWhitespace(sName) == ""){
		sName = GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(oTarget))));
	}
	SetFirstName(oTarget, sName);
	
	SetLocalObject(oPC, "ObjectToEnchant", oTarget);
	
	DisplayGuiScreen(oPC, sEnchantingScreen, TRUE, xmlEnchantingFile);
	
	DisplayItemDescription(oPC, oTarget);
	
	GenerateEnchantmentTypeList(oPC, oTarget);
}