

//i_ps_itemset_ue
/*	Script by Dedic8ed
	Created for use in the Sigil: City of Doors PW
	Thanks to the two scripters who gave me the basis to start from: Apep (Item Sets Minipack) and Mithridates (Nasher Items Fix)
	
	See the notes in i_ps_itemset_eq for instructions.
*/

// -FlatteFifth, July 23, 2026. Sometimes items, particularly if they've been in bags, get their resource reference
// truncated to 16 characters instead of 32. Added function GetIsSetItem() to include to determine whether an item 
// belongs to a particular set even if the res refs are shortened.  We don't actually need to get the full resref
// because we can check by item slot and/or base item type. It's not like anyone can equip a bracer on their head.
 
 
#include "ginc_ps_itemset"

void main(){
    object oPC      = GetPCItemLastUnequippedBy();
    object oItem    = GetPCItemLastUnequipped();
	int nSet 		= GetLocalInt(oItem, "vSetID");
	int nItem 		= GetBaseItemType(oItem);
	int bShowMessage = FALSE;
	object oKeyItem;

	switch (nSet){
/////////////////////////////////////////////////////////////////////////////////////////
// Sword Saint
		case 1:{
			if (nItem == BASE_ITEM_KATANA) oKeyItem = oItem;
			else oKeyItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			if (GetIsSetItem(oKeyItem, nSet)){
				bShowMessage = TRUE;
				SwordSaint1Standard(oKeyItem);
			}
		}
		break;
/////////////////////////////////////////////////////////////////////////////////////////
// Celestial Glory
		case 2:{
			if (nItem == BASE_ITEM_AMULET) oKeyItem = oItem;
			else oKeyItem = GetItemInSlot(INVENTORY_SLOT_NECK, oPC);
			if (GetIsSetItem(oKeyItem, nSet)){
				bShowMessage = TRUE;
				CelestialGloryStandard(oKeyItem);	
			}
		}
		break;		
/////////////////////////////////////////////////////////////////////////////////////////
// Arboreal Archer
		case 3:{
			if (nItem == BASE_ITEM_LONGBOW) oKeyItem = oItem;
			else oKeyItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			if (GetIsSetItem(oKeyItem, nSet)){
				bShowMessage = TRUE;
				ArborealArcherStandard(oKeyItem);
			}
		}
		break;
/////////////////////////////////////////////////////////////////////////////////////////
// Fallen Shadows
		case 4:{
			if (nItem == BASE_ITEM_ARMOR) oKeyItem = oItem;
			else oKeyItem =  GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
			if (GetIsSetItem(oKeyItem, nSet)){
				bShowMessage = TRUE;
				FallenShadowsStandard(oKeyItem);
			}
		}
		break;
/////////////////////////////////////////////////////////////////////////////////////////
// Slaadskin
		case 5:{
			if (nItem == BASE_ITEM_CLOAK) oKeyItem = oItem;
			else oKeyItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
			if (GetIsSetItem(oKeyItem, nSet)){
				bShowMessage = TRUE;
				SlaadskinStandard(oKeyItem);
			}
		}
		break;
/////////////////////////////////////////////////////////////////////////////////////////
// Iggwilv
		case 6:{
			if (nItem == BASE_ITEM_CLOAK) oKeyItem = oItem;
			else oKeyItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
			if (GetIsSetItem(oKeyItem, nSet)){
				bShowMessage = TRUE;
				IggwilvStandard(oKeyItem);
			}
		}
		break;
/////////////////////////////////////////////////////////////////////////////////////////
// Brazen
		case 7:{
			if (nItem == BASE_ITEM_ARMOR) oKeyItem = oItem;
			else oKeyItem =  GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
			if (GetIsSetItem(oKeyItem, nSet)){
				bShowMessage = TRUE;
				BrazenStandard(oKeyItem);
			}
		}
		break;
/////////////////////////////////////////////////////////////////////////////////////////
// Warlord
		case 8:{
			if (nItem == BASE_ITEM_BRACER) oKeyItem = oItem;
			else oKeyItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
			if (GetIsSetItem(oKeyItem, nSet)){
				bShowMessage = TRUE;
				FighterSpecStandard(oKeyItem);
			}
		}
		break;
	}
	if (bShowMessage) SendMessageToPC(oPC, "Item Set Separated");	
}




