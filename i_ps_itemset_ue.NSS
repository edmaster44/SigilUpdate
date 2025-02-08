#include "ff_safevar"

//i_ps_itemset_ue
/*	Script by Dedic8ed
	Created for use in the Sigil: City of Doors PW
	Thanks to the two scripters who gave me the basis to start from: Apep (Item Sets Minipack) and Mithridates (Nasher Items Fix)
	
	See the notes in i_ps_itemset_eq for instructions.
*/
 
#include "ginc_ps_itemset"

void main()
{
    object oPC      = GetPCItemLastUnequippedBy();
    object oItem    = GetPCItemLastUnequipped();

switch (PS_GetLocalInt(oItem,"vSetID"))
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