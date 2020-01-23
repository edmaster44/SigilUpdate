#include "ps_inc_newenchanting"

void PlayEnchantingAnimation(object oPC) {

	PlayCustomAnimation(oPC, "def_conjureloop", TRUE, 1.0f);
	
}

void main () {

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();
	object oTarget = GetItemActivatedTarget();
	
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
		if (!GetHasFeat(FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR, oPC) && !GetHasFeat(1430, oPC)) {
			SendMessageToPC(oPC, "You must have Craft Magic Arms and Armor or Imbue Item in order to enchant.");
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
	
	SetLocalObject(oPC, "ObjectToEnchant", oTarget);
	DisplayGuiScreen(oPC, sEnchantingScreen, TRUE, xmlEnchantingFile);
	
	DisplayItemDescription(oPC, oTarget);
	
	GenerateEnchantmentTypeList(oPC);
}