/* old
void main()
{
    object oPC      = GetPCItemLastUnequippedBy();
    object oItem    = GetPCItemLastUnequipped();

switch (GetLocalInt(oItem,"vSetID"))
{	

/////////////////////////////////////////////////////////////////////////////////////////

case 1 : //Sword Saint Set

{
	if (
	GetResRef(oItem) == "ps_itemset_swordsaint1")
{
	SendMessageToPC(oPC,"Item Set Separated");	
	SwordSaint1Standard(oItem);
}

	else 
{	
		if (
		GetResRef(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == "ps_itemset_swordsaint1")
{		
		SendMessageToPC(oPC,"Item Set Separated");	
		SwordSaint1Standard(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
}}}
	
break;

/////////////////////////////////////////////////////////////////////////////////////////

case 2: //Celestial Glory

{
	if (
	GetResRef(oItem) == "ps_itemset_celglory1")
{
	SendMessageToPC(oPC,"Item Set Separated");	
	CelestialGloryStandard(oItem);
}
	else
{
		if(
		GetResRef(GetItemInSlot(INVENTORY_SLOT_NECK, oPC)) == "ps_itemset_celglory1")
{		
		SendMessageToPC(oPC,"Item Set Separated");	
		CelestialGloryStandard(GetItemInSlot(INVENTORY_SLOT_NECK, oPC));
}}}

break;

/////////////////////////////////////////////////////////////////////////////////////////

case 3: //Arboreal Archer

{
	if (
	GetResRef(oItem) == "ps_itemset_aarcher3")
{
	SendMessageToPC(oPC,"Item Set Separated");	
	ArborealArcherStandard(oItem);
}
	else
{
		if(
		GetResRef(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == "ps_itemset_aarcher3")
{		
		SendMessageToPC(oPC,"Item Set Separated");	
		ArborealArcherStandard(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
}}}

break;

/////////////////////////////////////////////////////////////////////////////////////////

case 4: //Fallen Shadows

{
	if (
	GetResRef(oItem) == "ps_itemset_fallshad4")
{
	SendMessageToPC(oPC,"Item Set Separated");	
	FallenShadowsStandard(oItem);
}
	else
{
		if(
		GetResRef(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) == "ps_itemset_fallshad4")
{		
		SendMessageToPC(oPC,"Item Set Separated");	
		FallenShadowsStandard(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
}}}

break;

/////////////////////////////////////////////////////////////////////////////////////////

case 5: //Slaadskin

{
	if (
	GetResRef(oItem) == "ps_itemset_slaadskin2")
{
	SendMessageToPC(oPC,"Item Set Separated");	
	SlaadskinStandard(oItem);
}
	else
{
		if(
		GetResRef(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC)) == "ps_itemset_slaadskin2")
{		
		SendMessageToPC(oPC,"Item Set Separated");	
		SlaadskinStandard(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC));
}}}

break;

/////////////////////////////////////////////////////////////////////////////////////////

case 6: //Iggwilv

{
	if (
	GetResRef(oItem) == "ps_itemset_iggwilv1")
{
	SendMessageToPC(oPC,"Item Set Separated");	
	IggwilvStandard(oItem);
}
	else
{
		if(
		GetResRef(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC)) == "ps_itemset_iggwilv1")
{		
		SendMessageToPC(oPC,"Item Set Separated");	
		IggwilvStandard(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC));
}}}

break;

/////////////////////////////////////////////////////////////////////////////////////////

case 7: //Brazen

{
	if (
	GetResRef(oItem) == "ps_itemset_brazen1")
{
	SendMessageToPC(oPC,"Item Set Separated");	
	BrazenStandard(oItem);
}
	else
{
		if(
		GetResRef(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) == "ps_itemset_brazen1")
{		
		SendMessageToPC(oPC,"Item Set Separated");	
		BrazenStandard(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
}}}

break;

/////////////////////////////////////////////////////////////////////////////////////////

case 8: //Fighter Specific

{
	if (
	GetResRef(oItem) == "ps_itemset_fighter1")
{
	SendMessageToPC(oPC,"Item Set Separated");	
	FighterSpecStandard(oItem);
}
	else
{
		if(
		GetResRef(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC)) == "ps_itemset_fighter1")
{		
		SendMessageToPC(oPC,"Item Set Separated");	
		FighterSpecStandard(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC));
}}}

break;

/////////////////////////////////////////////////////////////////////////////////////////
}}

*/