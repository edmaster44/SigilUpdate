

// Returning thrown weapon on-activate script.
// This will refresh your stack of thrown weapons.
// By Electrohydra
// michel.remillard1@gmail.com

// Created 02/12/2018
// Last Edit 03/26/18 - MimiFearthegn, added arrow/bolt/bullet quivers
#include "ps_inc_itemprops"

const int STACK_SIZE = 999;
const int ITEM_TYPE_RETURNING_DARTS = 90;
const int ITEM_TYPE_RETURNING_AXES = 91;
const int ITEM_TYPE_RETURNING_SHURIKENS = 92;
const int ITEM_TYPE_RETURNING_ARROWS = 93;
const int ITEM_TYPE_RETURNING_BOLTS = 94;
const int ITEM_TYPE_RETURNING_BULLETS = 95;
const string TEMPLATE_DART = "nw_wthdt001";
const string TEMPLATE_THROWINGAXE = "nw_wthax001";
const string TEMPLATE_SHURIKEN = "nw_wthsh001";
const string TEMPLATE_ARROW = "nw_wamar001";
const string TEMPLATE_BOLT = "nw_wambo001";
const string TEMPLATE_BULLET = "nw_wambu001";

void main()
{
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
    object oTarget  = GetItemActivatedTarget();
    location lTarget = GetItemActivatedTargetLocation();

 	int iItemType = GetBaseItemType(oItem);

	// First, destroy any thrown weapons previously created by this.
	int id = GetLocalInt(oItem, "id");
	if (id == 0) { id = -1; }
	
	object iEquipped = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
	iEquipped = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
	if (GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
	iEquipped = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
	if (GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
	iEquipped = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
	if (GetLocalInt(iEquipped, "returningthrownid") == id) {
		DestroyObject(iEquipped, 0.0f, FALSE); }
		
	object iInventory = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(iInventory))
	{
		if (GetLocalInt(iInventory, "returningthrownid") == id) {
			DestroyObject(iInventory, 0.0f, FALSE); }
		iInventory = GetNextItemInInventory(oPC);
	}
	
	// Next, create a new set of thown weapons.
	string sThrownTemplate;
	if (iItemType == ITEM_TYPE_RETURNING_DARTS) { sThrownTemplate = TEMPLATE_DART; }
	if (iItemType == ITEM_TYPE_RETURNING_AXES) { sThrownTemplate = TEMPLATE_THROWINGAXE; }
	if (iItemType == ITEM_TYPE_RETURNING_SHURIKENS) { sThrownTemplate = TEMPLATE_SHURIKEN; }
	if (iItemType == ITEM_TYPE_RETURNING_ARROWS) { sThrownTemplate = TEMPLATE_ARROW; }
	if (iItemType == ITEM_TYPE_RETURNING_BOLTS) { sThrownTemplate = TEMPLATE_BOLT; }
	if (iItemType == ITEM_TYPE_RETURNING_BULLETS) { sThrownTemplate = TEMPLATE_BULLET; }
	
	object oCreated = CreateItemOnObject(sThrownTemplate, oPC, 500, "returnthrown", FALSE);
	
	// Tag the set and throwers.
	id = Random(99999);
	SetLocalInt(oCreated, "returningthrownid", id);
	SetLocalInt(oItem, "id", id);
	SetFirstName(oCreated, GetName(oItem));
	
	// Set the throwers as unsellable
	SetStolenFlag(oCreated, TRUE);
	SetPlotFlag(oCreated, TRUE);
	
	// Transfer the item properties.
	itemproperty prop = GetFirstItemProperty(oItem);
	int matType = 0;
	while (GetIsItemPropertyValid(prop))
	{
		if (GetItemPropertyType(prop) != ITEM_PROPERTY_CAST_SPELL)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, prop, oCreated, 0.0f); 
		}
		
		//Check if this is a MadeOf property; if so, check for base material type
		int nType = GetItemMaterialTypeFromProperty(prop);
		if (nType > 0)
			matType = nType;
			
		prop = GetNextItemProperty(oItem);
	}
	
	if (matType > 0) {
		//SendMessageToPC(oPC, "Debug: Material Type "+IntToString(matType));  
		SetItemBaseMaterialType(oCreated, matType);
	}
	
	// Equip the new item
	if (iItemType == ITEM_TYPE_RETURNING_ARROWS)
		AssignCommand(oPC, ActionEquipItem(oCreated, INVENTORY_SLOT_ARROWS));
	else if (iItemType == ITEM_TYPE_RETURNING_BOLTS)
		AssignCommand(oPC, ActionEquipItem(oCreated, INVENTORY_SLOT_BOLTS));
	else if (iItemType == ITEM_TYPE_RETURNING_BULLETS)
		AssignCommand(oPC, ActionEquipItem(oCreated, INVENTORY_SLOT_BULLETS));
	else
		AssignCommand(oPC, ActionEquipItem(oCreated, INVENTORY_SLOT_RIGHTHAND));
	
}