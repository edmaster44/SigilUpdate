/* Feat created by Ceremorph 11/25/15
Boosts immunity of the creature based on level  */

#include "x2_inc_spellhook"
#include "ps_inc_item_customize"
#include "aaa_constants"

void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}

    object oPC 		= OBJECT_SELF;
	object oItem	= GetSpellTargetObject();
	int nSpell 		= GetSpellId();
	
	if (GetObjectType(oItem) != OBJECT_TYPE_ITEM)
	{	SendMessageToPC(oPC, "This feature will only work on items.");
		return;	}
	
	switch (nSpell)
	{
		case 490 :		//Edit Item Name
			PS_SetItemName(oPC, oItem);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 491 :		//Edit Item Description
			PS_SetItemDescription(oPC, oItem);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 492 :		//Change Item Icon
			PS_SetItemIcon(oPC, oItem);
		break;
////////////////////////////////////////////////////////////////////////////////////
	}
}